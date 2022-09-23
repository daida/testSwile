//
//  AlertModel.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 23/09/2022.
//

import Foundation

// MARK: - AlertModel

/// Describe what to display in an AlertView
struct AlertModel {

    // MARK: Public properties

    /// Alert title
    let title: String

    /// Alert message
    let subTitle: String

    /// Button action describe Buttons title and actions closures
    let buttonActions: [ButtonAction]

    /// AlertModel init
    /// - Parameters:
    ///   - title: AlertView title
    ///   - subTitle: AlertView message
    ///   - buttonActions  Buttons actions describe buttons title and actions closures
    init(title: String, subTitle: String, buttonActions: [ButtonAction]) {
        self.title = title
        self.subTitle = subTitle
        self.buttonActions = buttonActions
    }

    /// AlertModel init
    /// - Parameters:
    ///   - title: AlertView title
    ///   - subTitle: AlertView message
    ///   - okAction: Buttons title and closure action (one button will be display in the AlertView)
    init(title: String, subTitle: String, okAction: ButtonAction) {
        self.title = title
        self.subTitle = subTitle
        self.buttonActions = [okAction]
    }
}

// MARK: - ButtonAction

extension AlertModel {

    /// Describe Button action
    struct ButtonAction {

        /// Button title
        let name: String

        /// Describe if the button should be displayed as a cancel button
        let isCancel: Bool

        /// Action to execute when the button is tapped
        let action: (() -> Void)?

        /// ButtonAction Init
        /// - Parameters:
        ///   - name: Button title
        ///   - isCancel: Describe if the button should be displayed as a cancel button
        ///   - action: Action to execute when the button is tapped
        init(name: String, isCancel: Bool = false, action: (() -> Void)? = nil) {
            self.name = name
            self.isCancel = isCancel
            self.action = action
        }
    }
}
