//
//  NSDateExtension.swift
//  GitHubToGo
//
//  Created by Josh Nagel on 4/17/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import Foundation

extension NSDate {

    func yearsFrom(date:NSDate) -> Int{
      return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear, fromDate: date, toDate: self, options: nil).year
    }
    func monthsFrom(date:NSDate) -> Int{
      return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitMonth, fromDate: date, toDate: self, options: nil).month
    }
    func weeksFrom(date:NSDate) -> Int{
      return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekOfYear, fromDate: date, toDate: self, options: nil).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
      return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitDay, fromDate: date, toDate: self, options: nil).day
    }
    func hoursFrom(date:NSDate) -> Int{
      return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour, fromDate: date, toDate: self, options: nil).hour
    }
    func minutesFrom(date:NSDate) -> Int{
      return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitMinute, fromDate: date, toDate: self, options: nil).minute
    }
    func secondsFrom(date:NSDate) -> Int{
      return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitSecond, fromDate: date, toDate: self, options: nil).second
    }
    func offsetFrom(date:NSDate) -> String {
      if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
      if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
      if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
      if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
      if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
      if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
      if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
      return ""
    }
  }
  
  let date1 = NSCalendar.currentCalendar().dateWithEra(1, year: 2014, month: 11, day: 28, hour: 5, minute: 9, second: 0, nanosecond: 0)!
  let date2 = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 8, day: 28, hour: 5, minute: 9, second: 0, nanosecond: 0)!
  
  let years = date2.yearsFrom(date1)     // 0
  let months = date2.monthsFrom(date1)   // 9
  let weeks = date2.weeksFrom(date1)     // 39
  let days = date2.daysFrom(date1)       // 273
  let hours = date2.hoursFrom(date1)     // 6,553
  let minutes = date2.minutesFrom(date1) // 393,180
  let seconds = date2.secondsFrom(date1) // 23,590,800
  
  let timeOffset = date2.offsetFrom(date1) // "9M"
  
  let date3 = NSCalendar.currentCalendar().dateWithEra(1, year: 2014, month: 11, day: 28, hour: 5, minute: 9, second: 0, nanosecond: 0)!
  let date4 = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 11, day: 28, hour: 5, minute: 9, second: 0, nanosecond: 0)!
  
  let timeOffset2 = date4.offsetFrom(date3) // "1y"
  
  let timeOffset3 = NSDate().offsetFrom(date3) // "54m"