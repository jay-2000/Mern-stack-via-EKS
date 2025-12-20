const mongoose = require("mongoose");

module.exports = async () => {
  try {
    if (!process.env.MONGO_CONN_STR) {
      throw new Error("MONGO_CONN_STR is not defined");
    }

    await mongoose.connect(process.env.MONGO_URI);

    console.log("✅ Connected to MongoDB Atlas");
  } catch (error) {
    console.error("❌ Could not connect to database:", error.message);
    process.exit(1);
  }
};
