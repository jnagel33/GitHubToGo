//
//  UserJSONParser.swift
//  GitHubToGo
//
//  Created by Josh Nagel on 4/14/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import Foundation

class UserJSONParser {
  
  class func getUsersFromJSONData(data: NSData) -> [User] {
    var users = [User]()
    var error: NSError?
    
    if let jsonObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? [String: AnyObject],
    searchUsers = jsonObject["items"] as? [[String: AnyObject]] {
      for user in searchUsers {
        if let id = user["id"] as? Int, login = user["login"] as? String, avatarUrl = user["avatar_url"] as? String {
          let user = User(id: id, login: login, avatarUrl: avatarUrl)
          users.append(user)
        }
      }
    }
    return users
  }
  
  
  class func getUserFromJSONData(data: NSData) -> User {
    var error: NSError?
    var returnUser: User?
    
    if let userInfo = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? [String: AnyObject],
         id = userInfo["id"] as? Int,
      login = userInfo["login"] as? String,
  avatarUrl = userInfo["avatar_url"] as? String,
    company = userInfo["company"] as? String,
        bio = userInfo["bio"] as? String,
  followers = userInfo["followers"] as? Int {
        let user = User(id: id, login: login, avatarUrl: avatarUrl)
        returnUser = user
    }
    return returnUser!
  }
}
