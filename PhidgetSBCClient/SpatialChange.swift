//
//  SpatialChange.swift
//  PhidgetSBCClient
//
//  Created by James Folk on 7/8/16.
//  Copyright © 2016 NJLIGames Ltd. All rights reserved.
//

import Foundation
import Darwin

class SpatialChange: Equatable
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
}


func ==(lhs: SpatialChange, rhs: SpatialChange) -> Bool
{
    return ((lhs.id == rhs.id) && (lhs.logTime == rhs.logTime))
}
