const userService = require('../services/user.service');
const ApiResponse = require('../utils/ApiResponse');

const getMe = async (req, res) => ApiResponse.ok(res, req.user);

const updateMe = async (req, res, next) => {
  try {
    const user = await userService.updateProfile(req.user._id, req.body);
    return ApiResponse.ok(res, user, 'تم التحديث');
  } catch (err) {
    next(err);
  }
};

const updateLocation = async (req, res, next) => {
  try {
    const { lng, lat } = req.body;
    const user = await userService.updateLocation(req.user._id, lng, lat);
    return ApiResponse.ok(res, user, 'تم تحديث الموقع');
  } catch (err) {
    next(err);
  }
};

const discover = async (req, res, next) => {
  try {
    const { lng, lat, radiusKm, query } = req.query;
    const users = await userService.discoverNearby(req.user._id, {
      lng: parseFloat(lng),
      lat: parseFloat(lat),
      radiusKm: radiusKm ? parseFloat(radiusKm) : 10,
      query,
    });
    return ApiResponse.ok(res, users);
  } catch (err) {
    next(err);
  }
};

const getUser = async (req, res, next) => {
  try {
    const user = await userService.getProfile(req.params.id);
    return ApiResponse.ok(res, user);
  } catch (err) {
    next(err);
  }
};

const listUsers = async (req, res, next) => {
  try {
    const data = await userService.listUsers(req.query);
    return ApiResponse.ok(res, data);
  } catch (err) {
    next(err);
  }
};

const banUser = async (req, res, next) => {
  try {
    const user = await userService.banUser(req.params.id, { ...req.body, adminId: req.user._id });
    return ApiResponse.ok(res, user, 'تم حظر المستخدم');
  } catch (err) {
    next(err);
  }
};

const unbanUser = async (req, res, next) => {
  try {
    const user = await userService.unbanUser(req.params.id);
    return ApiResponse.ok(res, user, 'تم إلغاء الحظر');
  } catch (err) {
    next(err);
  }
};

module.exports = { getMe, updateMe, updateLocation, discover, getUser, listUsers, banUser, unbanUser };