//
//  TransactionModel.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation

// MARK: - TransactionModel

/// Represent a User transaction
/// The model is Codable
struct TransactionModel: Codable {

    /// Transaction name exemple:  Restos du coeur
    let name: String

    /// Transaction type: donation, meal_voucher, gift, mobility, payment
    let type: String

    /// Transacton Date, date format 8601 with milisecond and timeZone exemple: 2021-03-07T14:04:45.000+01:00
    let date: Date

    /// Transaction message :
    let message: String?

    /// Amount model describe the currency and the amount of the transaction
    let amount: AmountModel

    /// Small icon model describe a category name and a image URL
    let smallIcon: ImageModel

    /// Large icon model describe a category name and a image URL
    let largeIcon: ImageModel
}
