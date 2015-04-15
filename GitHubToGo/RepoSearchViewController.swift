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
  var selectedRepository: Repository?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Repository Search"
    self.navigationItem.backBarButtonItem?.title = "Main"
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.searchBar.delegate = self
  }
  
  func dismissKeyboard() {
    self.searchBar.resignFirstResponder()
    self.view.removeGestureRecognizer(self.tapGestureRecognizer!)
//    self.tapGestureRecognizer = nil
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
  //MARK: UITableViewDelegate
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    self.selectedRepository = self.repositories[indexPath.row]
    self.performSegueWithIdentifier("ShowRepoDetails", sender: self)
  }
  
  
  //MARK: UISearchBarDelagate
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    self.dismissKeyboard()
    gitHubService.getRepositorySearchResults(searchBar.text, completionHandler: { [weak self] (repositories, error) -> Void in
      if self != nil {
        if error != nil {
          print(error)
        } else {
          self!.repositories = repositories!
          self!.tableView.reloadData()
        }
      }
    })
  }
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    if count(searchText) >= 5 {
      gitHubService.getRepositorySearchResults(searchBar.text, completionHandler: { [weak self] (repositories, error) -> Void in
        if self != nil {
          if error != nil {
            print(error)
          } else {
            self!.repositories = repositories!
            self!.tableView.reloadData()
          }
        }
      })
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
    if segue.identifier == "ShowRepoDetails" {
      let navigationController = segue.destinationViewController as? RepoDetailsViewController
      navigationController!.selectedRepository = self.selectedRepository
    }
  }
}
