//
//  InterfaceKitInputChange.swift
//  PhidgetSBCClient
//
//  Created by James Folk on 7/12/16.
//  Copyright © 2016 NJLIGames Ltd. All rights reserved.
//

import Foundation
import CoreData

class InterfaceKitInputChange : PhidgetLog, CustomDebugStringConvertible
{
    var debugDescription: String {
        get
        {
            return String.localizedStringWithFormat("%@, %@", self.id, self.logTime)
        }
    }
    
    override class func sqlTableName() -> String {
        return "INTERFACEKIT_INPUTCHANGE"
    }
    
    override func tableName() -> String
    {
        return InterfaceKitInputChange.sqlTableName()
    }
    
    private var _acceleration_x : Double = 0.0
    var acceleration_x : Double {
        get { return _acceleration_x }
    }
    private var _acceleration_y : Double = 0.0
    var acceleration_y : Double {
        get { return _acceleration_y }
    }
    private var _acceleration_z : Double = 0.0
    var acceleration_z : Double {
        get { return _acceleration_z }
    }
    
    private var _magneticfield_x : Double = 0.0
    var magneticfield_x : Double {
        get { return _magneticfield_x }
    }
    private var _magneticfield_y : Double = 0.0
    var magneticfield_y : Double {
        get { return _magneticfield_y }
    }
    private var _magneticfield_z : Double = 0.0
    var magneticfield_z : Double {
        get { return _magneticfield_z }
    }
    
    private var _angularrate_x : Double = 0
    var angularrate_x : Double {
        get { return _angularrate_x }
    }
    private var _angularrate_y : Double = 0
    var angularrate_y : Double {
        get { return _angularrate_y }
    }
    private var _angularrate_z : Double = 0
    var angularrate_z : Double {
        get { return _angularrate_z }
    }
    
    required init(json: [String: AnyObject])
    {
        super.init(json: json)
        
        if let t = json["ACCELERATION_X"] as? Double
        {
            self._acceleration_x = t
        }
        
        if let t = json["ACCELERATION_Y"] as? Double
        {
            self._acceleration_y = t
        }
        
        if let t = json["ACCELERATION_Z"] as? Double
        {
            self._acceleration_z = t
        }
        
        if let t = json["ANGULARRATE_X"] as? Double
        {
            self._angularrate_x = t
        }
        
        if let t = json["ANGULARRATE_Y"] as? Double
        {
            self._angularrate_y = t
        }
        
        if let t = json["ANGULARRATE_Z"] as? Double
        {
            self._angularrate_z = t
        }
        
        if let t = json["MAGNETICFIELD_X"] as? Double
        {
            self._magneticfield_x = t
        }
        
        if let t = json["MAGNETICFIELD_Y"] as? Double
        {
            self._magneticfield_y = t
        }
        
        if let t = json["MAGNETICFIELD_Z"] as? Double
        {
            self._magneticfield_z = t
        }
    }
    
    required init(managedObject: NSManagedObject)
    {
        super.init(managedObject: managedObject)
        
        if let t = managedObject.valueForKey("acceleration_x") as? Double
        {
            self._acceleration_x = t
        }
        
        if let t = managedObject.valueForKey("acceleration_y") as? Double
        {
            self._acceleration_y = t
        }
        
        if let t = managedObject.valueForKey("acceleration_z") as? Double
        {
            self._acceleration_z = t
        }
        
        if let t = managedObject.valueForKey("angularrate_x") as? Double
        {
            self._angularrate_x = t
        }
        
        if let t = managedObject.valueForKey("angularrate_y") as? Double
        {
            self._angularrate_y = t
        }
        
        if let t = managedObject.valueForKey("angularrate_z") as? Double
        {
            self._angularrate_z = t
        }
        
        if let t = managedObject.valueForKey("magneticfield_x") as? Double
        {
            self._magneticfield_x = t
        }
        
        if let t = managedObject.valueForKey("magneticfield_y") as? Double
        {
            self._magneticfield_y = t
        }
        
        if let t = managedObject.valueForKey("magneticfield_z") as? Double
        {
            self._magneticfield_z = t
        }
    }
    
    override func save(managedObject: NSManagedObject)
    {
        super.save(managedObject)
        
        managedObject.setValue(acceleration_x, forKey: "acceleration_x")
        managedObject.setValue(acceleration_y, forKey: "acceleration_y")
        managedObject.setValue(acceleration_z, forKey: "acceleration_z")
        
        managedObject.setValue(angularrate_x, forKey: "angularrate_x")
        managedObject.setValue(angularrate_y, forKey: "angularrate_y")
        managedObject.setValue(angularrate_z, forKey: "angularrate_z")
        
        managedObject.setValue(magneticfield_x, forKey: "magneticfield_x")
        managedObject.setValue(magneticfield_y, forKey: "magneticfield_y")
        managedObject.setValue(magneticfield_z, forKey: "magneticfield_z")
    }
}


