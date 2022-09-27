//
//  AccessoryImageView.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 26/09/2022.
//

import Foundation
import UIKit
import Combine
import SnapKit

// MARK: - AccessoryImageView

/// Display the image in the right corner of the TransactionImageView
class AccessoryImageView: UIView, AccessoryTransactionImageViewAnimatorInterface {

    // MARK: Private Properties

    /// ImageView display the remote image
    private let remoteImageView: UIImageView = {
        let dest = UIImageView()
        dest.contentMode = .scaleAspectFit
        dest.layer.cornerRadius = 8
        dest.clipsToBounds = true
        dest.translatesAutoresizingMaskIntoConstraints = false
        return dest
    }()

    /// Display the category image
    private let imageView: UIImageView = {
        let dest = UIImageView()
        dest.contentMode = .scaleAspectFit
        dest.clipsToBounds = true
        dest.backgroundColor = SWKit.Colors.backgroundColor
        return dest
    }()

    // Constraints references will be used during transition

    private var widthConstraint: Constraint?
    private var heightContraint: Constraint?

    private var imageConstraintWidth: Constraint?
    private var imageConstraintHeight: Constraint?

    private var remoteConstraintWidth: Constraint?
    private var remoteConstraintHeight: Constraint?

    // MARK: Private methods

    /// Setup view hierarchy and layout
    private func setup() {

        self.backgroundColor = SWKit.Colors.backgroundColor

        self.addSubview(self.imageView)
        self.addSubview(self.remoteImageView)

        self.remoteImageView.snp.makeConstraints { make in
            make.center.equalTo(self.snp.center)
            self.remoteConstraintWidth = make.width.equalTo(16).constraint
            self.remoteConstraintHeight = make.height.equalTo(16).constraint
        }

        self.imageView.snp.makeConstraints { make in
            make.center.equalTo(self.snp.center)
            self.imageConstraintWidth = make.width.equalTo(12).constraint
            self.imageConstraintHeight = make.height.equalTo(12).constraint
        }

        self.snp.makeConstraints { make in
            self.widthConstraint = make.width.equalTo(23).constraint
            self.heightContraint = make.height.equalTo(23).constraint
        }

        self.layer.cornerRadius = 11.5
        self.clipsToBounds = true

    }

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public methods

    /// Setup category image
    /// - Parameter image: image to display
    func setImage(_ image: UIImage?) {
        self.remoteImageView.isHidden = true
        self.remoteImageView.image = nil
        self.imageView.image = image
    }

    /// Set remote image (downloaded image)
    /// - Parameter image: image to display
    func setRemoteImage(_ image: UIImage?) {
        guard image != nil else { return }
        self.remoteImageView.image = image
        self.remoteImageView.isHidden = false
        self.imageView.image = nil
    }

    /// Disable size constraints (used in transition)
    func disableSizeConstraint() {
        self.widthConstraint?.deactivate()
        self.heightContraint?.deactivate()
    }

    /// Enable big mode (used in transition)
    func enableBigMode() {
        self.widthConstraint?.update(offset: 32)
        self.heightContraint?.update(offset: 32)

        self.imageConstraintWidth?.update(offset: 18)
        self.imageConstraintHeight?.update(offset: 18)

        self.remoteConstraintWidth?.update(offset: 18)
        self.remoteConstraintHeight?.update(offset: 18)

        self.remoteImageView.layer.cornerRadius = 9
        self.layer.cornerRadius = 16
    }

    /// Enable small mode (used in transition)
    func enableSmallMode() {
        self.widthConstraint?.update(offset: 23)
        self.heightContraint?.update(offset: 23)

        self.imageConstraintWidth?.update(offset: 12)
        self.imageConstraintHeight?.update(offset: 12)

        self.remoteConstraintWidth?.update(offset: 16)
        self.remoteConstraintHeight?.update(offset: 16)

        self.remoteImageView.layer.cornerRadius = 8
        self.layer.cornerRadius = 11.5
    }

}
