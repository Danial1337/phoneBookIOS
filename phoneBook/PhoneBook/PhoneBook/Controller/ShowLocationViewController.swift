

import UIKit
import MapKit
import CoreLocation

class ShowLocationViewController: UIViewController {
    
    @IBOutlet weak var mapKit: MKMapView!
    var address:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Location"
        
        
        coordinates(forAddress: address) {
            (location) in
            guard let location = location else {
                self.showToast(message: "Invalid Address", font: .systemFont(ofSize: 12.0))
                return
            }
            
            
            //show location
            self.showAnnotation(location: location)
            
        }
        
    }
    
    func showAnnotation(location:CLLocationCoordinate2D){
        //zoom to lication
        let viewRegion = MKCoordinateRegion(center: location, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapKit.setRegion(viewRegion, animated: false)
        
        //annotation
        let CLLCoordType = CLLocationCoordinate2D(latitude: location.latitude,longitude: location.longitude)
        let anno = MKPointAnnotation()
        anno.coordinate = CLLCoordType
        
        self.mapKit.addAnnotation(anno)
    }
    
    func coordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            (placemarks, error) in
            guard error == nil else {
                print("Geocoding error: \(error!)")
                completion(nil)
                return
            }
            completion(placemarks?.first?.location?.coordinate)
        }
    }
    
    
}
