//
//  LocationViewController.swift
//  SwiftTest
//
//  Created by ZhangLiang on 2017/12/10.
//  Copyright © 2017年 ZhangLiang. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationViewController: BaseViewController , CLLocationManagerDelegate, MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .authorizedAlways:
                createLocationManager(startImmediately: true)
            case .authorizedWhenInUse:
                createLocationManager(startImmediately: true)
            case .denied:
                disPlayAlertWithTitle(title: "Not determined", message: "Location services are not allowed for this app")
            case .notDetermined:
                //                createLocationManager(startImmediately: false)
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                disPlayAlertWithTitle(title: "Restricted", message: "Location services are not allowed for this app")
            @unknown default:
                debugPrint("@unknown default")
            }
        }else{
            print("Location services are not enabled")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        let suits = ["♠️",  "♥️",  "♣️",  "♦️"]
        let ranks = ["J", "Q", "k", "A"]
        
        let results = suits.flatMap({suit in ranks.map({
            rank in (suit, rank)
            })
        })
        print("results = \(results)")
        
        mapView = MKMapView()
        mapView.mapType = .standard
        mapView.frame = view.frame
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        addPinToMapView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setCenterOfMapLocation(location: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func addPinToMapView() {
        let location = CLLocationCoordinate2D(latitude: 31.231706, longitude: 121.472644)
        let annotation = MyAnnotation(coordinate: location, title: "My Title", subtitle: "My Sub Title")
        mapView.addAnnotation(annotation as MKAnnotation)
        setCenterOfMapLocation(location: location)
    }
    
    func disPlayAlertWithTitle(title: String, message: String)  {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
    
    func createLocationManager(startImmediately: Bool)  {
        locationManager.delegate = self;
        if startImmediately {
            locationManager.startUpdatingLocation()
        }
    }
    
    func showUserLocationOnMapView() {
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    
    //MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
        disPlayAlertWithTitle(title: "Failed", message: "Could not get the users location")
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "restaurants"
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        request.region = MKCoordinateRegion(center: (userLocation.location?.coordinate)!, span: span)
        let search = MKLocalSearch(request: request)
        
        search.start { (response, error) in
            if let response = response {
                for item in response.mapItems {
                    print("Item name = \(String(describing: item.name))")
                    print("Item phone number = \(String(describing: item.phoneNumber))")
                    print("Item url = \(String(describing: item.url))")
                    print("Item location = \(String(describing: item.placemark.location))")
                }
            }
        }
    }

}
