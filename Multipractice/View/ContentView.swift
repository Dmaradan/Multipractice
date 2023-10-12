//
//  SettingsView.swift
//  Multipractice
//
//  Created by Diego Martin on 10/12/23.
//

import SwiftUI

enum Difficulty: String, CaseIterable {
    case easy
    case medium
    case hard
}

struct SheetView: View {
    @Environment(\.dismiss) var dismiss
    
    var highestTable: Int
    var questionAmount: Int
    
    var body: some View {
        Text("We have \(questionAmount) questions to go through up to \(highestTable) table")
            .background(.teal)
    }
}

struct ContentView: View {
    let colors: [Color] = [.green, .blue, .yellow, .red]
    let questionAmounts = [5, 10, 20]
    
    @State private var highestTable = 7
    @State private var questionAmount = 10
    @State private var difficultyDescription = ""
    @State private var animal = "🦜"
    
    @State private var difficulty: Difficulty = .easy
    
    @State private var customDifficultyOn = false
    
    @State private var showingGameSheet = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("Presets")
                    .multilineTextAlignment(.leading)
                Form {
                    Section("Choose difficulty") {
                        Picker("", selection: $difficulty) {
                            ForEach(Difficulty.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: difficulty, chooseDifficulty)
                        
                        VStack {
                            Text(animal)
                                .font(.largeTitle)
                            Text(difficultyDescription)
                                .font(.title)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                
                Spacer()
                
                Text("Custom difficulty")
                
                Form {
                    Section("Choose highest table to practice") {
                        Picker("", selection: $highestTable) {
                            ForEach(2..<13, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    Section("Amount of questions") {
                        Picker("", selection: $questionAmount) {
                            ForEach(questionAmounts, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                
                //NavigationLink("PLAY", destination: SheetView())
                Button("PLAY") {
                    showingGameSheet.toggle()
                }
                
                
                Spacer()
                
            }
            .onAppear {
                chooseDifficulty()
            }
            .sheet(isPresented: $showingGameSheet) {
                SheetView(highestTable: highestTable, questionAmount: questionAmount)
            }
        }
    }
    
    func chooseDifficulty() {
        customDifficultyOn = false
        print("Choosing difficulty")
        switch difficulty {
        case .easy:
            animal = "🐸"
            difficultyDescription = "Hop on the lilypads: 5 questions from tables 2 through 5"
            questionAmount = 5
            highestTable = 5
        case .medium:
            animal = "🦜"
            difficultyDescription = "Soar high in the canopy: 10 questions from tables 2 through 10"
            questionAmount = 10
            highestTable = 10
        case .hard:
            animal = "🦍"
            difficultyDescription = "Challenge the king: 20 qustions from tables 2 through 12"
            questionAmount = 20
            highestTable = 12
        }
    }
}

#Preview {
    ContentView()
}
