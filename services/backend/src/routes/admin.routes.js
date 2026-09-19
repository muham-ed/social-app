const router = require('express').Router();
const auth = require('../middlewares/auth.middleware');
const admin = require('../middlewares/admin.middleware');
const ctrl = require('../controllers/admin.controller');

router.get('/stats', auth, admin, ctrl.dashboardStats);
router.get('/users', auth, admin, ctrl.listUsers);
router.post('/users/:id/toggle-ban', auth, admin, ctrl.toggleUserBan);
router.get('/rooms/active', auth, admin, ctrl.listActiveRooms);
router.get('/videos', auth, admin, ctrl.listVideos);
router.post('/notifications/global', auth, admin, ctrl.sendGlobalNotification);

module.exports = router;