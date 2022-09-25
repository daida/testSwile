//
//  RequestFactory.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation

class RequestFactory: RequestFactoryInterface {

    private struct Constant {
        
        static let endPoint = "https://gist.githubusercontent.com/Aurazion/365d587f5917d1478bf03bacabdc69f3/raw/3c92b70e1dc808c8be822698f1cbff6c95ba3ad3/transactions.json"
    }

    private let endPoint: String

    init(endPoint: String? = nil) {
        if let endPoint = endPoint {
            self.endPoint = endPoint
        } else {
            self.endPoint = Constant.endPoint
        }
    }

    func generateGetTransactionsRequest() -> URLRequest? {
        guard let destURL = URL(string: Constant.endPoint) else { return nil }
		var request = URLRequest(url: destURL)
        request.httpMethod = "GET"
        return request
    }

    func generateGetImage(imageURL: String) -> URLRequest? {
        guard let url = URL(string: imageURL) else { return nil }
    	var request = URLRequest(url: url)
        request.cachePolicy = .useProtocolCachePolicy
        request.httpMethod = "GET"
        return request
    }

}

protocol RequestFactoryInterface {
    func generateGetTransactionsRequest() -> URLRequest?
    func generateGetImage(imageURL: String) -> URLRequest?
}
