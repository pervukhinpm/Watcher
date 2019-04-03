//
//  DismissAnimator.swift
//  Watcher
//
//  Created by Петр Первухин on 04/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

class DismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
   
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    @objc func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let from = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations: { 
            from!.view.frame.origin.y = 800
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
   
    }
}
