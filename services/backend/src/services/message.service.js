const Message = require('../models/Message');
const ApiError = require('../utils/ApiError');
const { paginate, buildPagination } = require('../utils/helpers');

const makeConversationId = (a, b) => [a.toString(), b.toString()].sort().join('_');

const sendMessage = async (senderId, receiverId, { text, mediaUrl, mediaType }) => {
  if (!text && !mediaUrl) throw ApiError.badRequest('الرسالة فاضية');
  const conversationId = makeConversationId(senderId, receiverId);
  const msg = await Message.create({
    conversationId,
    sender: senderId,
    receiver: receiverId,
    text: text || '',
    mediaUrl: mediaUrl || '',
    mediaType: mediaType || '',
  });
  return msg;
};

const getConversation = async (userId, otherId, query) => {
  const { page, limit, skip } = paginate(query);
  const conversationId = makeConversationId(userId, otherId);
  const filter = { conversationId, isDeleted: false };
  const [messages, total] = await Promise.all([
    Message.find(filter).skip(skip).limit(limit).sort({ createdAt: -1 }),
    Message.countDocuments(filter),
  ]);
  return { messages, pagination: buildPagination(total, page, limit) };
};

const listConversations = async (userId) => {
  const list = await Message.aggregate([
    { $match: { $or: [{ sender: userId }, { receiver: userId }], isDeleted: false } },
    { $sort: { createdAt: -1 } },
    {
      $group: {
        _id: '$conversationId',
        lastMessage: { $first: '$$ROOT' },
        unread: {
          $sum: {
            $cond: [{ $and: [{ $eq: ['$receiver', userId] }, { $eq: ['$isRead', false] }] }, 1, 0],
          },
        },
      },
    },
    { $sort: { 'lastMessage.createdAt': -1 } },
  ]);
  return list;
};

const markRead = async (userId, otherId) => {
  const conversationId = makeConversationId(userId, otherId);
  await Message.updateMany(
    { conversationId, receiver: userId, isRead: false },
    { isRead: true, readAt: new Date() },
  );
};

module.exports = { sendMessage, getConversation, listConversations, markRead, makeConversationId };