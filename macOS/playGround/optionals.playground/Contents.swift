import Cocoa

var greeting = "Hello, playground"

var password = "1234"
let passcode = Int(password)
print("Force unwrapping the optional value: \(passcode!)")

password = "hello world"
if let code = Int(password) {
    print("Successfully converted to Int: \(code)")
}else{
    print("Invalid passcode")
}

let accessCode: Int
if let code = Int(password) {
    accessCode = code
}else{
    accessCode = 1111
}
print("The passcode is \(accessCode)")

let firstPassword: String = "hello"
let secondPassword: String = "world"

if let firstCode = Int(firstPassword),let secondCode = Int(secondPassword) {
      print("The firstCode is \(firstCode) and the secondCode is \(secondCode)")
}else{
    print("conversion failed")
}

let firstAccesscode: Int
let secondAccesscode: Int
if let firstCode = Int(firstPassword),let secondCode = Int(secondPassword) {
    firstAccesscode = firstCode
    secondAccesscode = secondCode
}else{
    firstAccesscode = 1111
    secondAccesscode = 2222
}

print("The fisrt passcode is \(firstAccesscode) and the second passcode is \(secondAccesscode)")