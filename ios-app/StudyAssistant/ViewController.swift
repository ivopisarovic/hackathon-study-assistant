//
//  ViewController.swift
//  StudyAssistant
//
//  Created by Ivo Pisarovic on 25/03/2017.
//  Copyright © 2017 MENDELU. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var map: GMSMapView!
    
    let locationManager = CLLocationManager()
    
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
                let locationText = String(currentLocation.coordinate.latitude) + " " + String(currentLocation.coordinate.longitude)
                label.text = locationText
                NSLog("did updated location %@", locationText)
            }
        }
    }
    
    private func compareLocations(_ a: CLLocation, _ b: CLLocation)->Bool{
        return
            round(a.coordinate.latitude) == round(b.coordinate.latitude) &&
            round(a.coordinate.longitude) == round(b.coordinate.longitude)
    }
    
    

}

