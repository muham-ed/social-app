const messageService = require('../services/message.service');
const ApiResponse = require('../utils/ApiResponse');

const send = async (req, res, next) => {
  try {
    const msg = await messageService.sendMessage(req.user._id, req.params.userId, req.body);
    return ApiResponse.created(res, msg, 'تم الإرسال');
  } catch (err) {
    next(err);
  }
};

const conversation = async (req, res, next) => {
  try {
    const data = await messageService.getConversation(req.user._id, req.params.userId, req.query);
    return ApiResponse.ok(res, data);
  } catch (err) {
    next(err);
  }
};

const list = async (req, res, next) => {
  try {
    const data = await messageService.listConversations(req.user._id);
    return ApiResponse.ok(res, data);
  } catch (err) {
    next(err);
  }
};

const markRead = async (req, res, next) => {
  try {
    await messageService.markRead(req.user._id, req.params.userId);
    return ApiResponse.ok(res, null, 'تم القراءة');
  } catch (err) {
    next(err);
  }
};

module.exports = { send, conversation, list, markRead };