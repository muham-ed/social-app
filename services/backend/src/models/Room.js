const mongoose = require('mongoose');

const participantSchema = new mongoose.Schema(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    role: { type: String, enum: ['owner', 'admin', 'speaker', 'listener'], default: 'listener' },
    joinedAt: { type: Date, default: Date.now },
    isMuted: { type: Boolean, default: false },
    isCameraOn: { type: Boolean, default: false },
  },
  { _id: false },
);

const roomSchema = new mongoose.Schema(
  {
    title: { type: String, required: true, trim: true, maxlength: 120 },
    description: { type: String, default: '', maxlength: 500 },
    owner: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true, index: true },
    channelName: { type: String, required: true, unique: true },
    type: { type: String, enum: ['audio', 'video'], default: 'audio' },
    coverImage: { type: String, default: '' },
    participants: [participantSchema],
    maxParticipants: { type: Number, default: 50 },
    isActive: { type: Boolean, default: true },
    isLocked: { type: Boolean, default: false },
    isPrivate: { type: Boolean, default: false },
    startedAt: { type: Date, default: Date.now },
    endedAt: Date,
    listenersCount: { type: Number, default: 0 },
    tags: [{ type: String, lowercase: true, trim: true }],
  },
  { timestamps: true },
);

roomSchema.index({ isActive: 1, createdAt: -1 });

module.exports = mongoose.model('Room', roomSchema);