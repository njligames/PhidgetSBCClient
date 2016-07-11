//
//  RestApiManager.swift
//  PhidgetSBCClient
//
//  Created by James Folk on 7/8/16.
//  Copyright © 2016 NJLIGames Ltd. All rights reserved.
//

//import SwiftyJSON
import Foundation

//typealias ServiceResponse = (JSON, NSError?) -> Void
typealias ServiceResponse = (AnyObject?, NSError?) -> Void

class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()
    
    private var _baseURL : String = "http://api.randomuser.me/"
    var baseURL : String {
        set { _baseURL = newValue }
        get { return _baseURL }
    }
    
    func get(onCompletion: (AnyObject) -> Void) {
        let route = baseURL
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json! as AnyObject)
        })
    }
    
    func post(body: [String: AnyObject], onCompletion: (AnyObject) -> Void) {
        let route = baseURL
        makeHTTPPostRequest(route, body: body, onCompletion: { json, err in
            onCompletion(json! as AnyObject)
        })
    }
    
    // MARK: Perform a GET Request
    private func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                
                onCompletion(json, nil)
            } catch {
                print("error serializing JSON: \(error)")
            }
        })
        task.resume()
    }
    
    // MARK: Perform a POST Request
    private func makeHTTPPostRequest(path: String, body: [String: AnyObject], onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        // Set the method to POST
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            // Set the POST body for the request
            let jsonBody = try NSJSONSerialization.dataWithJSONObject(body, options: .PrettyPrinted)
            
            request.setValue(String.localizedStringWithFormat("%d", jsonBody.length), forHTTPHeaderField: "Content-Length")
            request.HTTPBody = jsonBody
            
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                if((data) != nil)
                {
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                        
                        onCompletion(json, nil)
                    } catch {
                        print("error serializing JSON: \(error)")
                    }
                }
            })
            task.resume()
        } catch {
            // Create your personal error
            onCompletion(nil, nil)
        }
    }
}
