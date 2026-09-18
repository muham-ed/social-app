const router = require('express').Router();
const auth = require('../middlewares/auth.middleware');
const admin = require('../middlewares/admin.middleware');
const ctrl = require('../controllers/report.controller');

router.post('/', auth, ctrl.create);
router.get('/', auth, admin, ctrl.list);
router.post('/:id/handle', auth, admin, ctrl.handle);

module.exports = router;