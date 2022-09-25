//
//  APIManager.swift
//  TestSwileTests
//
//  Created by Nicolas Bellon on 25/09/2022.
//

import Foundation
import XCTest
@testable import TestSwile

final class TestAPIService: XCTestCase {

    func testGetTransaction() async {

        let requestFactory = RequestFactory()

        let apiService = APIService(requestFactory: requestFactory, internetChecker: InternetCheckerMock())

        do {
    		_ = try await apiService.getTransactions().value
        } catch {
            if let apiError = error as? APIServiceError {
                switch apiError {
                case .noInternet:
                    break
                default: fatalError()
                }
            } else {
             fatalError()
            }
        }

    }

    func testGetImage() async {

        let requestFactory = RequestFactory()

        let apiService = APIService(requestFactory: requestFactory, internetChecker: InternetCheckerMock())

        do {
            _ = try await apiService.getImage(imageURL: "fhkejhf").value
        } catch {
            if let apiError = error as? APIServiceError {
                switch apiError {
                case .noInternet:
                    break
                default: fatalError()
                }
            } else {
             fatalError()
            }
        }

    }

}
