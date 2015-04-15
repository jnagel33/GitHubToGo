//
//  RepoSearchCell.swift
//  GitHubToGo
//
//  Created by Josh Nagel on 4/13/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class RepoSearchTableViewCell: UITableViewCell {

  @IBOutlet weak var nameLabel: UILabel!
  
  func configureCell(repository: Repository) {
    self.nameLabel.text = repository.name
  }
  

}
