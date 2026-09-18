const { Server } = require('socket.io');
const jwt = require('jsonwebtoken');
const config = require('../config/env');
const logger = require('../utils/logger');
const registerChatHandlers = require('./chat.socket');
const registerRoomHandlers = require('./room.socket');
const User = require('../models/User');

const initSocket = (httpServer) => {
  const io = new Server(httpServer, {
    cors: { origin: config.corsOrigin, credentials: true },
  });

  io.use(async (socket, next) => {
    try {
      const token = socket.handshake.auth?.token;
      if (!token) return next(new Error('Auth token مطلوب'));
      const payload = jwt.verify(token, config.jwt.secret);
      const user = await User.findById(payload.sub).select('name username avatar');
      if (!user) return next(new Error('المستخدم غير موجود'));
      socket.user = user;
      next();
    } catch (err) {
      next(new Error('توكن غير صالح'));
    }
  });

  io.on('connection', (socket) => {
    logger.info(`🟢 Socket متصل: ${socket.user.username}`);
    socket.join(`user:${socket.user._id}`);

    registerChatHandlers(io, socket);
    registerRoomHandlers(io, socket);

    socket.on('disconnect', () => {
      logger.info(`🔴 Socket انفصل: ${socket.user.username}`);
    });
  });

  return io;
};

module.exports = initSocket;