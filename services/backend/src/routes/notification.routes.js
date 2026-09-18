const router = require('express').Router();
const auth = require('../middlewares/auth.middleware');
const ctrl = require('../controllers/notification.controller');

router.get('/', auth, ctrl.list);
router.post('/read-all', auth, ctrl.markAll);
router.post('/:id/read', auth, ctrl.markRead);
router.post('/token', auth, ctrl.registerToken);

module.exports = router;