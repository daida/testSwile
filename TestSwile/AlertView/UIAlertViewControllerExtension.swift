//
//  UIAlertViewControllerExtension.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 23/09/2022.
//

import Foundation
import UIKit

extension UIAlertController {

    /// Convenience UIAlertController, allow UIAlertViewController to be instantiate with an AlertModel
    /// - Parameter alertModel: model represent, title, message and action (button title and action closure)
    convenience init(alertModel: AlertModel) {

        self.init(title: alertModel.title,
                                      message: alertModel.subTitle,
                                      preferredStyle: .alert)

        alertModel.buttonActions.forEach { modelButton in

            let action = UIAlertAction(title: modelButton.name,
                                       style: modelButton.isCancel == true ? .cancel : .default) { [weak self] _ in
                guard let `self` = self else { return }
                self.dismiss(animated: true) {
                    modelButton.action?()
                }
            }
            self.addAction(action)
        }
    }
}
