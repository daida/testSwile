//
//  TransitionAnimator.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 24/09/2022.
//

import Foundation
import UIKit

// MARK: TransitionAnimator

/// This object will animate transition between list to detail animation
/// and the reverse animation (dissmiss)
class TransitionAnimator: NSObject {

    // MARK: Private properties

    /// From list to detail transition animation duration
    private let toDetailDuration = 1.8


    /// From detail to list transition animation duration
    private let toListDuration = 1.2

    // MARK: Public methods

    /// Perform the list to detail animation
    /// - Parameter transitionContext: Contain contenView, from and to viewController
    /// When the transition is done, completeTransition is called on then context object
    func animateToDetailAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        guard
            let last = (transitionContext.viewController(forKey: .from) as? UINavigationController)?.viewControllers.last,
            let fromViewController = last as? TransactionListAnimatorInterface,
            let toViewController = transitionContext.viewController(forKey: .to) as? TransactionDetailAnimatorInterface,
            let viewToAnimate = fromViewController.viewToAnimate,
            let frame = fromViewController.imageViewFrame else { return transitionContext.completeTransition(false) }

        transitionContext.containerView.addSubview(toViewController.view)
        toViewController.view.layoutIfNeeded()
        
        transitionContext.containerView.addSubview(viewToAnimate)
        fromViewController.hideAnimatedImage()
        viewToAnimate.frame = frame

        toViewController.view.alpha = 0.0

        viewToAnimate.layoutIfNeeded()

        viewToAnimate.activateBackgroundAlpha()

        toViewController.prepareForAnimation()

        let cellGrowSequence = {
            viewToAnimate.enableBigMode()
            viewToAnimate.frame = toViewController.header.frame
            viewToAnimate.layoutIfNeeded()
            toViewController.view.alpha = 1.0
        }

        let firstDetailAnimation = {
            viewToAnimate.revealBackButton()
            toViewController.firstAnimDone()
        }

        let lastDetailanimation = {
            toViewController.secondAnimDone()
        }

        let transitionClosure: (Bool) -> Void = { _ in
            viewToAnimate.removeFromSuperview()
            toViewController.displayHeader()
            transitionContext.completeTransition(true)
        }

        UIView.animateKeyframes(withDuration: self.toDetailDuration, delay: 0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1, animations: cellGrowSequence)
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.3, animations: firstDetailAnimation)
            UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.3, animations: lastDetailanimation)
        }, completion: transitionClosure)


    }

    /// Perform detail to list transition animation
    /// - Parameter transitionContext: Contain contenView, from and to viewController
    /// When the transition is done, completeTransition is called on then context object
    func animateToList( transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from) as? TransactionDetailAnimatorInterface,
            let nav = transitionContext.viewController(forKey: .to) as?
                UINavigationController,
            let toViewController = nav.viewControllers.last as? TransactionListAnimatorInterface,
            let destFrame = toViewController.imageViewFrame,
            let destCell = toViewController.viewToAnimate

        else { return transitionContext.completeTransition(false) }

        let header = fromViewController.generateHeader()

        let accessory = header.generateAccesoryView()

        header.layoutIfNeeded()

        let headerAccessoryFrame = header.convert(header.accessoryView.frame, to: transitionContext.containerView)

        nav.view.alpha = 0

        transitionContext.containerView.addSubview(nav.view)
        toViewController.view.layoutIfNeeded()

        transitionContext.containerView.addSubview(header)

        transitionContext.containerView.addSubview(destCell)

        accessory.removeFromSuperview()
        accessory.snp.removeConstraints()

        transitionContext.containerView.addSubview(accessory)
        accessory.translatesAutoresizingMaskIntoConstraints = true
        accessory.disableSizeConstraint()
        accessory.enableBigMode()
        accessory.frame = headerAccessoryFrame
        accessory.layoutIfNeeded()

        destCell.frame = destFrame
        destCell.disableBigMode()
        destCell.halfReveal()
        destCell.alpha = 0
        destCell.layoutIfNeeded()

        let shrinckCellSequence = {
            accessory.enableSmallMode()
            header.disableBigMode()
            header.frame = destFrame
            nav.view.alpha = 1.0
            destCell.alpha = 1.0
            accessory.frame = destCell.convert(destCell.accessoryView.frame,
                                               to: transitionContext.containerView)
            header.layoutIfNeeded()
            accessory.layoutIfNeeded()
        }

        let imageAlphaSequence = {
            header.hideContentImage()
        }

        let hideDetailAnimation = {
            fromViewController.startHideAnimation()
        }

        let completeTransitionClosure: (Bool) -> Void = { _ in
            header.removeFromSuperview()
            destCell.removeFromSuperview()
            toViewController.revealHiddenCell()
            transitionContext.completeTransition(true)
        }


        UIView.animateKeyframes(withDuration: self.toListDuration, delay: 0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.4, animations: hideDetailAnimation)
            UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.05, animations: imageAlphaSequence)
            UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.3, animations: shrinckCellSequence)
        }, completion: completeTransitionClosure)

    }

}

// MARK: - UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning

extension TransitionAnimator: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {

        if transitionContext?.viewController(forKey: .from) is UINavigationController {
            return self.toDetailDuration
        } else {
            return self.toListDuration
        }
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        if transitionContext.viewController(forKey: .from) is UINavigationController {
            self.animateToDetailAnimation(transitionContext)
        } else if transitionContext.viewController(forKey: .from) is TransactionDetailViewController {
            self.animateToList(transitionContext: transitionContext)
        }
    }


    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

// Thoses protocols are defined to limit the coopling between
// viewController and the UIViewControllerContextTransitioning 

// MARK: - TransactionDetailAnimatorInterface

protocol TransactionDetailAnimatorInterface: UIViewController {
    var header: TransactionImageView { get }
    func prepareForAnimation()
    func startHideAnimation()
    func displayHeader()
    func generateHeader() -> TransactionImageView
    func firstAnimDone()
    func secondAnimDone()
}

// MARK: - TransactionListAnimatorInterface

protocol TransactionListAnimatorInterface: UIViewController {
    var imageViewFrame: CGRect? { get }
    var viewToAnimate: TransactionImageView? { get }
    func hideAnimatedImage()
    func revealHiddenCell()
}
