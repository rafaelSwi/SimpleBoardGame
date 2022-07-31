import Foundation
import Darwin

let gameVersion = "Beta Swift Release 2.0"

struct Player {
    var name: String
    var position: Int
}

// Storage

enum errorTypes {
    case SafeLimitLock
    case InvalidValue
    case FatalError
}

enum GameSettings {
    static var diceLimit = 6
    static var positionLimit = 50
    static var penalty = 3
    static var safeLimitLock = true
    static var specialPositions = true
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

func gameLoop () {
    
    while true {
        
        Turn(Player: PlayerTurn)
        SwitchTurns(Player: PlayerTurn)
        cleanScreen()
        
    }
    
}

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
    
    gameLoop()
}

func specialPositionAlert (Player: Int, position: Int, Case: GoodOrBad) {
    
    if (GameSettings.specialPositions == true) {
        
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
    cleanScreen()
    SwitchTurns(Player: PlayerTurn)
    Turn(Player: PlayerTurn)
    
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
    default: errorScreen(ErrorType: errorTypes.FatalError)
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
        
    default: errorScreen(ErrorType: errorTypes.FatalError)
        
    }
    
}

func resetGameSettings () {
    
    GameSettings.diceLimit = 6
    GameSettings.positionLimit = 50
    GameSettings.penalty = 3
    GameSettings.specialPositions = true
    
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
    default: errorScreen(ErrorType: errorTypes.FatalError)
    }
}

func Skip (Player: Int) {
    cleanScreen()
    switch Player {
    case 1: print ("\(Player1.name) decided to Skip."); PressEnter()
    case 2: print ("\(Player2.name) decided to Skip."); PressEnter()
    default: errorScreen(ErrorType: errorTypes.FatalError)
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
    default: errorScreen(ErrorType: errorTypes.FatalError)
    }
    
    print ("""
    [TYPE 1] Roll The Dice.
    [TYPE 2] Skip Turn.
    """)
    
    menuOption = readLine()!
    switch menuOption {
    case "1": diceVerifyingProcess(Player: PlayerTurn)
    case "2": Skip(Player: PlayerTurn)
    default: diceVerifyingProcess(Player: PlayerTurn)
    }
}

// Menu Functions

func patchNotesScreen () {
    cleanScreen()
    
    print ("""
        [!] Current Version: \(gameVersion)
        
        [X] FEATURES:
        [#] Added Customization Menu
        [#] Added Safe Limit Lock
        [#] Added Patch Notes Menu
        [#] Added Fatal Error Screen
        (Hope you never see it)
        
        [X] FIXES:
        [#] Translated TYPE Buttons to English
        [#] Adjusted returning values for some inputs
        [#] Some code adjustments here and there
        
        [X] OTHERS:
        [#] ...
        
        [ENTER] Back to Start Menu
        """)
    
    menuOption = readLine()!
    StartMenu()
}

func errorScreen (ErrorType: errorTypes) {
    
    cleanScreen()
    switch ErrorType {
        
    case errorTypes.SafeLimitLock:
        print ("""
        [X] This value cannot be assigned because Safe Limit Lock is currently On.

        [?] Safe Limit Range:
        | Dice: 2.....12
        | Position: 25.....150
        | Penalty: 1.....8
        

        [ENTER] Return to Customization Menu
        """)
        
        menuOption = readLine()!
        customizationMenu()
        
    case errorTypes.InvalidValue:
        print ("""
        [X] You have entered a value that does not match any of the options.

        [ENTER] Return to Main Menu
        """)
        
        menuOption = readLine()!
        StartMenu()
        
    case errorTypes.FatalError:
        cleanScreen()
        print ("""
        [!] Unexpected fatal error ocorrued for an unknown reason.
        | Reseting All Settings to Default
        | Reseting Player's Status
        | Turning On Safe Limit Lock

        [ENTER] Back to Start Menu
        """)
        
        menuOption = readLine()!
        resetGameSettings()
        Player1 = Player (name: "P1", position: 0)
        Player2 = Player (name: "P2", position: 0)
        GameSettings.safeLimitLock = true
        StartMenu()
    }
    
    
}

