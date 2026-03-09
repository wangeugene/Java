var goldBars = 0
let unlockTreasureChest = {(inventory: Int) -> Int in
    inventory + 100
}

let unlockTreasureChestInout = {(inventory: inout Int) -> Void in
    inventory += 50
}

goldBars = unlockTreasureChest(goldBars) // 0 + 100
print("The gold bars is \(goldBars)")

unlockTreasureChestInout(&goldBars) // 100 + 50
print("The gold bars is \(goldBars)")

unlockTreasureChestInout(&goldBars) // 150 + 50
print("The gold bars is \(goldBars)")

goldBars = unlockTreasureChest(goldBars) // 200 + 100
print("The gold bars is \(goldBars)")