const mongoose = require('mongoose');

const reportSchema = new mongoose.Schema(
  {
    reporter: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    targetType: { type: String, enum: ['user', 'video', 'comment', 'room', 'message'], required: true },
    targetId: { type: mongoose.Schema.Types.ObjectId, required: true },
    reason: {
      type: String,
      enum: ['spam', 'harassment', 'hate', 'violence', 'nudity', 'false_info', 'other'],
      required: true,
    },
    description: { type: String, default: '', maxlength: 1000 },
    status: { type: String, enum: ['pending', 'reviewing', 'resolved', 'dismissed'], default: 'pending' },
    handledBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
    actionTaken: { type: String, enum: ['', 'warn', 'delete', 'temp_ban', 'perm_ban'], default: '' },
    handledAt: Date,
    notes: String,
  },
  { timestamps: true },
);

reportSchema.index({ status: 1, createdAt: -1 });

module.exports = mongoose.model('Report', reportSchema);