const router = require('express').Router();
const auth = require('../middlewares/auth.middleware');
const admin = require('../middlewares/admin.middleware');
const ctrl = require('../controllers/user.controller');

router.get('/me', auth, ctrl.getMe);
router.patch('/me', auth, ctrl.updateMe);
router.post('/me/location', auth, ctrl.updateLocation);
router.get('/discover', auth, ctrl.discover);
router.get('/:id', auth, ctrl.getUser);

// Admin
router.get('/', auth, admin, ctrl.listUsers);
router.post('/:id/ban', auth, admin, ctrl.banUser);
router.post('/:id/unban', auth, admin, ctrl.unbanUser);

module.exports = router;