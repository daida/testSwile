//
//  AmountModel.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation

// MARK: - AmountModel

/// Describe the model amount with the value and the currency
struct AmountModel: Codable {

    /// Amount value
    let value: Float

    /// Amount currency
    let currency: CurencyModel
}
