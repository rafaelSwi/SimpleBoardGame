import Foundation
import Darwin

struct Player {
    var name: String
    var position: Int
}

// Storage

enum GameSettings {
    static let diceLimit = 6
    static let positionLimit = 50
    static let penalty = 3
}

enum GoodOrBad {
    case bad
    case good
}

let specialPositions_Good = [11,25,39,44]
let specialPositions_Bad = [13,18,31,43]

// Game Variables

var Player1 = Player (name: "P1", position: 0)
var Player2 = Player (name: "P2", position: 0)

var PlayerTurn = 1
var menuOption = ""
var diceValue = 0

// Game Functions (unordered)

func PressEnter () {
    print ("\n[PRESS ENTER TO CONTINUE]")
    return menuOption = readLine()!
}

func SetNameForBothPlayers () {
    cleanScreen()
    print ("[X] INSERT PLAYER 1 NICKNAME [Default: Player One]:")
    Player1.name = readLine()!.capitalized
    if (Player1.name == "") {Player1.name = "Player One"}
    
    cleanScreen()
    print ("[X] INSERT PLAYER 2 NICKNAME [Default: Player Two]:")
    Player2.name = readLine()!.capitalized
    if (Player2.name == "") {Player2.name = "Player Two"}
    cleanScreen()
}

func specialPositionAlert (Player: Int, position: Int, Case: GoodOrBad) {
    
    if (Player == 1) {
        print ("[!] \(Player1.name) stepped into a Special Position! [\(position)]")
        if (Case == GoodOrBad.bad) {Player1.position -= GameSettings.penalty}
        if (Case == GoodOrBad.good) {Player1.position += GameSettings.penalty}
    }
    
    if (Player == 2) {
        print ("[!] \(Player2.name) stepped into a Special Position! [\(position)]")
        if (Case == GoodOrBad.bad) {Player2.position -= GameSettings.penalty}
        if (Case == GoodOrBad.good) {Player2.position += GameSettings.penalty}
    }
    
    switch Case {
        
    case GoodOrBad.bad:
        print ("""
            [X] Unfortunately, it was an Unlucky Position.
            [X] Regressed \(GameSettings.penalty) Positions.
            """)
        PressEnter()
        
    case GoodOrBad.good:
        print ("""
            [X] Fortunately, it was a Lucky position!
            [X] Progressed \(GameSettings.penalty) Positions.
            """)
        PressEnter()
        
    }
    
}

func specialPositionsCheck () {
    
    cleanScreen()
    
    for position in specialPositions_Bad {
        
        if (position == Player1.position)
        {specialPositionAlert(Player: 1, position: position, Case: GoodOrBad.bad)}
        if (position == Player2.position)
        {specialPositionAlert(Player: 2, position: position, Case: GoodOrBad.bad)}
        
    }
    
    for position in specialPositions_Good {
        
        if (position == Player1.position)
        {specialPositionAlert(Player: 1, position: position, Case: GoodOrBad.good)}
        if (position == Player2.position)
        {specialPositionAlert(Player: 2, position: position, Case: GoodOrBad.good)}
        
    }
}

func victoryScreen (Player: Int) {
    
    cleanScreen()
    
    if (Player == 1) {print ("[$] WINNER: \(Player1.name)")}
    if (Player == 2) {print ("[$] WINNER: \(Player2.name)")}
    
    PressEnter ()
    exit (0)
    
}

func CheckIfSomeoneWon () {
    
    if (Player1.position == GameSettings.positionLimit)
    {victoryScreen(Player: 1)}
    if (Player2.position == GameSettings.positionLimit)
    {victoryScreen(Player: 2)}
    
}

func SwitchTurns (Player: Int) {
    switch Player {
    case 1: PlayerTurn = 2
    case 2: PlayerTurn = 1
    default: return
    }
}

func cleanScreen () {for _ in 0...80 {print ("\n")}}

func diceVerifyingProcess (Player: Int) {
    
    diceValue = Int.random(in: 1...(GameSettings.diceLimit))
    
    switch Player {
        
    case 1:
        if (Player1.position + diceValue > GameSettings.positionLimit) {
            cleanScreen()
            print ("""
                [?] Dice Value: \(diceValue).
                [X] Oh no, \(Player1.name) can't Progress.
                [X] Position Limit: \(GameSettings.positionLimit).
                """)
            PressEnter()
            
        } else {RollTheDice(Player: PlayerTurn, diceValue: diceValue)}
        
    case 2:
        if (Player2.position + diceValue > GameSettings.positionLimit) {
            cleanScreen()
            print ("""
                [?] Dice Value: \(diceValue).
                [X] Oh no, \(Player2.name) can't Progress.
                [X] Position Limit: \(GameSettings.positionLimit).
                """)
            PressEnter()
            
        } else {RollTheDice(Player: PlayerTurn, diceValue: diceValue)}
        
    default: return
        
    }
    
}

func RollTheDice (Player: Int, diceValue: Int) {
    
    cleanScreen()
    switch Player {
    case 1: Player1.position += diceValue;
    print ("\(Player1.name) threw the Dice! [DICE: \(diceValue)]")
    PressEnter()
    specialPositionsCheck()
    case 2: Player2.position += diceValue;
    print ("\(Player2.name) threw the Dice! [DICE: \(diceValue)]")
    PressEnter()
    specialPositionsCheck()
    default: return
    }
}

func Skip (Player: Int) {
    cleanScreen()
    switch Player {
    case 1: print ("\(Player1.name) decided to Skip."); PressEnter()
    case 2: print ("\(Player2.name) decided to Skip."); PressEnter()
    default: return
    }
}

func Turn (Player: Int) {
    
    CheckIfSomeoneWon()
    
    switch Player {
    case 1:
        print ("[X] \(Player1.name)'s Turn.")
        print ("[!] \(Player1.name) in Position \(Player1.position)\n")
        print ("[!] Adversary \(Player2.name) in Position \(Player2.position)\n")
    case 2:
        print ("[X] \(Player2.name)'s Turn.")
        print ("[!] \(Player2.name) in Position \(Player2.position)\n")
        print ("[!] Adversary \(Player1.name) in Position \(Player1.position)\n")
    default: return
    }
    
    print ("""
    [DIGITE 1] Roll The Dice.
    [DIGITE 2] Skip Turn.
    """)
    
    menuOption = readLine()!
    switch menuOption {
    case "1": diceVerifyingProcess(Player: PlayerTurn)
    case "2": Skip(Player: PlayerTurn)
    default: diceVerifyingProcess(Player: PlayerTurn)
    }
}

// Start Menu

print ("""
    ||| SIMPLE BOARD GAME |||
    
    ||| Stable Swift Release 1.0
    
    [?] Rules:
    - The first to set foot in Position \(GameSettings.positionLimit), wins.
    - There are some special positions with Penalties.
    - You can't move forward if the dice value exceeds the Limit.
    
    [X] Any Questions?
    
    [ENTER] Play!
    """)

menuOption = readLine()!
cleanScreen()
SetNameForBothPlayers()

// Game's Loop

while true {
    
    Turn(Player: PlayerTurn)
    SwitchTurns(Player: PlayerTurn)
    cleanScreen()
    
}
