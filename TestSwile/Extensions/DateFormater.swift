//
//  DateFormater.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation

extension DateFormatter {

    static let isoFormater: ISO8601DateFormatter = {
        let formater = ISO8601DateFormatter()
        formater.formatOptions = [.withYear, .withMonth, .withDay,
            .withTime, .withDashSeparatorInDate,
            .withColonSeparatorInTime, .withFractionalSeconds,
            .withTimeZone]
        return formater
    }()

    static let fullDateFormatter: DateFormatter = {
        let dest = DateFormatter()
        // I had to force the locale because since the new Xcode updae my
        // locale is always en_FR...
        dest.locale = Locale(identifier: "fr_FR")
        dest.dateFormat = "EEEE d MMMM, HH:mm"
        return dest
    }()

    static let shortDateFormatter: DateFormatter = {
        let dest = DateFormatter()
        // I had to force the locale because since the new Xcode updae my
        // locale is always en_FR...
        dest.locale = Locale(identifier: "fr_FR")
        dest.dateFormat = "d MMMM"
        return dest
    }()

    static let monthDateFormater: DateFormatter = {
        let dest = DateFormatter()
        // I had to force the locale because since the new Xcode updae my
        // locale is always en_FR...
        dest.locale = Locale(identifier: "fr_FR")
        dest.dateFormat = "MMMM"
        return dest
    }()

    static let yearAndMonthFormatter: DateFormatter = {
        let dest = DateFormatter()
        dest.dateFormat = "MMMMYY"
        return dest
    }()

}
