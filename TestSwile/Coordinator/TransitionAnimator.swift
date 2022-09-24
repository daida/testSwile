//
//  TransitionAnimator.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 24/09/2022.
//

import Foundation
import UIKit

class TransitionAnimator: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    private var animTime = 0.0

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(animTime)
    }

    func animateToDetailAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from) as? TransactionListViewController,
            let toViewController = transitionContext.viewController(forKey: .to) as? TransactionDetailViewController else { return transitionContext.completeTransition(false) }

        self.animTime = 1.2

        transitionContext.containerView.addSubview(toViewController.view)
        toViewController.view.layoutIfNeeded()

        guard let viewToAnimate = fromViewController.viewToAnimate,
              let frame = fromViewController.imageViewFrame  else { return }
        
        transitionContext.containerView.addSubview(viewToAnimate)
        viewToAnimate.frame = frame

        toViewController.view.alpha = 0.0

        viewToAnimate.layoutIfNeeded()

        viewToAnimate.activateBackgroundAlpha()

        toViewController.prepareForAnimation()

        UIView.animate(withDuration: 0.4) {
            viewToAnimate.enableBigMode()
            viewToAnimate.frame = toViewController.headerFrame
            viewToAnimate.layoutIfNeeded()
            toViewController.view.alpha = 1.0
        } completion: { _ in
            toViewController.displayHeader()
            viewToAnimate.removeFromSuperview()
            UIView.animate(withDuration: 0.4) {
                toViewController.firstAnimDone()
            } completion: { _ in
                UIView.animate(withDuration: 0.4) {
                    toViewController.secoundAnimDone()
                } completion: { _ in
                    transitionContext.completeTransition(true)
                }
            }
        }
    }

    func animateToList( transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from) as? TransactionDetailViewController,
            let toViewController = transitionContext.viewController(forKey: .to) as? TransactionListViewController else { return transitionContext.completeTransition(false) }

        self.animTime = 1.1

        let header = fromViewController.headerCopy()

        toViewController.view.alpha = 0
        transitionContext.containerView.addSubview(toViewController.view)
        toViewController.view.layoutIfNeeded()

        transitionContext.containerView.addSubview(header)

        UIView.animate(withDuration: 0.6) {
            fromViewController.startHideAnimation()
        } completion: { _ in
            UIView.animate(withDuration: 0.5) {
                header.disableBigMode()
                if let destFrame = toViewController.imageViewFrame {
                    header.frame = destFrame
                }
                toViewController.view.alpha = 1.0
                header.layoutIfNeeded()
            } completion: { _ in
                toViewController.revealHiddenCell()
                header.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        }


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



