//
//  ViewController.swift
//  map_test
//
//  Created by Red Phoenix on 03/01/21.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    private var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        
        self.locationManager.startUpdatingLocation()
        setupUI()
        
        
    }
    
    private func setupUI() {
        let addFloadButton = UIButton(frame: CGRect.zero)
        addFloadButton.setImage(UIImage(named: "plus"), for: .normal)
        addFloadButton.addTarget(self, action: #selector(addFloodAnnotationButtonPressed), for: .touchUpInside)
        addFloadButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(addFloadButton)
        addFloadButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        addFloadButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true
        
        addFloadButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        addFloadButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        
    }
    
    @objc func addFloodAnnotationButtonPressed() {
        if let location = self.locationManager.location {
            let floodAnnotation = MKPointAnnotation()
            floodAnnotation.coordinate = location.coordinate
            self.mapView.addAnnotation(floodAnnotation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let coordinate = location.coordinate
            
            //this is used for zooming in the map
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01 )
            let region = MKCoordinateRegion(center: coordinate, span: span)
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

