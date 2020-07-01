//  SlideInTransition.swift
//  SlideInTransition
//  Created by Gary Tokman on 1/13/19.
//  Copyright © 2019 Gary Tokman. All rights reserved.

import UIKit

class SlideInTransition: NSObject, UIViewControllerAnimatedTransitioning {

    var isPresenting = false
    let dimmingView = UIView()

    var containerView = UIView()  /* Added By Chandra on 11th-Nov-2019 */
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from) else { return }

         containerView = transitionContext.containerView /* Changed By Chandra on 11th-Nov-2019 */

        let finalWidth = toViewController.view.bounds.width * 0.8
        let finalHeight = toViewController.view.bounds.height

        if isPresenting {
            // Add dimming view
            dimmingView.backgroundColor = .black
            dimmingView.alpha = 0.0
            containerView.addSubview(dimmingView)
            dimmingView.frame = containerView.bounds
            // Add menu view controller to container
            containerView.addSubview(toViewController.view)

            // Init frame off the screen
            toViewController.view.frame = CGRect(x: -finalWidth, y: 0, width: finalWidth, height: finalHeight)
        }
       /* Added By Chandra on 11th-Nov-2019  - from here */
        let swipeLeft = UITapGestureRecognizer(target: self, action: #selector(handleSwipe(swipe:)))
        dimmingView.addGestureRecognizer(swipeLeft)
        /* Added By Chandra on 11th-Nov-2019 - ends here */
        
        // Move on screen
        let transform = {
            self.dimmingView.alpha = 0.5
            toViewController.view.transform = CGAffineTransform(translationX: finalWidth, y: 0)
        }


        // Move back off screen
        let identity = {
            self.dimmingView.alpha = 0.0
            fromViewController.view.transform = .identity
        }

        // Animation of the transition
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        UIView.animate(withDuration: duration, animations: {
            self.isPresenting ? transform() : identity()
        }) { (_) in
            transitionContext.completeTransition(!isCancelled)
        }
    }

    /* Added By Chandra on 11th-Nov-2019  - starts here */
    @objc func handleSwipe(swipe: UISwipeGestureRecognizer){
        print("tap on homevc")
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromRight
        self.containerView.window!.layer.add(transition, forKey: nil)
        containerView.removeFromSuperview()
    }
    /* Added By Chandra on 11th-Nov-2019  - ends here */
}
