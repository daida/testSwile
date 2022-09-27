//
//  CurencyModel.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation

// MARK: - CurencyModel

/// Currency model
/// Represent a currency with symbol code and title
struct CurencyModel: Codable {

    /// Curency code
    let iso3: String

    /// Currency symbol
    let symbol: String

    /// Currency symbol
    let title: String
}
