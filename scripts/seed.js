/* eslint-disable no-console */
const mongoose = require('mongoose');
const config = require('../services/backend/src/config/env');
const User = require('../services/backend/src/models/User');

const run = async () => {
  await mongoose.connect(config.mongoUri);
  console.log('🌱 بدء إدخال بيانات تجريبية...');

  await User.deleteMany({});

  const admin = await User.create({
    name: 'Admin',
    username: 'admin',
    email: 'admin@social.app',
    password: 'admin123',
    role: 'admin',
    isVerified: true,
  });

  const users = [];
  for (let i = 1; i <= 5; i++) {
    users.push(
      await User.create({
        name: `User ${i}`,
        username: `user${i}`,
        email: `user${i}@social.app`,
        password: 'password123',
        location: { type: 'Point', coordinates: [31.2 + i * 0.01, 30.0 + i * 0.01] },
      }),
    );
  }

  console.log('✅ تم إنشاء:');
  console.log(`  - Admin: admin@social.app / admin123`);
  console.log(`  - Users: user1..5@social.app / password123`);
  await mongoose.disconnect();
};

run().catch((err) => {
  console.error(err);
  process.exit(1);
});