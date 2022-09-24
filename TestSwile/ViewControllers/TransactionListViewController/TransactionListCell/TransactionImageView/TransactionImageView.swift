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

class AccessoryImageView: UIView {

    private let remoteImageView: UIImageView = {
        let dest = UIImageView()
        dest.contentMode = .scaleAspectFit
        dest.layer.cornerRadius = 8
        dest.clipsToBounds = true
        dest.translatesAutoresizingMaskIntoConstraints = false
        return dest
    }()

    private let imageView: UIImageView = {
        let dest = UIImageView()
        dest.contentMode = .scaleAspectFit
        dest.clipsToBounds = true
        dest.backgroundColor = UIColor.white
        return dest
    }()

    var widthConstraint: Constraint?
    var heightContraint: Constraint?

    var imageConstraintWidth: Constraint?
    var imageConstraintHeight: Constraint?

    var remoteConstraintWidth: Constraint?
    var remoteConstraintHeight: Constraint?


    func setupBig() {
        self.widthConstraint?.update(offset: 32)
        self.heightContraint?.update(offset: 32)

        self.imageConstraintWidth?.update(offset: 18)
        self.imageConstraintHeight?.update(offset: 18)

        self.remoteConstraintWidth?.update(offset: 18)
        self.remoteConstraintHeight?.update(offset: 18)

        self.remoteImageView.layer.cornerRadius = 9
        self.layer.cornerRadius = 16
    }

    func setup() {

        self.backgroundColor = UIColor.white

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

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setImage(_ image: UIImage?) {
        self.remoteImageView.isHidden = true
        self.remoteImageView.image = nil
        self.imageView.image = image
    }

    func setRemoteImage(_ image: UIImage?) {
        guard image != nil else { return }
        self.remoteImageView.isHidden = false
        self.imageView.image = nil
        self.remoteImageView.image = image
    }

}

class TransactionImageView: UIView {

    private var viewModel: TransactionImageViewModelInterface? = nil

    var cancelable = Set<AnyCancellable>()

    private let accessoryView: AccessoryImageView = {
        let dest = AccessoryImageView()
        return dest
    }()


    func enableBigMode() {

        self.backgroundColor = self.viewModel?.bigBackgroundColor
        self.circleBackgroundView.backgroundColor = self.viewModel?.bigBackgroundColor

        self.circleBackgroundView.layer.cornerRadius = 120
        self.trailingConstraint?.update(offset: -30)
        self.bottomConstraint?.update(offset: 16)
        self.circleBackgroundView.layer.borderWidth = 0
        self.accessoryView.setupBig()

        self.imageWidth?.update(offset: 57)
        self.imageHeight?.update(offset: 57)

        self.imageCenter?.deactivate()

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

    private let circleBackgroundView: UIView = {
        let dest = UIView()
        dest.layer.cornerRadius = 23
        dest.translatesAutoresizingMaskIntoConstraints = false
	    dest.layer.borderWidth = 2
        dest.clipsToBounds = true
        return dest
    }()

    private let imageView: UIImageView = {
        let dest = UIImageView(frame: .zero)
        dest.contentMode = .scaleAspectFit
        dest.translatesAutoresizingMaskIntoConstraints = false
        return dest
    }()

    private let remoteImageView: UIImageView = {
        let dest = UIImageView(frame: .zero)
        dest.contentMode = .scaleAspectFit
        dest.backgroundColor = UIColor.clear
        dest.translatesAutoresizingMaskIntoConstraints = false
        return dest
    }()

    var trailingConstraint: Constraint?
    var bottomConstraint: Constraint?

    var imageWidth: Constraint?
    var imageHeight: Constraint?

    var imageCenter: Constraint?

    private func setupLayout() {

        self.circleBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
        }

        self.imageView.snp.makeConstraints { make in
            self.imageCenter = make.center.equalTo(self.circleBackgroundView).constraint
            self.imageWidth = make.width.equalTo(28).constraint
            self.imageHeight = make.height.equalTo(28).constraint
        }

        self.remoteImageView.snp.makeConstraints { make in
            make.center.equalTo(self.circleBackgroundView)
            make.width.equalTo(56)
            make.height.equalTo(56)
        }

        self.accessoryView.snp.makeConstraints { make in
            self.trailingConstraint = make.trailing.equalTo(self.snp.trailing).offset(5).constraint
            self.bottomConstraint = make.bottom.equalTo(self.snp.bottom).constraint.update(offset: 5)
        }
    }

    private func setupView() {
        self.addSubview(self.circleBackgroundView)
        self.circleBackgroundView.addSubview(self.imageView)
        self.circleBackgroundView.addSubview(self.remoteImageView)
        self.addSubview(self.accessoryView)
    }

    private func setup() {
        self.setupView()
        self.setupLayout()
    }

    init() {
        super.init(frame: .zero)
        self.setup()
    }


    func configure(viewModel: TransactionImageViewModelInterface) {

        self.remoteImageView.image = nil

        self.cancelable.removeAll()

        self.viewModel = viewModel
        self.imageView.image = viewModel.picto
        self.accessoryView.setImage(viewModel.acessoryPicto)


        self.circleBackgroundView.backgroundColor = viewModel.backgroundColor
        self.circleBackgroundView.layer.borderColor = viewModel.borderColor.cgColor

        viewModel.remoteImage.receive(on: DispatchQueue.main).sink { [weak self] image in
            guard let self = self else { return }
            if let image = image {
                self.imageView.image = nil
                self.remoteImageView.image = image
            }
        }.store(in: &self.cancelable)

        viewModel.accessoryRemoteImage.receive(on: DispatchQueue.main).sink { [weak self] image in
            guard let self = self else { return }
            self.accessoryView.setRemoteImage(image)
        }.store(in: &self.cancelable)


    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
