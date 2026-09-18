const authService = require('../services/auth.service');
const ApiResponse = require('../utils/ApiResponse');

const register = async (req, res, next) => {
  try {
    const { user, tokens } = await authService.register(req.body);
    return ApiResponse.created(res, { user, tokens }, 'تم التسجيل بنجاح');
  } catch (err) {
    next(err);
  }
};

const login = async (req, res, next) => {
  try {
    const { user, tokens } = await authService.login(req.body);
    return ApiResponse.ok(res, { user, tokens }, 'تم تسجيل الدخول');
  } catch (err) {
    next(err);
  }
};

const refresh = async (req, res, next) => {
  try {
    const tokens = await authService.refresh(req.body.refreshToken);
    return ApiResponse.ok(res, tokens);
  } catch (err) {
    next(err);
  }
};

const logout = async (req, res, next) => {
  try {
    await authService.logout(req.user._id, req.body.fcmToken);
    return ApiResponse.ok(res, null, 'تم تسجيل الخروج');
  } catch (err) {
    next(err);
  }
};

const me = async (req, res) => ApiResponse.ok(res, req.user);

module.exports = { register, login, refresh, logout, me };