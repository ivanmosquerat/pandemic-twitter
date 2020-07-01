//
//  MapViewController.swift
//  Twitter
//
//  Created by Ivan Mosquera on 26/6/20.
//  Copyright © 2020 Ivan Mosquera. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var mapContainer: UIView!
    
    //MARK: - Properties
    var posts = [Post]()
    private var map: MKMapView?
    
    // MARK: - Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupMap()
    }
    

    // MARK: - Private methods
    
    private func setupMap(){
        map = MKMapView(frame: mapContainer.bounds)
        mapContainer.addSubview(map ?? UIView())
        setupMarkers()
    }
    
    private func setupMarkers(){
        posts.forEach{ item in
            let marker = MKPointAnnotation()
            marker.coordinate = CLLocationCoordinate2D(latitude: item.location.latitude, longitude: item.location.longitude)
            marker.title = item.text
            marker.subtitle = item.author.nickname
            
            map?.addAnnotation(marker)
        }
        
        guard let lastPost = posts.last else {
            return
        }
        
        let lasPostLocation = CLLocationCoordinate2D(latitude: lastPost.location.latitude, longitude: lastPost.location.longitude)
        guard let heading = CLLocationDirection(exactly: 12) else {
            return
        }
        
        map?.camera = MKMapCamera(lookingAtCenter: lasPostLocation, fromDistance: 30, pitch: 0, heading: heading)
    }
}
