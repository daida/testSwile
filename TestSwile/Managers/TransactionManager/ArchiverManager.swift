//
//  ArchiverManager.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 25/09/2022.
//

import Foundation

class ArchiverManager {

    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder

    private let archivePath: URL? = {
            try? FileManager.default.url(for: .documentDirectory,
                                         in: .userDomainMask,
                                         appropriateFor: nil,
                                         create: true).appendingPathComponent("transactions")
        }()

    private var archivefilePath: URL? {
           guard let folderPath = archivePath else { return nil }
           return folderPath.appendingPathComponent("transactions.json")
       }

    private func createDirecoryIfNoPresent() {

            guard let archivePath = self.archivePath else { return }

            if FileManager.default.fileExists(atPath: archivePath.path, isDirectory: nil) == false {
                try? FileManager.default.createDirectory(at: archivePath, withIntermediateDirectories: true)
            }
        }

    init(jsonEconder: JSONEncoder?, jsonDecoder: JSONDecoder?) {
        if let jsonEconder = jsonEconder {
            self.jsonEncoder = jsonEconder
        } else {
            self.jsonEncoder = JSONEncoder()
        }

        if let jsonDecoder = jsonDecoder {
            self.jsonDecoder = jsonDecoder
        } else {
            self.jsonDecoder = JSONDecoder()
        }

        self.createDirecoryIfNoPresent()
    }


    func archiveTransaction(transactions: [TransactionModel]) async throws {

        Task {
            guard let url = self.archivefilePath else  {
                throw ArchiverManagerError.archiverError(nil)
            }
            do {
                let data = try self.jsonEncoder.encode(transactions)
                try data.write(to: url)
            } catch {
                throw ArchiverManagerError.archiverError(error)
            }

        }
    }

    func retriveTransaction() async throws -> [TransactionModel] {
        try await Task {
            guard let url = self.archivefilePath else {
                throw ArchiverManagerError.unarchiveError(nil)
            }
            do {
                let data = try Data(contentsOf: url)
                let tansaction = try self.jsonDecoder.decode([TransactionModel].self, from: data)
                return tansaction
            }
        }.value
    }

}

enum ArchiverManagerError: Error {
    case archiverError(Error?)
    case unarchiveError(Error?)
}


protocol ArchiverManagerInterface {
    func archiveTransaction(transaction: [TransactionModel]) async
    func retriveTransaction() async -> [TransactionModel]
}
