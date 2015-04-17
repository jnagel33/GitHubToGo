//
//  RepoSearchCell.swift
//  GitHubToGo
//
//  Created by Josh Nagel on 4/13/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class RepoSearchTableViewCell: UITableViewCell {

  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var userLabel: UILabel!
  
  let imageViewSize = CGSize(width: 75, height: 75)
  
  func configureCell(repository: Repository) {
    self.tag++
    let tag = self.tag
    self.nameLabel.text = nil
    self.userLabel.text = nil
    self.avatarImageView.image = nil
  
    self.nameLabel.text = repository.name
    self.userLabel.text = repository.login
    
    if let image = repository.avatarImage {
      self.avatarImageView.image = image
    } else {
      ImageService.sharedService.fetchProfileImage(repository.avatarUrl, completionHandler: { [weak self] (image) -> () in
        if self != nil {
          if tag == self!.tag {
            let resizedImage = ImageResizer.resizeImage(image!, size: self!.imageViewSize)
            repository.avatarImage = resizedImage
            self!.avatarImageView.image = resizedImage
          }
        }
      })
    }
  }
  

}
