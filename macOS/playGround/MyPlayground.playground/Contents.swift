import Cocoa

      

let levelScore = 10
var gameScore = 0

      gameScore += levelScore
      
print("The game's score is \(gameScore)")

var levelBonusScore = 10.0
levelBonusScore = 20
print("The level's bonus score is \(levelBonusScore).")
gameScore += Int(levelBonusScore)
print("The game's final score is \(gameScore).")
let levelLowestScore = 50
let levelHighestScore = 99
let levels = 10
let levelScoreDifference = levelHighestScore - levelLowestScore
let averageLevelScore = Double(levelScoreDifference) / Double(levels)
print("The average score for each level is \(averageLevelScore).")

// Working with Strings in Swift
let day = "Monday"
let dailyTemperature = 75
print("Today is \(day), Rise and shine!")
// Option + Shift + 8 to type °
print("The temperature on \(day) is \(dailyTemperature)°F")
var temperature = 70

print("Today is \(day), the temperature now is \(temperature)°F")
temperature = 80
print("The temmperature on \(day) evening is \(temperature)°F")

let weeklyTemperature = 75
temperature = weeklyTemperature
print("The average temperature this week is 75°F")

let hour = "6"
let minutes = "15"
let period = "PM"

var time = hour + ":" + minutes + " " + period
print("It is \(time).")
print("It is \(time) on \(day).")
let timezone = "PST"
time += " \(timezone)"
print("It is \(time) on \(day).")
let shortDay = day.prefix(3)
print("Today is \(shortDay).")
print("It is \(time) on \(shortDay).")

