//
//  SingleUserViewController.swift
//  GitHubToGo
//
//  Created by Josh Nagel on 4/14/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class SingleUserViewController: UIViewController {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var loginLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var emailIcon: UIImageView!
  @IBOutlet weak var locationIcon: UIImageView!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var backgroundProfileView: UIView!
  
  let gitHubService = GitHubService()
  let avatarImageViewSize = CGSize(width: 200, height: 200)
  let imageViewCornerRadius: CGFloat = 100
  var selectedUser: User?
  
  let animateHalfSecond: Double = 0.5
  let animateOneThirdSecond: Double = 0.3
  let slightSpringEffect: CGFloat = 0.8
  let normalSpringDamping: CGFloat = 1
  let quickerVelocity: CGFloat = 1
  let slowerVelocity: CGFloat = 0.8
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let user = selectedUser {
      self.selectedUser = user
      self.nameLabel.text = user.name
      self.loginLabel.text = user.login
      self.locationLabel.text = user.location
      self.emailLabel.text = user.email
      self.profileImageView.image = user.avatarImage
    }
    
    self.getUserInfo()
    self.doAnimations()
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
      self.profileImageView.alpha = 1
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
    
    UIView.animateWithDuration(self.animateHalfSecond, delay: self.animateOneThirdSecond, usingSpringWithDamping: self.normalSpringDamping, initialSpringVelocity: self.quickerVelocity, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
      self.locationLabel.center.x -= self.view.bounds.width
      }, completion: nil)
    
    UIView.animateWithDuration(self.animateHalfSecond, delay: self.animateOneThirdSecond, usingSpringWithDamping: self.normalSpringDamping, initialSpringVelocity: self.quickerVelocity, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
      self.emailLabel.center.x -= self.view.bounds.width
      }, completion: nil)
  }
  
  
  func getUserInfo() {
    self.gitHubService.getUser(self.selectedUser?.login, completionHandler: { [weak self] (user, error) -> Void in
      if self != nil {
        if error != nil {
          //handle error
        } else {
          self!.selectedUser = user!
          self!.nameLabel.text = user!.name
          self!.loginLabel.text = user!.login
          self!.locationLabel.text = user!.location
          self!.emailLabel.text = user!.email
          if self!.profileImageView.image == nil {
            self!.profileImageView.alpha = 0
            ImageService.sharedService.fetchProfileImage(user!.avatarUrl, completionHandler: { [weak self] (image) -> () in
              user!.avatarImage = image!
              let resizedImage = ImageResizer.resizeImage(image!, size: self!.avatarImageViewSize)
              self!.profileImageView.image = resizedImage
              UIView.animateWithDuration(self!.animateOneThirdSecond, animations: { () -> Void in
                self!.profileImageView.alpha = 1
              })
            })
          }
        }
      }
    })
  }
}
