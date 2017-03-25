//
//  ViewController.swift
//  StudyAssistant
//
//  Created by Ivo Pisarovic on 25/03/2017.
//  Copyright © 2017 MENDELU. All rights reserved.
//

import UIKit
import GoogleMaps
import RestKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var map: GMSMapView!
    
    private let locationManager = CLLocationManager()
    
    private var lastLocation = CLLocation();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
        
        map.isMyLocationEnabled = true
        map.settings.myLocationButton = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            let currentLocation = locations[0]
            if compareLocations(currentLocation, lastLocation) == false {
                lastLocation = currentLocation
                let json = getLocationAsJSON(currentLocation)
                NSLog("did changed location %@", json)
                label.text = json
                sendRequest(json: json)
            }
        }
    }
    
    private func compareLocations(_ a: CLLocation, _ b: CLLocation)->Bool{
        return
            round(a.coordinate.latitude) == round(b.coordinate.latitude) &&
            round(a.coordinate.longitude) == round(b.coordinate.longitude)
    }
    
    private func getLocationAsJSON(_ location: CLLocation)->String {
        /*let json =
            "{\"latitude\": " + String(location.coordinate.latitude) + ", \"longitude\": " + String(location.coordinate.longitude) + ", \"username\": \"ivo\"}"*/
        let json =
            "{\"id\": 6}"
        return json
    }
    
    private func sendRequest(json: String){
        let method = "POST"
        
        let urlTest = "http://zsmladeze.cz/aaa.php"
        let urlDeploy = "http://studyassistant.azurewebsites.net/reached_school"
        
        let request = ServerRequest(method: method, url: urlDeploy, bodyString: json)
        request.runWithoutJSON({ (request, response, nil) in
            NSLog("OK - request sent")
        }, failure: { (request, response, error, nil) in
            NSLog("FAILED - request!!! %@", error!.localizedDescription)
        })
    }

}

