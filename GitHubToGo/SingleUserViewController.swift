//
//  SingleUserViewController.swift
//  GitHubToGo
//
//  Created by Josh Nagel on 4/14/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class SingleUserViewController: UIViewController {

  var selectedUser: User!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    println(selectedUser.login)
  }
}
