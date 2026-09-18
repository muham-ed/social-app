const { validationResult } = require('express-validator');
const ApiError = require('../utils/ApiError');

const validate = (rules) => [
  ...rules,
  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return next(ApiError.badRequest('بيانات غير صحيحة', errors.array().map((e) => ({ field: e.path, msg: e.msg }))));
    }
    next();
  },
];

module.exports = validate;