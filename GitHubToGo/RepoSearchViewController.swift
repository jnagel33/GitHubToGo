//
//  RepoViewController.swift
//  GitHubToGo
//
//  Created by Josh Nagel on 4/13/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class RepoSearchViewController: UITableViewController, UISearchBarDelegate {

  @IBOutlet weak var searchBar: UISearchBar!
  
  var tapGestureRecognizer: UITapGestureRecognizer?
  var repositories = [Repository]()
  let gitHubService = GitHubService()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Repository Search"
    self.tableView.dataSource = self
    self.searchBar.delegate = self
  }
  
  func dismissKeyboard() {
    self.searchBar.resignFirstResponder()
    self.view.removeGestureRecognizer(self.tapGestureRecognizer!)
  }
  
  //MARK:
  //MARK: UITableViewDataSource
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return repositories.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("RepoSearchCell", forIndexPath: indexPath) as! RepoSearchTableViewCell
    cell.configureCell(self.repositories[indexPath.row])
    return cell
  }
  
  //MARK:
  //MARK: UISearchBarDelagate
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    self.dismissKeyboard()
    gitHubService.getRepositorySearchResults(searchBar.text, completionHandler: { [weak self] (repositories, error) -> Void in
      if self != nil {
        if error != nil {
          let alert = UIAlertController(title: "An error occured", message: error, preferredStyle: .Alert)
          let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
          alert.addAction(okAction)
          self!.presentViewController(alert, animated: true, completion: nil)
        } else {
          self!.repositories = repositories!
          self!.tableView.reloadData()
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
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty {
      self.repositories.removeAll(keepCapacity: false)
      self.tableView.reloadData()
    }
  }
  
  func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
    tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
    self.view.addGestureRecognizer(self.tapGestureRecognizer!)
    return true
  }

  //MARK:
  //MARK: prepareForSegue
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowRepoWebView" {
      let destinationController = segue.destinationViewController as? RepositoryWebViewController
      let indexPath = self.tableView.indexPathsForSelectedRows()!.first as! NSIndexPath
      destinationController!.selectedRepo = self.repositories[indexPath.row]
    }
  }
}
