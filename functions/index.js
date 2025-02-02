const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { onDocumentWritten } = require("firebase-functions/v2/firestore");

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
