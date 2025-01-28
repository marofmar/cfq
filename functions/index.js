const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Firebase Admin 초기화
admin.initializeApp();

const db = admin.firestore();

// Firestore 트리거 함수
exports.updateRanking = functions.firestore
  .document("records/{recordId}")
  .onWrite(async (change, context) => {
    const recordId = context.params.recordId;
    const recordsData = change.after.exists ? change.after.data() : null;

    if (!recordsData) {
      console.log(`Document ${recordId} was deleted.`);
      return null;
    }

    try {
      // 데이터 처리 로직
      const users = Object.entries(recordsData).map(([name, data]) => ({
        name,
        record: data.record,
        level: data.level,
        gender: data.gender,
      }));

      users.sort((a, b) => {
        const [aRounds, aReps] = a.record.split("R").map(Number);
        const [bRounds, bReps] = b.record.split("R").map(Number);
        return bRounds - aRounds || bReps - aReps;
      });

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
      return null;
    } catch (error) {
      console.error(`Error updating ranking for recordId: ${recordId}`, error);
      return null;
    }
  });
