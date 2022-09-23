//
//  TransactionImageView.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 23/09/2022.
//

import Foundation
import UIKit
import Combine

class AccessoryImageView: UIView {

    private let remoteImageView: UIImageView = {
        let dest = UIImageView()
        dest.contentMode = .scaleAspectFit
        dest.layer.cornerRadius = 8
        dest.clipsToBounds = true
        dest.backgroundColor = UIColor.white
        dest.translatesAutoresizingMaskIntoConstraints = false
        return dest
    }()

    private let imageView: UIImageView = {
        let dest = UIImageView()
        dest.contentMode = .center
        dest.layer.cornerRadius = 8
        dest.clipsToBounds = true
        dest.backgroundColor = UIColor.white
        return dest
    }()

    func setup() {

        self.backgroundColor = UIColor.white

        self.addSubview(self.imageView)
        self.addSubview(self.remoteImageView)

        self.remoteImageView.snp.makeConstraints { make in
            make.center.equalTo(self.snp.center)
            make.width.equalTo(self.imageView)
            make.height.equalTo(self.imageView)
        }

        self.imageView.snp.makeConstraints { make in
            make.center.equalTo(self.snp.center)
            make.height.equalTo(16)
            make.width.equalTo(16)
        }

        self.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(20)
        }

        self.layer.cornerRadius = 10
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

    private let circleBackgroundView: UIView = {
        let dest = UIView()
        dest.layer.cornerRadius = 28
        dest.translatesAutoresizingMaskIntoConstraints = false
        dest.layer.borderWidth = 1
        dest.clipsToBounds = true
        return dest
    }()

    private let imageView: UIImageView = {
        let dest = UIImageView()
        dest.contentMode = .center
        dest.translatesAutoresizingMaskIntoConstraints = false
        return dest
    }()

    private let remoteImageView: UIImageView = {
        let dest = UIImageView()
        dest.contentMode = .scaleAspectFit
        dest.translatesAutoresizingMaskIntoConstraints = false
        return dest
    }()


    private func setupLayout() {

        self.circleBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
        }

        self.imageView.snp.makeConstraints { make in
            make.top.equalTo(self.circleBackgroundView)
            make.bottom.equalTo(self.circleBackgroundView)
            make.leading.equalTo(self.circleBackgroundView)
            make.trailing.equalTo(self.circleBackgroundView)
        }

        self.remoteImageView.snp.makeConstraints { make in
            make.top.equalTo(self.circleBackgroundView)
            make.bottom.equalTo(self.circleBackgroundView)
            make.leading.equalTo(self.circleBackgroundView)
            make.trailing.equalTo(self.circleBackgroundView)
        }

        self.accessoryView.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom)
            make.trailing.equalTo(self.snp.trailing).offset(2)
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
        self.circleBackgroundView.layer.borderColor = viewModel.borderColor.cgColor
        self.circleBackgroundView.backgroundColor = viewModel.backgroundColor

        viewModel.remoteImage.receive(on: DispatchQueue.main).sink { [weak self] image in
            guard let self = self else { return }
            self.remoteImageView.image = image
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
