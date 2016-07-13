//
//  InterfaceKitOutputChange.swift
//  PhidgetSBCClient
//
//  Created by James Folk on 7/12/16.
//  Copyright © 2016 NJLIGames Ltd. All rights reserved.
//

import Foundation
import CoreData

class InterfaceKitOutputChange : PhidgetLog, CustomDebugStringConvertible
{
    var debugDescription: String {
        get
        {
            return String.localizedStringWithFormat("%@, %@", self.id, self.logTime)
        }
    }
    
    override class func sqlTableName() -> String {
        return "INTERFACEKIT_OUTPUTCHANGE"
    }
    
    override func tableName() -> String
    {
        return InterfaceKitOutputChange.sqlTableName()
    }
    
    private var _state : NSNumber = 0
    var state : NSNumber {
        get { return _state }
    }
    
    required init(json: [String: AnyObject])
    {
        super.init(json: json)
        
        if let t = json["STATE"] as? NSNumber
        {
            self._state = t
        }
    }
    
    required init(managedObject: NSManagedObject)
    {
        super.init(managedObject: managedObject)
        
        if let t = managedObject.valueForKey("state") as? NSNumber
        {
            self._state = t
        }
    }
    
    override func save(managedObject: NSManagedObject)
    {
        super.save(managedObject)
        
        managedObject.setValue(state, forKey: "state")
    }
}


