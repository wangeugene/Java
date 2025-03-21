type GPS = {
    latitudeValue: number;
    longitudeValue: number;
};
type House = {
    houseNumber: number;
    streetName: string;
    city: string;
    country: string;
    gps: GPS;
    postalCode: string;
};
const gps: GPS = {
    latitudeValue: 123,
    longitudeValue: 456
};
const house: House = {
    houseNumber: 123,
    streetName: 'Main St',
    city: 'City',
    country: 'Country',
    postalCode: '123456',
    gps: gps
};

export type Person = {
    firstName: string;
    lastName: string;
    highSchool: string;
    university: string;
    clientID: string;
    house: House;
};

export const person: Person = {
    firstName: 'John',
    lastName: 'Doe',
    highSchool: 'High School',
    university: 'University',
    clientID: '123456',
    house: house
};
