//
//  TransactionModel.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation

struct TransactionModel: Codable {
    let name: String
    let type: String
    let date: Date
    let message: String?
    let amount: AmountModel
    let smallIcon: ImageModel
    let largeIcon: ImageModel
}
