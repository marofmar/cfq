const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { onDocumentWritten } = require("firebase-functions/v2/firestore");
const { onCall } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");

const openAiApiKey = defineSecret("OPENAI_API_KEY");
// OpenAI는 함수 내부에서 생성 (배포 전 파싱 시점 오류 방지)
const { OpenAI } = require("openai");
// const openai = new OpenAI({
//   apiKey: process.env.OPENAI_API_KEY,
// });

// Firebase Admin 초기화
admin.initializeApp();
const db = admin.firestore();

function parseRecord(record) {
  // Remove all spaces from the record string
  const sanitizedRecord = record.replace(/\s+/g, "");

  if (sanitizedRecord.includes("R")) {
    // "5R10" 형식
    const [rounds, reps] = sanitizedRecord.split("R").map(Number);
    return { type: "rounds", value: rounds * 1000 + reps }; // 가중치를 주어 정렬
  } else if (sanitizedRecord.includes(":")) {
    // "18:10" 형식
    const [minutes, seconds] = sanitizedRecord.split(":").map(Number);
    return { type: "time", value: minutes * 60 + seconds };
  } else if (sanitizedRecord === "S") {
    // "S" 형식
    return { type: "status", value: 1 }; // 성공
  } else if (sanitizedRecord === "F") {
    // "F" 형식
    return { type: "status", value: 0 }; // 실패
  } else {
    // 숫자 형식
    return { type: "number", value: Number(sanitizedRecord) };
  }
}

function compareRecords(a, b) {
  const parsedA = parseRecord(a.record);
  const parsedB = parseRecord(b.record);

  if (parsedA.type !== parsedB.type) {
    return parsedA.type.localeCompare(parsedB.type);
  }

  // For time format, smaller values are better (ascending order)
  if (parsedA.type === "time") {
    return parsedA.value - parsedB.value;
  }

  // For other formats, larger values are better (descending order)
  return parsedB.value - parsedA.value;
}

// Firestore 트리거 함수
exports.updateRanking = onDocumentWritten(
  "records/{recordId}",
  async (event) => {
    const recordId = event.params.recordId;
    const recordsData = event.data?.after?.data() || null;

    if (!recordsData) {
      console.log(`Document ${recordId} was deleted.`);
      return;
    }

    try {
      const users = Object.entries(recordsData).map(([name, data]) => ({
        name,
        record: data.record,
        level: data.level,
        gender: data.gender,
      }));

      users.sort(compareRecords);

      const rankedUsers = users.map((user, index) => ({
        rank: index + 1,
        ...user,
      }));

      const rankingData = rankedUsers.reduce((acc, user) => {
        acc[user.name] = {
          rank: user.rank,
          record: user.record,
          level: user.level,
          gender: user.gender,
        };
        return acc;
      }, {});

      await db.collection("ranking").doc(recordId).set(rankingData);

      console.log(`Ranking updated for recordId: ${recordId}`);
    } catch (error) {
      console.error(`Error updating ranking for recordId: ${recordId}`, error);
    }
  }
);

exports.generateWod = functions.https.onCall(async (data, context) => {
  console.log("user auth context:", context.auth);
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User must be authenticated"
    );
  }

  try {
    const userDoc = await db.collection("users").doc(context.auth.uid).get();
    const userData = userDoc.data();
    console.log("user role:", userData);
    const openai = new OpenAI({
      apiKey: openAiApiKey.value(),
    });

    if (!userData || (userData.role !== "admin" && userData.role !== "coach")) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Only admin and coach can generate WODs"
      );
    }

    const completion = await openai.chat.completions.create({
      model: "gpt-4o-mini",
      messages: [
        {
          role: "system",
          content:
            "You are a helpful and witty manager in a CrossfitBox. You will write a WOD for the member of the gym.",
        },
        {
          role: "user",
          content: `Generate a CrossFit WOD with the following format:
            Title: [WOD Title]
            
            Exercises:
            [List of exercises]
            
            Levels:
            RXD: [RX'd level details]
            A: [Scaled A level details]
            B: [Scaled B level details]
            C: [Scaled C level details]
            
            Description: [Brief description or notes]`,
        },
      ],
    });

    const response = completion.choices[0].message.content;
    const wodData = parseWodResponse(response);

    const date = data.date;
    wodData.createdBy = `made by OpenAI and ${userData.name}`;
    await db.collection("wods").doc(date).set(wodData);

    return { success: true, data: wodData };
  } catch (error) {
    console.error("Error generating WOD:", error);
    throw new functions.https.HttpsError("internal", error.message);
  }
});

function parseWodResponse(response) {
  try {
    const lines = response
      .split("\n")
      .map((line) => line.trim())
      .filter((line) => line);
    let title = "";
    let exercises = [];
    let level = {};
    let description = "";
    let currentSection = "";

    for (const line of lines) {
      if (line.startsWith("Title:")) {
        title = line.replace("Title:", "").trim();
      } else if (line === "Exercises:") {
        currentSection = "exercises";
      } else if (line === "Levels:") {
        currentSection = "levels";
      } else if (line.startsWith("Description:")) {
        description = line.replace("Description:", "").trim();
      } else if (currentSection === "exercises" && line !== "Levels:") {
        exercises.push(line);
      } else if (currentSection === "levels") {
        if (line.toLowerCase().startsWith("rxd:")) {
          level.rxd = line.split(":")[1].trim();
        } else if (line.toLowerCase().startsWith("a:")) {
          level.a = line.split(":")[1].trim();
        } else if (line.toLowerCase().startsWith("b:")) {
          level.b = line.split(":")[1].trim();
        } else if (line.toLowerCase().startsWith("c:")) {
          level.c = line.split(":")[1].trim();
        }
      }
    }

    return {
      title,
      exercises,
      level,
      description,
    };
  } catch (error) {
    console.error("Error parsing WOD response:", error);
    throw new Error("Failed to parse OpenAI response");
  }
}
