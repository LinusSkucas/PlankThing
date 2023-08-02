//
//  GameCenterManager.swift
//  PlankThing
//
//  Created by Linus Skucas on 7/29/23.
//

import UIKit
import GameKit

class GameCenterManager: NSObject, ObservableObject, GKGameCenterControllerDelegate, GameCenterManagerDelegate {
    static let shared = GameCenterManager()
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
    
    
    func authenticateGameCenter() {
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            guard let viewController, error != nil else { return }
            UIApplication.shared.windows.first?.rootViewController?.present(viewController, animated: true)
            GKAccessPoint.shared.location = .topLeading
            GKAccessPoint.shared.showHighlights = true
            GKAccessPoint.shared.isActive = true
        }
    }
    
    func showDashboard() {
        let vc = GKGameCenterViewController(leaderboardID: "board", playerScope: .global, timeScope: .allTime)
        vc.gameCenterDelegate = self
        UIApplication.shared.windows.first?.rootViewController?.present(vc, animated: true)
    }
    
    func reportScore(timeInterval: TimeInterval) {
        print("reporting score")
        let leaderboardScore = GKLeaderboardScore()
        leaderboardScore.leaderboardID = "board"
        leaderboardScore.player = GKLocalPlayer.local
        leaderboardScore.value = Int(timeInterval)
        GKScore.report([leaderboardScore], withEligibleChallenges: []) { error in
            guard let error else { return }
            print("FAIL" + error.localizedDescription)
        }
    }
}
