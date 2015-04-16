//
//  RepoDetailsViewController.swift
//  GitHubToGo
//
//  Created by Josh Nagel on 4/14/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class RepoDetailsViewController: UIViewController {

  var selectedRepository: Repository!
  let gitHubService = GitHubService()
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
