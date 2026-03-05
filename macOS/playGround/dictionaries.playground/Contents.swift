import Cocoa

let levelScores: [Int] = [10,20,30,40,50,60,70]
levelScores.enumerated().forEach { level, score in
    print("The score of the Level \(level + 1): \(score) points")
}

var gameScore: Int = 0
for score in levelScores {
    gameScore += score
}
print("The total game score is: \(gameScore) points")

let weeklyTemperatures = ["Monday": 70, "Tuesday": 75, "Wednesday": 80, "Thursday": 85, "Friday":90, "Saturday": 95, "Sunday": 100]

for (day,temperature) in weeklyTemperatures {
    print("On \(day), it was \(temperature)°C")
}