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
          ownerId = owner["id"] as? Int,
            login = owner["login"] as? String,
        avatarUrl = owner["avatar_url"] as? String
        {
          let repository = Repository(id: id, name: name, login: login, htmlURL: url, description: description, score: score, ownerId: ownerId, avatarUrl: avatarUrl)
            repositories.append(repository)
        }
      }
    }
    return repositories
  }
}
