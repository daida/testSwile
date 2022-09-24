//
//  CircleView.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 23/09/2022.
//

import Foundation
import UIKit

class CircleImageView: UIImageView {
    let layer1 = CAShapeLayer()

    let circlePath: UIBezierPath = {
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 0.5, y: 28))
        bezier2Path.addCurve(to: CGPoint(x: 7, y: 6.49), controlPoint1: CGPoint(x: 0.5, y: 17.55), controlPoint2: CGPoint(x: 2.59, y: 10.72))
        bezier2Path.addCurve(to: CGPoint(x: 28, y: 0.5), controlPoint1: CGPoint(x: 11.4, y: 2.25), controlPoint2: CGPoint(x: 18.24, y: 0.5))
        bezier2Path.addCurve(to: CGPoint(x: 49, y: 6.49), controlPoint1: CGPoint(x: 37.76, y: 0.5), controlPoint2: CGPoint(x: 44.6, y: 2.25))
        bezier2Path.addCurve(to: CGPoint(x: 55.5, y: 28), controlPoint1: CGPoint(x: 53.41, y: 10.72), controlPoint2: CGPoint(x: 55.5, y: 17.55))
        bezier2Path.addCurve(to: CGPoint(x: 49, y: 49.51), controlPoint1: CGPoint(x: 55.5, y: 38.45), controlPoint2: CGPoint(x: 53.41, y: 45.28))
        bezier2Path.addCurve(to: CGPoint(x: 28, y: 55.5), controlPoint1: CGPoint(x: 44.6, y: 53.75), controlPoint2: CGPoint(x: 37.76, y: 55.5))
        bezier2Path.addCurve(to: CGPoint(x: 7, y: 49.51), controlPoint1: CGPoint(x: 18.24, y: 55.5), controlPoint2: CGPoint(x: 11.4, y: 53.75))
        bezier2Path.addCurve(to: CGPoint(x: 0.5, y: 28), controlPoint1: CGPoint(x: 2.59, y: 45.28), controlPoint2: CGPoint(x: 0.5, y: 38.45))
        bezier2Path.close()
        return bezier2Path
    }()

    func turnOffMask() {
        self.layer.mask = nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    	self.layer.mask = layer1
    }

    override init(image: UIImage?) {
        super.init(image: image)
        self.layer1.mask = layer1
    }

    override func layoutSubviews() {
        self.layer1.frame = self.bounds
        self.layer1.path = self.circlePath.fit(into: self.bounds).moveCenter(to: self.center).cgPath

//        if self.layer.mask == nil {
//            self.layer.cornerRadius = self.bounds.width / 2
//        }

    //    self.layer.mask = layer1
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CircleView: UIView {

    let layer1 = CAShapeLayer()

    let circlePath: UIBezierPath = {
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 0.5, y: 28))
        bezier2Path.addCurve(to: CGPoint(x: 7, y: 6.49), controlPoint1: CGPoint(x: 0.5, y: 17.55), controlPoint2: CGPoint(x: 2.59, y: 10.72))
        bezier2Path.addCurve(to: CGPoint(x: 28, y: 0.5), controlPoint1: CGPoint(x: 11.4, y: 2.25), controlPoint2: CGPoint(x: 18.24, y: 0.5))
        bezier2Path.addCurve(to: CGPoint(x: 49, y: 6.49), controlPoint1: CGPoint(x: 37.76, y: 0.5), controlPoint2: CGPoint(x: 44.6, y: 2.25))
        bezier2Path.addCurve(to: CGPoint(x: 55.5, y: 28), controlPoint1: CGPoint(x: 53.41, y: 10.72), controlPoint2: CGPoint(x: 55.5, y: 17.55))
        bezier2Path.addCurve(to: CGPoint(x: 49, y: 49.51), controlPoint1: CGPoint(x: 55.5, y: 38.45), controlPoint2: CGPoint(x: 53.41, y: 45.28))
        bezier2Path.addCurve(to: CGPoint(x: 28, y: 55.5), controlPoint1: CGPoint(x: 44.6, y: 53.75), controlPoint2: CGPoint(x: 37.76, y: 55.5))
        bezier2Path.addCurve(to: CGPoint(x: 7, y: 49.51), controlPoint1: CGPoint(x: 18.24, y: 55.5), controlPoint2: CGPoint(x: 11.4, y: 53.75))
        bezier2Path.addCurve(to: CGPoint(x: 0.5, y: 28), controlPoint1: CGPoint(x: 2.59, y: 45.28), controlPoint2: CGPoint(x: 0.5, y: 38.45))
        bezier2Path.close()
        return bezier2Path
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.layer.addSublayer(layer1)
        self.layer1.fillColor = .none
        self.layer1.miterLimit = 4
        self.layer1.lineWidth = 2
    }

    func turnOffCrop() {
        self.layer1.removeFromSuperlayer()
    }

    func updateBorderColor(_ color: UIColor) {
        self.layer1.strokeColor = color.cgColor
    }

    override func layoutSubviews() {
        self.layer1.frame = self.bounds
        self.layer1.path = self.circlePath.fit(into: self.bounds).moveCenter(to: self.center).cgPath
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
