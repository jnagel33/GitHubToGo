//
//  SingleUserViewController.swift
//  GitHubToGo
//
//  Created by Josh Nagel on 4/14/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class SingleUserViewController: UIViewController, UINavigationControllerDelegate {
  
  @IBOutlet weak var bioIcon: UIButton!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var loginLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var emailIcon: UIImageView!
  @IBOutlet weak var locationIcon: UIImageView!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var backgroundProfileView: UIView!
  @IBOutlet weak var bioLabel: UILabel!
  @IBOutlet weak var hireableLabel: UILabel!
  @IBOutlet weak var hireableStaticLabel: UILabel!
  
  let gitHubService = GitHubService()
  let avatarImageViewSize = CGSize(width: 200, height: 200)
  let imageViewCornerRadius: CGFloat = 100
  var selectedUser: User?
  var indexPath: NSIndexPath?
  var controllerCountIndexMax = 3
  
  let animateHalfSecond: Double = 0.5
  let animateOneThirdSecond: Double = 0.3
  let slightSpringEffect: CGFloat = 0.8
  let normalSpringDamping: CGFloat = 1
  let quickerVelocity: CGFloat = 1
  let slowerVelocity: CGFloat = 0.8
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var backBarButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "backButtonPressed")
    self.navigationItem.hidesBackButton = true;
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    
    if let user = selectedUser {
      self.selectedUser = user
      self.nameLabel.text = user.name
      self.loginLabel.text = user.login
      self.locationLabel.text = user.location
      self.emailLabel.text = user.email
      self.profileImageView.image = user.avatarImage
      if user.bio != nil {
        self.bioLabel.text = user.bio
      } else {
        self.bioLabel.text = "No Bio"
      }
      if user.hireable != nil {
        if user.hireable! {
          self.hireableLabel.text = "Yes"
        } else {
          self.hireableLabel.text = "No"
        }
      }
    }
    
    self.getUserInfo()
    self.doAnimations()
  }
  
  func backButtonPressed() {
    if self.navigationController!.viewControllers.count < controllerCountIndexMax {
      self.navigationController?.popToRootViewControllerAnimated(true)
    }
    self.performSegueWithIdentifier("Unwind", sender: self)
  }
  
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController!.delegate = self
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController!.delegate = nil
  }
  
  func doAnimations() {
    self.profileImageView.layer.cornerRadius = self.imageViewCornerRadius
    self.profileImageView.layer.masksToBounds = true
    self.nameLabel.center.x -= view.bounds.width
    self.loginLabel.center.x -= view.bounds.width
    self.locationLabel.center.x += view.bounds.width
    self.emailLabel.center.x += view.bounds.width
    self.emailIcon.center.y += view.bounds.height
    self.locationIcon.center.y += view.bounds.height
    self.backgroundProfileView.center.y -= view.bounds.height
    
    UIView.animateWithDuration(self.animateOneThirdSecond, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
      self.backgroundProfileView.center.y += self.view.bounds.height
    }) { (finished) -> Void in
      if finished {
        self.profileImageView.alpha = 1
      }
    }
    
    UIView.animateWithDuration(self.animateHalfSecond, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
      self.nameLabel.center.x += self.view.bounds.width
      }, completion: nil)
    
    UIView.animateWithDuration(self.animateHalfSecond, delay: self.animateOneThirdSecond, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
      self.loginLabel.center.x += self.view.bounds.width
      }) { (finished) -> Void in
    }
    
    UIView.animateWithDuration(self.animateHalfSecond, delay: self.animateOneThirdSecond, usingSpringWithDamping: self.slightSpringEffect, initialSpringVelocity: self.slightSpringEffect, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
      self.locationIcon.center.y -= self.view.bounds.height
      }, completion: nil)
    
    UIView.animateWithDuration(self.animateHalfSecond, delay: self.animateHalfSecond, usingSpringWithDamping: self.slightSpringEffect, initialSpringVelocity: self.slowerVelocity, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
      self.emailIcon.center.y -= self.view.bounds.height
      }, completion: nil)
    
    UIView.animateWithDuration(self.animateHalfSecond, delay: self.animateHalfSecond, usingSpringWithDamping: self.slightSpringEffect, initialSpringVelocity: self.slowerVelocity, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
      self.bioIcon.center.y -= self.view.bounds.height
      }, completion: nil)
    
    UIView.animateWithDuration(self.animateHalfSecond, delay: self.animateHalfSecond, usingSpringWithDamping: self.slightSpringEffect, initialSpringVelocity: self.slowerVelocity, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
      self.hireableStaticLabel.center.y -= self.view.bounds.height
      }, completion: nil)
    
    UIView.animateWithDuration(self.animateHalfSecond, delay: self.animateOneThirdSecond, usingSpringWithDamping: self.normalSpringDamping, initialSpringVelocity: self.quickerVelocity, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
      self.locationLabel.center.x -= self.view.bounds.width
      }, completion: nil)
    
    UIView.animateWithDuration(self.animateHalfSecond, delay: self.animateOneThirdSecond, usingSpringWithDamping: self.normalSpringDamping, initialSpringVelocity: self.quickerVelocity, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
      self.emailLabel.center.x -= self.view.bounds.width
      }, completion: nil)
    
    UIView.animateWithDuration(self.animateHalfSecond, delay: self.animateOneThirdSecond, usingSpringWithDamping: self.normalSpringDamping, initialSpringVelocity: self.quickerVelocity, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
      self.bioLabel.center.x -= self.view.bounds.width
      }, completion: nil)
    
    UIView.animateWithDuration(self.animateHalfSecond, delay: self.animateOneThirdSecond, usingSpringWithDamping: self.normalSpringDamping, initialSpringVelocity: self.quickerVelocity, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
      self.hireableLabel.center.x -= self.view.bounds.width
      }, completion: nil)
  }
  
  
  func getUserInfo() {
    self.gitHubService.getUser(self.selectedUser?.login, completionHandler: { [weak self] (user, error) -> Void in
      if self != nil {
        if error != nil {
          let alert = UIAlertController(title: "An error occured", message: error, preferredStyle: .Alert)
          let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
          alert.addAction(okAction)
          self!.presentViewController(alert, animated: true, completion: nil)
        } else {
          self!.selectedUser = user!
          self!.nameLabel.text = user!.name
          self!.loginLabel.text = user!.login
          self!.locationLabel.text = user!.location
          self!.emailLabel.text = user!.email
          if user!.bio != nil {
            self!.bioLabel.text = user!.bio
          } else {
            self!.bioLabel.text = "No Bio"
          }
          if user!.hireable != nil {
            if user!.hireable! {
              self!.hireableLabel.text = "Yes"
            } else {
              self!.hireableLabel.text = "No"
            }
          }
          if self!.profileImageView.image == nil {
            self!.profileImageView.alpha = 0
            ImageService.sharedService.fetchProfileImage(user!.avatarUrl, completionHandler: { [weak self] (image) -> () in
              if image != nil {
                user!.avatarImage = image!
                let resizedImage = ImageResizer.resizeImage(image!, size: self!.avatarImageViewSize)
                self!.profileImageView.image = resizedImage
                UIView.animateWithDuration(self!.animateOneThirdSecond, animations: { [weak self] () -> Void in
                  self!.profileImageView.alpha = 1
                })
              }
            })
          }
        }
      }
    })
  }
  
  //MARK:
  //MARK: UINavigationControllerDelegate
  
  func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    if toVC is UserSearchViewController {
      return UnwindSegueBackToSearch()
    }
    return nil
  }
}
