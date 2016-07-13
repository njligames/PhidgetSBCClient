//
//  ViewController.swift
//  PhidgetSBCClient
//
//  Created by James Folk on 7/8/16.
//  Copyright © 2016 NJLIGames Ltd. All rights reserved.
//

import UIKit
//import SwiftyJSON
import CoreData

extension String {
    
    var parseJSONString: AnyObject? {
        
        let data = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        if let jsonData = data {
            // Will return an object or nil if JSON decoding fails
            do {
                let response = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)
                return response
            } catch let serializationError as NSError {
                print(serializationError)
            }
            
        }
        return nil
    }
}

extension NSDate {
    convenience init?(jsonDate: String) {
        
        let prefix = "/Date("
        let suffix = ")/"
        // Check for correct format:
        if jsonDate.hasPrefix(prefix) && jsonDate.hasSuffix(suffix) {
            // Extract the number as a string:
            let from = jsonDate.startIndex.advancedBy(prefix.characters.count)
            let to = jsonDate.endIndex.advancedBy(-suffix.characters.count)
            // Convert milleseconds to double
            guard let milliSeconds = Double(jsonDate[from ..< to]) else {
                return nil
            }
            // Create NSDate with this UNIX timestamp
            self.init(timeIntervalSince1970: milliSeconds/1000.0)
        } else {
            return nil
        }
    }
}

class ViewController: UIViewController
{
    var spatialDataChangeLogs = [SpatialChange]()
    var accelerometerChangeLogs = [AccelerometerChange]()
    var interfaceKitInputChangeLogs = [InterfaceKitInputChange]()
    var interfaceKitOutputChangeLogs = [InterfaceKitOutputChange]()
    var interfaceKitSensorChangeLogs = [InterfaceKitSensorChange]()
    var temperatureChangeLogs = [TemperatureChange]()
    
    
    func loadLogs<T where T:PhidgetLog >(url: String, inout array: [T])
    {
        // populate array from database.
        let managedObjectArray = self.loadArray(T.sqlTableName())
        
        for managedObject in managedObjectArray
        {
            array.append(T(managedObject: managedObject))
        }
        
        // populate array from server.
        T.query(url, onCompletion: {(logs: [[String: AnyObject]]) in
            for log in logs
            {
                if let managedObject = self.saveDataLog(T(json: log))
                {
                    array.append(T(managedObject: managedObject))
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let url = String("http://10.0.1.17:8001/query")
        
//        self.loadLogs(url, array: &self.spatialDataChangeLogs)
        self.loadLogs(url, array: &self.accelerometerChangeLogs)
//        self.loadLogs(url, array: &self.interfaceKitInputChangeLogs)
//        self.loadLogs(url, array: &self.interfaceKitOutputChangeLogs)
//        self.loadLogs(url, array: &self.interfaceKitSensorChangeLogs)
//        self.loadLogs(url, array: &self.temperatureChangeLogs)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadArray(tableName: String) -> [NSManagedObject]
    {
        var managedObjectArray = [NSManagedObject]()
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: tableName)
        
        do
        {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            
            managedObjectArray = results as! [NSManagedObject]
            
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return managedObjectArray
    }
    
    func hasDataLog(data: PhidgetLog, managedContext: NSManagedObjectContext) -> Bool
    {
        let fetchRequest = NSFetchRequest(entityName: data.tableName())
        
        let predicate = NSPredicate(format: "id == %@ AND logtime == %@", data.id, data.logTime)
        fetchRequest.predicate = predicate
        
        let sortDescriptor1 = NSSortDescriptor(key: "logtime", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        
        // Execute Fetch Request
        do {
            if let result = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            {
                return result.count > 0
            }
            
        }
        catch
        {
            let fetchError = error as NSError
            print(fetchError)
        }
        return false
    }
    
    func saveDataLog(data: PhidgetLog) -> NSManagedObject?
    {
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        if !hasDataLog(data, managedContext: managedContext)
        {
            let entity =  NSEntityDescription.entityForName(data.tableName(),
                                                            inManagedObjectContext:managedContext)
            
            let log = NSManagedObject(entity: entity!,
                            insertIntoManagedObjectContext: managedContext)
            data.save(log)
            
            return log
        }
        
        return nil
    }
}

