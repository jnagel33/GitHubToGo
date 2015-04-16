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
  var email: String?
  let avatarUrl: String
  var avatarImage: UIImage?
  var name: String?
  var company: String?
  var location: String?
  var bio: String?
  var followers: Int?
  var hireable: Bool?
  
  
  init(id: Int, login: String, avatarUrl: String) {
    self.id = id
    self.login = login
    self.avatarUrl = avatarUrl
  }
  
  init(id: Int, login: String, avatarUrl: String, name: String?, email: String?, company: String?, location: String?, bio: String?, followers: Int, hireable: Bool?) {
    self.id = id
    self.login = login
    self.avatarUrl = avatarUrl
    self.name = name
    self.company = company
    self.email = email
    self.location = location
    self.bio = bio
    self.followers = followers
    self.hireable = hireable
  }
}
