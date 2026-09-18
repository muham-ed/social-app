const Report = require('../models/Report');
const ApiError = require('../utils/ApiError');
const { paginate, buildPagination } = require('../utils/helpers');

const createReport = async (reporterId, { targetType, targetId, reason, description }) => {
  const existing = await Report.findOne({ reporter: reporterId, targetType, targetId, status: 'pending' });
  if (existing) throw ApiError.conflict('تم الإبلاغ مسبقًا');
  return Report.create({ reporter: reporterId, targetType, targetId, reason, description });
};

const listReports = async (query) => {
  const { page, limit, skip } = paginate(query);
  const filter = {};
  if (query.status) filter.status = query.status;
  if (query.targetType) filter.targetType = query.targetType;

  const [reports, total] = await Promise.all([
    Report.find(filter)
      .populate('reporter', 'name username')
      .populate('handledBy', 'name username')
      .skip(skip)
      .limit(limit)
      .sort({ createdAt: -1 }),
    Report.countDocuments(filter),
  ]);
  return { reports, pagination: buildPagination(total, page, limit) };
};

const handleReport = async (id, adminId, { status, actionTaken, notes }) => {
  const report = await Report.findByIdAndUpdate(
    id,
    { status, actionTaken, notes, handledBy: adminId, handledAt: new Date() },
    { new: true },
  );
  if (!report) throw ApiError.notFound('البلاغ غير موجود');
  return report;
};

module.exports = { createReport, listReports, handleReport };