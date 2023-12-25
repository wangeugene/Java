// noinspection ExceptionCaughtLocallyJS

const divisor = 100
let dividend = 0
const quotient_message = 'Arithmetic Error: Division by Zero'

try {
    if (dividend === 0) {
        // define customized exception and throw it
        throw new Error(quotient_message)
    }
    console.log(divisor / dividend)
} catch (error) {
    console.log(error.message)
}