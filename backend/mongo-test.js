// require("dotenv").config();   // 👈 MUST BE FIRST LINE

// const mongoose = require("mongoose");

// (async () => {
//   try {
//     console.log("Loaded URI:", process.env.MONGO_CONN_STR); // DEBUG LINE

//     await mongoose.connect(process.env.MONGO_CONN_STR, {
//       useNewUrlParser: true,
//       useUnifiedTopology: true,
//     });

//     console.log("✅ MongoDB Atlas connection SUCCESS");
//     process.exit(0);
//   } catch (err) {
//     console.error("❌ MongoDB Atlas connection FAILED");
//     console.error(err.message);
//     process.exit(1);
//   }
// })();
// require("dotenv").config();

// const mongoose = require("mongoose");

// (async () => {
//   try {
//     console.log("Loaded URI:", process.env.MONGO_CONN_STR);
    
//     // Check if URI is loaded
//     if (!process.env.MONGO_CONN_STR) {
//       console.error("❌ MONGO_CONN_STR is undefined!");
//       console.log("Available environment variables:", Object.keys(process.env).filter(key => key.includes('MONGO')));
//       process.exit(1);
//     }
    
//     // Check URI format
//     const uri = process.env.MONGO_CONN_STR;
//     if (!uri.includes('mongodb+srv://')) {
//       console.error("❌ URI doesn't contain 'mongodb+srv://'");
//       console.error("URI starts with:", uri.substring(0, 20));
//       process.exit(1);
//     }
    
//     // Test if URI can be parsed
//     try {
//       // Extract hostname for debugging
//       const match = uri.match(/@([^/]+)/);
//       if (match) {
//         console.log("Hostname found:", match[1]);
//       } else {
//         console.error("❌ Could not extract hostname from URI");
//       }
//     } catch (e) {
//       console.error("❌ URI parsing error:", e.message);
//     }

//     // Connect with updated options (mongoose 6+)
//     await mongoose.connect(uri, {
//       // These options are no longer needed in Mongoose 6+
//       // useNewUrlParser: true,
//       // useUnifiedTopology: true,
//       serverSelectionTimeoutMS: 5000, // 5 seconds timeout
//     });

//     console.log("✅ MongoDB Atlas connection SUCCESS");
//     process.exit(0);
//   } catch (err) {
//     console.error("❌ MongoDB Atlas connection FAILED");
//     console.error("Error name:", err.name);
//     console.error("Error message:", err.message);
    
//     // Additional debug info
//     if (err.name === 'MongoParseError') {
//       console.error("This is a MongoDB URI parsing error");
//       console.error("Check your connection string format");
//     }
    
//     process.exit(1);
//   }
// })();

require("dotenv").config();   // 👈 MUST BE FIRST LINE

const mongoose = require("mongoose");

(async () => {
  try {
    console.log("Loaded URI:", process.env.MONGO_CONN_STR); // DEBUG LINE

    // 🚨 TEMPORARY FIX: Replace with your actual hardcoded credentials
    const testUri = "mongodb+srv://jayparmar7654321_db_user:cMCGfNz1Sf6V6QIO@cluster0.zcmj08i.mongodb.net/mern-db?retryWrites=true&w=majority";
    
    // Replace the variables with your actual values:
    // - username: Your MongoDB username
    // - password: Your MongoDB password (URL-encode special characters)
    // - cluster-name: Your cluster name (like cluster0)
    
    console.log("Testing with hardcoded URI:", testUri);
    
    await mongoose.connect(testUri, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });

    console.log("✅ MongoDB Atlas connection SUCCESS");
    process.exit(0);
  } catch (err) {
    console.error("❌ MongoDB Atlas connection FAILED");
    console.error(err.message);
    process.exit(1);
  }
})();