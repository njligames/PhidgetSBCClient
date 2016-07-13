//
//  Date.swift
//  PhidgetSBCClient
//
//  Created by James Folk on 7/13/16.
//  Copyright © 2016 NJLIGames Ltd. All rights reserved.
//

import Foundation

class Date {
    
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
        
        let components = NSCalendar.currentCalendar().components([.Month, .Day, .Year, .Hour, .Minute, .Second], fromDate: date)
        let dict: [String:String] = [
            "month" : String(components.month),
            "day"   : String(components.day),
            "year"  : String(components.year),
            "hour"  : String(components.hour),
            "minute": String(components.minute),
            "second"  : String(components.second)
        ]
        
        return dict
    }
    //"%s-%s-%s %s:%s:%s"
    //yyyy-MM-dd HH:mm:ss
    //yyyy-MM-dd
    class func parse(dateStr:String, format:String="yyyy-MM-dd HH:mm:ss") -> [String:String] {
        let dateFmt = NSDateFormatter()
        dateFmt.timeZone = NSTimeZone.defaultTimeZone()
        dateFmt.dateFormat = format
        let date = dateFmt.dateFromString(dateStr)!
        
        let components = NSCalendar.currentCalendar().components([.Month, .Day, .Year, .Hour, .Minute, .Second], fromDate: date)
        let dict: [String:String] = [
            "month" : String(components.month),
            "day"   : String(components.day),
            "year"  : String(components.year),
            "hour"  : String(components.hour),
            "minute": String(components.minute),
            "second"  : String(components.second)
        ]
        
        return dict
    }
    
    
}