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
    
    let manager = MapManager()
    
    var delegate : MapViewControllerDelegate?
    
    var annotationIdentifire = "annotationIdentifire"

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
        
            manager.checkLocationServices(managerDelegate: self, mapView: map)
        
            if incomSegue == "showPlace" {
                
                manager.setupMarks(place: place, map: map)
                
                pinMarkerImage.isHidden = true
                doneButton.isHidden = true
                
                
            } else if incomSegue == "showUserLocation" {
                
                manager.showUserLocation(map: map)
                centeringUserLocationButton.isHidden = true
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !CLLocationManager.locationServicesEnabled() {
            manager.showAlert(title:"Location service are disabled!", msg:"To enabled location service")
        }
    }
    
    @IBAction func centeringUserLocation() {
        manager.showUserLocation(map: map)
    }
    
    @IBAction func closeAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction() {
        delegate?.getAddress(addressLabel.text)
        dismiss(animated: true, completion: nil)
    }
    
}

extension MapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        DispatchQueue.main.async {
            self.manager.getAddress(mapView: self.map) { (addr) in
                self.addressLabel.text = addr
                print(addr)
            }
        }
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
        self.manager.checkLocationAuthorization(mapView: map)
    }
}
