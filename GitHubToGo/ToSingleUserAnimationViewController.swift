//
//  ToSingleUserAnimationViewController.swift
//  GitHubToGo
//
//  Created by Josh Nagel on 4/15/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class ToSingleUserAnimationViewController: NSObject, UIViewControllerAnimatedTransitioning {

  let duration = 0.5
  let imageViewCornerRadius: CGFloat = 100
  let scaleImageTransform: CGFloat = 2.5
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
    return duration
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! UserSearchViewController
    let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! SingleUserViewController
    let containerView = transitionContext.containerView()
    
    toVC.view.alpha = 0
    containerView.addSubview(toVC.view)
    
    let selectedIndexPath = fromVC.collectionView.indexPathsForSelectedItems().first as! NSIndexPath
    let userCell = fromVC.collectionView.cellForItemAtIndexPath(selectedIndexPath) as! UserSearchCollectionViewCell
    let snapShot = UIImageView(image: fromVC.users[selectedIndexPath.row].avatarImage)
    userCell.hidden = true
    snapShot.frame = containerView.convertRect(userCell.avatarImageView.frame, fromCoordinateSpace: userCell.avatarImageView.superview!)
    snapShot.layer.cornerRadius = snapShot.frame.width / 2
    snapShot.layer.masksToBounds = true
    containerView.addSubview(snapShot)
    toVC.view.layoutIfNeeded()
    
    toVC.profileImageView.hidden = true
    
    UIView.animateWithDuration(duration, animations: { () -> Void in
      toVC.view.alpha = 1
      snapShot.transform = CGAffineTransformMakeScale(self.scaleImageTransform, self.scaleImageTransform)
      snapShot.center = toVC.profileImageView.center
      
    }) { (finished) -> Void in
      if finished {
        toVC.profileImageView.hidden = false
        snapShot.removeFromSuperview()
        userCell.hidden = false
        transitionContext.completeTransition(true)
      } else {
        transitionContext.completeTransition(false)
      }
    }
  }
}
