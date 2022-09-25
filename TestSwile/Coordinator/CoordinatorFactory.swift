//
//  CoordinatorFactory.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation
import UIKit

class CoordinatorFactory {

    func generateTransactionCoordinator(navigationController: UINavigationController? = nil,
                                    transactionManager: TransactionManagerInterface? = nil,
                                    viewControllerFactory: ViewControllerFactoryInterface? = nil) -> Coordinator {

        let manager = transactionManager ?? TransactionManager(apiService:
                                                        APIService(requestFactory: RequestFactory(),
                                                                   internetChecker: InternetChecker()), archiverManager: ArchiverManager())

        let factory = viewControllerFactory ?? ViewControllerFactory()

        if let naviagtionController = navigationController {
            return TransactionCoordinator(navigationController: naviagtionController,
                                      financeManager: manager,
                                      viewControllerFactory: factory)
        } else {
            return TransactionCoordinator(financeManager: manager, viewControllerFactory: factory)
        }
    }
}
