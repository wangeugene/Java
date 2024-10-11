// pnpm add camelcase-keys
import camelcaseKeys from 'camelcase-keys';

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

const house: House = {
    houseNumber: 123,
    streetName: 'Main St',
    city: 'Anytown',
    country: 'USA',
    gps: {
        latitudeValue: 40.7128,
        longitudeValue: -74.0060
    },
    postalCode: '12345'
};

const snakeCaseHouse = camelcaseKeys(house, { deep: true, pascalCase: false });
console.log(snakeCaseHouse);

// cd Java/Typescript 
// ts-node src/camelcase_to_snakecase_via_third_library.ts
// requires ERR_REQUIRE_ESM
