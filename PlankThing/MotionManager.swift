//
//  MotionManager.swift
//  PlankThing
//
//  Created by Linus Skucas on 7/29/23.
//

import Foundation
import CoreMotion

class MotionManager: NSObject, ObservableObject {
    private let motion = CMMotionManager()
    
    var motionValues = MotionValues()
    
    var timer: Timer? = nil
    
    var delegate: MotionManagerDelegate?
    
    func startUpdates() throws {
        guard motion.isDeviceMotionAvailable && motion.isGyroAvailable else { throw MotionManagerError.deviceDoesNotSupportMotion }
        
        motion.deviceMotionUpdateInterval = 1.0/60.0
        motion.startDeviceMotionUpdates(using: .xArbitraryCorrectedZVertical)
        
        timer = Timer(fire: Date(), interval: motion.deviceMotionUpdateInterval, repeats: true, block: { [weak self] timer in
            if let data = self?.motion.deviceMotion {
                self?.motionValues.yaw = data.attitude.yaw * (180/Double.pi)
                self?.motionValues.pitch = data.attitude.pitch * (180/Double.pi)
                self?.motionValues.roll = data.attitude.roll * (180/Double.pi)
                
                self?.motionValues.gyroReady = true
                
                self?.delegate?.motionValuesDidChange(motionValues: self?.motionValues ?? MotionValues())
            }
        })
        
        guard let timer else { throw MotionManagerError.noTimer }
        RunLoop.current.add(timer, forMode: .default)
    }
    
    func stopUpdates() {
        motion.stopDeviceMotionUpdates()
        timer?.invalidate()
        timer = nil
    }
}

extension MotionManager {
    enum MotionManagerError: Error {
        case deviceDoesNotSupportMotion
        case noTimer
    }
}
