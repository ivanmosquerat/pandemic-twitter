//
//  HomeViewController.swift
//  Twitter
//
//  Created by Ivan Mosquera on 18/6/20.
//  Copyright © 2020 Ivan Mosquera. All rights reserved.
//

import UIKit
import Simple_Networking
import SVProgressHUD
import NotificationBannerSwift

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private let cellId = "TweetTableViewCell"
    private var dataSource = [Post]()

    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        getPosts()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Private methods
    
    private func setupUi(){
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    private func getPosts(){
        SVProgressHUD.show()
        
        SN.get(endpoint: EndPoints.getPosts) { (response: SNResultWithEntity<[Post], ErrorResponse>) in
            
            SVProgressHUD.dismiss()
            
            switch response{
                
            case .success(response: let posts):
                self.dataSource = posts
                self.tableView.reloadData()
                
            case .error(error: let error):
                print(error.localizedDescription)
                NotificationBanner(title: "Error", subtitle: error.localizedDescription, style: .danger).show()
            case .errorResult(entity: let entity):
                NotificationBanner(title: "Error", subtitle: entity.error, style: .warning).show()
            }
        }
    }

}

// MARK: - UITableViewDataSource
 
extension HomeViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        if let cell = cell as? TweetTableViewCell{
            cell.setupCellWith(post: dataSource[indexPath.row])
        }
        
        return cell
    }
}
