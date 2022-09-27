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

    /// Get Image Swift Concurrency TASK
    /// - Parameter imageURL: image URL to retive
    /// - Returns: Swift Concurrency TASK get raw image task
    func getImage(imageURL: String) -> Task<Data, Error> {
        let dest: Task<Data, Error> = Task {
            if error == true {
                throw APIServiceError.noInternet
            }
            guard let image = UIImage(named: "mockPicture") else {
                throw APIServiceError.wrongResponse
            }
            guard let jpegData =  image.jpegData(compressionQuality: 1.0) else {
                throw APIServiceError.wrongResponse
            }
            return jpegData
        }
        return dest
    }

    /// Get Cached image data
    /// - Parameter imageURL: cached image URL
    /// - Returns: Return an image data if the image is cached else an error is throw
    func getCachedImage(imageURL: String) throws -> Data {
        if error == true {
            throw APIServiceError.noInternet
        }
        guard let image = UIImage(named: "mockPicture") else {
            throw APIServiceError.wrongResponse
        }
        guard let jpegData =  image.jpegData(compressionQuality: 1.0) else {
            throw APIServiceError.wrongResponse
        }
        return jpegData
    }
}
