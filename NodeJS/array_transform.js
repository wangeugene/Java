const array = [1, 2, 3, 4, 5];
const modifyArray = (nums) => nums.map(item => item % 2 === 0 ? item * 2 : item * 3);

console.log(modifyArray(array));

