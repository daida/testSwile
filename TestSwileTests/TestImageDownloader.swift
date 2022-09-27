//
//  TestImageDownloader.swift
//  TestSwileTests
//
//  Created by Nicolas Bellon on 27/09/2022.
//

import Foundation
import XCTest
import Combine
@testable import TestSwile

final class TestImageDownloader: XCTestCase {

    func testImageDownloader() {
        guard let url = Bundle(for: TestImageDownloader.self).url(forResource: "mockImage", withExtension: "jpg") else { fatalError() }
        let imageDownloader = ImageDownloaderService(requestFactory: RequestFactory(),
                                                     internetChecker:
                                                        InternetCheckerMock(isConnected: true))

        let expect = XCTestExpectation()

        Task {
            do {
                let image = try await imageDownloader.getImage(imageURL: url.absoluteString)
                XCTAssertNotNil(image)
                expect.fulfill()

            } catch {
                fatalError()
            }

        }
        wait(for: [expect], timeout: 20)
    }

}
