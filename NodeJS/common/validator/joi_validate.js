const joi = require('joi')

const schema = joi.object({
    name: joi.string().required(),
    age: joi.number().required(),
})

const valid_value = schema.validate({name: 'John', age: 20})
console.log(valid_value)

const invalid_value = schema.validate({name: 'John'})
console.log(invalid_value)