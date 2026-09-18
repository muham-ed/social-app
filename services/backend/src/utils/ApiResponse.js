class ApiResponse {
  constructor(statusCode, data, message = 'تم بنجاح') {
    this.statusCode = statusCode;
    this.success = statusCode < 400;
    this.message = message;
    this.data = data;
  }

  static ok(res, data, message) {
    return res.status(200).json(new ApiResponse(200, data, message));
  }
  static created(res, data, message) {
    return res.status(201).json(new ApiResponse(201, data, message));
  }
}

module.exports = ApiResponse;