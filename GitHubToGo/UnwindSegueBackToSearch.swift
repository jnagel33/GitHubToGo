//
//  UnwindSegueBackToSearch.swift
//  GitHubToGo
//
//  Created by Josh Nagel on 4/17/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class UnwindSegueBackToSearch: NSObject, UIViewControllerAnimatedTransitioning {
  
  let duration = 0.5
  let imageViewCornerRadius: CGFloat = 100
  let scaleImageTransform: CGFloat = 2.5
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
    return duration
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! SingleUserViewController
    let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! UserSearchViewController
    let containerView = transitionContext.containerView()
    
    toVC.view.alpha = 0
    fromVC.profileImageView.alpha = 0
    containerView.addSubview(toVC.view)
    
    let selectedIndexPath = fromVC.indexPath
    let userCell = toVC.collectionView.cellForItemAtIndexPath(selectedIndexPath!) as! UserSearchCollectionViewCell
    let snapShot = fromVC.profileImageView.snapshotViewAfterScreenUpdates(false)
    
    userCell.hidden = true
    snapShot.frame = containerView.convertRect(fromVC.profileImageView.frame, fromCoordinateSpace: fromVC.profileImageView.superview!)
    containerView.addSubview(snapShot)
    toVC.view.layoutIfNeeded()
    
    let frame = containerView.convertRect(userCell.avatarImageView.frame, fromView: userCell)
    
    UIView.animateWithDuration(duration, animations: { () -> Void in
      toVC.view.alpha = 1
      snapShot.frame = frame
      }) { (finished) -> Void in
        if finished {
          userCell.hidden = false
          snapShot.removeFromSuperview()
          transitionContext.completeTransition(true)
        } else {
          transitionContext.completeTransition(false)
        }
    }
  }

}
