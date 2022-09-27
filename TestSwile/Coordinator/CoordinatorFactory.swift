//
//  CoordinatorFactory.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation
import UIKit

// MARK: - CoordinatorFactory

class CoordinatorFactory {

    // MARK: Public methods

    func generateTransactionCoordinator(navigationController: UINavigationController? = nil,
                                        transactionManager: TransactionManagerInterface? = nil,
                                        imageDownloader: ImageDownloaderServiceInterface? = nil,
                                        viewControllerFactory: ViewControllerFactoryInterface? = nil) -> Coordinator {

            let manager: TransactionManagerInterface

            if let transactionManager = transactionManager {
                manager = transactionManager
            } else {
                let api = APIService(requestFactory: RequestFactory(),
                                     internetChecker: InternetChecker())
                manager = TransactionManager(apiService: api, archiverManager: ArchiverManager())
            }

            let imageDownloader = imageDownloader ??
            ImageDownloaderService(requestFactory: RequestFactory(),
                                   internetChecker: InternetChecker())

            let factory = viewControllerFactory ?? ViewControllerFactory()

            if let navigationController = navigationController {
                return TransactionCoordinator(navigationController: navigationController,
                                              transactionManager: manager,
                                              imageDownloader: imageDownloader,
                                              viewControllerFactory: factory)
            } else {
                return TransactionCoordinator(transactionManager: manager,
                                              imageDownloader: imageDownloader,
                                              viewControllerFactory: factory)
            }

        }
}
