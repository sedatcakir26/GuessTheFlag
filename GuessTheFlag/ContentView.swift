//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Sedat Çakır on 1.08.2022.
//

import SwiftUI

struct FlagImage: ViewModifier {
    func body(content: Content) -> some View {
        content
        //  .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

//large, blue font suitable for prominent titles in a view.
struct NewFlagImage: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.weight(.bold))
            .foregroundColor(.blue)
    }
}

extension View{
    func titleStyle() -> some View {
        modifier(NewFlagImage())
    }
}



struct ContentView: View {
    @State private var opValue = 1.0
    @State private var tappedFlag = -1
    @State private var animationAmount = 0.0
    @State private var question = 0
    @State private var isGameFinished = false
    @State private var score = 0
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    
    
    var body: some View {
        
        ZStack{
            
            RadialGradient(stops: [.init(color:Color(red: 0.1, green: 0.2, blue: 0.45),
                                         location: 0.3),
                                   .init(color:Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700) .ignoresSafeArea()
            
            VStack{
                Spacer()
                Text("Guess the flag")
                    .titleStyle()
                
                VStack(spacing: 15){
                    VStack{
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundColor(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    
                    ForEach(0..<3) { number in
                        Button{
                            tappedFlag = number
                            flagTapped(number)
                            opValue = 0.25
                            withAnimation {
                                animationAmount += 360
                            }
                        }label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .modifier(FlagImage())
                                .rotation3DEffect(.degrees(tappedFlag == number ? animationAmount : 0), axis: (x: 0, y: 1, z: 0))
                                .opacity(tappedFlag == number ? 1 : opValue)
                                
                                .scaleEffect(tappedFlag == number ? 1 : opValue)
                              
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .font(.title.bold())
                    .foregroundColor(.white)
                Spacer()
            }
            
            .padding()
            
        }
        
        .alert(scoreTitle, isPresented: $showingScore){
            Button("Continue" , action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        
        .alert("Your score is \(score)", isPresented: $isGameFinished){
            Button("RESTART GAME", action: restartGame)
        }
    }
    
    func restartGame(){
        askQuestion()
        showingScore = false
        isGameFinished = false
        question = 0
        score = 0
    }
    
    func flagTapped(_ number : Int){
        
        
        showingScore = true
        
        if(number == correctAnswer){
            score+=1
            scoreTitle = "Correct"
        }else{
            scoreTitle = "Wrong! That’s the flag of \(countries[correctAnswer])"
        }
        
        
        
        question+=1
        
        if question == 8 {
            isGameFinished = true
        }
        
    }
    
    func askQuestion(){
        opValue = 1
        if !isGameFinished {
            countries = countries.shuffled()
            correctAnswer = Int.random(in: 0...2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
