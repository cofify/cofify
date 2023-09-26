const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.calculateDistance = functions.https.onRequest((req, res) => {
          const { lat1, lon1, lat2, lon2 } = req.query;

          // Izračunajte udaljenost između tačaka lat1, lon1 i lat2, lon2
          const distance = calculateDistance(lat1, lon1, lat2, lon2);

          // Vratite rezultat kao JSON
          res.status(200).json({ distance });
});

// Implementirajte funkciju calculateDistance prema vašim potrebama
function calculateDistance(lat1, lon1, lat2, lon2) {
          return lat1 + lon1 + lat2 + lon2;
}
