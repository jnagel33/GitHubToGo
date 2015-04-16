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
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var backgroundProfileView: UIView!
  
  let gitHubService = GitHubService()
  let avatarImageViewSize = CGSize(width: 200, height: 200)
  let imageViewCornerRadius: CGFloat = 100
  var selectedUser: User?
  var isAuthenticatedUser: Bool!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.nameLabel.center.x -= view.bounds.width
    self.loginLabel.center.x -= view.bounds.width
    self.locationLabel.center.x += view.bounds.width
    self.emailLabel.center.x += view.bounds.width
    self.emailIcon.center.y += view.bounds.height
    
    UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
      self.loginLabel.center.x += self.view.bounds.width
    }, completion: nil)
    
    UIView.animateWithDuration(0.5, delay: 0.3, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
      self.loginLabel.center.x += self.view.bounds.width
    }) { (finished) -> Void in
      
    }
    
    UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
        self.locationLabel.center.x -= self.view.bounds.width
    }, completion: nil)
    
    UIView.animateWithDuration(0.5, delay: 0.3, usingSpringWithDamping: 1, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
      self.emailLabel.center.x -= self.view.bounds.width
      }, completion: nil)
    
    UIView.animateWithDuration(0.5, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
      self.emailIcon.center.y -= self.view.bounds.height
    }, completion: nil)
    
    self.profileImageView.layer.cornerRadius = self.imageViewCornerRadius
    self.profileImageView.layer.masksToBounds = true
    
    if self.isAuthenticatedUser! {
      self.gitHubService.getAuthenticatedUser({ [weak self] (user, error) -> Void in
        if self != nil {
          if error != nil {
            //handle error
          } else {
            self!.loginLabel.text = user!.login
            ImageService.sharedService.fetchProfileImage(user!.avatarUrl, completionHandler: { [weak self] (image) -> () in
              if self != nil {
                self!.profileImageView.alpha = 0
                user!.avatarImage = image!
                let resizedImage = ImageResizer.resizeImage(image!, size: self!.avatarImageViewSize)
                self!.profileImageView.image = resizedImage
                self!.selectedUser = user
                self!.nameLabel.text = user!.name
                self!.locationLabel.text = user!.location
                self!.emailLabel.text = user!.email
                
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                  self!.profileImageView.alpha = 1
                  self!.nameLabel.alpha = 1
                  self!.loginLabel.alpha = 1
                  self!.emailLabel.alpha = 1
                  self!.locationLabel.alpha = 1
                })
              }
            })
          }
        }
      })
    } else {
      self.loginLabel.text = selectedUser!.login
      if let image = self.selectedUser!.avatarImage {
        let resizedImage = ImageResizer.resizeImage(image, size: avatarImageViewSize)
        self.profileImageView.image = resizedImage
      }
      self.gitHubService.getUser(self.selectedUser!.login, completionHandler: { [weak self] (user, error) -> Void in
        if self != nil {
          if error != nil {
            //handle error
          } else {
            self!.nameLabel.text = user!.name
            self!.locationLabel.text = user!.location
            self!.emailLabel.text = user!.email
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
              self!.loginLabel.alpha = 1
              self!.nameLabel.alpha = 1
              self!.emailLabel.alpha = 1
              self!.locationLabel.alpha = 1
            })
          }
        }
      })
    }
  }
}
