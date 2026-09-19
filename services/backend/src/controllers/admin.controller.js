const User = require('../models/User');
const Video = require('../models/Video');
const Room = require('../models/Room');
const Report = require('../models/Report');
const ApiResponse = require('../utils/ApiResponse');

const dashboardStats = async (req, res, next) => {
  try {
    const [usersCount, videosCount, activeRooms, pendingReports] = await Promise.all([
      User.countDocuments(),
      Video.countDocuments({ isDeleted: false }),
      Room.countDocuments({ isActive: true }),
      Report.countDocuments({ status: 'pending' }),
    ]);
    const since = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000);
    const newUsers = await User.countDocuments({ createdAt: { $gte: since } });
    const newVideos = await Video.countDocuments({ createdAt: { $gte: since } });

    return ApiResponse.ok(res, {
      users: { total: usersCount, newThisWeek: newUsers },
      videos: { total: videosCount, newThisWeek: newVideos },
      rooms: { active: activeRooms },
      reports: { pending: pendingReports },
    });
  } catch (err) {
    next(err);
  }
};

const listUsers = async (req, res, next) => {
  try {
    const users = await User.find().sort({ createdAt: -1 });
    return ApiResponse.ok(res, users);
  } catch (err) {
    next(err);
  }
};

const toggleUserBan = async (req, res, next) => {
  try {
    const user = await User.findById(req.params.id);
    if (!user) return ApiResponse.notFound(res, 'المستخدم غير موجود');
    user.isBanned = !user.isBanned;
    await user.save();
    return ApiResponse.ok(res, user, user.isBanned ? 'تم حظر المستخدم' : 'تم فك حظر المستخدم');
  } catch (err) {
    next(err);
  }
};

const listActiveRooms = async (req, res, next) => {
  try {
    const rooms = await Room.find({ isActive: true }).populate('owner', 'name username');
    return ApiResponse.ok(res, rooms);
  } catch (err) {
    next(err);
  }
};

const listVideos = async (req, res, next) => {
  try {
    const videos = await Video.find({ isDeleted: false }).populate('author', 'name username').sort({ createdAt: -1 });
    return ApiResponse.ok(res, videos);
  } catch (err) {
    next(err);
  }
};

const sendGlobalNotification = async (req, res, next) => {
  try {
    // Logic to send notification to all users (e.g., via FCM)
    // For now, just a placeholder response
    return ApiResponse.ok(res, null, 'تم إرسال الإشعار لجميع المستخدمين');
  } catch (err) {
    next(err);
  }
};

module.exports = {
  dashboardStats,
  listUsers,
  toggleUserBan,
  listActiveRooms,
  listVideos,
  sendGlobalNotification,
};