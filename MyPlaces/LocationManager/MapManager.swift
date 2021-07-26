//
//  NavigatorManager.swift
//  MyPlaces
//
//  Created by Andrey on 19.07.2021.
//

import MapKit
import UIKit

class MapManager {
    
 
  let locationManager = CLLocationManager()
  

  private  var placeCoordinate: CLLocationCoordinate2D?
  
  private var directionsArray: [MKDirections] = []
    
    

    
    func setupPlaceMark(place: MapModel, mapView: MKMapView) {
      
       guard let location = place.location  else { return }
       
       let geocoder = CLGeocoder()
       geocoder.geocodeAddressString(location) { (placeMarks, error) in
           if let error = error {
               print(error.localizedDescription)
       }
           guard let placeMarks = placeMarks else { return }
           
           let placeMark = placeMarks.first
           
           
           let annotation = MKPointAnnotation()
           annotation.title = place.name
           annotation.subtitle = place.type
           
           guard let placeMarkLocation = placeMark?.location else { return }
           
           annotation.coordinate = placeMarkLocation.coordinate
           self.placeCoordinate = placeMarkLocation.coordinate
           
           mapView.showAnnotations([annotation], animated: true)
           mapView.selectAnnotation(annotation, animated: true)
       }
           
   }
    
    func checKLocationServices(mapView: MKMapView, segueIdentifier: String, closure: () -> Void) {
       
       if CLLocationManager.locationServicesEnabled() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkLocationAuthorization(mapView: mapView, segueIdentifier: segueIdentifier)
        closure()
       } else {
           DispatchQueue.main.async {
            self.showAlert(title: "Location Services are Disabled", message: "To enable it go: Settings -> Privacy -> Locatin Services and turn On")
           }
        
       }
   
    }
    
    func startTrackingUserLocation(mapView: MKMapView, and location: CLLocation?, closure: (_ currenLocation: CLLocation) -> Void)  {
        guard let location =  location else { return  }
        let center = getCenterLocation(for: mapView)
        guard center.distance(from: location) > 50 else { return }
        closure(center)
        
    }
    func checkLocationAuthorization(mapView: MKMapView, segueIdentifier: String) {
        
        switch locationManager.authorizationStatus {
        
        case .authorizedWhenInUse:
            
            mapView.showsUserLocation = true
            
            if segueIdentifier == "getAddress"{showUserLocation(mapView: mapView)}
            print(segueIdentifier)
            
          
            break
        case .denied:
           showAlert(title: "Your location is not Availeble ", message: "To give permisson Go to: Setting -> MyPlaces -> Location")
        break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted:
           
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("New Case available")
        }
    }
  
    func creatDirectionRequest(from coordinate: CLLocationCoordinate2D ) -> MKDirections.Request? {
        
        guard let destinationCoordinate = placeCoordinate else { return nil }
        let startingLocation = MKPlacemark(coordinate: coordinate )
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        return request
    }
    
    
    func getDirections(mapView: MKMapView, previousLocation: (CLLocation) -> ()) {
        
        guard let location = locationManager.location?.coordinate else {
           showAlert(title: "Error", message: "Current Location is not found")
            return }
        
        locationManager.startUpdatingLocation()
        previousLocation(CLLocation(latitude: location.latitude, longitude: location.longitude))
        guard let request  = creatDirectionRequest(from: location) else {
            showAlert(title: "Error", message: "Destinaton is not found")
            return  }
        
        let directions = MKDirections(request: request)
        resetNewView(with: directions, mapView: mapView)
        directions.calculate { response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let response = response else {
                self.showAlert(title: "Error", message: "Direction is not available")
                return }
            
            for route in response.routes {
               
                
            mapView.addOverlay(route.polyline)
            mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
                let distance = String(format: "%.1f", route.distance / 1000)
                let timeInterval =  (route.expectedTravelTime / 60).rounded()
                
                
                print("Растояния до места \(distance) km")
                print("Время в пути составит \(timeInterval)")
            }
        }
    }
    
    func resetNewView(with directions: MKDirections, mapView: MKMapView) {
        
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        
        let  _ =  directionsArray.map({$0.cancel()})
        directionsArray.removeAll()
    }
    private  let regionsInMetr: CLLocationDistance = 1000
    
     
    
    func showUserLocation(mapView: MKMapView) {
        
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionsInMetr, longitudinalMeters: regionsInMetr)
            mapView.setRegion(region, animated: true)
           
        }
    }
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        
        
        return CLLocation(latitude: latitude, longitude: longitude)
        
    }
    func showAlert(title: String, message: String) {
      
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let goButton = UIAlertAction(title: "Ok", style: .default)
        
        
        alert.addAction(goButton)
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        
        alertWindow.rootViewController? .present(alert, animated: true) {
            print("complited")
        }
       
    }
 
}

