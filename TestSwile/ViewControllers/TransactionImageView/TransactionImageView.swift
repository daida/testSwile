//
//  TransactionImageView.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 23/09/2022.
//

import Foundation
import UIKit
import Combine
import SnapKit

/// Image view used in cell and Detail view
/// Also used in the transition
class TransactionImageView: UIView {

    // MARK: Private properties

    /// Transaction ImageViewModel
    /// this is a var property because this view is used in UITableViewCell
    private var viewModel: TransactionImageViewModelInterface? = nil

    /// Combine observable property subscription are canceled when the viewModel change
    private var cancelable = Set<AnyCancellable>()

    /// Background with a corner radius
    private let circleBackgroundView: UIView = {
        let dest = UIView()
        dest.layer.cornerRadius = 23
        dest.translatesAutoresizingMaskIntoConstraints = false
        dest.layer.borderWidth = 2
        dest.clipsToBounds = true
        return dest
    }()

    /// ImageView display the picto image
    private let imageView: UIImageView = {
        let dest = UIImageView(frame: .zero)
        dest.contentMode = .scaleAspectFit
        dest.translatesAutoresizingMaskIntoConstraints = false
        return dest
    }()

    /// Image view display the remote imageView
    private let remoteImageView: UIImageView = {
        let dest = UIImageView(frame: .zero)
        dest.contentMode = .scaleAspectFit
        dest.backgroundColor = UIColor.clear
        dest.translatesAutoresizingMaskIntoConstraints = false
        return dest
    }()

    /// Back button (used in the transition animation)
    private let backButton = SWKit.Button.SWBackButton()

    /// Full view background (used in transition animation)
    private let bigBackground = UIView()

    // Constraint Reference used in animation transition

    private var accessoryTrailingConstraint: Constraint?
    private var accessoryBottomConstraint: Constraint?
    private var imageViewWidth: Constraint?
    private var imageViewHeight: Constraint?
    private var imageViewCenter: Constraint?

    // MARK: Public properties

    /// Display the accesory view (right small icon )
    let accessoryView: AccessoryImageView = {
        let dest = AccessoryImageView()
        return dest
    }()

    // MARK: Public method

    /// Setup a full size backgroundView with the alpha to 0 (used for the transition animation)
    func activateBackgroundAlpha() {
        self.bigBackground.backgroundColor = self.viewModel?.backgroundColor
        self.bigBackground.alpha = 0
    }

    /// Display only the image (remote or picto) used for the transition animation
    func halfReveal() {
        self.isHidden = false
        self.circleBackgroundView.backgroundColor = UIColor.clear
        self.circleBackgroundView.layer.borderColor = UIColor.clear.cgColor
        self.accessoryView.isHidden = true
    }

    /// Reset the image to the original state (usefull when the animation is done)
    func revealImage() {
        self.isHidden = false
        self.circleBackgroundView.backgroundColor = self.viewModel?.backgroundColor
        self.circleBackgroundView.layer.borderColor = self.viewModel?.borderColor.cgColor
        self.accessoryView.isHidden = false
    }

    /// Hide the image content (usefull during the detail to list transition)
    func hideContentImage() {
        self.remoteImageView.alpha = 0
        self.imageView.alpha = 0
    }

    /// Reset the view to the original state (used in detail to list transition)
    func disableBigMode() {
        self.backButton.alpha = 0
        self.bigBackground.alpha = 0
        self.circleBackgroundView.layer.cornerRadius = 23
        self.circleBackgroundView.layer.borderWidth = 2

        self.accessoryView.snp.makeConstraints { make in
            self.accessoryTrailingConstraint?.update(offset: 5)
            self.accessoryBottomConstraint?.update(offset: 5)
        }

        self.imageView.snp.removeConstraints()

        self.imageView.snp.makeConstraints { make in
            self.imageViewCenter = make.center.equalTo(self.circleBackgroundView).constraint
            self.imageViewWidth = make.width.equalTo(28).constraint
            self.imageViewHeight = make.height.equalTo(28).constraint
        }


        self.remoteImageView.snp.removeConstraints()

        self.remoteImageView.snp.makeConstraints { make in
            make.center.equalTo(self.circleBackgroundView)
            make.width.equalTo(56)
            make.height.equalTo(56)
        }

        self.accessoryView.enableSmallMode()
    }

