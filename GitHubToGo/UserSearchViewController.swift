//
//  UserSearchViewController.swift
//  GitHubToGo
//
//  Created by Josh Nagel on 4/14/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class UserSearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {

  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var collectionView: UICollectionView!
  
  var users = [User]()
  let gitHubService = GitHubService()
  var tapGestureRecognizer: UITapGestureRecognizer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "User Search"
    
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    self.searchBar.delegate = self
  }
  
  func dismissKeyboard(tap: UIGestureRecognizer?) {
    self.searchBar.resignFirstResponder()
    self.view.removeGestureRecognizer(self.tapGestureRecognizer!)
    
  }
  
  //MARK:
  //MARK: UICollectionViewDataSource
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return users.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UserSearchCell", forIndexPath: indexPath) as! UserSearchCollectionViewCell
    cell.tag++
    let tag = cell.tag
    
    cell.avatarImageView.image = nil
    cell.loginNameLabel.text = nil
    
    let user = users[indexPath.row]
    cell.loginNameLabel.text = user.login
      if let image = user.avatarImage {
        cell.avatarImageView.image = image
      } else {
        ImageService.sharedService.fetchProfileImage(user.avatarUrl, completionHandler: { (image) -> () in
          if tag == cell.tag {
            let resizedImage = ImageResizer.resizeImage(image!, size: CGSize(width: 100, height: 100))
            user.avatarImage = resizedImage
            cell.avatarImageView.image = resizedImage
          }
        })
    }
    
    
    return cell
  }
  
  //MARK:
  //MARK: UICollectionViewDelegate
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    //Add custom transition
  }
  
  //MARK:
  //MARK: UISearchBarDelegate
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    self.dismissKeyboard(nil)
    self.gitHubService.getUserSearchResults(searchBar.text, completionHandler: { [weak self] (users, error) -> Void in
      if self != nil {
        if error != nil {
          // handle error
        } else {
          self!.users = users!
          self!.collectionView.reloadData()
        }
      }
    })
  }
  
  func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
    self.view.addGestureRecognizer(self.tapGestureRecognizer!)
  }
}
