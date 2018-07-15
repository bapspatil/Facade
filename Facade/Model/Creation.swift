//
//  Creation.swift
//  Facade
//
//  Created by Bapusaheb Patil on July 16,2018.
//  Copyright © 2018 Bapusaheb Patil. All rights reserved.
//

import Foundation
import UIKit

class Creation {
    
    var image: UIImage
    var colorSwatch: ColorSwatch
    static var defaultImage: UIImage {
        return UIImage.init(named: "Splash.png")!
    }
    static var defaultColorSwatch: ColorSwatch {
        return ColorSwatch.init(caption: "Yellow", color: .yellow)
    }
    
    init() {
        image = Creation.defaultImage
        colorSwatch = Creation.defaultColorSwatch
    }
    
    convenience init(image: UIImage, colorSwatch: ColorSwatch) {
        self.init()
        self.image = image
        self.colorSwatch = colorSwatch
    }
    
    convenience init(colorSwatch: ColorSwatch?) {
        self.init()
        if let userColorSwatch = colorSwatch {
            self.colorSwatch = userColorSwatch
        }
    }
    
    func reset(colorSwatch: ColorSwatch?) {
        image = Creation.defaultImage
        if let userColorSwatch = colorSwatch {
            self.colorSwatch = userColorSwatch
        }
        else {
            self.colorSwatch = Creation.defaultColorSwatch
        }
    }
}
