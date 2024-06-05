const bearerFormatRegex = /Bearer ([^ ]+)/i;
let a_match_str = "Bearer abc123";

let match = a_match_str.match(bearerFormatRegex);

console.log(match);

// separating line console.log
console.log("=====================================");

// show me not much case
a_not_match_str = "Beer abc123";
let not_match = a_not_match_str.match(bearerFormatRegex);
console.log(not_match);
