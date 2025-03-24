import { schedule } from 'node-cron';

// Schedule the cron job
const cronJob = schedule('* * * * * *', () => {
    console.log('cron job');
});

// Start the cron job
cronJob.start();

setInterval(() => {}, 1000); // Keep process alive