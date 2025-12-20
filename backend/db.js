const mongoose = require("mongoose");

module.exports = async () => {
  try {
    // Kubernetes → backend-secret injects this
    // Local dev → .env supplies MONGO_CONN_STR
    const uri = process.env.MONGO_URI || process.env.MONGO_CONN_STR;

    if (!uri) {
      throw new Error("❌ No MongoDB connection string found (MONGO_URI or MONGO_CONN_STR).");
    }

    console.log("📌 Using MongoDB URI:", uri.substring(0, 30) + "..."); // Debug preview

    await mongoose.connect(uri, {
      serverSelectionTimeoutMS: 5000,
    });

    console.log("✅ Connected to MongoDB Atlas");
  } catch (error) {
    console.error("❌ MongoDB connection failed:", error.message);
    process.exit(1);
  }
};
