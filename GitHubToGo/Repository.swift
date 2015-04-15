//
//  Repo.swift
//  GitHubToGo
//
//  Created by Josh Nagel on 4/13/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class Repository {
  
  let id: Int
  let name: String
  let htmlURL: String
  let description: String
  let score: Double
  let ownerId: Int
  let login: String
  let avatarUrl: String
  var avatarImage: UIImage?
  
  
  init(id: Int, name : String, login : String, htmlURL : String, description : String, score: Double, ownerId: Int, avatarUrl: String) {
    self.id = id
    self.name = name
    self.login = login
    self.htmlURL = htmlURL
    self.description = description
    self.score = score
    self.ownerId = ownerId
    self.avatarUrl = avatarUrl
  }
}