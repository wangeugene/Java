import Cocoa

let levels = 10
let freeLevels = 4
let bonusLevel = 3

for level in 1...levels {
    if level == bonusLevel {
        print("Skip bonus level \(bonusLevel).")
        continue
    }
    print("Play level \(level).")
    if level == freeLevels {
        print("You have played all \(freeLevels) free levels. Buy the game to play the remaining \(levels - freeLevels) levels.")
        break
    }
}