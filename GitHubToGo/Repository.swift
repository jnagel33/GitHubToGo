//
//  Repo.swift
//  GitHubToGo
//
//  Created by Josh Nagel on 4/13/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import Foundation

struct Repository {
  
  let name : String
  let login : String
  let htmlURL : String
  let description : String
  
  
  init(name : String, login : String, htmlURL : String, description : String) {
    self.name = name
    self.login = login
    self.htmlURL = htmlURL
    self.description = description
  }
}