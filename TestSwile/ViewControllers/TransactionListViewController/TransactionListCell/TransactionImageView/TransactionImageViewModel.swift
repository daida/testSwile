//
//  TransactionImageViewModel.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 23/09/2022.
//

import Foundation
import UIKit
import Combine

class TransactionImageViewModel: TransactionImageViewModelInterface {

    private let transaction: TransactionModel
    private let transactionManager: TransactionManagerInterface

    let acessoryPicto: UIImage?
    let picto: UIImage?

    let remoteImage = CurrentValueSubject<UIImage?, Never>(nil)
    let accessoryRemoteImage = CurrentValueSubject<UIImage?, Never>(nil)

    let borderColor: UIColor
    let backgroundColor: UIColor

    init(transaction: TransactionModel, manager: TransactionManagerInterface) {

        self.transactionManager = manager

        switch transaction.type {
        case "donation":
            self.borderColor = SWKit.Colors.donationBorderColor
            self.backgroundColor = SWKit.Colors.donationColor
        case "meal_voucher":
            self.borderColor = SWKit.Colors.mealVocherBorderColor
            self.backgroundColor = SWKit.Colors.mealVocherColor
        case "gift":
            self.borderColor = SWKit.Colors.giftBorderColor
            self.backgroundColor = SWKit.Colors.giftColor
        case "mobility":
            self.borderColor = SWKit.Colors.mobilityBorderColor
            self.backgroundColor = SWKit.Colors.mobilityColor
        case "payment":
            self.borderColor = SWKit.Colors.paymentBorderColor
            self.backgroundColor = SWKit.Colors.paymentColor
        default:
            self.borderColor = SWKit.Colors.mealVocherBorderColor
            self.backgroundColor = SWKit.Colors.mealVocherColor
        }

        self.acessoryPicto = UIImage(named: transaction.smallIcon.category)
        self.picto = UIImage(named: transaction.largeIcon.category)
        self.transaction = transaction

        Task {
            if let url = transaction.largeIcon.url {
                self.remoteImage.value = try? await self.transactionManager.getImage(imageURL: url)
            }

            if let smallIcon = transaction.smallIcon.url {
                self.accessoryRemoteImage.value = try? await self.transactionManager.getImage(imageURL: smallIcon)
            }
        }

    }

}

protocol TransactionImageViewModelInterface {

    var acessoryPicto: UIImage? { get }
    var picto: UIImage? { get }
    var borderColor: UIColor { get }
    var backgroundColor: UIColor { get }


    var remoteImage: CurrentValueSubject<UIImage?, Never> { get }
    var accessoryRemoteImage: CurrentValueSubject<UIImage?, Never> { get }
}
