//
//  UserRepoWebViewController.swift
//  GitHubToGo
//
//  Created by Josh Nagel on 4/17/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit
import WebKit

class UserRepoWebViewController: UIViewController {

  var repository: Repository!
  
  var webView: WKWebView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let urlRequest = NSURLRequest(URL: NSURL(string: self.repository.htmlURL)!)
    self.webView = WKWebView(frame: self.view.frame)
    self.view.addSubview(self.webView)
    self.webView.loadRequest(urlRequest)
  }
}
