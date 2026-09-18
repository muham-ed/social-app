const mongoose = require('mongoose');
const config = require('./env');
const logger = require('../utils/logger');

const connectDB = async () => {
  try {
    mongoose.set('strictQuery', true);
    const conn = await mongoose.connect(config.mongoUri, {
      autoIndex: !config.isProd,
    });
    logger.info(`✅ MongoDB متصلة: ${conn.connection.host}`);
    return conn;
  } catch (err) {
    logger.error(`❌ فشل الاتصال بـ MongoDB: ${err.message}`);
    process.exit(1);
  }
};

module.exports = connectDB;