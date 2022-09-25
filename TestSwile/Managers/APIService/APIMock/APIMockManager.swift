//
//  APIMockManager.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 25/09/2022.
//

import Foundation
import UIKit

class APIMockManager: APIServiceInterface {

    let error: Bool

    init(error: Bool =  false) {
        self.error = error
    }

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
