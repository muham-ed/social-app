const { RtcTokenBuilder, RtcRole } = require('agora-token');
const config = require('./env');

const buildRtcToken = ({ channelName, uid, role = 'publisher', expireSeconds = 3600 }) => {
  if (!config.agora.appId || !config.agora.appCertificate) {
    throw new Error('Agora credentials غير مهيأة');
  }
  const agoraRole = role === 'publisher' ? RtcRole.PUBLISHER : RtcRole.AUDIENCE;
  const privilegeExpire = Math.floor(Date.now() / 1000) + expireSeconds;
  return RtcTokenBuilder.buildTokenWithUid(
    config.agora.appId,
    config.agora.appCertificate,
    channelName,
    uid,
    agoraRole,
    privilegeExpire,
    privilegeExpire,
  );
};

module.exports = { buildRtcToken };