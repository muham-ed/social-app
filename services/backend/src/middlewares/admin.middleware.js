const ApiError = require('../utils/ApiError');

const adminOnly = (req, res, next) => {
  if (!req.user) return next(ApiError.unauthorized());
  if (!['admin', 'moderator'].includes(req.user.role)) {
    return next(ApiError.forbidden('هذه العملية تتطلب صلاحيات إدارية'));
  }
  next();
};

module.exports = adminOnly;