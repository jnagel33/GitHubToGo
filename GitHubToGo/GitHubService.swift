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
  private let authenticatedUserReposURL = "https://api.github.com/user/repos"
  
  //TODO status code check
  func getRepositorySearchResults(searchText: String, completionHandler: ([Repository]?, String?) -> Void) {
    if let encodedSearchText = searchText.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
      let accessToken = NSUserDefaults.standardUserDefaults().valueForKey("accessToken") as? String
      let urlStr = self.searchRepositoriesURL + "?access_token=\(accessToken!)&q=\(encodedSearchText)"
      let url = NSURL(string: urlStr)
      let requestURL = NSURLRequest(URL: url!)
      
      let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(requestURL, completionHandler: { (data, response, error) -> Void in
        var errorDescription: String? = nil
        var repositories: [Repository]? = nil
        if error != nil {
          errorDescription = error.description
        } else {
          if let httpResponse = response as? NSHTTPURLResponse {
            let status = self.checkStatusCode(httpResponse.statusCode)
            if status.readyToParse {
              repositories = RepoJSONParser.getRepositoriesFromJSONData(data)
            } else {
              errorDescription = status.errorDescription
            }
          }
        }
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          completionHandler(repositories, errorDescription)
        })
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
        var errorDescription: String? = nil
        var users: [User]? = nil
        if error != nil {
          errorDescription = error.description
        } else {
          if let httpResponse = response as? NSHTTPURLResponse {
            let status = self.checkStatusCode(httpResponse.statusCode)
            if status.readyToParse {
              users = UserJSONParser.getUsersFromJSONData(data!)
            } else {
              errorDescription = status.errorDescription
            }
          }
        }
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          completionHandler(users, errorDescription)
        })
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
      var errorDescription: String? = nil
      var user: User? = nil
      if error != nil {
        errorDescription = error.description
      } else {
        if let httpResponse = response as? NSHTTPURLResponse {
          let status = self.checkStatusCode(httpResponse.statusCode)
          if status.readyToParse {
            user = UserJSONParser.getUserFromJSONData(data!)
          } else {
            errorDescription = status.errorDescription
          }
        }
      }
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
        completionHandler(user, errorDescription)
      })
    })
    dataTask.resume()
  }
  
  func getRepository(completionHandler: ([Repository]?, String?) -> Void) {
    let accessToken = NSUserDefaults.standardUserDefaults().valueForKey("accessToken") as? String
    var urlStr = "\(self.authenticatedUserReposURL)?access_token=\(accessToken!)"
    let url = NSURL(string: urlStr)
    let requestUrl = NSURLRequest(URL: url!)
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(requestUrl, completionHandler: { (data, response, error) -> Void in
      var errorDescription: String? = nil
      var repositories: [Repository]? = nil
      if error != nil {
        errorDescription = error.description
      } else {
        if let httpResponse = response as? NSHTTPURLResponse {
          let status = self.checkStatusCode(httpResponse.statusCode)
          if status.readyToParse {
            repositories = RepoJSONParser.getUserRepositories(data!)
          } else {
            errorDescription = status.errorDescription
          }
        }
      }
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
        completionHandler(repositories, errorDescription)
      })
    })
    dataTask.resume()
  }
  
  private func checkStatusCode(statusCode: Int) -> (readyToParse: Bool, errorDescription: String?) {
    var readyToParse: Bool = false
    var errorDescription: String? = nil
    switch statusCode {
    case 200...299:
      readyToParse = true
    case 400...499:
      errorDescription = "Oops, please try again."
    case 500...599:
      errorDescription = "Service is down, please try again later."
    default:
      errorDescription = "Try again"
    }
    return (readyToParse, errorDescription)
  }
}
