process.stdout.write('Listen to your input using standard input:\n')

process.stdin.on('data', (data) =>
    process.stdout.write(data.toString().toUpperCase())
)
