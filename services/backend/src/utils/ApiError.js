class ApiError extends Error {
  constructor(statusCode, message, errors = []) {
    super(message);
    this.statusCode = statusCode;
    this.errors = errors;
    this.isOperational = true;
    Error.captureStackTrace(this, this.constructor);
  }

  static badRequest(msg = 'طلب غير صحيح', errors = []) {
    return new ApiError(400, msg, errors);
  }
  static unauthorized(msg = 'غير مصرح') {
    return new ApiError(401, msg);
  }
  static forbidden(msg = 'ممنوع') {
    return new ApiError(403, msg);
  }
  static notFound(msg = 'غير موجود') {
    return new ApiError(404, msg);
  }
  static conflict(msg = 'تعارض') {
    return new ApiError(409, msg);
  }
  static internal(msg = 'خطأ داخلي') {
    return new ApiError(500, msg);
  }
}

module.exports = ApiError;