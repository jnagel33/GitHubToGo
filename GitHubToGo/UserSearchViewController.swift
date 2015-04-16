//
//  UserSearchViewController.swift
//  GitHubToGo
//
//  Created by Josh Nagel on 4/14/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class UserSearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UINavigationControllerDelegate {

  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var collectionView: UICollectionView!
  
  var users = [User]()
  let gitHubService = GitHubService()
  var tapGestureRecognizer: UITapGestureRecognizer?
  var avatarImageViewSize = CGSize(width: 100, height: 100)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "User Search"
    
    self.navigationController!.delegate = self
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
        let resizedImage = ImageResizer.resizeImage(image, size: self.avatarImageViewSize)
        cell.avatarImageView.image = resizedImage
      } else {
        ImageService.sharedService.fetchProfileImage(user.avatarUrl, completionHandler: { [weak self] (image) -> () in
          if self != nil {
            if tag == cell.tag {
              cell.avatarImageView.alpha = 0
              cell.avatarImageView.layer.cornerRadius = 40
              cell.avatarImageView.layer.masksToBounds = true
              cell.avatarImageView.transform = CGAffineTransformMakeScale(1.3, 1.3)
              user.avatarImage = image
              let resizedImage = ImageResizer.resizeImage(image!, size: self!.avatarImageViewSize)
              cell.avatarImageView.image = resizedImage
              UIView.animateWithDuration(0.2, animations: { () -> Void in
                cell.avatarImageView.alpha = 1
                cell.avatarImageView.transform  = CGAffineTransformMakeScale(1.0, 1.0)
              })
            }
          }
        })
      }
      return cell
    }
  
  //MARK:
  //MARK: UICollectionViewDelegate
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    self.performSegueWithIdentifier("ShowUserDetail", sender: self)
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
  
  
  //MARK:
  //MARK: UINavigationControllerDelegate
  
  func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    if toVC is SingleUserViewController {
      return ToSingleUserAnimationViewController()
    }
    return nil
  }
  
  
  //MARK:
  //MARK: prepareForSegue
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowUserDetail" {
      let destinationController = segue.destinationViewController as! SingleUserViewController
      let selectedIndexPath = self.collectionView.indexPathsForSelectedItems().first as! NSIndexPath
      destinationController.selectedUser = self.users[selectedIndexPath.row]
      destinationController.isAuthenticatedUser = false
    }
  }
}
