#!/bin/bash
sudo apt update
sudo apt install -y curl
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
mkdir minecraft-bots
cd minecraft-bots
npm init -y
npm install mineflayer
cat > bot-script.js << 'EOF'
const mineflayer = require('mineflayer');
const HOST = '15.204.142.106';
const PORT = 26188;
const VERSION = '1.20.1';
const usernames = ['test1', 'test2', 'test3', 'test4', 'test5', 'test6', 'test7', 'test8', 'test9', 'test10', 'test11', 'test12', 'test13', 'test14', 'test15', 'test16', 'test17', 'test18'];
const bots = [];
let spawnedCount = 0;
function createBot(username) {
  const bot = mineflayer.createBot({
    host: HOST,
    port: PORT,
    username: username,
    version: VERSION,
    auth: 'offline'
  });
  bot.on('login', () => console.log(`${username} logged in`));
  bot.on('spawn', () => {
    console.log(`${username} spawned`);
    spawnedCount++;
    bots.push(bot);
    if (spawnedCount === 18) {
      console.log('All 18 bots spawned! Starting activity...');
      bots.forEach(b => startActivity(b));
    }
  });
  bot.on('error', (err) => console.error(`${username} error:`, err));
  bot.on('end', () => {
    console.log(`${username} disconnected. Reconnecting...`);
    setTimeout(() => createBot(username), 5000);
  });
  return bot;
}
function startActivity(bot) {
  bot.setControlState('forward', true);
  setInterval(() => {
    bot.setControlState('jump', true);
    setTimeout(() => bot.setControlState('jump', false), 200);
  }, 2000);
  setInterval(() => {
    const yaw = Math.random() * 2 * Math.PI;
    bot.look(yaw, 0, false);
  }, 10000);
}
usernames.forEach(username => createBot(username));
console.log(`Starting 18 Minecraft bots for ${HOST}:${PORT} (version ${VERSION})`);
EOF
node bot-script.js
