//
//  TransactionResponseModel.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation

// MARK: - TransactionResponseModel

/// Transaction Response model, contain an array of TransactionModel
struct TransactionResponseModel: Codable {

    /// Array of Transaction Model
    let transactions: [TransactionModel]

}
