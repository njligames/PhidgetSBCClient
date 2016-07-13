//
//  PhidgetLog.swift
//  PhidgetSBCClient
//
//  Created by James Folk on 7/12/16.
//  Copyright © 2016 NJLIGames Ltd. All rights reserved.
//

import Foundation
import CoreData

class PhidgetLog
{
    private var _index : NSNumber = 0
    var index : NSNumber {
        get { return _index }
    }
    
    private var _logTime : NSDate = NSDate(jsonDate: "/Date(1385677404333)/")!
    var logTime : NSDate {
        get { return _logTime }
    }
    
    private var _id : NSNumber = 0
    var id : NSNumber {
        get { return _id }
    }
    
    private var _serialNumber : NSNumber = 0.0
    var serialNumber : NSNumber {
        get { return _serialNumber }
    }
    
    required init(json: [String: AnyObject]) {
        if let t = json["IDX"] as? NSNumber
        {
            self._index = t
        }
        
        if let t = json["LOGTIME"] as? NSNumber
        {
            
            let s = "/Date(" + String(t.longLongValue) + ")/"
            self._logTime = NSDate(jsonDate: s)!
        }
        
        if let t = json["ID"] as? NSNumber
        {
            self._id = t
        }
        
        if let t = json["SERIALNUMBER"] as? NSNumber
        {
            self._serialNumber = t
        }
    }
    
    required init(managedObject: NSManagedObject)
    {
        
        if let t = managedObject.valueForKey("index") as? NSNumber
        {
            self._index = t
        }
        
        if let t = managedObject.valueForKey("logtime") as? NSNumber
        {
            
            let s = "/Date(" + String(t.longLongValue) + ")/"
            self._logTime = NSDate(jsonDate: s)!
        }
        
        if let t = managedObject.valueForKey("id") as? NSNumber
        {
            self._id = t
        }
        
        if let t = managedObject.valueForKey("serialnumber") as? NSNumber
        {
            self._serialNumber = t
        }
    }
    
    func save(managedObject: NSManagedObject)
    {
        managedObject.setValue(id, forKey: "id")
        managedObject.setValue(index, forKey: "index")
        managedObject.setValue(logTime, forKey: "logtime")
        managedObject.setValue(serialNumber, forKey: "serialnumber")
    }
    
    func tableName() -> String
    {
        return PhidgetLog.sqlTableName()
    }
    
    class func sqlTableName() -> String {
        return ""
    }
    
    class func queryRange(url: String, from: [String:String], to: [String:String], onCompletion: ([[String: AnyObject]]) -> Void)
    {
        let baseBody : [String: AnyObject] = ["table":sqlTableName(),
                                              "year_from":from["year"]!,
                                              "month_from":from["month"]!,
                                              "day_from":from["day"]!,
                                              "hour_from":from["hour"]!,
                                              "minute_from":from["minute"]!,
                                              "second_from":from["second"]!,
                                              "year_to":to["year"]!,
                                              "month_to":to["month"]!,
                                              "day_to":to["day"]!,
                                              "hour_to":to["hour"]!,
                                              "minute_to":to["minute"]!,
                                              "second_to":to["second"]!]
        
        RestApiManager.sharedInstance.baseURL = url
        RestApiManager.sharedInstance.post(baseBody, onCompletion: { (json:AnyObject) in
            if let v = json[sqlTableName()] as? String
            {
                if let logs = v.parseJSONString as? [[String: AnyObject]]
                {
                    onCompletion(logs)
                }
            }
        })
    }
    
    class func queryUntilNow(url: String, from: [String:String], onCompletion: ([[String: AnyObject]]) -> Void)
    {
        queryRange(url, from: from, to: Date.now(), onCompletion: onCompletion)
    }
    
    class func query(url: String, onCompletion: ([[String: AnyObject]]) -> Void)
    {
        queryRange(url, from: Date.distantPast(), to: Date.distantFuture(), onCompletion: onCompletion)
    }
}
