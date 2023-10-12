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
    
    @State private var questions: [String:Int] = [:]
    @State private var currentQuestion: String = ""
    @State private var currentAnswer: Int = 0
    @State private var answerText: Int = 0
    
    @State private var usedQuestions: Set<String> = []
    @State private var response = "Waiting"
    @State private var showingAnswer = false
    
    @State private var score = 0
    @State private var questionNumber = 0
    
    var highestTable: Int
    var questionAmount: Int
    
    
    var body: some View {
        VStack() {
            Text("Score: \(score)")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
            
            Text(questions.count > 0 ? "Question \(questionNumber + 1):   \(currentQuestion)" : "Loading")
                .font(.headline)
            
            Form {
                Section("Enter your answer") {
                    TextField("", value: $answerText, format: .number)
                        .onSubmit {
                            response = checkAnswer() ? "Correct!" : "Wrong"
                        }
                }
            }
            Spacer()
            Spacer()
            Spacer()
            Text(response)
                .font(.headline)
                .fontWeight(.bold)
            Text(showingAnswer ? "The answer is \(currentAnswer)" : "")
            
            Spacer()
        }
        .padding(50)
        .background(.teal)
        .onAppear{
            populateQuestions()
            displayQuestion()
        }
        .alert(response, isPresented: $showingAnswer) {
            Button("Next question") {
                resetFields()
            }
        }
    }
    
    func resetFields() {
        response = "Waiting"
        questionNumber += 1
        displayQuestion()
    }
    
    func checkAnswer() -> Bool {
        showingAnswer = true
        if answerText == currentAnswer {
            score += 1
            return true
        } else {
            return false
        }
    }
    
    func displayQuestion() {
        let currentPair = fetchQuestion()
        if usedQuestions.contains(currentPair.0) {
            displayQuestion()
        } else {
            currentQuestion = currentPair.0
            usedQuestions.insert(currentQuestion)
            currentAnswer = currentPair.1
        }
    }
    
    func fetchQuestion() -> (String, Int) {
        if let safeQuestion = questions.randomElement() {
            return (safeQuestion.key, safeQuestion.value)
        }
        
        return ("Can't find any more questions ☠️", 0)
    }
    
    func populateQuestions() {
        for table in (2...highestTable) {
            for num in (1...10) {
                let question = "What is \(table) * \(num)?"
                questions[question] = table * num
            }
        }
        
        if highestTable >= 11 {
            questions["What is 11 * 11?"] = 121
        }
        
        if highestTable == 12 {
            questions["What is 12 * 11?"] = 132
            questions["What is 12 * 12?"] = 144
        }
        
        print(questions)
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
