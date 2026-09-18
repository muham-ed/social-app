const router = require('express').Router();
const auth = require('../middlewares/auth.middleware');
const ctrl = require('../controllers/room.controller');

router.post('/', auth, ctrl.create);
router.get('/', auth, ctrl.list);
router.get('/:id', auth, ctrl.getOne);
router.post('/:id/join', auth, ctrl.join);
router.post('/:id/leave', auth, ctrl.leave);
router.get('/:id/token', auth, ctrl.token);
router.post('/:id/close', auth, ctrl.close);

module.exports = router;