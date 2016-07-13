//
//  Date.swift
//  PhidgetSBCClient
//
//  Created by James Folk on 7/13/16.
//  Copyright © 2016 NJLIGames Ltd. All rights reserved.
//

import Foundation

class Date {
    
    private class func createDict(date:NSDate) -> [String:String] {
        let components = NSCalendar.currentCalendar().components([.Month, .Day, .Year, .Hour, .Minute, .Second], fromDate: date)
        
        let month = String(format: "%02d", components.month)
        let day = String(format: "%02d", components.day)
        let year = String(format: "%04d", components.year)
        let hour = String(format: "%02d", components.hour)
        let minute = String(format: "%02d", components.minute)
        let second = String(format: "%02d", components.second)
        
        let dict: [String:String] = [
            "month" : month,
            "day"   : day,
            "year"  : year,
            "hour"  : hour,
            "minute": minute,
            "second"  : second
        ]
        
        return dict
    }
    class func from(year:Int, month:Int, day:Int, hour:Int, minute:Int, second:Int) -> [String:String] {
        let c = NSDateComponents()
        c.year = year
        c.month = month
        c.day = day
        c.hour = hour
        c.minute = minute
        c.second = second
        
        let gregorian = NSCalendar(identifier:NSCalendarIdentifierGregorian)
        let date = gregorian!.dateFromComponents(c)! as NSDate
        
        return Date.createDict(date)
    }
    //"%s-%s-%s %s:%s:%s"
    //yyyy-MM-dd HH:mm:ss
    //yyyy-MM-dd
    class func parse(dateStr:String, format:String="yyyy-MM-dd HH:mm:ss") -> [String:String] {
        let dateFmt = NSDateFormatter()
        dateFmt.timeZone = NSTimeZone.defaultTimeZone()
        dateFmt.dateFormat = format
        let date = dateFmt.dateFromString(dateStr)!
        
        return Date.createDict(date)
    }
    
    class func now() -> [String:String] {
        let date = NSDate()
        
        return Date.createDict(date)
    }
    
    class func distantPast() -> [String:String] {
        let date = NSDate.distantPast()
        
        return Date.createDict(date)
    }
    
    class func distantFuture() -> [String:String] {
        let date = NSDate.distantFuture()
        
        return Date.createDict(date)
    }
    
}