//
//  TestModelArchiver.swift
//  TestSwileTests
//
//  Created by Nicolas Bellon on 25/09/2022.
//

import Foundation
import XCTest
@testable import TestSwile

final class TestModelArchiver: XCTestCase {


    func testArchiveObject() async {

        let api = APIMockManager()
        do {
            let transaction = try await TransactionManager(apiService: api).getTransactions()
            let archiver = ArchiverManager()
            try await archiver.archiveTransaction(transactions: transaction)
        } catch {
            fatalError()
        }
    }

    func testRetriveArchiveObject() async {
        let api = APIMockManager()
        do {
            let transaction = try await TransactionManager(apiService: api).getTransactions()
            let archiver = ArchiverManager()
            try await archiver.archiveTransaction(transactions: transaction)
            let archivedTransac = try await archiver.retriveTransaction()
            XCTAssertEqual(archivedTransac.isEmpty, false)
            XCTAssertEqual(archivedTransac.count, 8)
        } catch {
            fatalError()
        }
    }

}
