//
//  User.swift
//  GitHubToGo
//
//  Created by Josh Nagel on 4/14/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class User {
  
  let id: Int
  let login: String
  let avatarUrl: String
  var avatarImage: UIImage?
  
  init(id: Int, login: String, avatarUrl: String) {
    self.id = id
    self.login = login
    self.avatarUrl = avatarUrl
  }
}
