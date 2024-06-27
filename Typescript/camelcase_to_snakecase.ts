import {snakeCase} from 'lodash';

const camelCaseToSnakeCase = (str: string): string => {
    return snakeCase(str);
};

console.log(camelCaseToSnakeCase('myName'));

type GPS = {
    latitudeValue: number;
    longitudeValue: number;
}

type House = {
    houseNumber: number;
    streetName: string;
    city: string;
    country: string;
    gps: GPS;
    postalCode: string;
}

type Person = {
    firstName: string;
    lastName: string;
    highSchool: string;
    university: string;
    clientID: string;
    house: House;
}

const gps: GPS = {
    latitudeValue: 123,
    longitudeValue: 456
}

const house: House = {
    houseNumber: 123,
    streetName: 'Main St',
    city: 'City',
    country: 'Country',
    postalCode: '123456',
    gps: gps
}

const person: Person = {
    firstName: 'John',
    lastName: 'Doe',
    highSchool: 'High School',
    university: 'University',
    clientID: '123456',
    house: house
}

// use snake-case to convert the person object,  need to convert House object as well and as well as GPS object
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

// ts-node camelcase_to_snakecase.ts to run