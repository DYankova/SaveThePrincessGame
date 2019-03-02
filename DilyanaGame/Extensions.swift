//
//  Extensions.swift
//  DilyanaGame
//
//  Created by Dilyana Yankova on 26.02.19.
//  Copyright © 2019 Dilyana Yankova. All rights reserved.
//

import UIKit
import AudioToolbox

class Extensions {
extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
}
