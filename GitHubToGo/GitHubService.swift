//
//  GitHubService.swift
//  GitHubToGo
//
//  Created by Josh Nagel on 4/13/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import Foundation

class GitHubService {
  
  private let searchRepositoriesURL = "https://api.github.com/search/repositories"
  private let searchUsersURL = "https://api.github.com/search/users"
  private let userURL = "https://api.github.com/users"
  private let authenticatedUserURL = "https://api.github.com/user"
  
  func getRepositorySearchResults(searchText: String, completionHandler: ([Repository]?, String?) -> Void) {
    if let encodedSearchText = searchText.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
      let accessToken = NSUserDefaults.standardUserDefaults().valueForKey("accessToken") as? String
      let urlStr = self.searchRepositoriesURL + "?access_token=\(accessToken!)&q=\(encodedSearchText)"
      let url = NSURL(string: urlStr)
      let requestURL = NSURLRequest(URL: url!)
      
      let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(requestURL, completionHandler: { (data, response, error) -> Void in
        if error != nil {
          // handle error
        } else {
          if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
              let repositories = RepoJSONParser.getRepositoriesFromJSONData(data)
              NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completionHandler(repositories, nil)
              })
            }
          }
        }
      })
      dataTask.resume()
    }
  }
  
  func getUserSearchResults(searchText: String, completionHandler: ([User]?, String?) -> Void) {
    if let encodedSearchText = searchText.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
      let accessToken = NSUserDefaults.standardUserDefaults().valueForKey("accessToken") as? String
      let urlStr = self.searchUsersURL + "?access_token=\(accessToken!)&q=\(encodedSearchText)"
      let url = NSURL(string: urlStr)
      let requestUrl = NSURLRequest(URL: url!)
      let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(requestUrl, completionHandler: { (data, response, error) -> Void in
        if error != nil {
          // handle error
        } else {
          if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
              let users = UserJSONParser.getUsersFromJSONData(data!)
              NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completionHandler(users, nil)
              })
            }
          }
        }
      })
      dataTask.resume()
    }
  }
  
  func getUser(login: String?, completionHandler: (User?, String?) -> Void) {
    let accessToken = NSUserDefaults.standardUserDefaults().valueForKey("accessToken") as? String
    var urlStr = "\(self.authenticatedUserURL)?access_token=\(accessToken!)"
    if let username = login {
      urlStr = self.userURL + "/\(username)?access_token=\(accessToken!)"
    }
    let url = NSURL(string: urlStr)
    let requestUrl = NSURLRequest(URL: url!)
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(requestUrl, completionHandler: { (data, response, error) -> Void in
      if error != nil {
        // handle error
      } else {
        if let httpResponse = response as? NSHTTPURLResponse {
          if httpResponse.statusCode == 200 {
            let user = UserJSONParser.getUserFromJSONData(data!)
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
              completionHandler(user, nil)
            })
          }
        }
      }
    })
    dataTask.resume()
  }
}
