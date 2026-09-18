const messageService = require('../services/message.service');

const registerChatHandlers = (io, socket) => {
  socket.on('message:send', async (payload, ack) => {
    try {
      const { receiverId, text, mediaUrl, mediaType } = payload;
      const msg = await messageService.sendMessage(socket.user._id, receiverId, {
        text,
        mediaUrl,
        mediaType,
      });
      io.to(`user:${receiverId}`).emit('message:new', msg);
      socket.emit('message:sent', msg);
      if (typeof ack === 'function') ack({ ok: true, data: msg });
    } catch (err) {
      if (typeof ack === 'function') ack({ ok: false, error: err.message });
      socket.emit('error', { message: err.message });
    }
  });

  socket.on('message:typing', ({ receiverId, isTyping }) => {
    io.to(`user:${receiverId}`).emit('message:typing', {
      from: socket.user._id,
      isTyping,
    });
  });

  socket.on('message:read', async ({ otherId }) => {
    await messageService.markRead(socket.user._id, otherId);
    io.to(`user:${otherId}`).emit('message:read', { by: socket.user._id });
  });
};

module.exports = registerChatHandlers;