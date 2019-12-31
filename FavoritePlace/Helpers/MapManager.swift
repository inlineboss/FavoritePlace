//
//  MapManager.swift
//  FavoritePlace
//
//  Created by inlineboss on 30.12.2019.
//  Copyright © 2019 inlineboss. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapManager {
    
    let locationManager = CLLocationManager()
    
    let regionInMeters = 1000.00
    
    func showUserLocation(map : MKMapView) {
        
        if let coordinate = locationManager.location?.coordinate {
            
            let region = MKCoordinateRegion(center: coordinate,
                                            latitudinalMeters: regionInMeters,
                                            longitudinalMeters: regionInMeters)
            
            map.setRegion(region, animated: true)
        }
        
    }
    
    func getCoordinatesCenterScreen(for mapVC : MKMapView) -> CLLocation {
       return CLLocation(latitude: mapVC.centerCoordinate.latitude,
                         longitude: mapVC.centerCoordinate.longitude)
    }
    
    func getAddress(mapView: MKMapView, clouser: @escaping (_ address : String) -> Void ) {
        
        let location = getCoordinatesCenterScreen(for: mapView)
        
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks.first
            
            let streetName = placemark?.thoroughfare
            
            let buildNumber = placemark?.subThoroughfare
            
            clouser("\(streetName ?? " " != " " ? "\(streetName!), " : "") \(buildNumber ?? "")")

        }  )
    }
    
    func showAlert(title: String, msg : String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController()
        window.windowLevel = UIWindow.Level.alert + 1
        window.makeKeyAndVisible()
        window.rootViewController?.present(alert, animated: true)
    }
    
    func setupLocationManager(managerDelegate: CLLocationManagerDelegate) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = managerDelegate
    }
    
    func inUseAuth () {
        
    }
    
    func setupMarks(place : Place, map: MKMapView) {
        
        guard let location = place.location else { return }
        
        let geo = CLGeocoder()
        
        geo.geocodeAddressString(location, completionHandler: {(placemarks, error) -> Void in
            
            if let err = error {
                print (err)
                return
            }
            
            guard let placemark = placemarks?.first else {
                return
            }
            
            guard let coordinates = placemark.location?.coordinate else {
                return
            }
            
            let anotation = MKPointAnnotation()
                        
            anotation.title = place.name
            anotation.subtitle = place.type
            anotation.coordinate = coordinates
            
            map.showAnnotations([anotation], animated: true)
            map.selectAnnotation(anotation, animated: true)
                
        })
    
    }
    
    func checkLocationServices(managerDelegate: CLLocationManagerDelegate, mapView : MKMapView) {
           
           if CLLocationManager.locationServicesEnabled() {
               setupLocationManager(managerDelegate: managerDelegate)
               checkLocationAuthorization(mapView: mapView)
           }
           
       }
       
    func checkLocationAuthorization(mapView: MKMapView) {
           switch CLLocationManager.authorizationStatus() {
           case .authorizedWhenInUse:
               mapView.showsUserLocation = true
               break;
           case .denied:
               
               break;
           case .notDetermined:
               locationManager.requestWhenInUseAuthorization()
               
               break;
           case .restricted:
               //alert
               break;
           case .authorizedAlways:
               break;
           @unknown default:
               print ("State not found")
           }
       }
}
