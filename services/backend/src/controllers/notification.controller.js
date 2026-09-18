const notifService = require('../services/notification.service');
const ApiResponse = require('../utils/ApiResponse');

const list = async (req, res, next) => {
  try {
    const data = await notifService.list(req.user._id, req.query);
    return ApiResponse.ok(res, data);
  } catch (err) {
    next(err);
  }
};

const markRead = async (req, res, next) => {
  try {
    await notifService.markRead(req.user._id, req.params.id);
    return ApiResponse.ok(res, null);
  } catch (err) {
    next(err);
  }
};

const markAll = async (req, res, next) => {
  try {
    await notifService.markAllRead(req.user._id);
    return ApiResponse.ok(res, null);
  } catch (err) {
    next(err);
  }
};

const registerToken = async (req, res, next) => {
  try {
    await notifService.registerFcmToken(req.user._id, req.body.token);
    return ApiResponse.ok(res, null, 'تم تسجيل التوكن');
  } catch (err) {
    next(err);
  }
};

module.exports = { list, markRead, markAll, registerToken };