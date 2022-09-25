//
//  APIService.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation

class APIService: APIServiceInterface {

    private let requestFactory: RequestFactoryInterface
    private let internetChecker: InternetCheckerInterface
    private let urlSession: URLSession

    init(urlSession: URLSession? = nil,
         requestFactory: RequestFactoryInterface,
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

     func getCachedImage(imageURL: String) throws -> Data  {
        guard let imageRequest = self.requestFactory.generateGetImage(imageURL: imageURL) else {
            throw APIServiceError.wrongRequest
        }
         if let cachedResponse = self.urlSession.configuration.urlCache?.cachedResponse(for: imageRequest) {
             return cachedResponse.data
         } else {
             throw APIServiceError.noInternet
         }
    }

    func getImage(imageURL: String) -> Task<Data, Error> {
        let dest: Task<Data, Error> = Task {

            guard let imageRequest = self.requestFactory.generateGetImage(imageURL: imageURL) else {
                throw APIServiceError.wrongRequest
            }


            guard self.internetChecker.isConnected == true else {

                if let cachedResponse = self.urlSession.configuration.urlCache?.cachedResponse(for: imageRequest) {
                    return cachedResponse.data
                } else {
                    throw APIServiceError.noInternet
                }
            }


            do {
                return try await self.urlSession.data(for: imageRequest).0
            } catch {
                throw APIServiceError.apiError(error: error)
            }


        }
        return dest
    }

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

protocol APIServiceInterface {
    func getTransactions() -> Task<Data, Error>
    func getImage(imageURL: String) -> Task<Data, Error>
    func getCachedImage(imageURL: String) throws -> Data
}

enum APIServiceError: Error {
    case noInternet
    case wrongRequest
    case wrongResponse
    case forbidden(httpCode: Int)
    case apiError(error: Error?)
}
