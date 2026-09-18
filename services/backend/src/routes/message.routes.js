const router = require('express').Router();
const auth = require('../middlewares/auth.middleware');
const ctrl = require('../controllers/message.controller');

router.get('/', auth, ctrl.list);
router.get('/:userId', auth, ctrl.conversation);
router.post('/:userId', auth, ctrl.send);
router.post('/:userId/read', auth, ctrl.markRead);

module.exports = router;