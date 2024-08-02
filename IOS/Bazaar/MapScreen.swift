/*==================================================
 Bazaar
 
 © XScoder 2018
 All Rights reserved
 
 RE-SELLING THIS SOURCE CODE TO ANY ONLINE MARKETPLACE IS A SERIOUS COPYRIGHT INFRINGEMENT.
 YOU WILL BE LEGALLY PROSECUTED

====================================================*/

import UIKit
import MapKit
import CoreLocation


class MapScreen: UIViewController, MKMapViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
    
    /*--- VIEWS ---*/
    @IBOutlet weak var aMap: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var searchLocationTxt: UITextField!
    @IBOutlet weak var setLocationButton: UIButton!
    @IBOutlet weak var pinIcon: UIImageView!
    

    
    /*--- VARIABLES ---*/
    var isSelling = false
    var distance = Double()
    var location = CLLocation()
    var locationManager: CLLocationManager!
    
    
    
    
    
    // ------------------------------------------------
    // MARK: - VIEW DID LOAD
    // ------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        // Layouts
        setLocationButton.layer.cornerRadius = 18
        pinIcon.center = aMap.center
        
        
        // In case you need the Map to set a location while selling stuff
        if isSelling {
            distanceLabel.isHidden = true
            distanceSlider.isHidden = true
            aMap.isZoomEnabled = true
        }
        
        
        // Format distance in Km
        distance = 15.0
        let distFormatted = String(format: "%.0f", distance)
        distanceLabel.text = "\(distFormatted) Km"
        distanceSlider.value = Float(distance)
        
        if chosenLocation != nil { location = chosenLocation!
        } else { getCurrentLocation() }
        
        // Add a pin on the Map
        setMapRegion(location)
    }

    
    
    
    // ------------------------------------------------
    // MARK: - SEARCH FOR A LOCATION BY ADDRESS OR CITY
    // ------------------------------------------------
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            let address = textField.text!
            textField.resignFirstResponder()
            print(address)
            
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
                if let placemark = placemarks?.first {
                    let coords = placemark.location!.coordinate
                    self.location = CLLocation(latitude: coords.latitude, longitude: coords.longitude)
                    self.setMapRegion(self.location)
                    
                // error
                } else { self.simpleAlert("Location not found. Try a new search.") }
            })
        }
        return true
    }
    
    
    
    
    
    // ------------------------------------------------
    // MARK: - GET CURRENT LOCATION BUTTON
    // ------------------------------------------------
    @IBAction func currentLocationButt(_ sender: Any) {
        getCurrentLocation()
    }
    
    
    // ------------------------------------------------
    // MARK: - GET CURRENT LOCATION FUNCTION
    // ------------------------------------------------
    func getCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        if locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.startUpdatingLocation()
    }
    
    // ------------------------------------------------
    // MARK: - LOCATION MANAGER DELEGATE
    // ------------------------------------------------
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        simpleAlert("We coulnd't get your location. Please go into Settings, search for woopy and enable Location service, so you'll be able to see ads nearby you.")
        
        // Set Default Location
        location = DEFAULT_LOCATION
        chosenLocation = nil
        
        // Set map region
        setMapRegion(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        location = locations.last!
        locationManager = nil
        chosenLocation = nil
        
        // Set map region
        setMapRegion(location)
    }

    
    
    // ------------------------------------------------
    // MARK: - SET MAP REGION
    // ------------------------------------------------
    func setMapRegion(_ location: CLLocation) {
        aMap.delegate = self
        aMap.removeOverlays(aMap.overlays)
      
        aMap.centerCoordinate = location.coordinate
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: distance*4000, longitudinalMeters: distance*4000);
        aMap.setRegion(region, animated: true)
        aMap.regionThatFits(region)
        aMap.reloadInputViews()
        
        // Add Radius circle
        addRadiusCircle(location)
    }
    
    
    
    // ------------------------------------------------
    // MARK: - ADD A RADIUS CIRCLE AROUND THE AREA
    // ------------------------------------------------
    func addRadiusCircle(_ location: CLLocation) {
        if !isSelling {
            let circle = MKCircle(center: location.coordinate, radius: distance*1000 as CLLocationDistance)
            aMap.addOverlay(circle)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.blue
            circle.fillColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
            circle.lineWidth = 1
            return circle
        }
        return MKOverlayRenderer()
    }
    
    
    // ------------------------------------------------
    // MARK: - GET CENTER COORDINATES OF THE MAP WHILE DRAGGING OR ZOOMING IT
    // ------------------------------------------------
    var center:CLLocationCoordinate2D!
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        center = mapView.centerCoordinate
        location = CLLocation(latitude: center.latitude, longitude: center.longitude)
        print("LOCATION ON DRAGGING/ZOOMING MAP: \(String(describing: location))")
        
        // Re-add a Radius circle
        aMap.removeOverlays(aMap.overlays)
        addRadiusCircle(location)
    }

    
    
    
    // ------------------------------------------------
    // MARK: - DISTANCE SLIDER CHANGED
    // ------------------------------------------------
    @IBAction func distanceChanged(_ sender: UISlider) {
        distance = Double(sender.value)
        let distFormatted = String(format: "%.0f", distance)
        distanceLabel.text = "\(distFormatted) Km"
    }
    
    
    // ------------------------------------------------
    // MARK: - DISTANCE SLIDER ENDS DRAGGING - REFRESH THE MAP
    // ------------------------------------------------
    @IBAction func sliderEndDrag(_ sender: UISlider) {
        // Refresh the MapView
        setMapRegion(location)
    }
    
    
    // ------------------------------------------------
    // MARK: - SET LOCATION BUTTON
    // ------------------------------------------------
    @IBAction func setLocationButt(_ sender: Any) {
        chosenLocation = location
        distanceInKm = distance
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // ------------------------------------------------
    // MARK: - DISMISS BUTTON
    // ------------------------------------------------
    @IBAction func dismissButt(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    

}// ./ end
