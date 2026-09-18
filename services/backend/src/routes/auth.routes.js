const router = require('express').Router();
const { body } = require('express-validator');
const validate = require('../middlewares/validation.middleware');
const { authLimiter } = require('../middlewares/rateLimit.middleware');
const ctrl = require('../controllers/auth.controller');
const auth = require('../middlewares/auth.middleware');

router.post(
  '/register',
  authLimiter,
  validate([
    body('name').trim().notEmpty().withMessage('الاسم مطلوب'),
    body('username').trim().isLength({ min: 3, max: 30 }).withMessage('اسم المستخدم غير صالح'),
    body('email').isEmail().withMessage('البريد غير صالح').normalizeEmail(),
    body('password').isLength({ min: 6 }).withMessage('كلمة المرور 6 أحرف على الأقل'),
  ]),
  ctrl.register,
);

router.post(
  '/login',
  authLimiter,
  validate([
    body('emailOrUsername').notEmpty().withMessage('البريد أو اسم المستخدم مطلوب'),
    body('password').notEmpty().withMessage('كلمة المرور مطلوبة'),
  ]),
  ctrl.login,
);

router.post('/refresh', validate([body('refreshToken').notEmpty()]), ctrl.refresh);
router.post('/logout', auth, ctrl.logout);
router.get('/me', auth, ctrl.me);

module.exports = router;