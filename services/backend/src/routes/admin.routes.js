const router = require('express').Router();
const auth = require('../middlewares/auth.middleware');
const admin = require('../middlewares/admin.middleware');
const ctrl = require('../controllers/admin.controller');

router.get('/stats', auth, admin, ctrl.dashboardStats);

module.exports = router;