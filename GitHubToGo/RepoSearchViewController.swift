//
//  RepoViewController.swift
//  GitHubToGo
//
//  Created by Josh Nagel on 4/13/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class RepoSearchViewController: UITableViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var searchBar: UISearchBar!
  
  var repositories = [Repository]()
  let gitHubService = GitHubService()
  var selectedRepository: Repository?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Repository Search"
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.searchBar.delegate = self
    
    var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
    self.view.addGestureRecognizer(tapGestureRecognizer)
  }
  
  func dismissKeyboard(tap: UIGestureRecognizer?) {
    self.searchBar.resignFirstResponder()
    if let recognizers = self.view.gestureRecognizers {
      for recognizer in recognizers {
        self.view.removeGestureRecognizer(recognizer as! UIGestureRecognizer)
      }
    }
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
    self.dismissKeyboard(nil)
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
  
//  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//
//  }
  
  func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
    var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
    self.view.addGestureRecognizer(tapGestureRecognizer)
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
