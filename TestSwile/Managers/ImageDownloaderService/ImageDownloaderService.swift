//
//  ImageDownloaderService.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 27/09/2022.
//

import Foundation
import UIKit

// MARK: - ImageDownloaderService

/// Retrive image from REST API or from URLSession cache
class ImageDownloaderService: ImageDownloaderServiceInterface {

    // MARK: Private properties

    /// URLSession used to retrive image, can be injected
    private let urlSession: URLSession

    /// Genetate image request
    private let requestFactory: RequestFactoryImageInterface

    /// Check if internet is reachable
	private let internetChecker: InternetCheckerInterface

    /// Cache metrics constants
    private struct Constant {
        static let cachedSizeMemory: Int = 30*1024*1024; // 30 MB
        static let cachedSizeDisk: Int = 50*1024*1024; // 50 MB
    }

    // MARK: Init

    /// ImageDownloaderService init
    /// - Parameters:
    ///   - requestFactory: Genetate image request
    ///   - internetChecker: Check if internet is reachable
    ///   - urlSession: URLSession used to retrive image, can be injected
    init(requestFactory: RequestFactoryImageInterface,
         internetChecker: InternetCheckerInterface,
         urlSession: URLSession? = nil)  {
        self.requestFactory = requestFactory
        self.internetChecker = internetChecker
        if let urlSession = urlSession {
            self.urlSession = urlSession
        } else {
            let conf = URLSessionConfiguration.default
            let cache = URLCache(memoryCapacity: Constant.cachedSizeMemory,
                                 diskCapacity: Constant.cachedSizeDisk,
                                 diskPath: nil)

            // UseFull for REST API call so we are sure we get server response and not some previous response cached
            conf.requestCachePolicy = .useProtocolCachePolicy
            conf.urlCache = cache
            self.urlSession = URLSession(configuration: conf)
        }
    }

    // MARK: Public methods

    /// Get Image by using Swift Concurrency  urlSession method
    /// - Parameter imageURL: image URL to retive
    /// - Returns: UIImage, if the image can't be reach an error is throw
    func getImage(imageURL: String) async throws -> UIImage {

        guard let imageRequest = self.requestFactory.generateGetImage(imageURL: imageURL) else {
            throw ImageDownloaderServiceError.wrongRequest
        }

        guard self.internetChecker.isConnected == true else {
            if let cachedResponse = self.urlSession.configuration.urlCache?.cachedResponse(for: imageRequest) {
                if let image = UIImage(data: cachedResponse.data) {
                    return image
                }
            }
            throw ImageDownloaderServiceError.noInternet
        }

        do {
            let data = try await self.urlSession.data(for: imageRequest).0
            guard let image = UIImage(data: data) else {
                throw ImageDownloaderServiceError.wrongImageFormat
            }
            return image
        } catch {
            throw ImageDownloaderServiceError.apiError(error)
        }
    }

    /// Get Image from URLSession cache
    /// - Parameter imageURL: image URL to retrive
    /// - Returns: cached image
    func getCachedImage(imageURL: String) throws -> UIImage {
        guard let imageRequest = self.requestFactory.generateGetImage(imageURL: imageURL) else {
            throw ImageDownloaderServiceError.wrongRequest
        }
         if let cachedResponse = self.urlSession.configuration.urlCache?.cachedResponse(for: imageRequest) {
             guard let image = UIImage(data: cachedResponse.data) else {
                 throw ImageDownloaderServiceError.wrongImageFormat
             }
             return image
         } else {
             throw ImageDownloaderServiceError.noImageInCache
         }
    }

}

// MARK: - ImageDownloaderServiceInterface

protocol ImageDownloaderServiceInterface {
    func getImage(imageURL: String) async throws -> UIImage
    func getCachedImage(imageURL: String) throws -> UIImage
}

// MARK: - ImageDownloaderServiceError

enum ImageDownloaderServiceError: Error {
    case noImageInCache
    case wrongImageFormat
    case wrongRequest
    case noInternet
    case apiError(Error)

}
