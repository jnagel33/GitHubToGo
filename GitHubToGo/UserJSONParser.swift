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
        if let id = user["id"] as? Int,
            login = user["login"] as? String,
        avatarUrl = user["avatar_url"] as? String {
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
  followers = userInfo["followers"] as? Int {
    
    var bio: String?
    var company: String?
    var email: String?
    var location: String?
    var name: String?
    var hireable: Bool?
    
    if let userName = userInfo["name"] as? String {
      name = userName
    }
    if let userCompany = userInfo["company"] as? String {
      company = userCompany
    }
    if let userBio = userInfo["bio"] as? String {
      bio = userBio
    }
    if let userEmail = userInfo["email"] as? String {
      email = userEmail
    }
    if let userLocation = userInfo["location"] as? String {
     location = userLocation
    }
    if let isHireable = userInfo["hireable"] as? Bool {
      hireable = isHireable
    }
    let user = User(id: id, login: login, avatarUrl: avatarUrl, name: name, email: email, company: company, location: location, bio: bio, followers: followers, hireable: hireable)
    returnUser = user
    }
    return returnUser!
  }
}
