//
//  MotionValues.swift
//  PlankThing
//
//  Created by Linus Skucas on 7/29/23.
//

import Foundation

struct MotionValues {
    var yaw: Double = 0
    var pitch: Double = 0
    var roll: Double = 0
    var altitude: Double = 0
    
    var gyroReady = false
    
    var valuesReady: Bool {
        gyroReady
    }
}
