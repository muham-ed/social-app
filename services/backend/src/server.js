const http = require('http');
const app = require('./app');
const config = require('./config/env');
const logger = require('./utils/logger');
const connectDB = require('./config/db');
const initSocket = require('./sockets');

const start = async () => {
  await connectDB();

  const server = http.createServer(app);
  const io = initSocket(server);

  // نخلي io متاح من req.app
  app.set('io', io);

  server.listen(config.port, () => {
    logger.info(`🚀 السيرفر يعمل على المنفذ ${config.port} [${config.nodeEnv}]`);
  });

  const shutdown = async (signal) => {
    logger.info(`⏹️  إيقاف السيرفر (${signal})...`);
    server.close(() => process.exit(0));
    setTimeout(() => process.exit(1), 10000);
  };

  process.on('SIGINT', () => shutdown('SIGINT'));
  process.on('SIGTERM', () => shutdown('SIGTERM'));
};

start().catch((err) => {
  logger.error(`❌ فشل بدء السيرفر: ${err.message}`);
  process.exit(1);
});