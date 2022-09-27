//
//  NumberFormater.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 24/09/2022.
//

import Foundation

// MARK: NumberFormatter

extension NumberFormatter {

    /// Format a Price string with a currency code
    /// The method output will depend of the user current locale
    /// - Parameters:
    ///   - price: price amount
    ///   - currency: currency code
    /// - Returns: formated price str
	static func formatPrice(price: Float, currency: String) -> String? {

        let numberFormater = NumberFormatter()

        numberFormater.numberStyle = .currency
        numberFormater.currencyCode = currency

        if price.truncatingRemainder(dividingBy: 1) == 0 {
            numberFormater.maximumFractionDigits = 0
        }

    	let dest = numberFormater.string(from: NSNumber(value: price))
        if let dest = dest, price > 0 {
    		return "+\(dest)"
        } else {
            return dest
        }
    }
}


