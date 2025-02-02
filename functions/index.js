const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { onDocumentWritten } = require("firebase-functions/v2/firestore");

// Firebase Admin 초기화
admin.initializeApp();
const db = admin.firestore();

function parseRecord(record) {
  if (record.includes("R")) {
    // "5R10" 형식
    const [rounds, reps] = record.split("R").map(Number);
    return { type: "rounds", value: rounds * 1000 + reps }; // 가중치를 주어 정렬
  } else if (record.includes(":")) {
    // "18:10" 형식
    const [minutes, seconds] = record.split(":").map(Number);
    return { type: "time", value: minutes * 60 + seconds };
  } else if (record === "S") {
    // "S" 형식
    return { type: "status", value: 1 }; // 성공
  } else if (record === "F") {
    // "F" 형식
    return { type: "status", value: 0 }; // 실패
  } else {
    // 숫자 형식
    return { type: "number", value: Number(record) };
  }
}

function compareRecords(a, b) {
  const parsedA = parseRecord(a.record);
  const parsedB = parseRecord(b.record);

  if (parsedA.type !== parsedB.type) {
    // 다른 형식 간의 비교 로직 (필요에 따라 정의)
    return parsedA.type.localeCompare(parsedB.type);
  }

  return parsedA.value - parsedB.value;
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