func StartMenu () {
    
    cleanScreen()
    
    print ("""
        ||| SIMPLE BOARD GAME |||
        
        ||| \(gameVersion)
        
        [?] Rules:
        - The first to set foot in Position \(GameSettings.positionLimit), wins.
        - There are some special positions with Penalties.
        - You can't move forward if the dice value exceeds the Limit.
        
        [TYPE 1] Play!
        [TYPE 2] Customize
        [TYPE 3] Patch Notes
        """)
    
    menuOption = readLine()!
    
    switch menuOption {
        
    case "1": SetNameForBothPlayers()
    case "2": customizationMenu()
    case "3": patchNotesScreen()
    default: errorScreen(ErrorType: errorTypes.InvalidValue)
        
    }
    
}

func customizationMenu () {
    cleanScreen()
    
    print ("""
        ||| CUSTOMIZATION MENU |||
        
        | [TYPE 1] Dice Limit [\(GameSettings.diceLimit)]
        
        | [TYPE 2] Position Limit [\(GameSettings.positionLimit)]
        
        | [TYPE 3] Special Positions Penalty [\(GameSettings.penalty)]
        
        | [TYPE 4] Special Positions [\(GameSettings.specialPositions)]
        
        | [TYPE 5] Safe Limit Lock [\(GameSettings.safeLimitLock)]
        
        [?] Security Lock is recommended,
        it prevents you from making changes
        that could potentially result in errors
        during gameplay.
        
        
        [TYPE 6] Back to Main Menu and Save Changes
        [TYPE 7] Reset All to Default Values
        """)
    
    menuOption = readLine()!
    
    switch menuOption {
        
    case "1": cleanScreen()
    print ("| INSERT DICE LIMIT. [Current Value: \(GameSettings.diceLimit)]")
    menuOption = readLine()!
    let menuOptionAsNumber = Int(menuOption) ?? 6
    if (2...12 ~= menuOptionAsNumber && GameSettings.safeLimitLock == true)
    {GameSettings.diceLimit = menuOptionAsNumber; customizationMenu()}
    if (GameSettings.safeLimitLock == false)
    {GameSettings.diceLimit = menuOptionAsNumber; customizationMenu()}
    else {errorScreen(ErrorType: errorTypes.SafeLimitLock)}
        
    case "2": cleanScreen()
    print ("| INSERT POSITION LIMIT. [Current Value: \(GameSettings.positionLimit)]")
    menuOption = readLine()!
    let menuOptionAsNumber = Int(menuOption) ?? 50
    if (25...150 ~= menuOptionAsNumber && GameSettings.safeLimitLock == true)
    {GameSettings.positionLimit = menuOptionAsNumber; customizationMenu()}
    if (GameSettings.safeLimitLock == false)
    {GameSettings.positionLimit = menuOptionAsNumber; customizationMenu()}
    else {errorScreen(ErrorType: errorTypes.SafeLimitLock)}
        
    case "3": cleanScreen()
    print ("| INSERT PENALTY VALUE. [Current Value: \(GameSettings.penalty)]")
    menuOption = readLine()!
    let menuOptionAsNumber = Int(menuOption) ?? 3
    if (1...8 ~= menuOptionAsNumber && GameSettings.safeLimitLock == true)
    {GameSettings.penalty = menuOptionAsNumber; customizationMenu()}
    if (GameSettings.safeLimitLock == false)
    {GameSettings.penalty = menuOptionAsNumber; customizationMenu()}
    else {errorScreen(ErrorType: errorTypes.SafeLimitLock)}
        
    case "4": cleanScreen()
    switch GameSettings.specialPositions
    {
    case true: GameSettings.specialPositions = false
    case false: GameSettings.specialPositions = true
    }
    customizationMenu()
        
    case "5": cleanScreen()
    switch GameSettings.safeLimitLock
    {
    case true: GameSettings.safeLimitLock = false
    case false: GameSettings.safeLimitLock = true; resetGameSettings()
    }
    customizationMenu()
        
    case "6": cleanScreen()
    StartMenu()
        
    case "7": cleanScreen()
    resetGameSettings()
    customizationMenu()
        
    default: errorScreen(ErrorType: errorTypes.InvalidValue)
        
    }
    
}

StartMenu()
