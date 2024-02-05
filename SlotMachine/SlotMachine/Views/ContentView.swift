//
//  ContentView.swift
//  SlotMachine
//
//  Created by Sunil Maurya on 03/01/24.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - Properties
    let symbols = ["gfx-bell", "gfx-cherry", "gfx-coin", "gfx-grape", "gfx-seven", "gfx-strawberry"]
    
    
    //let haptics = UINotificationFeedbackGenerator()
    
    @State private var reels: Array = [0, 1, 2]
    @State private var highScore: Int = UserDefaults.standard.integer(forKey: "HighScore")
    @State private var coins: Int = 100
    @State private var betAmount: Int = 10
    @State private var showingInfoView = false
    @State private var isActiveBet10 = true
    @State private var isActiveBet20 = false
    @State private var showingModel = false
    @State private var animatingSymbol = false
    @State private var animatingModal = false

    
    //MARK: - Functions
    
    //SPIN THE REELS
    func spinReels() {
        reels = reels.map { _ in
            Int.random(in: 0...symbols.count - 1)
        }
        playSound(sound: "spin", type: "mp3")
        //haptics.notificationOccurred(.success)
    }
    
    //CHECK THE WINNING
    func checkWinning() {
        if reels[0] == reels[1] && reels[1] == reels[2] && reels [0] == reels [2] {
            //PLAYER WINS
            playerWins()
            
            //NEW HIGHSCORE
            if coins > highScore {
                newHighScore()
            } else {
                playSound(sound: "win", type: "mp3")
            }
        } else {
            //PLAYER LOSES
            playerLoses()
        }
    }
    
    func playerWins() {
        coins += betAmount * 10
    }
    
    func newHighScore() {
        highScore = coins
        UserDefaults.standard.setValue(highScore, forKey: "HighScore")
        playSound(sound: "high-score", type: "mp3")
    }
    
    func playerLoses() {
        coins -= betAmount
    }
 
    func activateBet20() {
        betAmount = 20
        isActiveBet10 = false
        isActiveBet20 = true
        playSound(sound: "casino-chips", type: "mp3")
        //haptics.notificationOccurred(.success)
    }
    
    func activateBet10() {
        betAmount = 10
        isActiveBet20 = false
        isActiveBet10 = true
        playSound(sound: "casino-chips", type: "mp3")
        //haptics.notificationOccurred(.success)
    }
    //GAME IS OVER
    func isGameOver() {
        if coins <= 0 {
            //SHOW MODEL WINDOW
            showingModel = true
            playSound(sound: "game-over", type: "mp3")
        }
    }
    
    func resetGame() {
        UserDefaults.standard.setValue(0, forKey: "HighScore")
        highScore = 0
        coins = 100
        activateBet10()
        playSound(sound: "chimeup", type: "mp3")
    }
    
    //MARK: - Body
    var body: some View {
        ZStack {
            //MARK: - Background
            LinearGradient(colors: [Color("ColorPink"), Color("ColorPurple")], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            
            //MARK: - Interface
            VStack(alignment: .center, spacing: 5) {
                
                //MARK: - Header
                LogoView()
                Spacer()
                
                
                
                //MARK: - Score
                HStack {
                    HStack {
                        Text("Your\nCoins".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.trailing)
                        
                        Text("\(coins)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                    }
                    .modifier(ScoreContainerModifier())
                    
                    Spacer()
                    
                    HStack {
                        
                        Text("\(highScore)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                        
                        Text("High\nScore".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.leading)
                        
                        
                    }
                    .modifier(ScoreContainerModifier())
                }
                
                //MARK: - Slot Machine
                VStack(alignment: .center, spacing: 0) {
                    //MARK: - REEL 1
                    ZStack {
                        ReelView()
                        Image(symbols[reels[0]])
                            .resizable()
                            .modifier(ImageModifier())
                            .opacity(animatingSymbol ? 1 : 0)
                            .offset(y: animatingSymbol ? 0 : -50)
                            .animation(.easeOut(duration: Double.random(in: 0.5...0.7)), value: animatingSymbol)
                            .onAppear {
                                self.animatingSymbol.toggle()
                                playSound(sound: "riseup", type: "mp3")
                            }
                    }
                    
                    HStack(alignment: .center, spacing: 0) {
                        //MARK: - REEL 2
                        ZStack {
                            ReelView()
                            Image(symbols[reels[1]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbol ? 1 : 0)
                                .offset(y: animatingSymbol ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.7...0.9)), value: animatingSymbol)
                                .onAppear {
                                    self.animatingSymbol.toggle()
                                }
                        }
                        
                        Spacer()
                        
                        //MARK: - REEL 3
                        ZStack {
                            ReelView()
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbol ? 1 : 0)
                                .offset(y: animatingSymbol ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.9...1.1)), value: animatingSymbol)
                                .onAppear {
                                    self.animatingSymbol.toggle()
                                }
                        }
                    }
                    .frame(maxWidth: 500)
                    
                    
                    //MARK: - REEL 4
                    Button {
                        //1. SET THE DEFAULT STATE: NO ANIMATION
                        withAnimation {
                            self.animatingSymbol = false
                        }
                        //2. SPIN REELS WITH CHANGING SYMBOLS
                        self.spinReels()
                        
                        //3.TRIGGER THE ANIMATION AFTER CHANGING SYMBOL
                        withAnimation {
                            self.animatingSymbol = true
                        }
                        
                        //4. CHECK WINNING
                        self.checkWinning()
                        
                        //5. GAME IS OVER
                        self.isGameOver()
                    } label: {
                        Image("gfx-spin")
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImageModifier())
                    }

                }
                .layoutPriority(2)
                
                //MARK: - Footer
                Spacer()
                
                HStack {
                    //MARK: - BET 20 Button
                    HStack(alignment: .center, spacing: 10) {
                        Button{
                            activateBet20()
                        } label: {
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundStyle(isActiveBet20 ? .yellow : .white)
                                .modifier(BetNumberModifier())
                            
                        }
                        .modifier(BetCapsuleModifier())
                        
                    Image("gfx-casino-chips")
                            .resizable()
                            .offset(x: isActiveBet20 ? 0 : 20)
                            .opacity(isActiveBet20 ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                    }//INNER HSTACK
                    
                    Spacer()
                    
                    //MARK: - BET 10 Button
                    HStack(alignment: .center, spacing: 10) {
                        Image("gfx-casino-chips")
                                .resizable()
                                .offset(x: isActiveBet10 ? 0 : -20)
                                .opacity(isActiveBet10 ? 1 : 0)
                                .modifier(CasinoChipsModifier())
                        
                        Button{
                            activateBet10()
                        } label: {
                            Text("10")
                                .fontWeight(.heavy)
                                .foregroundStyle(isActiveBet10 ? .yellow : .white)
                                .modifier(BetNumberModifier())
                            
                        }
                        .modifier(BetCapsuleModifier())
                    }//INNER HSTACK
                }// UPPER HSTACK
            }
            //MARK: - Buttons
            .overlay(
                //RESET
                Button(action: {
                    self.resetGame()
                }) {
                    Image(systemName: "arrow.2.circlepath.circle")
                }
                .modifier(ButtonModifier()),
                alignment: .topLeading
            )
            .overlay(
                //Info
                Button(action: {
                    self.showingInfoView = true
                }) {
                    Image(systemName: "info.circle")
                }
                .modifier(ButtonModifier()),
                alignment: .topTrailing
            )
            .padding()
            .frame(maxWidth: 720)
            .blur(radius: $showingModel.wrappedValue ? 5 : 0, opaque: false)
            
            //MARK: - Popup
            if $showingModel.wrappedValue {
                ZStack {
                    Color("ColorTransparentBlack")
                        .ignoresSafeArea(.all)
                    
                    VStack(spacing: 0) {
                        //Title
                        Text("Game Over")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.heavy)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color("ColorPink"))
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        //Message
                        VStack(alignment: .center, spacing: 16) {
                            Image("gfx-seven-reel")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 72)
                            
                            Text("Bad luck! You lost all the coins.\nLet's play again!")
                                .font(.system(.body))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.gray)
                                .layoutPriority(1)
                            
                            Button {
                                self.showingModel = false
                                self.coins = 100
                                self.animatingModal = false
                                self.activateBet10()
                            } label: {
                                Text("New Game".uppercased())
                                    .font(.system(.body, design: .rounded))
                                    .fontWeight(.semibold)
                                    .accentColor(Color("ColorPink"))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minWidth: 128)
                                    .background(
                                        Capsule()
                                            .strokeBorder(lineWidth: 1.75)
                                            .foregroundStyle(Color("ColorPink"))
                                    )
                            }

                        }
                        
                        Spacer()
                    }
                    .frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color("ColorTransparentBlack"), radius: 6, x: 0, y: 8)
                    .opacity(self.$animatingModal.wrappedValue ? 1 : 0)
                    .offset(y: self.$animatingModal.wrappedValue ? 0 : -100)
                    .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0), value: animatingModal)
                    .onAppear {
                        self.animatingModal = true
                    }
                }
            }
            
        } //ZStack
        .sheet(isPresented: $showingInfoView, content: {
            InfoView()
        })
    }
}

#Preview {
    ContentView()
}
