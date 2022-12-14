//
//  APIService.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation

// MARK: - APIService

/// Communicate with the End Point API
/// Return Transaction model and image data
/// This manager return RAW data (this manager will not do model or image parsing)
class APIService: APIServiceInterface {

    // MARK: Private properties

    private let requestFactory: RequestFactoryApiInterface
    private let internetChecker: InternetCheckerInterface
    private let urlSession: URLSession

    // MARK: Init

    /// APIService init
    /// - Parameters:
    ///   - urlSession: URLSession can be injected be a default is provided
    ///   - requestFactory: Generate request for all API call
    ///   - internetChecker: check if the internet is reachable
    init(urlSession: URLSession? = nil,
         requestFactory: RequestFactoryApiInterface,
         internetChecker: InternetCheckerInterface) {
        if let urlSession = urlSession {
            self.urlSession = urlSession
        } else {
            let conf = URLSessionConfiguration.default
            conf.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            let session = URLSession(configuration: conf)
            self.urlSession = session
        }
        self.requestFactory = requestFactory
        self.internetChecker = internetChecker
    }

    // MARK: Public properties

    /// Get Transactions Swift Concurrency TASK
    /// This task will return raw data
    /// - Returns: Transactions Swift Concurrency TASK
    func getTransactions() -> Task<Data, Error> {

        let dest: Task<Data, Error> = Task {

            guard let request = self.requestFactory.generateGetTransactionsRequest()
            else { throw APIServiceError.wrongRequest }

            guard self.internetChecker.isConnected == true else {
                throw APIServiceError.noInternet
            }

            do {
                try Task.checkCancellation()
                let rep = try await self.urlSession.data(for: request)
                try Task.checkCancellation()
                guard let httpResponse = rep.1 as? HTTPURLResponse else {
                    throw APIServiceError.wrongResponse
                }

                guard httpResponse.statusCode == 200 else {
                    throw APIServiceError.forbidden(httpCode: httpResponse.statusCode)
                }

                return rep.0

            } catch {
                throw APIServiceError.apiError(error: error)
            }
        }

        return dest

    }

}

// MARK: - APIServiceInterface

protocol APIServiceInterface {
    func getTransactions() -> Task<Data, Error>
}

// MARK: - APIServiceError

enum APIServiceError: Error {
    case noInternet
    case wrongRequest
    case wrongResponse
    case forbidden(httpCode: Int)
    case apiError(error: Error?)
}
