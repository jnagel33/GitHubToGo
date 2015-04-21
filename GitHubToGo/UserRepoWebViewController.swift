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
    var top = NSLayoutConstraint(item: self.webView, attribute: NSLayoutAttribute.Top, relatedBy: .Equal, toItem: self.view, attribute: NSLayoutAttribute.TopMargin, multiplier: 1.0, constant: 0)
    self.view.addConstraint(top)
    var bottom = NSLayoutConstraint(item: self.webView, attribute: NSLayoutAttribute.Bottom, relatedBy: .Equal, toItem:
      self.view, attribute: NSLayoutAttribute.BottomMargin, multiplier: 1.0, constant: 0)
    self.view.addConstraint(bottom)
    var left = NSLayoutConstraint(item: self.webView, attribute: .LeadingMargin, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 0.0)
    self.view.addConstraint(left)
    var right = NSLayoutConstraint(item: self.webView, attribute: .TrailingMargin, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1.0, constant: 0)
    self.view.addConstraint(right)
    self.webView.loadRequest(urlRequest)
    self.webView.setTranslatesAutoresizingMaskIntoConstraints(false)
  }
}
