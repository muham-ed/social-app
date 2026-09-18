const jwt = require('jsonwebtoken');
const config = require('../config/env');
const User = require('../models/User');
const ApiError = require('../utils/ApiError');

const signTokens = (user) => {
  const access = jwt.sign({ sub: user._id, role: user.role }, config.jwt.secret, {
    expiresIn: config.jwt.expiresIn,
  });
  const refresh = jwt.sign({ sub: user._id, type: 'refresh' }, config.jwt.refreshSecret, {
    expiresIn: config.jwt.refreshExpiresIn,
  });
  return { access, refresh };
};

const register = async ({ name, username, email, password, phone }) => {
  const exists = await User.findOne({ $or: [{ email }, { username }, ...(phone ? [{ phone }] : [])] });
  if (exists) throw ApiError.conflict('المستخدم موجود مسبقًا');

  const user = await User.create({ name, username, email, password, phone });
  const tokens = signTokens(user);
  return { user, tokens };
};

const login = async ({ emailOrUsername, password }) => {
  const user = await User.findOne({
    $or: [{ email: emailOrUsername.toLowerCase() }, { username: emailOrUsername.toLowerCase() }],
  }).select('+password');

  if (!user) throw ApiError.unauthorized('بيانات الدخول غير صحيحة');
  if (user.isBanned) throw ApiError.forbidden('الحساب محظور');

  const ok = await user.comparePassword(password);
  if (!ok) throw ApiError.unauthorized('بيانات الدخول غير صحيحة');

  user.lastSeenAt = new Date();
  await user.save({ validateBeforeSave: false });

  const tokens = signTokens(user);
  return { user, tokens };
};

const refresh = async (token) => {
  try {
    const payload = jwt.verify(token, config.jwt.refreshSecret);
    const user = await User.findById(payload.sub);
    if (!user) throw ApiError.unauthorized();
    return signTokens(user);
  } catch (err) {
    throw ApiError.unauthorized('Refresh token غير صالح');
  }
};

const logout = async (userId, fcmToken) => {
  if (fcmToken) {
    await User.findByIdAndUpdate(userId, { $pull: { fcmTokens: fcmToken } });
  }
};

module.exports = { register, login, refresh, logout, signTokens };