    /// Generate an accessoryView equal to the view one
    /// - Returns: an AccessoryView configured like the one in the view
    func generateAccesoryView() -> AccessoryImageView {
		let dest = AccessoryImageView()

        if self.viewModel?.acessoryPicto != nil {
            dest.setImage(self.viewModel?.acessoryPicto)
        }

        if self.viewModel?.accessoryRemoteImage.value != nil {
            dest.setRemoteImage(self.viewModel?.accessoryRemoteImage.value)
        }

        return dest
    }

    /// Enable big mode for the image (like is displayed in the detail view)
    func enableBigMode() {
        self.bigBackground.alpha = 1
        self.circleBackgroundView.layer.cornerRadius = 120
        self.circleBackgroundView.layer.borderWidth = 0
        self.accessoryTrailingConstraint?.update(offset: -30)
        self.accessoryBottomConstraint?.update(offset: 16)

        self.accessoryView.enableBigMode()

        self.imageViewWidth?.update(offset: 57)
        self.imageViewHeight?.update(offset: 57)

        self.imageViewCenter?.deactivate()

        self.imageView.snp.makeConstraints { make in
            make.bottom.equalTo(self.circleBackgroundView).offset(-62)
            make.centerX.equalTo(self.circleBackgroundView.snp.centerX)
        }

        self.remoteImageView.snp.removeConstraints()
        
        self.remoteImageView.snp.makeConstraints { make in
            make.center.equalTo(self.imageView)
            make.width.equalTo(self.imageView)
            make.height.equalTo(self.imageView)
        }
    }

    /// Display the back button used in the list to detail transition
    func revealBackButton() {
        self.backButton.alpha = 1.0
    }

    /// Configure the view with the corresponding viewModel
    /// - Parameter viewModel: imageViewModel
    func configure(viewModel: TransactionImageViewModelInterface) {

        self.remoteImageView.image = nil

        self.cancelable.removeAll()

        self.viewModel = viewModel
        self.imageView.image = viewModel.picto
        self.accessoryView.setImage(viewModel.acessoryPicto)


        self.circleBackgroundView.backgroundColor = viewModel.backgroundColor
        self.circleBackgroundView.layer.borderColor = viewModel.borderColor.cgColor

        self.remoteImageView.image = viewModel.remoteImage.value

        viewModel.remoteImage.receive(on: DispatchQueue.main).sink { [weak self] image in
            guard let self = self else { return }
            if let image = image {
                self.imageView.image = nil
                self.remoteImageView.image = image
            }
        }.store(in: &self.cancelable)

        if viewModel.accessoryRemoteImage.value != nil {
            self.accessoryView.setRemoteImage(viewModel.accessoryRemoteImage.value)
        }

        viewModel.accessoryRemoteImage.receive(on: DispatchQueue.main).sink { [weak self] image in
            guard let self = self else { return }
            self.accessoryView.setRemoteImage(image)
        }.store(in: &self.cancelable)
    }


    // MARK: Private methods

    /// Setup view layout
    private func setupLayout() {

        self.bigBackground.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
        }

        self.circleBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
        }

        self.imageView.snp.makeConstraints { make in
            self.imageViewCenter = make.center.equalTo(self.circleBackgroundView).constraint
            self.imageViewWidth = make.width.equalTo(28).constraint
            self.imageViewHeight = make.height.equalTo(28).constraint
        }

        self.remoteImageView.snp.makeConstraints { make in
            make.center.equalTo(self.circleBackgroundView)
            make.width.equalTo(56)
            make.height.equalTo(56)
        }

        self.accessoryView.snp.makeConstraints { make in
            self.accessoryTrailingConstraint = make.trailing.equalTo(self.snp.trailing).offset(5).constraint
            self.accessoryBottomConstraint = make.bottom.equalTo(self.snp.bottom).constraint.update(offset: 5)
        }

        self.backButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(30)
            make.leading.equalTo(self).offset(20)
        }
    }

    /// Setup view hierarchy
    private func setupView() {
        self.addSubview(self.bigBackground)
        self.bigBackground.alpha = 0
        self.addSubview(self.circleBackgroundView)
        self.circleBackgroundView.addSubview(self.imageView)
        self.circleBackgroundView.addSubview(self.remoteImageView)
        self.addSubview(self.accessoryView)
        self.addSubview(self.backButton)
        self.backButton.alpha = 0
    }

    /// Setup view and hierarchy
    private func setup() {
        self.setupView()
        self.setupLayout()
    }

    // MARK: Init

    /// TransactionImageView init
    init() {
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
