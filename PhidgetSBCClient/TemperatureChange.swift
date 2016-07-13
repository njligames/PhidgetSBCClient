//
//  TemperatureChange.swift
//  PhidgetSBCClient
//
//  Created by James Folk on 7/12/16.
//  Copyright © 2016 NJLIGames Ltd. All rights reserved.
//

import Foundation
import CoreData

class TemperatureChange : PhidgetLog, CustomDebugStringConvertible
{
    var debugDescription: String {
        get
        {
            return String.localizedStringWithFormat("%@, %@", self.id, self.logTime)
        }
    }
    
    override class func sqlTableName() -> String {
        return "TEMPERATURE_CHANGE"
    }
    
    override func tableName() -> String
    {
        return TemperatureChange.sqlTableName()
    }
    
    private var _temperature : Double = 0.0
    var temperature : Double {
        get { return _temperature }
    }
    
    private var _potential : Double = 0.0
    var potential : Double {
        get { return _potential }
    }
    
    required init(json: [String: AnyObject])
    {
        super.init(json: json)
        
        if let t = json["TEMPERATURE"] as? Double
        {
            self._temperature = t
        }
        
        if let t = json["POTENTIAL"] as? Double
        {
            self._potential = t
        }
    }
    
    required init(managedObject: NSManagedObject)
    {
        super.init(managedObject: managedObject)
        
        if let t = managedObject.valueForKey("temperature") as? Double
        {
            self._temperature = t
        }
        
        if let t = managedObject.valueForKey("potential") as? Double
        {
            self._potential = t
        }
    }
    
    override func save(managedObject: NSManagedObject)
    {
        super.save(managedObject)
        
        managedObject.setValue(temperature, forKey: "temperature")
        managedObject.setValue(potential, forKey: "potential")
    }
}


