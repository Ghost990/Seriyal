//
//  Colorize.swift
//  Seriyal-2
//
//  Created by Zsolt Nagy on 2017. 10. 28..
//  Copyright © 2017. Zsolt Nagy. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    var isLight: Bool {
        guard let components = cgColor.components else { return false }
        let redBrightness = components[0] * 299
        let greenBrightness = components[1] * 587
        let blueBrightness = components[2] * 114
        let brightness = (redBrightness + greenBrightness + blueBrightness) / 1000
        return brightness > 0.5
    }
}
