// https://www.linkedin.com/learning/node-js-essential-training-14888164/using-readline?resume=false&u=106534538

const readline = require('./readline')
const readline_interface = readline.createInterface({
    input: process.stdin,
    output: process.stdout
})
const questions = ['What is your name?', 'Where do you live?', 'What are you going to do with NodeJS?']

function collectAnswers(questions, done) {
    const answers = []
    const questionAnswered = (answer) => {
        answers.push(answer)
        if (answers.length < questions.length) {
            readline_interface.question(questions[answers.length], questionAnswered)
        } else {
            done(answers)
        }
    }

    readline_interface.question(questions[0], questionAnswered)
}

collectAnswers(questions, answers => {
    console.log('Thank you for your answers. ')
    console.log(answers)
    process.exit()
})
