//
//  TransactionResponseModel.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation

struct TransactionResponseModel: Codable {
    let transactions: [TransactionModel]
}
