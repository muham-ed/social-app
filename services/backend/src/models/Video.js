const mongoose = require('mongoose');

const videoSchema = new mongoose.Schema(
  {
    author: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true, index: true },
    caption: { type: String, default: '', maxlength: 500 },
    videoUrl: { type: String, required: true },
    thumbnailUrl: { type: String, default: '' },
    duration: { type: Number, default: 0 }, // بالثواني
    width: Number,
    height: Number,
    soundName: { type: String, default: '' },
    hashtags: [{ type: String, lowercase: true, trim: true }],
    mentions: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
    likesCount: { type: Number, default: 0 },
    commentsCount: { type: Number, default: 0 },
    sharesCount: { type: Number, default: 0 },
    viewsCount: { type: Number, default: 0 },
    isHidden: { type: Boolean, default: false },
    isDeleted: { type: Boolean, default: false },
    visibility: { type: String, enum: ['public', 'followers', 'private'], default: 'public' },
  },
  { timestamps: true },
);

videoSchema.index({ hashtags: 1 });
videoSchema.index({ createdAt: -1 });

module.exports = mongoose.model('Video', videoSchema);