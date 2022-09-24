//
//  NumberFormater.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 24/09/2022.
//

import Foundation

extension NumberFormatter {
	static func formatPrice(price: Float, currency: String) -> String? {
        let numberFormater = NumberFormatter()
        numberFormater.numberStyle = .currency
        numberFormater.currencyCode = currency
        numberFormater.positivePrefix = "+"

        if price.truncatingRemainder(dividingBy: 1) == 0 {
            numberFormater.maximumFractionDigits = 0
        }

        numberFormater.locale = Locale(identifier: "fr_FR")
        return numberFormater.string(from: NSNumber(value: price))
    }
}


