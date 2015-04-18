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
  
  var users: [User]! = [User]()
  let gitHubService = GitHubService()
  var tapGestureRecognizer: UITapGestureRecognizer?
  var avatarImageViewSize = CGSize(width: 100, height: 100)
  let avatarImageViewCornerRadius: CGFloat = 40
  let transformSpalshEffect: CGFloat = 0.3
  let animationDuration = 0.2
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "User Search"
    
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    self.searchBar.delegate = self
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    self.navigationController!.delegate = self
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    self.navigationController!.delegate = nil
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
    cell.avatarImageView.layer.cornerRadius = self.avatarImageViewCornerRadius
    cell.avatarImageView.layer.masksToBounds = true
    
    let user = users[indexPath.row]
    cell.loginNameLabel.text = user.login
      if let image = user.avatarImage {
        let resizedImage = ImageResizer.resizeImage(image, size: self.avatarImageViewSize)
        cell.avatarImageView.image = resizedImage
      } else {
        ImageService.sharedService.fetchProfileImage(user.avatarUrl, completionHandler: { [weak self] (image) -> () in
          if self != nil {
            if image != nil {
              if tag == cell.tag {
                cell.avatarImageView.alpha = 0
                cell.avatarImageView.transform = CGAffineTransformMakeScale(self!.transformSpalshEffect, self!.transformSpalshEffect)
                user.avatarImage = image
                let resizedImage = ImageResizer.resizeImage(image!, size: self!.avatarImageViewSize)
                cell.avatarImageView.image = image
                UIView.animateWithDuration(self!.animationDuration, animations: { () -> Void in
                  cell.avatarImageView.alpha = 1
                  cell.avatarImageView.transform  = CGAffineTransformMakeScale(1, 1)
                })
              }
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
          let alert = UIAlertController(title: "An error occured", message: error, preferredStyle: .Alert)
          let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
          alert.addAction(okAction)
          self!.presentViewController(alert, animated: true, completion: nil)
        } else {
          self!.users = users
          self!.collectionView.reloadSections(NSIndexSet(index: 0))
        }
      }
    })
  }
  
  func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    if text.validForURL() {
      searchBar.tintColor = UIColor.blackColor()
      return true
    } else {
      searchBar.tintColor = UIColor.redColor()
      return false
    }
  }
  
  func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
    self.view.addGestureRecognizer(self.tapGestureRecognizer!)
  }
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty {
      self.users.removeAll(keepCapacity: false)
      self.collectionView.reloadSections(NSIndexSet(index: 0))
    }
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
    }
  }
  
  @IBAction func prepareForUnwind(sender: UIStoryboardSegue) {
  }
}
