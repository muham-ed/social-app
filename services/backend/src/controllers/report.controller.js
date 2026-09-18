const reportService = require('../services/report.service');
const ApiResponse = require('../utils/ApiResponse');

const create = async (req, res, next) => {
  try {
    const report = await reportService.createReport(req.user._id, req.body);
    return ApiResponse.created(res, report, 'تم إرسال البلاغ');
  } catch (err) {
    next(err);
  }
};

const list = async (req, res, next) => {
  try {
    const data = await reportService.listReports(req.query);
    return ApiResponse.ok(res, data);
  } catch (err) {
    next(err);
  }
};

const handle = async (req, res, next) => {
  try {
    const report = await reportService.handleReport(req.params.id, req.user._id, req.body);
    return ApiResponse.ok(res, report, 'تم معالجة البلاغ');
  } catch (err) {
    next(err);
  }
};

module.exports = { create, list, handle };