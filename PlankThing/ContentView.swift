//
//  ContentView.swift
//  PlankThing
//
//  Created by Linus Skucas on 7/29/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var gameManager = GameManager()
    @ObservedObject var gameCenterManager = GameCenterManager.shared
    
    let instructions = "To plank:\n1 - Start planking on flat ground\n2 - Have someone put the phone in the center of your back, vertically. Have them press \"begin game\"\n3 - The red box appears when you've failed.\n4 - Your score is reported to Game Center automatically.\n\nIf you cheat you're lame.\nMake sure Game Center is enabled already before you start."
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Game Status: \(gameManager.gameStatus.rawValue)")
                Button("Begin game") {
                    try? gameManager.startGame()
                }
                Spacer()
                if gameManager.gameStatus == .inProgress {
                    Text(gameManager.startTime ?? Date(), style: .relative)
                        .font(.title)
                    Button("Stop") {
                        gameManager.endGame()
                    }
                }
                if gameManager.gameStatus == .ended {
                    Rectangle()
                        .fill(Color.red)
                        .frame(height: 100)
                    
                    Text(formatter.string(from: gameManager.duration!)!)
                }
                Text(instructions)
                Spacer()
                HStack {
                    //                Button("Clear") {
                    //                    gameManager.initialMotionValues = nil
                    //                    gameManager.gameStatus = .notStarted
                    //                }
                    Button("Leaderboard") {
                        gameCenterManager.showDashboard()
                    }
                }
            }
        }
        .padding()
        .onAppear {
            gameCenterManager.authenticateGameCenter()
        }
    }
    
    var formatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .short
        return formatter
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


