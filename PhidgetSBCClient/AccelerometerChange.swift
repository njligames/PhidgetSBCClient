//
//  AccelerometerChange.swift
//  PhidgetSBCClient
//
//  Created by James Folk on 7/12/16.
//  Copyright © 2016 NJLIGames Ltd. All rights reserved.
//

import Foundation
import CoreData

class AccelerometerChange : PhidgetLog, CustomDebugStringConvertible
{
    var debugDescription: String {
        get
        {
            return String.localizedStringWithFormat("%@, %@", self.id, self.logTime)
        }
    }
    
    override class func sqlTableName() -> String {
        return "ACCELEROMETER_CHANGE"
    }
    
    override func tableName() -> String
    {
        return AccelerometerChange.sqlTableName()
    }
    
    private var _acceleration : Double = 0.0
    var acceleration : Double {
        get { return _acceleration }
    }
    
    required init(json: [String: AnyObject])
    {
        super.init(json: json)
        
        if let t = json["ACCELERATION"] as? Double
        {
            self._acceleration = t
        }
    }
    
    required init(managedObject: NSManagedObject)
    {
        super.init(managedObject: managedObject)
        
        if let t = managedObject.valueForKey("acceleration") as? Double
        {
            self._acceleration = t
        }
    }
    
    override func save(managedObject: NSManagedObject)
    {
        super.save(managedObject)
        
        managedObject.setValue(acceleration, forKey: "acceleration")
    }
}

