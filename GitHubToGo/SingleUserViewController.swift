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

  @IBOutlet weak var profileImageView: UIImageView!
  let gitHubService = GitHubService()
  let avatarImageViewSize = CGSize(width: 200, height: 200)
  var selectedUser: User?
  var isAuthenticatedUser: Bool!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if self.isAuthenticatedUser! {
      self.gitHubService.getAuthenticatedUser({ [weak self] (user, error) -> Void in
        if self != nil {
          if error != nil {
            //handle error
          } else {
            self!.loginLabel.text = user!.login
            ImageService.sharedService.fetchProfileImage(user!.avatarUrl, completionHandler: { [weak self] (image) -> () in
              if self != nil {
                  user!.avatarImage = image!
                  let resizedImage = ImageResizer.resizeImage(image!, size: self!.avatarImageViewSize)
                  self?.profileImageView.image = resizedImage
                }
              })

            self!.selectedUser = user
            self!.nameLabel.text = user!.name
            self!.locationLabel.text = user!.location
            self!.emailLabel.text = user!.email
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
          }
        }
      })
    }
  }
}
