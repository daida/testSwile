//
//  TransactionImageViewModel.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 23/09/2022.
//

import Foundation
import UIKit
import Combine

// MARK: TransactionImageViewModel

/// TransactionImage ViewModel
class TransactionImageViewModel: TransactionImageViewModelInterface {

    // MARK: Private properties

    /// Transaction model to display
    private let transaction: TransactionModel

    /// Transaction Manager
    private let imageDownloader: ImageDownloaderServiceInterface

    // MARK: Public properties

    /// Category image to display in the accessory view
    let acessoryPicto: UIImage?

    /// Describe if the loader should be display
    let shouldDisplaySpinner = CurrentValueSubject<Bool, Never>(false)

    // Category image to display
    let picto: UIImage?

    /// Observable image to display (the image will be automaticaly dowloaded)
    let remoteImage = CurrentValueSubject<UIImage?, Never>(nil)

    /// Observable accessory image to display in the accessory view (the image will be automaticaly dowloaded)
    let accessoryRemoteImage = CurrentValueSubject<UIImage?, Never>(nil)

    /// Border color according to the model category
    let borderColor: UIColor

    // BackgroundColor according to the model category
    let backgroundColor: UIColor

    /// For some transaction type (donation and  payment, the background color is white
    /// it don't look good in big mode (detail page) so for those
    /// categories the background color is changed in big mode (detail)
    /// These property refer to this color (for other categories, this color = backgrounColor)
    let bigBackgroundColor: UIColor

    // MARK: Init

    /// TransactionImageViewModel init
    /// - Parameters:
    ///   - transaction: Transaction model to display
    ///   - manager: Transaction Manager
    init(transaction: TransactionModel, imageDownloader: ImageDownloaderServiceInterface) {

        self.imageDownloader = imageDownloader

        switch transaction.type {
        case "donation":
            self.borderColor =  SWKit.Colors.donationBorderColor
            self.backgroundColor = SWKit.Colors.donationColor
            self.bigBackgroundColor = SWKit.Colors.alternativeBackgroundColor
        case "meal_voucher":
            self.borderColor = SWKit.Colors.mealVocherBorderColor
            self.backgroundColor = SWKit.Colors.mealVocherColor
            self.bigBackgroundColor = SWKit.Colors.mealVocherColor
        case "gift":
            self.borderColor = SWKit.Colors.giftBorderColor
            self.backgroundColor = SWKit.Colors.giftColor
            self.bigBackgroundColor = SWKit.Colors.giftColor
        case "mobility":
            self.borderColor = SWKit.Colors.mobilityBorderColor
            self.backgroundColor = SWKit.Colors.mobilityColor
            self.bigBackgroundColor = SWKit.Colors.mobilityColor
        case "payment":
            self.borderColor = SWKit.Colors.paymentBorderColor
            self.backgroundColor = SWKit.Colors.paymentColor
            self.bigBackgroundColor = SWKit.Colors.alternativeBackgroundColor
        default:
            self.borderColor = SWKit.Colors.mealVocherBorderColor
            self.backgroundColor = SWKit.Colors.mealVocherColor
            self.bigBackgroundColor = SWKit.Colors.mealVocherColor
        }

        let acessPictoType = SWKit.CategoriesIcons(rawValue: transaction.smallIcon.category)
        let picto = SWKit.CategoriesIcons(rawValue: transaction.largeIcon.category)

        self.acessoryPicto = acessPictoType?.image
        self.picto = picto?.image
        self.transaction = transaction

        if let remoteImageURL = transaction.largeIcon.url,
           let image = try? self.imageDownloader.getCachedImage(imageURL: remoteImageURL) {
            self.remoteImage.value = image
        }

        if let accessoryURL = transaction.smallIcon.url,
           let image = try? self.imageDownloader.getCachedImage(imageURL: accessoryURL) {
            self.accessoryRemoteImage.value = image
        }

        Task {

            if let url = transaction.largeIcon.url, self.remoteImage.value == nil {
                self.shouldDisplaySpinner.value = true
                self.remoteImage.value = try? await self.imageDownloader.getImage(imageURL: url)
                self.shouldDisplaySpinner.value = false
            }

            if let smallIcon = transaction.smallIcon.url {
                self.accessoryRemoteImage.value = try? await self.imageDownloader.getImage(imageURL: smallIcon)
            }
        }

    }

}

// MARK: TransactionImageViewModelInterface

protocol TransactionImageViewModelInterface {

    var acessoryPicto: UIImage? { get }
    var picto: UIImage? { get }
    var borderColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var bigBackgroundColor: UIColor { get }

    var remoteImage: CurrentValueSubject<UIImage?, Never> { get }
    var accessoryRemoteImage: CurrentValueSubject<UIImage?, Never> { get }

    var shouldDisplaySpinner: CurrentValueSubject<Bool, Never> { get }
}
