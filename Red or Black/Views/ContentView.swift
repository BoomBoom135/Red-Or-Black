//
//  ContentView.swift
//  Red or Black
//
//  Created by Nick Shahbaz on 2024-06-05.
//

import SwiftUI
import AVFoundation

//Struct View
struct ContentView: View {
    
    //View and logical related Functions------------------------------------
    
    //Updates Coins
    func updateCoins(amount: Int, operation: String) {
        
        if operation == "add" {
            
            if coins + amount > 9999 {
                
                coins = 9999
                
            } else {
                
                coins += amount
                
            }
            
        } else {
            
            coins -= amount
            
        }
        UserDefaults.standard.set(coins, forKey: "Coins")
        
    }
    
    //Plays Music
    func playMusic() {
        
        if musicOn{
            let url = Bundle.main.url(forResource: "music1", withExtension: "mp3")
            music = try? AVAudioPlayer(contentsOf: url!)
            music.numberOfLoops = -1
            music?.play()
        }
        
    }
    
    //Plays ding sound
    func playDing() {
        
        if soundOn{
            let url = Bundle.main.url(forResource: "ding", withExtension: "wav")
            audioDing = try? AVAudioPlayer(contentsOf: url!)
            audioDing?.play()
        }
        
    }
    
    //Plays flip sound
    func playFlip() {
        
        if soundOn{
            let url = Bundle.main.url(forResource: "flip", withExtension: "wave")
            audioFlip = try? AVAudioPlayer(contentsOf: url!)
            audioFlip?.play()
        }
        
    }
    
    //Updates Highscore
    func updateHighscore() {
        if score > highscore{
            UserDefaults.standard.set(score ,forKey: "Highscore")
            highscore = score
        }
    }
    
    //Finds active item for edit screen
    func active(name: String, active: String) -> Bool {
        
        if name == active {
            
            return true
            
        } else {
            
            return false
            
        }
        
    }
    
    //Update Table Buys
    func updateBuyTable(table: String) {
        
        buyTable.append(table)
        UserDefaults.standard.set(buyTable ,forKey: "bTable")
        
    }
    
    //Update table
    func updateTable(tableC: String) {
        
        UserDefaults.standard.set(tableC ,forKey: "background")
        backgroundImage = tableC

        
    }
    
    //Update Deck Buys
    func updateBuyDeck(deck: String) {
        
        buyDeck.append(deck)
        UserDefaults.standard.set(buyDeck ,forKey: "bDeck")
        
    }
    
    //Update Deck
    func updateDeck(deckC: String) {
        
        UserDefaults.standard.set(deckC ,forKey: "back")
        cardBack = deckC
        
    }
    
