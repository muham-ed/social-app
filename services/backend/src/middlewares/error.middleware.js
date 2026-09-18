const logger = require('../utils/logger');
const ApiError = require('../utils/ApiError');
const config = require('../config/env');

// eslint-disable-next-line no-unused-vars
const errorHandler = (err, req, res, next) => {
  let error = err;

  if (!(error instanceof ApiError)) {
    if (error.name === 'ValidationError') {
      error = ApiError.badRequest('بيانات غير صحيحة', Object.values(error.errors).map((e) => e.message));
    } else if (error.name === 'CastError') {
      error = ApiError.badRequest('معرّف غير صالح');
    } else if (error.code === 11000) {
      error = ApiError.conflict('القيمة مستخدمة مسبقًا');
    } else {
      error = ApiError.internal(error.message || 'خطأ غير متوقع');
    }
  }

  if (error.statusCode >= 500) logger.error(err);

  res.status(error.statusCode).json({
    success: false,
    message: error.message,
    errors: error.errors,
    ...(config.isProd ? {} : { stack: err.stack }),
  });
};

const notFound = (req, res, next) => {
  next(ApiError.notFound(`المسار ${req.originalUrl} غير موجود`));
};

module.exports = { errorHandler, notFound };