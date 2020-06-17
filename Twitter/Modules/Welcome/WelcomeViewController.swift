//
//  WelcomeViewController.swift
//  Twitter
//
//  Created by Ivan Mosquera on 15/6/20.
//  Copyright © 2020 Ivan Mosquera. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: Private methods
    
    private func setupUI(){
        loginButton.layer.cornerRadius = 25
    }
    

}
