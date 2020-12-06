
import UIKit
import MapKit
import CoreData


class MapViewController: UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var dataController: DataController!
    var fetchedResults: NSFetchedResultsController<Map>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupFetchedResultsController()
        fetchMapLocation()
        
        // Generate long-press
        let myLongPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
        myLongPress.addTarget(self, action: #selector(recognizeLongPress(_:)))
        mapView.addGestureRecognizer(myLongPress)
    }
    
    
    // A method called when long press is detected.
    @objc private func recognizeLongPress(_ sender: UILongPressGestureRecognizer) {
        // Do not generate pins many times during long press.
        if sender.state != UIGestureRecognizer.State.began {
            return
        }
        
        let location = sender.location(in: mapView)
        let coordinate: CLLocationCoordinate2D = mapView.convert(location, toCoordinateFrom: mapView)
        let pin: MKPointAnnotation = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
        addNewLocation(lat: coordinate.latitude, lng: coordinate.longitude)
    }
    
    func addNewLocation(lat: Double, lng: Double) {
        print("Should save lng and lat")
        let mapDB = Map(context: dataController.viewContext)
        mapDB.latitude = lat
        mapDB.longitude = lng
        try? dataController.viewContext.save()
    }
    
    func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Map> = Map.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "latitude", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResults = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "mapAnnotations")
        fetchedResults.delegate = self
        
        do {
            try fetchedResults.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    
    fileprivate func fetchMapLocation() {
        var annotations = [MKPointAnnotation]()
        for coordinateObject in fetchedResults.fetchedObjects!{
            let lat = coordinateObject.latitude
            let lng = coordinateObject.longitude
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Should show album view")
        //let photoController = PhotoAlbumViewController()
        let photoController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Photo") as! PhotoAlbumViewController
        present(photoController, animated: true, completion: nil)
    }
    
    
}
