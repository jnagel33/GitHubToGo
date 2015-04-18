//
//  LoginViewController.swift
//  GitHubToGo
//
//  Created by Josh Nagel on 4/14/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  var oathService: OAuthService?
  let transitionDuration = 0.5
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func loginPressed(sender: UIButton) {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    self.oathService = appDelegate.oathService
    
    self.oathService?.requestAccess({ [weak self] () -> () in
      let window = appDelegate.window
      let navigationController = window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("MainMenuNav") as! UINavigationController
      UIView.transitionFromView(self!.view, toView: navigationController.view, duration: self!.transitionDuration, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: { (finished) -> Void in
        if finished {
          window?.rootViewController = navigationController
        }
      })
    })
  }
}
