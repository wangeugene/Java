// pnpm add camelcase-keys
// tsconfig.json ->  "moduleResolution": "node" is a must
import camelcaseKeys from 'camelcase-keys';
import { person } from './Person';

const snakeCaseHouse = camelcaseKeys(person, { deep: true, pascalCase: false });
console.log(snakeCaseHouse);

// ts-node /Users/eugene/IdeaProjects/Java/Typescript/src/camelCase2snakeCase/camelcase_to_snakecase_via_third_library.ts
// ES-module error
