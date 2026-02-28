import Cocoa

// to store the scores of the levels
var levelScores: [Int] = []

if levelScores.count == 0 {
    print("Start playing the game!")
}

// to save score 10 for level 1
let firstLevelScore = 10
levelScores.append(firstLevelScore)
print("The first level score is \(levelScores[0])")

let levelBonusScore = 40
levelScores[0] += levelBonusScore
print("The first level score with bonus is \(levelScores[0])")

let freeLevelScores = [20,30]
levelScores += freeLevelScores

for score in levelScores {
       print("Level score: \(score)")
}
let freeLevels = 3
if levelScores.count == freeLevels {
    print("You have to buy the game in order to play its full version.")
    levelScores = []
    print("Game restarted.")
}

