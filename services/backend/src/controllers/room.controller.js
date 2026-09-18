const roomService = require('../services/room.service');
const ApiResponse = require('../utils/ApiResponse');

const create = async (req, res, next) => {
  try {
    const room = await roomService.createRoom(req.user._id, req.body);
    return ApiResponse.created(res, room, 'تم إنشاء الغرفة');
  } catch (err) {
    next(err);
  }
};

const list = async (req, res, next) => {
  try {
    const data = await roomService.listActiveRooms(req.query);
    return ApiResponse.ok(res, data);
  } catch (err) {
    next(err);
  }
};

const getOne = async (req, res, next) => {
  try {
    const room = await roomService.getRoomById(req.params.id);
    return ApiResponse.ok(res, room);
  } catch (err) {
    next(err);
  }
};

const join = async (req, res, next) => {
  try {
    const data = await roomService.joinRoom(req.params.id, req.user._id);
    return ApiResponse.ok(res, data, 'تم الدخول للغرفة');
  } catch (err) {
    next(err);
  }
};

const leave = async (req, res, next) => {
  try {
    await roomService.leaveRoom(req.params.id, req.user._id);
    return ApiResponse.ok(res, null, 'تم الخروج');
  } catch (err) {
    next(err);
  }
};

const token = async (req, res, next) => {
  try {
    const data = await roomService.generateToken(req.params.id, req.user._id, req.query.role);
    return ApiResponse.ok(res, data);
  } catch (err) {
    next(err);
  }
};

const close = async (req, res, next) => {
  try {
    await roomService.closeRoom(req.params.id, req.user);
    return ApiResponse.ok(res, null, 'تم إغلاق الغرفة');
  } catch (err) {
    next(err);
  }
};

module.exports = { create, list, getOne, join, leave, token, close };