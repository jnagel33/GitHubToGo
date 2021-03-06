//
//  RepoJSONParser.swift
//  GitHubToGo
//
//  Created by Josh Nagel on 4/13/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import Foundation

class RepoJSONParser {
  
  class func getRepositoriesFromJSONData(data: NSData) -> [Repository]? {
    var repositories = [Repository]()
    var error: NSError?
    
    if let jsonObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? [String: AnyObject], items = jsonObject["items"] as? [[String: AnyObject]] {
      for item in  items {
        if let id = item["id"] as? Int,
             name = item["name"] as? String,
              url = item["html_url"] as? String,
      description = item["description"] as? String,
            score = item["score"] as? Double,
            owner = item["owner"] as? [String: AnyObject],
            login = owner["login"] as? String,
        avatarUrl = owner["avatar_url"] as? String,
        updatedAt = item["updated_at"] as? String {
          
          let repository = Repository(id: id, name: name, login: login, htmlURL: url, description: description, score: score, avatarUrl: avatarUrl, updatedAt: updatedAt)
          repositories.append(repository)
        }
      }
    }
    return repositories
  }
  
  class func getUserRepositories(data: NSData) -> [Repository]? {
    var repositories = [Repository]()
    var error: NSError?
    
    if let jsonObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? [[String: AnyObject]] {
      for item in  jsonObject {
        if let owner = item["owner"] as? [String: AnyObject],
          id = owner["id"] as? Int,
          avatarUrl = owner["avatar_url"] as? String,
          login = owner["login"] as? String,
          name = item["name"] as? String,
          url = item["html_url"] as? String,
          description = item["description"] as? String,
        updatedAt = item["updated_at"] as? String {
            
          let repository = Repository(id: id, name: name, login: login, htmlURL: url, description: description, score: nil, avatarUrl: avatarUrl, updatedAt: updatedAt)
            repositories.append(repository)
        }
      }
    }
    return repositories
  }
}
