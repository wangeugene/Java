import {snakeCase} from 'snake-case';

const camelCaseToSnakeCase = (str) => snakeCase(str);

console.log(camelCaseToSnakeCase('camelCase')); // camel_case
