//
//  MapViewController.swift
//  MyPlaces
//
//  Created by Andrey on 16.07.2021.
//

import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate {
   func getAddress(_ address: String)
}

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    let mapManager = MapManager()
    var place: MapModel?
    var segueIdentifier = ""
    var  mapViewControllerDelegate: MapViewControllerDelegate?
    let annotationIdentifier = "annotationIdentifire"
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var currentAddress: UILabel!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pinImage: UIImageView!
    
    
     var previewLocation: CLLocation? {
     didSet{
        mapManager.startTrackingUserLocation(mapView: mapView, and: previewLocation) {  (currentLocation) in
            previewLocation = currentLocation
            print(currentLocation.coordinate)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.mapManager.showUserLocation(mapView: self.mapView)
            }
        }
         
     }
 }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        mapView.delegate = self
        setupMapView()
        currentAddress.text = ""
    
        
    }
    
    
    
    @IBAction func centerUserLocation() {
        
        mapManager.showUserLocation(mapView: mapView)
    }
     
    @IBAction func doneBtnPressed(_ sender: Any) {
        
        guard let text = currentAddress.text else { return  }
        mapViewControllerDelegate?.getAddress(text)
        dismiss(animated: true)
        
    }
    
    
    @IBAction func goButtonPressed(_ sender: UIButton) {
        mapManager.getDirections(mapView: mapView) { (location) in
            self.previewLocation = location
            
        }
    }
    @IBAction func closeVc(_ sender: Any) {
        
        dismiss(animated: true)
    }

 
   
    func setupMapView() {
       
        goButton.isHidden = true
        
        mapManager.checKLocationServices(mapView: mapView, segueIdentifier: segueIdentifier) {
            mapManager.locationManager.delegate = self
        }
        
        if segueIdentifier == "goToMap" {
            guard let place = place else { return  }
            mapManager.setupPlaceMark(place: place, mapView: mapView)
            pinImage.isHidden = true
            doneButton.isHidden = true
            currentAddress.isHidden = true
            goButton.isHidden = false
        }
    }
    deinit {
        print("Controller удален")
    }
   
 
 
        
    }
   
extension MapViewController: MKMapViewDelegate {
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        guard !( annotation is MKUserLocation ) else { return nil }
        
        var annotaionView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotaionView == nil {
            annotaionView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotaionView?.canShowCallout = true
        }
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.image = place?.imagePlace
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            annotaionView?.rightCalloutAccessoryView = imageView
        
        return annotaionView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let center = mapManager.getCenterLocation(for: mapView)
        let geocoder = CLGeocoder()
        if segueIdentifier == "goToMap" && previewLocation != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.mapManager.showUserLocation(mapView: self.mapView)
            }
        }
    
            geocoder.cancelGeocode()
        
        geocoder.reverseGeocodeLocation(center) { placeMarks, error in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let placeMarks = placeMarks else {  return }
            let placeMark = placeMarks.first
            let streetName = placeMark?.thoroughfare
            let buildNumber = placeMark?.subThoroughfare
            
            DispatchQueue.main.async {
              
                if streetName != nil && buildNumber != nil {
                self.currentAddress.text = "\(streetName!),  \(buildNumber!)"
                } else if streetName != nil {
                    self.currentAddress.text = "\(streetName!)"
                } else {
                    self.currentAddress.text = ""
                }
            }
            
        }
    
         
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        mapManager.checkLocationAuthorization(mapView: mapView, segueIdentifier: segueIdentifier )
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .systemBlue
        return renderer
    }
  
}






