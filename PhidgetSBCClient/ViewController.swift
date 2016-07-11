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
    var spatialDataChangeItems = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //curl -H "Content-type: application/json" -X POST http://10.0.1.17:8001/query -d '{"table":"SPATIAL_DATACHANGE", "year_from":"2016", "month_from":"06", "day_from":"28", "hour_from":"13", "minute_from":"52", "second_from":"39", "year_to":"2016", "month_to":"06", "day_to":"28", "hour_to":"13", "minute_to":"52", "second_to":"39"}'
        let baseBody : [String: AnyObject] = ["table":"SPATIAL_DATACHANGE",
                                              "year_from":"2016",
                                              "month_from":"06",
                                              "day_from":"28",
                                              "hour_from":"13",
                                              "minute_from":"52",
                                              "second_from":"39",
                                              "year_to":"2016",
                                              "month_to":"06",
                                              "day_to":"28",
                                              "hour_to":"13",
                                              "minute_to":"52",
                                              "second_to":"39"]
        
        RestApiManager.sharedInstance.baseURL = "http://10.0.1.17:8001/query"
        RestApiManager.sharedInstance.post(baseBody, onCompletion: { (json:AnyObject) in
            if let v = json["SPATIAL_DATACHANGE"] as? String {
                if let logs = v.parseJSONString as? [[String: AnyObject]] {
                    for log in logs
                    {
                        self.saveSpatialChange(SpatialChange(json: log))
                    }
                }
            }
        })
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.loadSpatialDataChangeItems()
        
    }
    
    func loadSpatialDataChangeItems()
    {
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "SPATIAL_DATACHANGE")
        
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            self.spatialDataChangeItems = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hasSpatialChange(data:SpatialChange, managedContext: NSManagedObjectContext) -> Bool
    {
        // Fetching
        let fetchRequest = NSFetchRequest(entityName: "SPATIAL_DATACHANGE")
        
        // Create Predicate
        let predicate = NSPredicate(format: "id == %@ AND logtime == %@", data.id, data.logTime)
        fetchRequest.predicate = predicate
        
        // Add Sort Descriptor
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
    
    func saveSpatialChange(data: SpatialChange)
    {
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        if !hasSpatialChange(data, managedContext: managedContext)
        {
            let entity =  NSEntityDescription.entityForName("SPATIAL_DATACHANGE",
                                                            inManagedObjectContext:managedContext)
            
            let log = NSManagedObject(entity: entity!,
                                        insertIntoManagedObjectContext: managedContext)
            
            log.setValue(data.acceleration_x, forKey: "acceleration_x")
            log.setValue(data.acceleration_y, forKey: "acceleration_y")
            log.setValue(data.acceleration_z, forKey: "acceleration_z")
            
            log.setValue(data.angularrate_x, forKey: "angularrate_x")
            log.setValue(data.angularrate_y, forKey: "angularrate_y")
            log.setValue(data.angularrate_z, forKey: "angularrate_z")
            
            log.setValue(data.id, forKey: "id")
            log.setValue(data.index, forKey: "index")
            log.setValue(data.logTime, forKey: "logtime")
            
            log.setValue(data.magneticfield_x, forKey: "magneticfield_x")
            log.setValue(data.magneticfield_y, forKey: "magneticfield_y")
            log.setValue(data.magneticfield_z, forKey: "magneticfield_z")
            
            do
            {
                try managedContext.save()
                
                self.spatialDataChangeItems.append(log)
            }
            catch let error as NSError
            {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
}

