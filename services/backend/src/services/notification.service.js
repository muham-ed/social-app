const Notification = require('../models/Notification');
const User = require('../models/User');
const { paginate, buildPagination } = require('../utils/helpers');

const create = async ({ user, type, title, body, data, actor }) => {
  const notif = await Notification.create({ user, type, title, body, data, actor });
  // هنا ممكن نضيف إرسال FCM
  return notif;
};

const list = async (userId, query) => {
  const { page, limit, skip } = paginate(query);
  const filter = { user: userId };
  const [notifications, total] = await Promise.all([
    Notification.find(filter).skip(skip).limit(limit).sort({ createdAt: -1 }),
    Notification.countDocuments(filter),
  ]);
  return { notifications, pagination: buildPagination(total, page, limit) };
};

const markRead = async (userId, id) => {
  await Notification.updateOne({ _id: id, user: userId }, { isRead: true, readAt: new Date() });
};

const markAllRead = async (userId) => {
  await Notification.updateMany({ user: userId, isRead: false }, { isRead: true, readAt: new Date() });
};

const registerFcmToken = async (userId, token) => {
  await User.findByIdAndUpdate(userId, { $addToSet: { fcmTokens: token } });
};

module.exports = { create, list, markRead, markAllRead, registerFcmToken };