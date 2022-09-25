//
//  TransactionManager.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation
import UIKit

class TransactionManager: TransactionManagerInterface {

    private let apiService: APIServiceInterface

    private let jsonDecoder: JSONDecoder

    private var previousGetTransactionTask: Task<Data, Error>?

    private var imageTask = [String: Task<Data, Error>]()

    init(apiService: APIServiceInterface, jsonDecoder: JSONDecoder? = nil) {
        self.apiService = apiService

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

    func getImage(imageURL: String) async throws -> UIImage {

        self.imageTask[imageURL]?.cancel()
        let task = self.apiService.getImage(imageURL: imageURL)
        self.imageTask[imageURL] = task
        let ret = await task.result
        self.imageTask.removeValue(forKey: imageURL)
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

    func getTransactions() async throws -> [TransactionModel] {

        self.previousGetTransactionTask?.cancel()
        let task = self.apiService.getTransactions()
        self.previousGetTransactionTask = task

        let result = await task.result

        switch result {
        case .success(let data):
            do {
        		let responseModel = try self.jsonDecoder.decode(TransactionResponseModel.self, from: data)
                return responseModel.transactions
            } catch {
                throw TransactionManagerError.serialisationError(error: error)
            }

        case .failure(let error):
            if let apiError = error as? APIServiceError {
                throw TransactionManagerError.apiServiceError(error: apiError)
            } else {
                throw TransactionManagerError.unknowError(error: error)
            }
        }

    }

}

protocol TransactionManagerInterface {
    func getTransactions() async throws -> [TransactionModel]
    func getImage(imageURL: String) async throws -> UIImage
    func getCachedImage(imageURL: String) throws -> UIImage?
}


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
                return "There is no internet"
            case .apiError, .wrongRequest, .wrongResponse:
                return "Server error"
            case .forbidden:
                return "Access forbidden"

            }
        default:
            return "Unknow error"
        }
    }

}
