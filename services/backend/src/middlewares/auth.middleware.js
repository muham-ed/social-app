const jwt = require('jsonwebtoken');
const config = require('../config/env');
const ApiError = require('../utils/ApiError');
const User = require('../models/User');

const auth = async (req, res, next) => {
  try {
    const header = req.headers.authorization || '';
    const token = header.startsWith('Bearer ') ? header.slice(7) : null;
    if (!token) throw ApiError.unauthorized('التوكن مطلوب');

    const payload = jwt.verify(token, config.jwt.secret);
    const user = await User.findById(payload.sub);
    if (!user) throw ApiError.unauthorized('المستخدم غير موجود');
    if (user.isBanned) throw ApiError.forbidden('الحساب محظور');
    if (!user.isActive) throw ApiError.forbidden('الحساب غير مفعّل');

    req.user = user;
    next();
  } catch (err) {
    if (err.name === 'JsonWebTokenError' || err.name === 'TokenExpiredError') {
      return next(ApiError.unauthorized('التوكن غير صالح أو منتهي'));
    }
    next(err);
  }
};

module.exports = auth;