//
//  ViewController.swift
//  map_test
//
//  Created by Red Phoenix on 03/01/21.
//
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView :MKMapView!
    
    private var rootRef :DatabaseReference!
    
    private var locationManager :CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rootRef = Database.database().reference()
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
    
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        
        self.locationManager.startUpdatingLocation()
        
        setupUI()
        
        populateFloodedRegions()
    }
    
    private func populateFloodedRegions() {
        
        let floodedRegionsRef = self.rootRef.child("flooded-regions")
        
        floodedRegionsRef.observe(.value) { snapshot in
            
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            let floodDictionaries = snapshot.value as? [String:Any] ?? [:]
            
            for (key, _) in floodDictionaries {
                
                if let floodDict = floodDictionaries[key] as? [String:Any] {
                    
                    if let flood = Flood(dictionary: floodDict) {
                        
                        DispatchQueue.main.async {
                            
                            let floodAnnotation = MKPointAnnotation()
                            floodAnnotation.coordinate = CLLocationCoordinate2D(latitude: flood.latitude, longitude: flood.longitude)
                            
                            self.mapView.addAnnotation(floodAnnotation)
                            
                        }
                        
                    }
                    
                }
            }
            
        }
        
    }
    
    private func setupUI() {
        
        let addFloodButton = UIButton(frame: CGRect.zero)
        addFloodButton.setImage(UIImage(named :"plus"), for: .normal)
        
        addFloodButton.addTarget(self, action: #selector(addFloodAnnotationButtonPressed), for: .touchUpInside)
        addFloodButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(addFloodButton)
        
        addFloodButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        addFloodButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true
        addFloodButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        addFloodButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
    }
    
    @objc func addFloodAnnotationButtonPressed(sender :Any?) {
        
        if let location = self.locationManager.location {
            
            let floodAnnotation = MKPointAnnotation()
            floodAnnotation.coordinate = location.coordinate
            self.mapView.addAnnotation(floodAnnotation)
            
            let coordinate = location.coordinate
            let flood = Flood(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            let floodedRegionsRef = self.rootRef.child("flooded-regions")
            
            let floodRef = floodedRegionsRef.childByAutoId()
            floodRef.setValue(flood.toDictionary())
            
        }
        
        print("addFloodAnnotationButtonPressed")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            
            let coordinate = location.coordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: coordinate, span: span)
           // self.mapView.setRegion(region, animated: true)
        }
        
    }
    

}

