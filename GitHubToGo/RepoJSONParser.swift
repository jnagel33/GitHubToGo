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
        if let name = item["name"] as? String,
                url = item["html_url"] as? String,
        description = item["description"] as? String,
              owner = item["owner"] as? [String: AnyObject],
          login = owner["login"] as? String {
          let repository = Repository(name: name, login: login, htmlURL: url, description: description)
            repositories.append(repository)
        }
      }
    }
    return repositories
  }
}