    //Pressed
    func isPressed() {
        
        pressed.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            pressed.toggle()
        }
        
    }
    
    //Pressed (Faster)
    func isPressedFast() {
        pressed.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            pressed.toggle()
        }
        
    }
    
    //Flip Animation
    func flipsCard() {
        
        //Play flip audio
        playFlip()
        
        let animationTime = 0.75
        
        withAnimation(Animation.linear(duration: animationTime)){
            cardRotation += 180
        }
        
        withAnimation(Animation.linear(duration: 0.001).delay(animationTime / 2)){
            contentRotation += 180
            flipped.toggle()
        }
        
    }
    
    //Check Finished
    func ifEndGame() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            if allCards.count == 0 {
                updateHighscore()
                playScreen = false
                endScreen = true

            }
            
        }
    }
    
    //Restarts Game
    func restartGame() {
        allCards = ["2C", "2D", "2S", "2H", "3C", "3D", "3S", "3H", "4C", "4D", "4S", "4H", "5C", "5D", "5S", "5H", "6C", "6D", "6S", "6H", "7C", "7D", "7S", "7H", "8C", "8D", "8S", "8H", "9C", "9D", "9S", "9H", "10C", "10D", "10S", "10H", "11C", "11D", "11S", "11H", "12C", "12D", "12S", "12H", "13C", "13D", "13S", "13H", "14C", "14D", "14S", "14H"]
        updateCoins(amount: score, operation: "add")
        score = 0
        clearCards()
        endScreen = false
        playScreen = true
    }
    
    //Clears Cards from screen when wrong
    func clearCards() {
        
        card1 = cardBack
        card2 = cardBack
        card3 = cardBack
        currentCard = cardBack
        
        bSet1 = true
        bSet2 = false
        bSet3 = false
        bSet4 = false
        
        return
    }
    
    //Gets card for player
    func getCard() -> String {
        
        //toggle pressed
        isPressed()
        
        //Gets card
        currentCard = allCards.randomElement() ?? "Nothing"
        allCards = allCards.filter { $0 != currentCard}
        
        return currentCard
        
    }
    
    //Checks answer for Red and Black
    func buttons1(b1: String) -> String {
        
        //Gets card
        currentCard = getCard()
        
        //Shows Face
        flipsCard()
        
        //Finds card Color
        var ans = " "
        if currentCard.contains("D") || currentCard.contains("H") {
            ans = "red"
        } else {
            ans = "black"
        }
        
        //Shows Back
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            flipsCard()
        }
        
            
        //Compares Color with Answer and Change Buttons
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if ans == b1 {
                bSet1 = false
                bSet2 = true
                score += 1
                playDing()
                
                //Sets card1 to currentCard
                card1 = currentCard
            } else{
                clearCards()
            }
            
        }
        
        //Checks if done
        ifEndGame()
        
        //Return
        return currentCard
        
    }
    
    //Checks answer for Over or Under
    func buttons2(b2: String) -> String {
        
        //Gets card
        currentCard = getCard()
        
        //Shows Face
        flipsCard()
        
        //Gets Cards Number Value
        let tempCValue = currentCard.filter { !letters.contains(UnicodeScalar(String($0))!) }
        let temp1Value = card1.filter { !letters.contains(UnicodeScalar(String($0))!) }
        let cardCValue = Int(tempCValue) ?? 0
        let card1Value = Int(temp1Value) ?? 0
        
        //Determines Over, Under or On
        var ans = " "
        if cardCValue > card1Value {
            ans = "over"
        } else if cardCValue < card1Value {
            ans = "under"
        } else {
            ans = "on"
        }
        
        //Shows Back
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            flipsCard()
        }
        
        //Compares Numbers with Answer and Change Buttons
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if ans == b2 {
                bSet2 = false
                bSet3 = true
                score += 2
                playDing()
                
                //Sets card2 to currentCard
                card2 = currentCard
            } else {
                clearCards()
            }
        }
        
        //Checks if done
        ifEndGame()
        
        //Return
        return currentCard
        
    }
    
    //Checks answer for In or Out
    func buttons3(b3: String) -> String{
        
        //Gets card
        currentCard = getCard()
        
        //Shows Face
        flipsCard()
        
        //Gets Cards Number Value
        let tempCValue = currentCard.filter { !letters.contains(UnicodeScalar(String($0))!) }
        let temp1Value = card1.filter { !letters.contains(UnicodeScalar(String($0))!) }
        let temp2Value = card2.filter { !letters.contains(UnicodeScalar(String($0))!) }
        let cardCValue = Int(tempCValue) ?? 0
        let card1Value = Int(temp1Value) ?? 0
        let card2Value = Int(temp2Value) ?? 0
        
        //Sets Low and High
        var low = 0
        var high = 0
        if card1Value < card2Value {
            low = card1Value
            high = card2Value
        } else if card1Value > card2Value {
            low = card2Value
            high = card1Value
        } else {
            low = card1Value
            high = card1Value
        }
        
        //Determines In, Out or On
        var ans = " "
        if cardCValue > low && cardCValue < high {
            ans = "in"
        } else if cardCValue < low || cardCValue > high {
            ans = "out"
        } else {
            ans = "on"
        }
        
        //Shows Back
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            flipsCard()
        }
        
        //Compares Numbers with Answer and Change Buttons
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if ans == b3 {
                bSet3 = false
                bSet4 = true
                score += 3
                playDing()
                
                //Sets card3 to currentCard
                card3 = currentCard
            } else {
                clearCards()
            }
        }
        
        //Checks if done
        ifEndGame()
        
        //Return
        return currentCard
    }
    
    //Checks answer for Suit
    func buttons4(b4: String) -> String{
        
        //Gets card
        let currentCard = getCard()
        
        //Shows Face
        flipsCard()
        
        //Shows Back
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            flipsCard()
        }
        
        //Compares Numbers with Answer and Change Buttons
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if currentCard.contains(b4) {
                clearCards()
                score += 4
                playDing()

            } else {
                clearCards()
            }
        }
        
        //Checks if done
        ifEndGame()
        
        return currentCard
        
    }
    
    //Constant Images
    let titleImage: String = "RedOrBlackTitle"
    let playImage: String = "Play"
    
    //Changing Images
    @State var backgroundImage: String = UserDefaults.standard.string(forKey: "background") ?? "backgroundGreen"
    @State var cardBack: String = UserDefaults.standard.string(forKey: "back") ?? "cardBackRB"
    @State var card1: String = ""
    @State var card2: String = ""
    @State var card3: String = ""
    @State var currentCard: String = ""
    
    //Card flip Variables
    @State var flipped: Bool = false
    @State var cardRotation:  Double = 0.0
    @State var contentRotation: Double = 0.0
    
    //Screen Changers
    @State var titleScreen: Bool = true
    @State var playScreen: Bool = false
    @State var endScreen: Bool = false
    @State var infoScreen: Bool = false
    @State var editScreen: Bool = false
    @State var settingScreen: Bool = false
    
    //Test Screen
    @State var testScreen: Bool = false
    
    //Buttons Set Changers
    @State var bSet1: Bool = true
    @State var bSet2: Bool = false
    @State var bSet3: Bool = false
    @State var bSet4: Bool = false
    
    //Card Set Changer
    @State var cSet: Bool = true
    
    //Changing Variables
    @State var score: Int = 0
    @State var usedCards: Int = 0
    @State var pressed: Bool = false
    @State var cardCValue = " "
    @State var card1Value = " "
    @State var card2Value = " "
    @State var cardActive: Bool = false
    @State var soundOn: Bool = UserDefaults.standard.bool(forKey: "sound")
    @State var musicOn: Bool = UserDefaults.standard.bool(forKey: "music")
    
    //Constant Variables
    let letters = CharacterSet.letters
    
    //Audio
    @State var audioDing: AVAudioPlayer!
    @State var audioFlip: AVAudioPlayer!
    @State var music: AVAudioPlayer!
    
    //Highscore and coins
    @State var highscore: Int = UserDefaults.standard.integer(forKey: "Highscore") ?? 0
    
    @State var coins: Int = UserDefaults.standard.integer(forKey: "Coins") ?? 0
    
    //Lists
    @State var allCards: [String] = ["2C", "2D", "2S", "2H", "3C", "3D", "3S", "3H", "4C", "4D", "4S", "4H", "5C", "5D", "5S", "5H", "6C", "6D", "6S", "6H", "7C", "7D", "7S", "7H", "8C", "8D", "8S", "8H", "9C", "9D", "9S", "9H", "10C", "10D", "10S", "10H", "11C", "11D", "11S", "11H", "12C", "12D", "12S", "12H", "13C", "13D", "13S", "13H", "14C", "14D", "14S", "14H"]

    @State var backgroundColors: [String] = ["backgroundGreen", "backgroundBlack", "backgroundBlue", "backgroundRed", "backgroundGray", "backgroundPink", "backgroundWhite", "backgroundPurple"]
    
    @State var deckColors: [String] = ["cardBackRB" , "cardBackOrange", "cardBackGreen", "cardBackGray", "cardBackBlue", "cardBackPurple", "cardBackRed", "cardBackBlack"]
    
    @State var buyDeck: [String] = UserDefaults.standard.stringArray(forKey: "bDeck") ?? ["cardBackRB"]
    
    @State var buyTable: [String] = UserDefaults.standard.stringArray(forKey: "bTable") ?? ["backgroundGreen"]
    
    //View
    var body: some View {
        
        ZStack{
            
            //Background Color
            Image(backgroundImage)
                .resizable()
                .ignoresSafeArea()
            
            //Title Screen
            if titleScreen{
                
                VStack{
                    
                    //Coins highscore and  Make
                    HStack{
                        
                        Spacer()
                        
                        //Coins
                        HStack {
                            Image("coin")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                            
                            Text(String(coins))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                        }
                        .padding(.trailing, 10)
                        
                        
                        Spacer()
                        
                        HStack {
                            
                            Spacer()
                            
                            //Highscore
                            ZStack{
                                
                                Image("Button1")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 125)
                                    .border(Color.black, width: 3)
                                
                                HStack{
                                    
                                    Text("Highscore: ")
                                        .font(.footnote)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                    
                                    Text(String(highscore))
                                        .font(.footnote)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                    
                                }
                                
                            }
                            
                            Spacer()
                            
                            //Make
                            ZStack{
                                
                                Image("Button1")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100)
                                    .border(Color.black, width: 2)
                                
                                Text("SHAZZZ")
                                    .font(.title2)
                                    .fontWeight(.thin)
                                    .foregroundColor(Color.white)
                                
                            }
                            
                        }
                        Spacer()
                    }
                    
                    Spacer()
                    
                    //Title
                    Image(titleImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(7.0)
                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 3)
                        .padding()
                    
                    Spacer()
                    
                    //Play Button
                    Button(action: {
                        titleScreen = false
                        playScreen = true
                        restartGame()
                    }, label: {
                        Image(playImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 3)
                            .frame(width: 200)
                        
                    })
                    
                    Spacer()
                    
                    HStack{
                        
                        Spacer()
                        
                        //How to Play Button
                        Button(action: {
                            titleScreen = false
                            infoScreen = true
                        }, label: {
                            Image("infoButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50)
                            
                        })
                        
                        Spacer()
                        
                        //Customize Button
                        Button(action: {
                            titleScreen = false
                            editScreen = true
                        }, label: {
                            Image("customButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .frame(width: 50)
                            
                        })
                        
                        Spacer()
                        
                        //Settings Button
                        Button(action: {
                            titleScreen = false
                            settingScreen = true
                        }, label: {
                            ZStack{
                                
                                Image("emptyButton")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50)
                                
                                Image(systemName: "gearshape.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.white)
                                    .frame(width: 30)
                            }
                            
                        })
                        
                        Spacer()
                    }
                    .padding()
                    Spacer()
                    
                }
                
            }
            
            //How To Play Screen
            if infoScreen{
                
                VStack{
                    
                    HStack{
                        
                        //Back Button
                        Button(action: {
                            infoScreen = false
                            titleScreen = true
                        }, label: {
                            Image("backButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                                .padding()
                            
                        })
                       
                        Spacer()
                        
                    }
                    
                    Spacer()
                    
                    
                    //Examples
                    HStack{
                        
                        Spacer()
                        
                        VStack{
                            
                            Image("Sample1")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 125)
                                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 3)
                            
                            Text("1. Guess The Color\n")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                
                            
                        }
                        
                        Spacer()
                        
                        VStack{
                            
                            Image("Sample2")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 125)
                                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 3)
                            
                            Text("2. Higher or Lower than card 1")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                
                            
                        }
                        
                        Spacer()
                        Spacer()
                        Spacer()
                        
                    }
                    
                    Spacer()
                    
                    HStack{
                        
                        Spacer()
                        Spacer()
                        Spacer()
                        
                        VStack{
                            
                            Image("Sample3")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 125)
                                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 3)
                            
                            Text("3. In Between or Outside of card 1 and 2")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                
                            
                        }
                        
                        Spacer()
                        
                        VStack{
                            
                            Image("Sample4")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 125)
                                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 3)
                            
                            Text("4. Guess the Suit\n")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            
                        }
                    
                        Spacer()
                        
                    }
                    
                    Spacer()
                    
                }

                
            }
            
            //Scheme Change
            if editScreen {
                
                VStack{
                    
                    HStack{

                        //Back Button
                        Button(action: {
                            editScreen = false
                            titleScreen = true
                        }, label: {
                            Image("backButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                                .padding()
                            
                        })
                        
                        Spacer()
                        
                        //Coins
                        HStack {
                            Text(String(coins))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                            Image("coin")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                        }
                        .padding(10)
                    }
                    
                    //Scroll View for Decks
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        Spacer()
                        
                        HStack{
                            
                            Spacer()
                            
                            VStack {
                                
                                Text("D")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .padding(1)
                                Text("E")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .padding(1)
                                Text("C")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .padding(1)
                                Text("K")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .padding(1)
                                Text("S")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .padding(1)
                            }
                            
                            //Decks
                            ForEach(deckColors.indices, id: \.self) { i in
                                
                                VStack {
                                    
                                    Image(deckColors[i])
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxHeight: 225)
                                        .padding(5)
                                    
                                    let act = active(name: deckColors[i], active: cardBack)
                                    
                                    if act {
                                        
                                        Image("checkedButton")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxHeight: 60)
                                            .padding(5)
                                        
                                    } else if !act && buyDeck.contains(deckColors[i]){
                                        
                                        Button {
                                            
                                            updateDeck(deckC: deckColors[i])

                                            
                                        } label: {
                                            
                                            Image("emptyButton")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(maxHeight: 60)
                                                .padding(5)
                                            
                                        }
                                        
                                    } else {
                                        
                                        Button {
                                            
                                            if coins >= 150*(i+1) {
                                                
                                                updateCoins(amount: 150*(i+1), operation: "sub")
                                                
                                                updateBuyDeck(deck: deckColors[i])
                                                
                                            }
                                            
                                            
                                        } label: {
                                            
                                            ZStack {
                                                
                                                Image("Button1")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .border(Color.black, width: 2)
                                                    .frame(maxHeight: 40)
                                                    .padding(5)
                                                
                                                HStack{
                                                    
                                                    Image("coin")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(maxHeight: 20)
                                                        .padding(1)
                                                    
                                                    Text(String(150*(i+1)))
                                                        .font(.title2)
                                                        .fontWeight(.bold)
                                                        .foregroundColor(Color.white)
                                                        .padding(1)
                                                        
                                                    
                                                }
                                                
                                            }
                                            
                                        }

                                        
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    //Scroll View for Tables
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        Spacer()
                        
                        HStack{
                            
                            Spacer()
                            
                            VStack {
                                
                                Text("T")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .padding(1)
                                Text("A")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .padding(1)
                                Text("B")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .padding(1)
                                Text("L")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .padding(1)
                                Text("E")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .padding(1)
                                Text("S")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .padding(1)
                            }
                            
                            ForEach(backgroundColors.indices, id: \.self) { i in
                                
                                VStack {
                                    
                                    Image(backgroundColors[i])
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxHeight: 200)
                                        .border(Color.black, width: 3)
                                        .padding(5)
                                    
                                    let act = active(name: backgroundColors[i], active: backgroundImage)
                                    
                                    if act {
                                        
                                        Image("checkedButton")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxHeight: 60)
                                            .padding(5)
                                        
                                    } else if !act && buyTable.contains(backgroundColors[i]){
                                        
                                        Button {
                                            
                                            updateTable(tableC: backgroundColors[i])

                                            
                                        } label: {
                                            
                                            Image("emptyButton")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(maxHeight: 60)
                                                .padding(5)
                                            
                                        }
                                        
                                    } else {
                                        
                                        Button {
                                            
                                            if coins >= 250 {
                                                
                                                updateCoins(amount: 250, operation: "sub")
                                                
                                                updateBuyTable(table: backgroundColors[i])
                                                
                                            }
                                            
                                            
                                        } label: {
                                            
                                            ZStack {
                                                
                                                Image("Button1")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .border(Color.black, width: 2)
                                                    .frame(maxHeight: 40)
                                                    .padding(5)
                                                
                                                HStack{
                                                    
                                                    Image("coin")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(maxHeight: 20)
                                                        .padding(1)
                                                    
                                                    Text(String(250))
                                                        .font(.title2)
                                                        .fontWeight(.bold)
                                                        .foregroundColor(Color.white)
                                                        .padding(1)
                                                        
                                                    
                                                }
                                                
                                            }
                                            
                                        }

                                        
                                    }
                                    
                                }
                            }
                            
                        }
                    }
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    
                }
                
            }
            
            //Toggle SFX and Music
            if settingScreen{
                
                VStack{
                    
                    HStack{

                        //Back Button
                        Button(action: {
                            settingScreen = false
                            titleScreen = true
                        }, label: {
                            Image("backButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                                .padding()
                                
                            
                        })
                        
                        Spacer()
                        
                    }
                    
                    ZStack{
                        
                        Image("Button1")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .padding()
                            .frame(maxWidth: 300, maxHeight: 300)
                        
                        VStack{
                            
                            Spacer()
                            
                            HStack{
                                
                                Spacer()
                                
                                //SoundFX Toggle
                                VStack{
                                    
                                    Text("SoundFX")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                    
                                    Button(action: {
                                        
                                        UserDefaults.standard.set(soundOn ,forKey: "sound")
                                        soundOn.toggle()
                                        
                                    }, label: {
                                        
                                        ZStack{
                                            
                                            Image("emptyButton")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 50)
                                            
                                            if soundOn {
                                                
                                                Image(systemName: "speaker.wave.1.fill")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .foregroundColor(.white)
                                                    .frame(width: 30)
                                                
                                                
                                            } else {
                                                
                                                Image(systemName: "speaker.slash.fill")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .foregroundColor(.white)
                                                    .frame(width: 35)
                                                
                                            }
                                            
                                        }
                                        
                                    })
                                    
                                }
                                
                                Spacer()
                                
                                //Music Button Toggle
                                VStack{
                                    
                                    Text("Music")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                    
                                    Button(action: {
                                        
                                        UserDefaults.standard.set(musicOn ,forKey: "music")
                                        musicOn.toggle()
                                        
                                        if !musicOn{
                                            
                                            music.stop()
                                            
                                        } else {
                                            
                                            playMusic()
                                            
                                        }
                                        
                                    },
                                           label: {
                                        
                                        ZStack{
                                            
                                            Image("emptyButton")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 50)
                                            
                                            if musicOn {
                                                
                                                Image(systemName: "play.fill")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .foregroundColor(.white)
                                                    .frame(width: 25)
                                                
                                                
                                            } else {
                                                
                                                Image(systemName: "play.slash.fill")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .foregroundColor(.white)
                                                    .frame(width: 30)
                                                
                                            }
                                            
                                        }
                                        
                                    })
                                    
                                }
                                .padding()
                                
                                Spacer()
                                
                            }
                            
                            Spacer()
                            
                        }
                        
                    }
                    
                    Text("Sneaking - Copyright Free Music ＆ SFX from https://yoyosound.com")
                        .font(.title3)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .padding()
                    
                }
                
            }
            
            //Play Screen
            if playScreen{
                
                VStack{
                    
                    Spacer()
                    
                    //Back, Restart and Score
                    HStack{
                        
                        Spacer()
                        
                        //Back Button
                        
                        Button(action: {
                            restartGame()
                            playScreen = false
                            titleScreen = true
                        }, label: {
                            Image("backButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 45)
                            
                        })
                        
                        Spacer()
                        
                        //Restart
                        ZStack{
                            Image("Button1")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .border(Color.black, width: 2)
                                .cornerRadius(5.0)
                                .frame(maxWidth: 150)
                            
                            
                            Button(action: {
                                if !pressed{
                                    restartGame()
                                    isPressed()
                                }
                            }, label: {
                                Text("RESTART")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                
                            })
                        }
                        
                        
                        Spacer()
                        
                        //Score
                        VStack{
                            Text("SCORE")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                            
                            
                            Text(String(score))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                        }
                        Spacer()
                    }
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    //Cards
                    if cSet{
                        
                        HStack{
                            
                            Spacer()
                            Spacer()
                            
                            //Side Cards
                            VStack{
                                
                                Image(card1)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(5.0)
                                    .frame(maxWidth: 95, maxHeight: 145)
                                
                                Spacer()
                                
                                Image(card2)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(5.0)
                                    .frame(maxWidth: 95, maxHeight: 145)
                                
                                Spacer()
                                
                                Image(card3)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(5.0)
                                    .frame(maxWidth: 95, maxHeight: 145)
                                
                                Spacer()
                                
                            }
                            
                            //Current Card
                            VStack{
                                
                                Spacer()
                                
                                ZStack{
                                    
                                    if !flipped{
                                        //Back of Card
                                        Image(cardBack)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .cornerRadius(10.0)
                                            .frame(maxWidth: 220)
                                            .padding()
                                    } else {
                                        //Front of Card
                                        Image(currentCard)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxWidth: 220)
                                            .padding()
                                    }
                                    
                                }
                                .rotation3DEffect(.degrees(contentRotation), axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/)
                                .rotation3DEffect(.degrees(cardRotation), axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/)
                                .frame(maxWidth: 275)
                                
                                Spacer()
                                
                                //Gap
                                Text(String())
                                
                                
                                Spacer()
                                Spacer()
                                Spacer()
                                
                            }
                            
                            Spacer()
                            
                        }
                    }
                    
                    Spacer()
                    Spacer()
                    
                    //Answer Buttons----
                    
                    //Buttons(Red / Black)
                    if bSet1{
                        
                        VStack{
                            
                            HStack{
                                
                                Spacer()
                                
                                if !pressed{
                                    
                                    Button(action: {
                                        currentCard = buttons1(b1: "red")
                                    }, label: {
                                        ZStack{
                                            Image("Button1")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .border(Color.black, width: 2)
                                                .cornerRadius(5.0)
                                                .frame(width: 150, height: 60)
                                            
                                            Text("RED")
                                                .font(.title)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.white)
                                        }
                                        
                                    })
                                } else {
                                    ZStack{
                                        Image("Button1")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .border(Color.black, width: 2)
                                            .cornerRadius(5.0)
                                            .frame(width: 150, height: 60)
                                        
                                        Text("RED")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.white)
                                    }
                                }
                                
                                Spacer()
                                
                                if !pressed{
                                    Button(action: {
                                        currentCard = buttons1(b1: "black")
                                    }, label: {
                                        ZStack{
                                            Image("Button1")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .border(Color.black, width: 2)
                                                .cornerRadius(5.0)
                                                .frame(width: 150, height: 60)
                                            
                                            Text("BLACK")
                                                .font(.title)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.white)
                                        }
                                        
                                    })
                                } else {
                                    ZStack{
                                        Image("Button1")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .border(Color.black, width: 2)
                                            .cornerRadius(5.0)
                                            .frame(width: 150, height: 60)
                                        
                                        Text("BLACK")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.white)
                                    }
                                }
                                
                                Spacer()
                                
                            }
                            
                            Text("Choose Wisely..")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .frame(width: 250,height: 50.0)
                            
                            
                        }
                        
                    }
                    
                    //Buttons(Over / Under / On)
                    if bSet2{
                        
                        VStack{
                            
                            HStack{
                                
                                Spacer()
                                
                                if !pressed{
                                    
                                    Button(action: {
                                        currentCard = buttons2(b2: "over")
                                    }, label: {
                                        ZStack{
                                            Image("Button1")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .border(Color.black, width: 2)
                                                .cornerRadius(5.0)
                                                .frame(width: 150, height: 60)
                                            
                                            Text("OVER")
                                                .font(.title)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.white)
                                        }
                                        
                                    })
                                } else {
                                    ZStack{
                                        Image("Button1")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .border(Color.black, width: 2)
                                            .cornerRadius(5.0)
                                            .frame(width: 150, height: 60)
                                        
                                        Text("OVER")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.white)
                                    }
                                }
                                
                                Spacer()
                                
                                if !pressed{
                                    Button(action: {
                                        currentCard = buttons2(b2: "under")
                                    }, label: {
                                        ZStack{
                                            Image("Button1")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .border(Color.black, width: 2)
                                                .cornerRadius(5.0)
                                                .frame(width: 150, height: 60)
                                            
                                            Text("UNDER")
                                                .font(.title)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.white)
                                        }
                                        
                                    })
                                } else {
                                    ZStack{
                                        Image("Button1")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .border(Color.black, width: 2)
                                            .cornerRadius(5.0)
                                            .frame(width: 150, height: 60)
                                        
                                        Text("UNDER")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.white)
                                    }
                                }
                                
                                Spacer()
                                
                            }
                            
                            if !pressed{
                                Button(action: {
                                    currentCard = buttons2(b2: "on")
                                }, label: {
                                    ZStack{
                                        Image("Button1")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .border(Color.black, width: 2)
                                            .cornerRadius(5.0)
                                            .frame(width: 125,height: 50.0)
                                        
                                        Text("ON")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.white)
                                    }
                                    
                                })
                            } else {
                                ZStack{
                                    Image("Button1")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .border(Color.black, width: 2)
                                        .cornerRadius(5.0)
                                        .frame(width: 125,height: 50.0)
                                    
                                    Text("ON")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                }
                            }
                            
                            
                        }
                        
                    }
                    
                    //Buttons(In / Out / On)
                    if bSet3{
                        
                        VStack{
                            
                            HStack{
                                
                                Spacer()
                                
                                if !pressed{
                                    Button(action: {
                                        currentCard = buttons3(b3: "in")
                                    }, label: {
                                        ZStack{
                                            Image("Button1")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .border(Color.black, width: 2)
                                                .cornerRadius(5.0)
                                                .frame(width: 150, height: 60)
                                            
                                            Text("IN")
                                                .font(.title)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.white)
                                        }
                                    })
                                } else {
                                    ZStack{
                                        Image("Button1")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .border(Color.black, width: 2)
                                            .cornerRadius(5.0)
                                            .frame(width: 150, height: 60)
                                        
                                        Text("IN")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.white)
                                    }
                                }
                                
                                Spacer()
                                
                                if !pressed{
                                    Button(action: {
                                        currentCard = buttons3(b3: "out")
                                    }, label: {
                                        ZStack{
                                            Image("Button1")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .border(Color.black, width: 2)
                                                .cornerRadius(5.0)
                                                .frame(width: 150, height: 60)
                                            
                                            Text("OUT")
                                                .font(.title)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.white)
                                        }
                                        
                                    })
                                } else {
                                    ZStack{
                                        Image("Button1")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .border(Color.black, width: 2)
                                            .cornerRadius(5.0)
                                            .frame(width: 150, height: 60)
                                        
                                        Text("OUT")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.white)
                                    }
                                }
                                
                                Spacer()
                                
                            }
                            
                            if !pressed{
                                Button(action: {
                                    currentCard = buttons3(b3: "on")
                                }, label: {
                                    ZStack{
                                        Image("Button1")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .border(Color.black, width: 2)
                                            .cornerRadius(5.0)
                                            .frame(width: 125.0,height: 50.0)
                                        
                                        Text("ON")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.white)
                                    }
                                })
                            } else {
                                ZStack{
                                    Image("Button1")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .border(Color.black, width: 2)
                                        .cornerRadius(5.0)
                                        .frame(width: 125.0,height: 50.0)
                                    
                                    Text("ON")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                }
                            }
                            
                            
                        }
                        
                    }
                    
                    //Buttons(In / Out / On)
                    if bSet4{
                        
                        VStack{
                            
                            HStack{
                                
                                Spacer()
                                
                                if !pressed{
                                    Button(action: {
                                        currentCard = buttons4(b4: "S")
                                    }, label: {
                                        ZStack{
                                            Image("Button1")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .border(Color.black, width: 2)
                                                .cornerRadius(5.0)
                                                .frame(width: 140, height: 60)
                                            
                                            Image(systemName: "suit.spade.fill")
                                                .font(.title)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.white)
                                        }
                                    })
                                } else {
                                    ZStack{
                                        Image("Button1")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .border(Color.black, width: 2)
                                            .cornerRadius(5.0)
                                            .frame(width: 140, height: 60)
                                        
                                        Image(systemName: "suit.spade.fill")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.white)
                                    }
                                }
                                
                                Spacer()
                                
                                if !pressed{
                                    Button(action: {
                                        currentCard = buttons4(b4: "D")
                                    }, label: {
                                        ZStack{
                                            Image("Button1")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .border(Color.black, width: 2)
                                                .cornerRadius(5.0)
                                                .frame(width: 140, height: 60)
                                            
                                            Image(systemName: "suit.diamond.fill")
                                                .font(.title)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.white)
                                        }
                                        
                                    })
                                } else {
                                    ZStack{
                                        Image("Button1")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .border(Color.black, width: 2)
                                            .cornerRadius(5.0)
                                            .frame(width: 140, height: 60)
                                        
                                        Image(systemName: "suit.diamond.fill")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.white)
                                    }
                                }
                                
                                Spacer()
                                
                            }
                            
                            HStack{
                                
                                Spacer()
                                
                                if !pressed{
                                    Button(action: {
                                        currentCard = buttons4(b4: "H")
                                    }, label: {
                                        ZStack{
                                            Image("Button1")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .border(Color.black, width: 2)
                                                .cornerRadius(5.0)
                                                .frame(width: 140, height: 60)
                                            
                                            Image(systemName: "suit.heart.fill")
                                                .font(.title)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.white)
                                        }
                                        
                                    })
                                } else {
                                    ZStack{
                                        Image("Button1")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .border(Color.black, width: 2)
                                            .cornerRadius(5.0)
                                            .frame(width: 140, height: 60)
                                        
                                        Image(systemName: "suit.heart.fill")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.white)
                                    }
                                }
                                
                                Spacer()
                                
                                if !pressed{
                                    Button(action: {
                                        currentCard = buttons4(b4: "C")
                                    }, label: {
                                        ZStack{
                                            Image("Button1")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .border(Color.black, width: 2)
                                                .cornerRadius(5.0)
                                                .frame(width: 140, height: 60)
                                            
                                            Image(systemName: "suit.club.fill")
                                                .font(.title)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.white)
                                        }
                                        
                                    })
                                } else {
                                    ZStack{
                                        Image("Button1")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .border(Color.black, width: 2)
                                            .cornerRadius(5.0)
                                            .frame(width: 140, height: 60)
                                        
                                        Image(systemName: "suit.club.fill")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.white)
                                    }
                                }
                                
                                Spacer()
                                
                            }
                            
                            
                        }
                        
                    }
                    
                }
                
                Spacer()
                
            }
            
            //Play screen for card count
            if playScreen{
                
                //Remaining Cards
                Text(String("CARDS :  \(allCards.count)"))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .offset(x: 50, y: 175)
                    .padding()
                
            }
            
            //End Screen
            if endScreen{
                
                VStack {
                    
                    HStack{
                        
                        //Coins
                        HStack {
                            Image("coin")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                            
                            
                            Text(String(coins))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                        }
                        .padding()
                        
                        Spacer()
                        
                        //Make
                        ZStack{
                            
                            Image("Button1")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100)
                                .border(Color.black, width: 2)
                            
                            Text("SHAZZZ")
                                .font(.title2)
                                .fontWeight(.thin)
                                .foregroundColor(Color.white)
                                .padding()
                            
                        }
                        
                    }
                    
                    ZStack{
                        
                        Image("Button1")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .padding()
                            .frame(maxWidth: 325, maxHeight: 325)
                        
                        VStack{
                            
                            Spacer()
                            
                            HStack{
                                
                                Spacer()
                                
                                //Score
                                VStack{
                                    
                                    Text("Your Score")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                    
                                    Text(String(score))
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                    
                                }
                                
                                Spacer()
                                
                                //Highscore
                                VStack{
                                    
                                    Text("Highscore")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                    
                                    Text(String(highscore))
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                    
                                }
                                
                                Spacer()
                                
                            }
                            
                            //Restart and Back Button
                            
                            HStack{
                                
                                Spacer()
                                
                                //Back Button
                                Button(action: {
                                    endScreen = false
                                    titleScreen = true
                                }, label: {
                                    Image("backButton")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50)
                                    
                                    
                                })
                                
                                Spacer()
                                
                                //Restart
                                ZStack{
                                    
                                    Image("Button1")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(5.0)
                                        .frame(maxWidth: 200, maxHeight: 100)
                                    
                                    Button(action: {
                                        restartGame()
                                    }, label: {
                                        Text("PLAY AGAIN")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.white)
                                        
                                    })
                                    
                                }
                                
                                Spacer()
                                
                            }
                            Spacer()
                        }
                        
                    }
                    
                    Spacer()
                    Spacer()
                }
                
            }
            
            //Test Screen
            if testScreen{
                
                
                
            }
            
        }
        //Plays Music when Game Opens if activated(soundfx also)
        .onAppear(perform: {
            musicOn.toggle()
            soundOn.toggle()
            playMusic()
        })
        
        
    }   //view
}   //struct

#Preview {
    ContentView()
}
