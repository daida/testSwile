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

    private let duration = 1.4

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }

    func animateToDetailAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from) as? TransactionListViewController,
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
            viewToAnimate.removeFromSuperview()
            toViewController.firstAnimDone()
        }

        let lastDetailanimation = {
            toViewController.secoundAnimDone()
        }

        let transitionClosure: (Bool) -> Void = { _ in
            transitionContext.completeTransition(true)
        }

        let firstDetailAnimationClosure: (Bool) -> Void = { _ in
            UIView.animate(withDuration: (self.duration / 3.0),
                           animations: lastDetailanimation, completion: transitionClosure)
        }

        let cellGrowClosure: (Bool) -> Void = { _ in
            toViewController.displayHeader()
            UIView.animate(withDuration: (self.duration / 3.0),
                           animations: firstDetailAnimation, completion: firstDetailAnimationClosure)
        }

        UIView.animate(withDuration: (self.duration / 3.0),
                       animations: cellGrowSequence, completion: cellGrowClosure)

    }

    func animateToList( transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from) as? TransactionDetailViewController,
            let toViewController = transitionContext.viewController(forKey: .to) as?
                TransactionListViewController,
        let destFrame = toViewController.imageViewFrame
        else { return transitionContext.completeTransition(false) }

        let header = fromViewController.headerCopy()

        toViewController.view.alpha = 0
        transitionContext.containerView.addSubview(toViewController.view)
        toViewController.view.layoutIfNeeded()

        transitionContext.containerView.addSubview(header)

        let shrinckCellSequence = {
                header.disableBigMode()
                header.frame = destFrame
                toViewController.view.alpha = 1.0
                header.layoutIfNeeded()
        }

        let hideDetailAnimation = {
            fromViewController.startHideAnimation()
        }

        let completeTransitionClosure: (Bool) -> Void = { _ in
            toViewController.revealHiddenCell()
            header.removeFromSuperview()
            transitionContext.completeTransition(true)
        }

        let hideAnimationClosure: (Bool) -> Void = {_ in
            UIView.animate(withDuration: (self.duration / 2.0),
                           animations: shrinckCellSequence,
                           completion: completeTransitionClosure)
        }

        UIView.animate(withDuration: (self.duration / 2.0),
                       animations: hideDetailAnimation,
                       completion: hideAnimationClosure)

    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {


        if transitionContext.viewController(forKey: .from) is TransactionListViewController {
            self.animateToDetailAnimation(transitionContext)
        } else if transitionContext.viewController(forKey: .from) is TransactionDetailViewController {
            self.animateToList(transitionContext: transitionContext)
        }
    }


    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self
    }
}

extension TransitionAnimator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}



