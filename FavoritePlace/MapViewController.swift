//
//  MapViewController.swift
//  FavoritePlace
//
//  Created by inlineboss on 27.12.2019.
//  Copyright © 2019 inlineboss. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate {
    func getAddress(_ address: String?)
}
class MapViewController: UIViewController {
    
    var place = Place()
    
    var delegate : MapViewControllerDelegate?
    
    let regionInMeters = 1000.00
    
    var annotationIdentifire = "annotationIdentifire"
    let locationManager = CLLocationManager()

    var incomSegue : String!
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var pinMarkerImage: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var centeringUserLocationButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        addressLabel.text = ""
        
        map.delegate = self
        checkLocationServices()
        if incomSegue == "showPlace" {
            
            setupMarks()
            pinMarkerImage.isHidden = true
            doneButton.isHidden = true
            
            
        } else if incomSegue == "showUserLocation" {
            
            showUserLocation()
            centeringUserLocationButton.isHidden = true
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !CLLocationManager.locationServicesEnabled() {
          showAlert()
        }
    }
    
    @IBAction func centeringUserLocation() {
        
        showUserLocation()
         
    }
    
    private func showUserLocation() {
        if let coordinate = locationManager.location?.coordinate {
            
            let region = MKCoordinateRegion(center: coordinate,
                                            latitudinalMeters: regionInMeters,
                                            longitudinalMeters: regionInMeters)
            
            map.setRegion(region, animated: true)
        }
    }
    
    private func getCoordinatesCenterScreen(for mapVC : MKMapView) -> CLLocation {
        
        return CLLocation(latitude: mapVC.centerCoordinate.latitude,
                          longitude: mapVC.centerCoordinate.longitude)
        
    }
    
    private func showAlert() {
        
        let alert = UIAlertController(title: "Location service are disabled!", message: "To enabled location service", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        present(alert, animated: true)
        
    }
    
    @IBAction func closeAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction() {
        delegate?.getAddress(addressLabel.text)
        dismiss(animated: true, completion: nil)
    }
    
    private func checkLocationServices() {
        
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        }
        
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            map.showsUserLocation = true
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
    
    private func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    private func setupMarks() {
        
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
                        
            anotation.title = self.place.name
            anotation.subtitle = self.place.type
            anotation.coordinate = coordinates
            
            self.map.showAnnotations([anotation], animated: true)
            self.map.selectAnnotation(anotation, animated: true)
                
        })
    
    }
}

extension MapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
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
            
            DispatchQueue.main.async {
                
                self.addressLabel.text = "\(streetName ?? " " != " " ? "\(streetName!), " : "") \(buildNumber ?? "")"
                print("\(streetName ?? " " != " " ? "\(streetName!), " : "") \(buildNumber ?? "")")
            }
            
            
        }  )
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationVIew = map.dequeueReusableAnnotationView(withIdentifier: annotationIdentifire) as? MKPinAnnotationView
        
        if annotationVIew == nil {
            
            annotationVIew = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifire)
            
            annotationVIew?.canShowCallout = true
            
        }
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        if let imageData = place.imageData{
            imageView.image = UIImage(data: imageData)
        } else {
            imageView.image = #imageLiteral(resourceName: "imagePlaceholder")
        }
        
        annotationVIew?.rightCalloutAccessoryView = imageView
        
        return annotationVIew
    }
}

extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
