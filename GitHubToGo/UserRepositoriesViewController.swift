//
//  UserRepositoryWebViewController.swift
//  GitHubToGo
//
//  Created by Josh Nagel on 4/16/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class UserRepositoriesViewController: UIViewController, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  
  var repositories = [Repository]()
  let gitHubService = GitHubService()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.dataSource = self
    
    self.gitHubService.getRepository { (repositories, error) -> Void in
      if error != nil {
        
      } else {
        var repos = repositories!
        repos.sort({ (r1, r2) -> Bool in
          let dateFormatter = NSDateFormatter()
          let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
          dateFormatter.locale = enUSPosixLocale
         dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
          let date1 = dateFormatter.dateFromString(r1.updatedAt!)
          let hourDif1 = date1?.hoursFrom(NSDate())
          
          let date2 = dateFormatter.dateFromString(r2.updatedAt!)
          let hourDif2 = date2?.hoursFrom(NSDate())
          
          return hourDif1 > hourDif2
        })
        self.repositories = repos
        self.tableView.reloadData()
        
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
    
    let dateFormatter = NSDateFormatter()
    let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
    dateFormatter.locale = enUSPosixLocale
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    let date = dateFormatter.dateFromString(repositories[indexPath.row].updatedAt!)
    
    var displayText = ""
    let dayDif = date?.daysFrom(NSDate())
    let hourDif = date?.hoursFrom(NSDate())
    let minuteDif = date?.minutesFrom(NSDate())
    if hourDif == 0 {
      displayText = "\(abs(minuteDif!)) minutes ago"
    } else if dayDif == 0 {
    let minuteRemainder = hourDif! % 60
      displayText = "\(abs(hourDif!)) hours, \(abs(minuteRemainder)) minutes ago"
    } else {
      displayText = "\(abs(dayDif!)) days"
    }
    cell.detailTextLabel!.text = displayText
    
    return cell
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
