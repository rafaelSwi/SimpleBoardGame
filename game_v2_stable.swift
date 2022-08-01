import Foundation
import Darwin

let gameVersion = "Stable Swift Release 2.0"

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

enum Settings {
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

var Player1 = Player (name: "P1", position: 0)
var Player2 = Player (name: "P2", position: 0)

var PlayerTurn = 1
var menuOption = ""
var diceValue = 0

// "Tool" Functions

func cleanScreen () {for _ in 0...80 {print ("\n")}}

func PressEnter () {
    print ("\n[PRESS ENTER TO CONTINUE]")
    return menuOption = readLine()!
}

func resetSettings () {
    Settings.diceLimit = 6
    Settings.positionLimit = 50
    Settings.penalty = 3
    Settings.specialPositions = true
}

// Game Functions

func gameLoop () {
    
    while true {
        
        Turn(Player: PlayerTurn)
        SwitchTurns(Player: PlayerTurn)
        cleanScreen()
        
    }
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

func Turn (Player: Int) {
    
    CheckIfSomeoneWon()
    
    switch Player {
    case 1:
        print ("""
            [X] \(Player1.name)'s Turn.
            [X] \(Player1.name) in Position \(Player1.position)\n
            [!] Adversary \(Player2.name) in Position \(Player2.position)\n
            """)
    case 2:
        print ("""
            [X] \(Player2.name)'s Turn.
            [X] \(Player2.name) in Position \(Player2.position)\n
            [!] Adversary \(Player1.name) in Position \(Player1.position)\n
            """)
        
    default: errorScreen(ErrorType: errorTypes.FatalError)
        
    }
    
    print ("""
        
        [GOAL] Position \(Settings.positionLimit)
        
        
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

func Skip (Player: Int) {
    cleanScreen()
    switch Player {
    case 1: print ("\(Player1.name) decided to Skip."); PressEnter()
    case 2: print ("\(Player2.name) decided to Skip."); PressEnter()
    default: errorScreen(ErrorType: errorTypes.FatalError)
    }
}

func diceVerifyingProcess (Player: Int) {
    
    diceValue = Int.random(in: 1...(Settings.diceLimit))
    
    switch Player {
        
    case 1:
        if (Player1.position + diceValue > Settings.positionLimit) {
            cleanScreen()
            print ("""
                [?] Dice Value: \(diceValue).
                [X] Oh no, \(Player1.name) can't Progress.
                [X] Position Limit: \(Settings.positionLimit).
                """)
            PressEnter()
            
        } else {RollTheDice(Player: PlayerTurn, diceValue: diceValue)}
        
    case 2:
        if (Player2.position + diceValue > Settings.positionLimit) {
            cleanScreen()
            print ("""
                [?] Dice Value: \(diceValue).
                [X] Oh no, \(Player2.name) can't Progress.
                [X] Position Limit: \(Settings.positionLimit).
                """)
            PressEnter()
            
        } else {RollTheDice(Player: PlayerTurn, diceValue: diceValue)}
        
    default: errorScreen(ErrorType: errorTypes.FatalError)
        
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
    default: errorScreen(ErrorType: errorTypes.FatalError)
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

func specialPositionAlert (Player: Int, position: Int, Case: GoodOrBad) {
    
    if (Settings.specialPositions == true) {
        
        if (Player == 1) {
            print ("[!] \(Player1.name) stepped into a Special Position! [\(position)]")
            if (Case == GoodOrBad.bad) {Player1.position -= Settings.penalty}
            if (Case == GoodOrBad.good) {Player1.position += Settings.penalty}
        }
        
        if (Player == 2) {
            print ("[!] \(Player2.name) stepped into a Special Position! [\(position)]")
            if (Case == GoodOrBad.bad) {Player2.position -= Settings.penalty}
            if (Case == GoodOrBad.good) {Player2.position += Settings.penalty}
        }
        
        switch Case {
            
        case GoodOrBad.bad:
            print ("""
                [X] Unfortunately, it was an Unlucky Position.
                [X] Regressed \(Settings.penalty) Positions.
                """)
            PressEnter()
            
        case GoodOrBad.good:
            print ("""
                [X] Fortunately, it was a Lucky position!
                [X] Progressed \(Settings.penalty) Positions.
                """)
            PressEnter()
            
        }
    }
    
    cleanScreen()
    SwitchTurns(Player: PlayerTurn)
    Turn(Player: PlayerTurn)
    
}

func CheckIfSomeoneWon () {
    
    if (Player1.position == Settings.positionLimit)
    {victoryScreen(Player: 1)}
    if (Player2.position == Settings.positionLimit)
    {victoryScreen(Player: 2)}
    
}

func victoryScreen (Player: Int) {
    
    cleanScreen()
    
    if (Player == 1) {print ("[$] WINNER: \(Player1.name)")}
    if (Player == 2) {print ("[$] WINNER: \(Player2.name)")}
    
    PressEnter ()
    exit (0)
    
}

func SwitchTurns (Player: Int) {
    switch Player {
    case 1: PlayerTurn = 2
    case 2: PlayerTurn = 1
    default: errorScreen(ErrorType: errorTypes.FatalError)
    }
}


// Menu Functions

func patchNotesScreen () {
    cleanScreen()
    
    print ("""
        [!] Current Version: \(gameVersion)
        
        [X] FEATURES:
        [#] Added "GOAL"
        [#] Added Customization Menu
        [#] Added Safe Limit Lock
        [#] Added Patch Notes Menu
        [#] Added Fatal Error Screen
        (Hope you never see it)
        
        [X] FIXES:
        [#] Translated TYPE Buttons to English
        [#] Adjusted returning values for some inputs
        [#] Turning Safe Limit Lock on after turning
        it off, resets all Game Settings to Default
        
        [X] CODE:
        [#] Functions are now organized
        [#] Changed "GameSettings" to "Settings"
        [#] It went from 261 Lines to almost 500
        [#] Increased 10KB in size (6KB - 16KB)
        [#] Bunch of code optimizations
        
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
        resetSettings()
        Player1 = Player (name: "P1", position: 0)
        Player2 = Player (name: "P2", position: 0)
        Settings.safeLimitLock = true
        StartMenu()
    }
    
    
}

func StartMenu () {
    
    cleanScreen()
    
    print ("""
        ||| SIMPLE BOARD GAME |||
        
        ||| \(gameVersion)
        
        [?] Rules:
        - The first to set foot in Position \(Settings.positionLimit), wins.
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
        
        | [TYPE 1] Dice Limit [\(Settings.diceLimit)]
        
        | [TYPE 2] Position Limit [\(Settings.positionLimit)]
        
        | [TYPE 3] Special Positions Penalty [\(Settings.penalty)]
        
        | [TYPE 4] Special Positions [\(Settings.specialPositions)]
        
        | [TYPE 5] Safe Limit Lock [\(Settings.safeLimitLock)]
        
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
    print ("| INSERT DICE LIMIT. [Current Value: \(Settings.diceLimit)]")
    menuOption = readLine()!
    let menuOptionAsNumber = Int(menuOption) ?? 6
    if (2...12 ~= menuOptionAsNumber && Settings.safeLimitLock == true)
    {Settings.diceLimit = menuOptionAsNumber; customizationMenu()}
    if (Settings.safeLimitLock == false)
    {Settings.diceLimit = menuOptionAsNumber; customizationMenu()}
    else {errorScreen(ErrorType: errorTypes.SafeLimitLock)}
        
    case "2": cleanScreen()
    print ("| INSERT POSITION LIMIT. [Current Value: \(Settings.positionLimit)]")
    menuOption = readLine()!
    let menuOptionAsNumber = Int(menuOption) ?? 50
    if (25...150 ~= menuOptionAsNumber && Settings.safeLimitLock == true)
    {Settings.positionLimit = menuOptionAsNumber; customizationMenu()}
    if (Settings.safeLimitLock == false)
    {Settings.positionLimit = menuOptionAsNumber; customizationMenu()}
    else {errorScreen(ErrorType: errorTypes.SafeLimitLock)}
        
    case "3": cleanScreen()
    print ("| INSERT PENALTY VALUE. [Current Value: \(Settings.penalty)]")
    menuOption = readLine()!
    let menuOptionAsNumber = Int(menuOption) ?? 3
    if (1...8 ~= menuOptionAsNumber && Settings.safeLimitLock == true)
    {Settings.penalty = menuOptionAsNumber; customizationMenu()}
    if (Settings.safeLimitLock == false)
    {Settings.penalty = menuOptionAsNumber; customizationMenu()}
    else {errorScreen(ErrorType: errorTypes.SafeLimitLock)}
        
    case "4": cleanScreen()
    switch Settings.specialPositions
    {
    case true: Settings.specialPositions = false
    case false: Settings.specialPositions = true
    }
    customizationMenu()
        
    case "5": cleanScreen()
    switch Settings.safeLimitLock
    {
    case true: Settings.safeLimitLock = false
    case false: Settings.safeLimitLock = true; resetSettings()
    }
    customizationMenu()
        
    case "6": cleanScreen()
    StartMenu()
        
    case "7": cleanScreen()
    resetSettings()
    customizationMenu()
        
    default: errorScreen(ErrorType: errorTypes.InvalidValue)
        
    }
    
}

StartMenu()
