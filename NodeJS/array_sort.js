const arr = [3, 1, 2, 5, 7, 8, 10, 11, 11];


arr.sort().reverse();
console.log(arr)

arr.sort((a, b) => b - a)
console.log(arr)