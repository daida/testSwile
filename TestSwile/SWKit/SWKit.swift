//
//  SWKit.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 23/09/2022.
//

import Foundation
import UIKit

struct SWKit {

    enum CategoriesIcons: String {
        case bakery
        case burger
        case computer
        case gift
        case meal_voucher
        case mobility
        case supermarket
        case sushi
        case train

        var image: UIImage? {
            return UIImage(named: self.rawValue)
        }

    }

}
