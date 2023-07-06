//
//  UIColorEx.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 06/07/2023.
//

import UIKit

extension UIColor {
    convenience init?(hex: Int, alpha: CGFloat = 1.0) {
        let red = (hex >> 16) & 0xFF
        let green = (hex >> 8) & 0xFF
        let blue = hex & 0xFF

        if red < 0 || red > 255 ||
            green < 0 || green > 255 ||
            blue < 0 || blue > 255 {
            return nil
        }

        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: alpha)
    }
}
