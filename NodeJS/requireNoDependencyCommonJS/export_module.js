let count = 0;
const increase = () => count++;
const decrease = () => count--;
const getCount = () => count;

const author = 'eugene';

module.exports = {
    status: true,
    increase,
    decrease,
    getCount,
    author
}