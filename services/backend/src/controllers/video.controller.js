const videoService = require('../services/video.service');
const ApiResponse = require('../utils/ApiResponse');

const create = async (req, res, next) => {
  try {
    const payload = {
      caption: req.body.caption,
      videoUrl: req.body.videoUrl || (req.file ? `/uploads/${req.file.filename}` : ''),
      thumbnailUrl: req.body.thumbnailUrl || '',
      duration: req.body.duration ? Number(req.body.duration) : 0,
      hashtags: req.body.hashtags ? req.body.hashtags.split(',').map((t) => t.trim()) : [],
    };
    const video = await videoService.createVideo(req.user._id, payload);
    return ApiResponse.created(res, video, 'تم نشر الفيديو');
  } catch (err) {
    next(err);
  }
};

const feed = async (req, res, next) => {
  try {
    const data = await videoService.getFeed(req.query);
    return ApiResponse.ok(res, data);
  } catch (err) {
    next(err);
  }
};

const userVideos = async (req, res, next) => {
  try {
    const data = await videoService.getUserVideos(req.params.userId, req.query);
    return ApiResponse.ok(res, data);
  } catch (err) {
    next(err);
  }
};

const getOne = async (req, res, next) => {
  try {
    const video = await videoService.getVideoById(req.params.id);
    return ApiResponse.ok(res, video);
  } catch (err) {
    next(err);
  }
};

const remove = async (req, res, next) => {
  try {
    await videoService.deleteVideo(req.params.id, req.user);
    return ApiResponse.ok(res, null, 'تم حذف الفيديو');
  } catch (err) {
    next(err);
  }
};

module.exports = { create, feed, userVideos, getOne, remove };