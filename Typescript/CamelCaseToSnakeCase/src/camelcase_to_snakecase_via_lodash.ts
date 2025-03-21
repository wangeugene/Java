import {snakeCase} from 'lodash';
import { Person, person } from './Person';

const convertPersonToSnakeCase = (person: Person): Person => {
    const snakeCasePerson = {} as Person;
    for (const key in person) {
        if (typeof person[key] === 'object') {
            snakeCasePerson[snakeCase(key)] = convertPersonToSnakeCase(person[key]);
        } else {
            snakeCasePerson[snakeCase(key)] = person[key];
        }
    }
    return snakeCasePerson;
}
console.log(convertPersonToSnakeCase(person));

// ts-node /Users/eugene/IdeaProjects/Java/Typescript/src/camelCase2snakeCase/camelcase_to_snakecase_lodash.ts
// works fine
