//
//  RepositoryWebViewController.swift
//  GitHubToGo
//
//  Created by Josh Nagel on 4/16/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit
import WebKit

class RepositoryWebViewController: UIViewController {

  var webView: WKWebView!
  var selectedRepo: Repository!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    let urlRequest = NSURLRequest(URL: NSURL(string: self.selectedRepo.htmlURL)!)
    self.webView = WKWebView(frame: self.view.frame)
    self.view.addSubview(self.webView)
    self.webView.loadRequest(urlRequest)
  }
}
