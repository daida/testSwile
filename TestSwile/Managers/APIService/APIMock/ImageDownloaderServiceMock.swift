//
//  ImageDownloaderServiceMock.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 27/09/2022.
//

import Foundation
import UIKit

class ImageDownloaderServiceMock: ImageDownloaderServiceInterface {

    private let error: Bool

    init(error: Bool = false) {
        self.error = error
    }
    func getImage(imageURL: String) async throws -> UIImage {

        if self.error == true {
            throw ImageDownloaderServiceError.noInternet
        }

        guard let image = UIImage(named: "mockPicture") else {
            throw APIServiceError.wrongResponse
        }
        return image
    }

    func getCachedImage(imageURL: String) throws -> UIImage {
        if self.error == true {
            throw ImageDownloaderServiceError.noInternet
        }

        guard let image = UIImage(named: "mockPicture") else {
            throw APIServiceError.wrongResponse
        }
        return image
    }

}
