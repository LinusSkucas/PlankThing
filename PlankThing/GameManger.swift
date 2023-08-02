//
//  GameManger.swift
//  PlankThing
//
//  Created by Linus Skucas on 7/29/23.
//

import Foundation

class GameManager: NSObject, ObservableObject, MotionManagerDelegate {
    let motionManager = MotionManager()
    
    override init() {
        super.init()
        
        motionManager.delegate = self
    }
    
    @Published var gameStatus = GameStatus.notStarted
    var startTime: Date?
    var duration: TimeInterval?
    
    var initialMotionValues: MotionValues? = nil
    
    func startGame() throws {
        gameStatus = .inProgress
        try motionManager.startUpdates()
        startTime = Date()
        duration = nil
    }
    
    func endGame() {
        motionManager.stopUpdates()
        gameStatus = .ended
        
        duration = abs(startTime?.timeIntervalSinceNow ?? 0)
        
        guard let duration else { return }
        GameCenterManager.shared.reportScore(timeInterval: duration)
    }
    
    internal func motionValuesDidChange(motionValues: MotionValues) {
        // Check that motion values are valid
        guard motionValues.valuesReady else { return }
        // Check that motion values are within range
        print(motionValues)
        
        if motionValues.pitch > 40.0 || motionValues.pitch < -10.0 || abs(motionValues.yaw) > 10 || abs(motionValues.roll) > 7 {
            endGame()
        }
        
        if initialMotionValues == nil {
            initialMotionValues = motionValues
        }
    }
}
