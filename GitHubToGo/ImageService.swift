//
//  ImageService.swift
//  GitHubToGo
//
//  Created by Josh Nagel on 4/14/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class ImageService {
  
  class var sharedService: ImageService {
    struct Static {
      static var instance: ImageService?
    }
    if Static.instance == nil {
      Static.instance = ImageService()
    }
    return Static.instance!
  }
  
  let imageQueue = NSOperationQueue()
  
  func fetchProfileImage(url : String, completionHandler : (UIImage?) ->()) {
    self.imageQueue.addOperationWithBlock { () -> Void in
      if let url = NSURL(string: url) {
        if let imageData = NSData(contentsOfURL: url) {
          if let image = UIImage(data: imageData) {
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
              completionHandler(image)
            })
          }
        }
      }
    }
  }
}