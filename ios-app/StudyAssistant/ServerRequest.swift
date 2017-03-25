//
//  ServerRequest.swift
//  Gisella
//
//  Created by Ivo Pisarovic on 10/26/15.
//  Copyright (c) 2015 MENDELU. All rights reserved.
//

import Foundation
import AFNetworking

class ServerRequest{
    
    var result: AnyObject?
    //var operation: AFJSONRequestOperation? = nil
    //var httpOperation: AFHTTPRequestOperation? = nil
    private var manager: AFURLSessionManager? = nil
    
    var method: String
    var url: String
    var body: Data?
    var deviceID: Int? = nil
    
    /**
     Ctr for initializating a new server request.
     
     - parameter method: HTTP request method according to struct HTTPMethod.
     - parameter url:    Target URL as String.
     - parameter body:   HTTP body as NSData
     */
    init(method: String, url: String, body: Data?){
        self.method = method
        self.url = url
        self.body = body
        
        let configuration = URLSessionConfiguration.default;
        manager = AFURLSessionManager.init(sessionConfiguration: configuration)
    }
    
    /**
     Ctr for initializating a new server request using String for body.
     
     - parameter method: HTTP request method according to struct HTTPMethod.
     - parameter url:    Target URL as String.
     - parameter body:   HTTP body as String
     */
    convenience init(method: String, url: String, bodyString: String){
        let bodyData = ServerRequest.bodyStringToData(bodyString)
        self.init(method: method, url: url, body: bodyData)
    }
    
    /**
     Converts HTTP body string to NSData
     
     - parameter string: HTTP body as String
     
     - returns: HTTP body as NSData. If the conversion fails, returns nil.
     */
    static func bodyStringToData(_ body: String)->Data?{
        return body.data(using: String.Encoding.utf8, allowLossyConversion: false)
    }
    
    /**
     Prepares request parameters like URL, device ID or Authorization field.
     
     - returns: Configured request.
     */
    fileprivate func prepareRequest()->NSMutableURLRequest{
        var validURL = url
        
        let nsurl = URL(string: validURL)
        
        let request: NSMutableURLRequest = NSMutableURLRequest(url: nsurl!)
        
        request.httpMethod = method
        request.httpBody = body
        
        return request
    }
    
    /**
     Performs a server request. The response body is converted to JSON object.
     
     - parameter success: Success callback function. The last parameter is response body.
     - parameter failure: Failure callback function. The last parameter is response body.
     */
    func run(_ success: ((URLRequest?, HTTPURLResponse?, AnyObject?) -> Void)?, failure: ((URLRequest?, HTTPURLResponse?, NSError?, AnyObject?) -> Void)?){
        
        let request = prepareRequest()
        
        let dataTask = manager!.dataTask(with: request as URLRequest) { (response, responseObject, error) in
            if error != nil {
                success!(request as URLRequest, response as? HTTPURLResponse, responseObject as AnyObject?)
            }else{
                failure!(request as URLRequest, response as? HTTPURLResponse, error as NSError?, nil)
            }
        }
        dataTask.resume()
    }
    
    /**
     Performs a request without converting response to JSON.
     
     - parameter success: Success callback function. The last parameter is response body.
     - parameter failure: Failure callback function. The last parameter is response body.
     */
    func runWithoutJSON(_ success: ((URLRequest?, HTTPURLResponse?, AnyObject?) -> Void)?, failure: ((URLRequest?, HTTPURLResponse?, NSError?, AnyObject?) -> Void)?){
        
        let request = prepareRequest()
        
        let dataTask = manager!.dataTask(with: request as URLRequest) { (response, responseObject, error) in
            if error == nil {
                success!(request as URLRequest, response as? HTTPURLResponse, responseObject as AnyObject?)
            }else{
                failure!(request as URLRequest, response as? HTTPURLResponse, error as NSError?, nil)
            }
        }
        dataTask.resume()
    }
    
    /**
     Tries to stop the current request operation.
     */
    func stop(){
        //operation?.cancel()
        //httpOperation?.cancel()
        manager!.invalidateSessionCancelingTasks(true)
    }
    

}
