//
//  UserRepositoryWebViewController.swift
//  GitHubToGo
//
//  Created by Josh Nagel on 4/16/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class UserRepositoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  var repositories = [Repository]()
  let gitHubService = GitHubService()
  var minutesInAnHour: Int = 60
  var dateFormatter = NSDateFormatter()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.dataSource = self
    self.tableView.delegate = self
    
    self.gitHubService.getRepositories { [weak self] (repositories, error) -> Void in
      if self != nil {
        if error != nil {
          let alert = UIAlertController(title: "An error occured", message: error, preferredStyle: .Alert)
          let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
          alert.addAction(okAction)
          self!.presentViewController(alert, animated: true, completion: nil)
        } else {
          self!.repositories = repositories!
          self!.repositories.sort({ (r1, r2) -> Bool in
            let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
            self!.dateFormatter.locale = enUSPosixLocale
            self!.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            let date1 = self!.dateFormatter.dateFromString(r1.updatedAt!)
            let hourDif1 = date1?.hoursFrom(NSDate())
            
            let date2 = self!.dateFormatter.dateFromString(r2.updatedAt!)
            let hourDif2 = date2?.hoursFrom(NSDate())
            
            return hourDif1 > hourDif2
          })
          self!.tableView.reloadData()
        }
      }
    }
  }
  
  //MARK:
  //MARK: UITableViewDataSource
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.repositories.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("UserRepoCell", forIndexPath: indexPath) as! UITableViewCell
    cell.textLabel!.text = repositories[indexPath.row].name
    
    let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
    self.dateFormatter.locale = enUSPosixLocale
    self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    let date = self.dateFormatter.dateFromString(repositories[indexPath.row].updatedAt!)
    
    var displayText: String!
    let dayDifference = date?.daysFrom(NSDate())
    let hourDifference = date?.hoursFrom(NSDate())
    let minuteDifference = date?.minutesFrom(NSDate())
    if hourDifference == 0 {
      displayText = "\(abs(minuteDifference!)) minutes ago"
    } else if dayDifference == 0 {
    let minuteRemainder = hourDifference! % self.minutesInAnHour
      displayText = "\(abs(hourDifference!)) hours, \(abs(minuteRemainder)) minutes ago"
    } else {
      displayText = "\(abs(dayDifference!)) days"
    }
    cell.detailTextLabel!.text = displayText
    
    return cell
  }
  
  //MARK:
  //MARK: UITableViewDelegate
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  //MARK:
  //MARK: prepareForSegue
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowUserRepoWebView" {
      let destinationController = segue.destinationViewController as? UserRepoWebViewController
      let indexPath = self.tableView.indexPathsForSelectedRows()!.first as! NSIndexPath
      destinationController!.repository = self.repositories[indexPath.row]
    }
  }
}
