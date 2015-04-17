//
//  RepoTableViewController.swift
//  GitHubToGo
//
//  Created by Josh Nagel on 4/13/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class MainMenuViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowAuthenticatedUser" {
      let destinationController = segue.destinationViewController as! SingleUserViewController
    }
  }
}
