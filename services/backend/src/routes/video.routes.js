const router = require('express').Router();
const auth = require('../middlewares/auth.middleware');
const upload = require('../middlewares/upload.middleware');
const ctrl = require('../controllers/video.controller');

router.post('/', auth, upload.single('video'), ctrl.create);
router.get('/feed', auth, ctrl.feed);
router.get('/user/:userId', auth, ctrl.userVideos);
router.get('/:id', auth, ctrl.getOne);
router.delete('/:id', auth, ctrl.remove);

module.exports = router;