const roomService = require('../services/room.service');

const registerRoomHandlers = (io, socket) => {
  socket.on('room:join', async ({ roomId }, ack) => {
    try {
      const { room } = await roomService.joinRoom(roomId, socket.user._id);
      socket.join(`room:${roomId}`);
      io.to(`room:${roomId}`).emit('room:user-joined', {
        roomId,
        user: socket.user,
      });
      if (typeof ack === 'function') ack({ ok: true, data: room });
    } catch (err) {
      if (typeof ack === 'function') ack({ ok: false, error: err.message });
    }
  });

  socket.on('room:leave', async ({ roomId }) => {
    socket.leave(`room:${roomId}`);
    await roomService.leaveRoom(roomId, socket.user._id);
    io.to(`room:${roomId}`).emit('room:user-left', {
      roomId,
      userId: socket.user._id,
    });
  });

  socket.on('room:message', ({ roomId, text }) => {
    io.to(`room:${roomId}`).emit('room:message', {
      roomId,
      user: socket.user,
      text,
      createdAt: new Date(),
    });
  });

  socket.on('room:mute', ({ roomId, targetUserId, muted }) => {
    io.to(`room:${roomId}`).emit('room:muted', { targetUserId, muted });
  });

  socket.on('room:kick', ({ roomId, targetUserId }) => {
    io.to(`user:${targetUserId}`).emit('room:kicked', { roomId });
  });

  socket.on('disconnecting', () => {
    for (const room of socket.rooms) {
      if (room.startsWith('room:')) {
        const roomId = room.split(':')[1];
        socket.to(room).emit('room:user-left', { roomId, userId: socket.user._id });
      }
    }
  });
};

module.exports = registerRoomHandlers;