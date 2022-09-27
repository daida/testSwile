//
//  RequestFactory.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation

// MARK: - RequestFactory

/// Generate request for the APIService
class RequestFactory: RequestFactoryApiInterface, RequestFactoryImageInterface {

    // MARK: Private properties

    /// Request Factory constant
    private struct Constant {

        /// Default Transaction EndPoint
        static let endPoint = "https://gist.githubusercontent.com/Aurazion/365d587f5917d1478bf03bacabdc69f3/raw/3c92b70e1dc808c8be822698f1cbff6c95ba3ad3/transactions.json"
    }

    /// API EndPoint
    private let endPoint: String

    // MARK: Init

    /// Request Factory init
    /// - Parameter endPoint: the endPoint can be injected, but a default one is provided
    init(endPoint: String? = nil) {
        if let endPoint = endPoint {
            self.endPoint = endPoint
        } else {
            self.endPoint = Constant.endPoint
        }
    }

    // MARK: Public methods

    /// Genereate the get Transaction Request
    /// - Returns: a getTransaction Request
    func generateGetTransactionsRequest() -> URLRequest? {
        guard let destURL = URL(string: Constant.endPoint) else { return nil }
		var request = URLRequest(url: destURL)
        request.httpMethod = "GET"
        return request
    }

    /// Generate a get Image URL
    /// - Parameter imageURL: url image to download
    /// - Returns: URLRequest image
    func generateGetImage(imageURL: String) -> URLRequest? {
        guard let url = URL(string: imageURL) else { return nil }
    	var request = URLRequest(url: url)
        request.cachePolicy = .useProtocolCachePolicy
        request.httpMethod = "GET"
        return request
    }

}

// MARK: - RequestFactoryInterface

protocol RequestFactoryApiInterface {
    func generateGetTransactionsRequest() -> URLRequest?

}

protocol RequestFactoryImageInterface {
    func generateGetImage(imageURL: String) -> URLRequest?
}
