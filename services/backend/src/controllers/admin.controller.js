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

module.exports = { dashboardStats };