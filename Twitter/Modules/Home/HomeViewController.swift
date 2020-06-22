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

    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getPosts()
    }
    
    
    //MARK: - Private methods
    
    private func setupUi(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    private func getPosts(){
        SVProgressHUD.show()
        
        SN.get(endpoint: EndPoints.getPosts) { (result: SNResultWithEntity<[Post], ErrorResponse>) in
            
            SVProgressHUD.dismiss()
            
            switch result{
                
            case .success(let posts):
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
    
    private func deletePost(indexPath: IndexPath){
        SVProgressHUD.show()
        let postId = dataSource[indexPath.row].id
        let endPoint = EndPoints.delete + postId
        
        SN.delete(endpoint: endPoint) { (result: SNResultWithEntity<GeneralResponse, ErrorResponse>) in
            
            SVProgressHUD.dismiss()
            switch result{
                
            case .success(response: let response):
                self.dataSource.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .left)
                
            case .error(error: let error):
                NotificationBanner(title: "Error", subtitle: error.localizedDescription, style: .danger).show()
            case .errorResult(entity: let entity):
                NotificationBanner(title: "Error", subtitle: entity.error, style: .warning).show()
            }
        }
    }

}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Eliminar") { (_, _) in
            self.deletePost(indexPath: indexPath)
        }
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return dataSource[indexPath.row].author.email != ""
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
