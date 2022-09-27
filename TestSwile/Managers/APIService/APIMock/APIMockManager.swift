//
//  APIMockManager.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 25/09/2022.
//

import Foundation
import UIKit

/// APIMock manager, conform to APIServiceInterface and return JSON data file
class APIMockManager: APIServiceInterface {

    /// If this property is set an error will be throw on each call
    private let error: Bool

    /// APIMock init
    /// - Parameter error: If this property is set an error will be throw on each call
    init(error: Bool =  false) {
        self.error = error
    }

    /// Get Transactions Swift Concurrency TASK
    /// This task will return raw data (loaded from a local JSON file)
    /// - Returns: Transactions Swift Concurrency TASK
    func getTransactions() -> Task<Data, Error> {

        let dest: Task<Data, Error> = Task {
            if error == true {
                throw APIServiceError.noInternet
            }
            guard let url = Bundle.main.url(forResource: "mock", withExtension: "json") else { throw APIServiceError.wrongResponse }
        	return try Data(contentsOf: url)
        }
        return dest
    }
}
