const { v4: uuid } = require('uuid');
const Room = require('../models/Room');
const User = require('../models/User');
const ApiError = require('../utils/ApiError');
const { buildRtcToken } = require('../config/agora');
const { paginate, buildPagination } = require('../utils/helpers');

const createRoom = async (ownerId, { title, description, type = 'audio', isPrivate = false, maxParticipants = 50 }) => {
  const channelName = `room_${uuid().replace(/-/g, '')}`;
  const room = await Room.create({
    title,
    description,
    type,
    owner: ownerId,
    channelName,
    isPrivate,
    maxParticipants,
    participants: [{ user: ownerId, role: 'owner', isCameraOn: type === 'video' }],
  });
  return room;
};

const listActiveRooms = async (query) => {
  const { page, limit, skip } = paginate(query);
  const filter = { isActive: true, isPrivate: false };
  if (query.type) filter.type = query.type;
  if (query.search) filter.title = { $regex: query.search, $options: 'i' };

  const [rooms, total] = await Promise.all([
    Room.find(filter).populate('owner', 'name username avatar').skip(skip).limit(limit).sort({ createdAt: -1 }),
    Room.countDocuments(filter),
  ]);
  return { rooms, pagination: buildPagination(total, page, limit) };
};

const getRoomById = async (id) => {
  const room = await Room.findById(id)
    .populate('owner', 'name username avatar')
    .populate('participants.user', 'name username avatar');
  if (!room) throw ApiError.notFound('الغرفة غير موجودة');
  return room;
};

const joinRoom = async (roomId, userId) => {
  const room = await Room.findById(roomId);
  if (!room) throw ApiError.notFound('الغرفة غير موجودة');
  if (!room.isActive) throw ApiError.badRequest('الغرفة منتهية');

  const existing = room.participants.find((p) => p.user.toString() === userId.toString());
  if (existing) return { room, role: existing.role };

  if (room.participants.length >= room.maxParticipants) {
    throw ApiError.badRequest('الغرفة ممتلئة');
  }

  room.participants.push({ user: userId, role: 'listener' });
  room.listenersCount += 1;
  await room.save();
  return { room, role: 'listener' };
};

const leaveRoom = async (roomId, userId) => {
  const room = await Room.findById(roomId);
  if (!room) throw ApiError.notFound('الغرفة غير موجودة');
  room.participants = room.participants.filter((p) => p.user.toString() !== userId.toString());
  if (room.participants.length === 0) {
    room.isActive = false;
    room.endedAt = new Date();
  }
  await room.save();
  return room;
};

const generateToken = async (roomId, userId, role = 'publisher') => {
  const room = await Room.findById(roomId);
  if (!room) throw ApiError.notFound('الغرفة غير موجودة');
  const token = buildRtcToken({ channelName: room.channelName, uid: userId, role });
  return { token, channelName: room.channelName, uid: userId };
};

const closeRoom = async (roomId, requester) => {
  const room = await Room.findById(roomId);
  if (!room) throw ApiError.notFound('الغرفة غير موجودة');
  const isOwner = room.owner.toString() === requester._id.toString();
  if (!isOwner && !['admin', 'moderator'].includes(requester.role)) {
    throw ApiError.forbidden('لا تملك صلاحية إغلاق الغرفة');
  }
  room.isActive = false;
  room.endedAt = new Date();
  await room.save();
  return room;
};

module.exports = { createRoom, listActiveRooms, getRoomById, joinRoom, leaveRoom, generateToken, closeRoom };