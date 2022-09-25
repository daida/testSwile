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

        let acessPictoType = SWKit.CategoriesIcons(rawValue: transaction.smallIcon.category)
        let picto = SWKit.CategoriesIcons(rawValue: transaction.largeIcon.category)

        self.acessoryPicto = acessPictoType?.image
        self.picto = picto?.image
        self.transaction = transaction

        if let remoteImageURL = transaction.largeIcon.url,
           let image = try? self.transactionManager.getCachedImage(imageURL: remoteImageURL) {
            self.remoteImage.value = image
        }

        if let accessoryURL = transaction.smallIcon.url,
           let image = try? self.transactionManager.getCachedImage(imageURL: accessoryURL) {
            self.accessoryRemoteImage.value = image
        }

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
