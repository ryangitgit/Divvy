//
//  ViewController.swift
//  Divvy Mapper
//
//  Created by Ryan Weatherby on 5/3/21.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return divvyStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        let divvyStation = divvyStations[indexPath.row]
        cell.textLabel?.text = divvyStation.station_name
        if let userLocation = userLocation, let docksInService = divvyStation.docks_in_service {
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = "Docks \(docksInService)\nDistance \(round(divvyStation.distance(to: userLocation)*3.28084))"
        }
        return cell
    }
    
    var userLocation: CLLocation?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var divvyStations = [DivvyStation]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        mapView.delegate = self
        mapView.showsUserLocation = true
            }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Placemark"
        if annotation.isEqual(mapView.userLocation){
            return nil
        }
        // attempt to find a cell we can recycle
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            // we didn't find one; make a new one
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            // allow this to show pop up information
            annotationView?.canShowCallout = true
            
            // attach an information button to the view
            // annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            // we have a view to reuse, so give it the new annotation
            annotationView?.annotation = annotation
        }
        
        // whether it's a new view or a recycled one, send it back
        return annotationView
    }
    
    func fetchDivvyStations() {
        StationManager.fetchDivvyStations { (divvyStations) in
            self.divvyStations = divvyStations
            if self.userLocation != nil {
                self.divvyStations.sort(by: {$0.distance(to: self.userLocation!) < $1.distance(to: self.userLocation!)})
            }
            for station in self.divvyStations{
                print(station.station_name)
                self.addAnnotationForStation(station: station)
            }
            self.tableView.reloadData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        if let userLocation = locations.first {
            self.userLocation = userLocation
            self.fetchDivvyStations()
            let center = userLocation.coordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
            let region = MKCoordinateRegion(center: center, span: span)
            mapView.setRegion(region, animated: false)
        }
    }
    
    func addAnnotationForStation(station: DivvyStation){
        let annotation = MKPointAnnotation()
        annotation.coordinate = station.coordinate!
        annotation.title = station.station_name
        if let userLocation = self.userLocation {
            annotation.subtitle = "\(Int(round(station.distance(to: userLocation)*3.28084))) feet"
        }
        mapView.addAnnotation(annotation)
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            tableView.isHidden = true
            mapView.isHidden = false
        }
        else {
            tableView.isHidden = false
            mapView.isHidden = true
        }
    }
}

