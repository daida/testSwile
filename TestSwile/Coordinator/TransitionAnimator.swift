//
//  TransitionAnimator.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 24/09/2022.
//

import Foundation
import UIKit

class TransitionAnimator: NSObject, UIViewControllerTransitioningDelegate,
                            UIViewControllerAnimatedTransitioning {

    private let duration = 2.0

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }

    func animateToDetailAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        guard
            let last = (transitionContext.viewController(forKey: .from) as? UINavigationController)?.viewControllers.last,
            let fromViewController = last as? TransactionListViewController,
            let toViewController = transitionContext.viewController(forKey: .to) as? TransactionDetailViewController,
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
            viewToAnimate.frame = toViewController.headerFrame
            viewToAnimate.layoutIfNeeded()
            toViewController.view.alpha = 1.0
        }

        let firstDetailAnimation = {
            viewToAnimate.revealBackButton()
            toViewController.firstAnimDone()
        }

        let lastDetailanimation = {
            toViewController.secoundAnimDone()
        }

        let transitionClosure: (Bool) -> Void = { _ in
			viewToAnimate.removeFromSuperview()
            toViewController.displayHeader()
            transitionContext.completeTransition(true)
        }

        UIView.animateKeyframes(withDuration: 1.8, delay: 0, options: .calculationModeLinear, animations: {

            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2, animations: cellGrowSequence)

            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.2, animations: firstDetailAnimation)

            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2, animations: lastDetailanimation)

        }, completion: transitionClosure)


    }

    func animateToList( transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from) as? TransactionDetailViewController,
            let nav = transitionContext.viewController(forKey: .to) as?
                UINavigationController,
            let toViewController = nav.viewControllers.last as? TransactionListViewController,
        let destFrame = toViewController.imageViewFrame,
            let destCell = toViewController.viewToAnimate

        else { return transitionContext.completeTransition(false) }

        let header = fromViewController.headerCopy()

        let accessory = destCell.accessoryView

        let headerAccessoryFrame = destCell.convert(destCell.accessoryView.frame, to: transitionContext.containerView)
        

        header.layoutIfNeeded()

        nav.view.alpha = 0

        transitionContext.containerView.addSubview(nav.view)
        toViewController.view.layoutIfNeeded()

        transitionContext.containerView.addSubview(header)

        transitionContext.containerView.addSubview(destCell)

        


        destCell.frame = destFrame
        destCell.disableBigMode()
        destCell.halfReveal()
        destCell.alpha = 0
		destCell.layoutIfNeeded()

        let shrinckCellSequence = {
                header.disableBigMode()
                header.frame = destFrame
                nav.view.alpha = 1.0
	            destCell.alpha = 1.0
                header.layoutIfNeeded()
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


        UIView.animateKeyframes(withDuration: 1.2, delay: 0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3, animations: hideDetailAnimation)
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.05, animations: imageAlphaSequence)
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: shrinckCellSequence)
        }, completion: completeTransitionClosure)

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

extension TransitionAnimator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}



