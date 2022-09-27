//
//  ArchiverManager.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 25/09/2022.
//

import Foundation

// MARK: - ArchiverManager

/// Archvie and retrieve Transaction model from the disk
/// Archive format is JSON
/// Archive and unarchive opperation are done asynchronously
/// by using Swift Concurency
class ArchiverManager: ArchiverManagerInterface {

    // MARK: Private properties

    /// JSON decoder will be user to encode model to JSON format
    private let jsonEncoder: JSONEncoder

    // JSON decoder will be used to decode model from JSON format
    private let jsonDecoder: JSONDecoder

    /// Describe the archive directory
    private let archivePath: URL? = {
            try? FileManager.default.url(for: .documentDirectory,
                                         in: .userDomainMask,
                                         appropriateFor: nil,
                                         create: true).appendingPathComponent("transactions")
        }()

    /// Describe the archive file paths
    private var archivefilePath: URL? {
           guard let folderPath = archivePath else { return nil }
           return folderPath.appendingPathComponent("transactions.json")
       }

    /// Create archive directory if it doesn't exist
    private func createDirecoryIfNoPresent() {

            guard let archivePath = self.archivePath else { return }

            if FileManager.default.fileExists(atPath: archivePath.path,
                                              isDirectory: nil) == false {
                try? FileManager.default.createDirectory(at: archivePath,
                                                         withIntermediateDirectories: true)
            }
        }

    // MARK: Init

    /// Init the archiver with a JSONEncoder to persist models and jsonDecoder to retive models from the disk
    /// - Parameters:
    ///   - jsonEconder: JSON decoder will be user to encode model to JSON format
    ///   - jsonDecoder: JSON decoder will be used to decode model from JSON format
    init(jsonEconder: JSONEncoder? = nil, jsonDecoder: JSONDecoder? = nil) {

        self.jsonEncoder = jsonEconder ?? JSONEncoder()
        self.jsonDecoder = jsonDecoder ?? JSONDecoder()
        self.createDirecoryIfNoPresent()
    }

    // MARK: Private methods

    /// Archive transaction models to the disk
    /// - Parameter transactions: Transaction model array to persist
    func archiveTransaction(transactions: [TransactionModel]) async throws {

        guard let url = self.archivefilePath else {
            throw ArchiverManagerError.archiverError(nil)
        }

        do {
            let data = try self.jsonEncoder.encode(transactions)
            try data.write(to: url)
        } catch {
            throw ArchiverManagerError.archiverError(error)
        }

    }

    /// Retrive transaction from the disk
    /// - Returns: stored transaction  model array
    func retriveTransaction() async throws -> [TransactionModel] {
        guard let url = self.archivefilePath else {

            throw ArchiverManagerError.unarchiveError(nil)
        }
        do {
            let data = try Data(contentsOf: url)
            let tansaction = try self.jsonDecoder.decode([TransactionModel].self, from: data)
            return tansaction
        } catch {
            throw ArchiverManagerError.unarchiveError(error)
        }
    }

}

// MARK: - ArchiverManagerError

enum ArchiverManagerError: Error {
    case archiverError(Error?)
    case unarchiveError(Error?)
}

// MARK: - ArchiverManagerInterface

protocol ArchiverManagerInterface {
    func archiveTransaction(transactions: [TransactionModel]) async throws
    func retriveTransaction() async throws -> [TransactionModel]
}
