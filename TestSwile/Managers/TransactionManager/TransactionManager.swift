//
//  TransactionManager.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation
import UIKit

// MARK: - TransactionManager

/// Handle Transaction fetching parsing and storing also used to retrieve transaction image.
class TransactionManager: TransactionManagerInterface {

    // MARK: Private properties

    /// API Service object will be use to communicate with the REST API
    private let apiService: APIServiceInterface

    /// JSON decoder object will be use to deserialize models
    private let jsonDecoder: JSONDecoder

    /// Last get transaction request, will be used to cancel the previous pending getTransaction request
    private var previousGetTransactionTask: Task<Data, Error>?

    /// Archiver manager will be used to persist and retrive models
    /// This manager is optional, the Transaction Manager can work without the archiver
    private let archiverManager: ArchiverManagerInterface?

    // MARK: Init

    /// TransactionManager Init
    /// - Parameters:
    ///   - apiService: API service will be used to communicate with the REST API
    ///   - jsonDecoder: JSON decoder will be used to deserialize model (JSON data to Model)
    ///   - archiverManager: Archiver manager will be used to persist and retrive models
    init(apiService: APIServiceInterface,
         jsonDecoder: JSONDecoder? = nil,
         archiverManager: ArchiverManagerInterface? = nil) {

        self.apiService = apiService
        self.archiverManager = archiverManager

        if let jsonDecoder = jsonDecoder {
            self.jsonDecoder = jsonDecoder
        } else {
            self.jsonDecoder = JSONDecoder()
            self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            self.jsonDecoder.dateDecodingStrategy = .custom { decoder in
                let container = try decoder.singleValueContainer()
                let dateStr = try container.decode(String.self)
                let destDate = DateFormatter.isoFormater.date(from: dateStr)

                guard let destDate = destDate else {
                    throw TransactionManagerError.serialisationError(error: nil)
                }

                return destDate
            }
        }

    }

    // MARK: Public methods

    /// Get a image already downloaded from the cache
    /// - Parameter imageURL: image URL
    /// - Returns: a cached image
    func getCachedImage(imageURL: String) throws -> UIImage? {

        do {
            let data = try self.apiService.getCachedImage(imageURL: imageURL)
            guard let image = UIImage(data: data) else { throw TransactionManagerError.wrongImageFormat }
            return image
        } catch {
            if let apiError = error as? APIServiceError {
                throw TransactionManagerError.apiServiceError(error: apiError)
            } else {
                throw TransactionManagerError.unknowError(error: error)
            }
        }

    }

    /// Get Image from a string URL
    /// - Parameter imageURL: image URL to fetch
    /// - Returns: The fetched image or an error is throw
    func getImage(imageURL: String) async throws -> UIImage {
        let ret = await self.apiService.getImage(imageURL: imageURL).result
        switch ret {
        case .success(let data):
            guard let image = UIImage(data: data) else {
                throw TransactionManagerError.wrongImageFormat
            }
        	return image
        case .failure(let error):
            if let apiError = error as? APIServiceError {
                throw TransactionManagerError.apiServiceError(error: apiError)
            } else {
                throw TransactionManagerError.unknowError(error: error)
            }
        }
    }

    /// Get Transactions models
    /// - Returns: Transaction model array (this method will throw an error if the model are not reachable no internet for instance)
    /// If therer is cached result there will be returned, the app alway try to get new result first and then fallback on cache model if an error occured
    func getTransactions() async throws -> [TransactionModel] {

        self.previousGetTransactionTask?.cancel()
        let task = self.apiService.getTransactions()
        self.previousGetTransactionTask = task

        let result = await task.result

        switch result {
        case .success(let data):
            do {
        		let responseModel = try self.jsonDecoder.decode(TransactionResponseModel.self, from: data)
                do {
                    try await self.archiverManager?.archiveTransaction(transactions: responseModel.transactions)
                } catch {
                    // We do nothing here, if the archiver fail
                    // we don't want to warn the user, the app can run without archieving
                }
                return responseModel.transactions
            } catch {
                throw TransactionManagerError.serialisationError(error: error)
            }

        case .failure(let error):

            if let cachedResult = try? await self.archiverManager?.retriveTransaction() {
                return cachedResult
            }

            if let apiError = error as? APIServiceError {
                throw TransactionManagerError.apiServiceError(error: apiError)
            } else {
                throw TransactionManagerError.unknowError(error: error)
            }
        }

    }
}

// MARK: - TransactionManagerInterface

protocol TransactionManagerInterface {
    func getTransactions() async throws -> [TransactionModel]
    func getImage(imageURL: String) async throws -> UIImage
    func getCachedImage(imageURL: String) throws -> UIImage?
}

// MARK: - TransactionManagerError

enum TransactionManagerError: Error {
    
	case apiServiceError(error: APIServiceError)
	case serialisationError(error: Error?)
	case unknowError(error: Error)
    case wrongImageFormat
    case noImageInCache

    var text: String {
        switch self {
        case .apiServiceError(error: let apiError):
            switch apiError {
            case .noInternet:
                return  NSLocalizedString("error.internet", comment: "")
            case .apiError, .wrongRequest, .wrongResponse:
                return NSLocalizedString("error.server", comment: "")
            case .forbidden:
                return NSLocalizedString("error.forbidden", comment: "")

            }
        default:
            return NSLocalizedString("error.unknow", comment: "")
        }
    }

}
