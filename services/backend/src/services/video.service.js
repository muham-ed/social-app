const Video = require('../models/Video');
const User = require('../models/User');
const ApiError = require('../utils/ApiError');
const { paginate, buildPagination } = require('../utils/helpers');

const createVideo = async (authorId, payload) => {
  const video = await Video.create({ ...payload, author: authorId });
  await User.findByIdAndUpdate(authorId, { $inc: { videosCount: 1 } });
  return video;
};

const getFeed = async (query) => {
  const { page, limit, skip } = paginate(query);
  const filter = { isDeleted: false, isHidden: false, visibility: 'public' };
  if (query.hashtag) filter.hashtags = query.hashtag.toLowerCase();

  const [videos, total] = await Promise.all([
    Video.find(filter)
      .populate('author', 'name username avatar isVerified')
      .skip(skip)
      .limit(limit)
      .sort({ createdAt: -1 }),
    Video.countDocuments(filter),
  ]);
  return { videos, pagination: buildPagination(total, page, limit) };
};

const getUserVideos = async (userId, query) => {
  const { page, limit, skip } = paginate(query);
  const filter = { author: userId, isDeleted: false };
  const [videos, total] = await Promise.all([
    Video.find(filter).skip(skip).limit(limit).sort({ createdAt: -1 }),
    Video.countDocuments(filter),
  ]);
  return { videos, pagination: buildPagination(total, page, limit) };
};

const getVideoById = async (id) => {
  const video = await Video.findByIdAndUpdate(id, { $inc: { viewsCount: 1 } }, { new: true }).populate(
    'author',
    'name username avatar isVerified',
  );
  if (!video) throw ApiError.notFound('الفيديو غير موجود');
  return video;
};

const toggleLike = async (videoId, userId) => {
  // simplified — في الحقيقة هنحتاج مجموعة Likes منفصلة
  const video = await Video.findById(videoId);
  if (!video) throw ApiError.notFound('الفيديو غير موجود');
  return video;
};

const deleteVideo = async (videoId, requester) => {
  const video = await Video.findById(videoId);
  if (!video) throw ApiError.notFound('الفيديو غير موجود');
  const isOwner = video.author.toString() === requester._id.toString();
  if (!isOwner && !['admin', 'moderator'].includes(requester.role)) {
    throw ApiError.forbidden('لا تملك صلاحية الحذف');
  }
  video.isDeleted = true;
  await video.save();
  return video;
};

module.exports = {
  createVideo,
  getFeed,
  getUserVideos,
  getVideoById,
  toggleLike,
  deleteVideo,
};