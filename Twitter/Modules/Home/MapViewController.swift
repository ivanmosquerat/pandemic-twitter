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
    private var posts = [Post]()
    private var map: MKMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMap()
    }
    

    private func setupMap(){
        map = MKMapView(frame: mapContainer.bounds)
        mapContainer.addSubview(map ?? UIView())
    }
}
