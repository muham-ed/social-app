const User = require('../models/User');
const Block = require('../models/Block');
const ApiError = require('../utils/ApiError');
const { paginate, buildPagination } = require('../utils/helpers');

const getProfile = async (userId) => {
  const user = await User.findById(userId);
  if (!user) throw ApiError.notFound('المستخدم غير موجود');
  return user;
};

const updateProfile = async (userId, updates) => {
  const allowed = ['name', 'bio', 'avatar', 'gender', 'birthDate'];
  const data = {};
  allowed.forEach((k) => {
    if (updates[k] !== undefined) data[k] = updates[k];
  });
  const user = await User.findByIdAndUpdate(userId, data, { new: true, runValidators: true });
  return user;
};

const updateLocation = async (userId, lng, lat) => {
  const user = await User.findByIdAndUpdate(
    userId,
    { location: { type: 'Point', coordinates: [lng, lat] } },
    { new: true },
  );
  return user;
};

const discoverNearby = async (userId, { lng, lat, radiusKm = 10, query }) => {
  const blocked = await Block.find({ blocker: userId }).distinct('blocked');
  const filter = {
    _id: { $ne: userId, $nin: blocked },
    isActive: true,
    isBanned: false,
    location: {
      $nearSphere: {
        $geometry: { type: 'Point', coordinates: [lng, lat] },
        $maxDistance: radiusKm * 1000,
      },
    },
  };
  if (query) filter.name = { $regex: query, $options: 'i' };
  return User.find(filter).limit(50);
};

const listUsers = async (query) => {
  const { page, limit, skip } = paginate(query);
  const filter = {};
  if (query.search) {
    filter.$or = [
      { name: { $regex: query.search, $options: 'i' } },
      { username: { $regex: query.search, $options: 'i' } },
      { email: { $regex: query.search, $options: 'i' } },
    ];
  }
  if (query.role) filter.role = query.role;
  if (query.isBanned !== undefined) filter.isBanned = query.isBanned === 'true';

  const [users, total] = await Promise.all([
    User.find(filter).skip(skip).limit(limit).sort({ createdAt: -1 }),
    User.countDocuments(filter),
  ]);
  return { users, pagination: buildPagination(total, page, limit) };
};

const banUser = async (userId, { reason, until, permanent, adminId }) => {
  const user = await User.findByIdAndUpdate(
    userId,
    {
      isBanned: true,
      banReason: reason,
      bannedUntil: permanent ? null : until,
      isActive: false,
    },
    { new: true },
  );
  if (!user) throw ApiError.notFound('المستخدم غير موجود');
  return user;
};

const unbanUser = async (userId) => {
  return User.findByIdAndUpdate(
    userId,
    { isBanned: false, banReason: null, bannedUntil: null, isActive: true },
    { new: true },
  );
};

module.exports = {
  getProfile,
  updateProfile,
  updateLocation,
  discoverNearby,
  listUsers,
  banUser,
  unbanUser,
};