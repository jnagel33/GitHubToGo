//
//  OAuthService.swift
//  GitHubToGo
//
//  Created by Josh Nagel on 4/14/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class OAuthService {
  
  private var oauthRequestCompletionHandler: (() -> ())?
  
  func requestAccess(completionHandler: (() -> ())) {
    self.oauthRequestCompletionHandler = completionHandler
    let urlStr = "http://github.com/login/oauth/authorize?client_id=\(kClientID)&scope=user,public_repo"
    UIApplication.sharedApplication().openURL(NSURL(string: urlStr)!)
  }
  
  func handleRedirect(url: NSURL) {
    if let accessCode = url.query {
      let urlStr = "https://github.com/login/oauth/access_token?\(accessCode)&client_id=\(kClientID)&client_secret=\(kClientSecret)"
      let url = NSURL(string: urlStr)
      var requestURL = NSMutableURLRequest(URL: url!)
      requestURL.HTTPMethod = "POST"
      
      requestURL.setValue("application/json", forHTTPHeaderField: "Accept")
      
      let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(requestURL, completionHandler: { (data, response, error) -> Void in
        if error != nil {
          
        } else {
          if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
              var error: NSError?
              if let jsonObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? [String: AnyObject],  let accessToken = jsonObject["access_token"] as? String {
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setValue(accessToken, forKey: "accessToken")
                userDefaults.synchronize()
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                  self.oauthRequestCompletionHandler!()
                })
              }
            }
          }
        }
      })
      dataTask.resume()
    }
  }
}
