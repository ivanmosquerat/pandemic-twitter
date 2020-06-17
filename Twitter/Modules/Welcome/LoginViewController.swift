//
//  LoginViewController.swift
//  
//
//  Created by Ivan Mosquera on 15/6/20.
//

import UIKit
import NotificationBannerSwift
import Simple_Networking
import SVProgressHUD

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Actions
    @IBAction func loginButtonAction() {
        perfomLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI(){
        view.endEditing(false)
        loginButton.layer.cornerRadius = 25
    }
    
    private func perfomLogin(){
        
        guard let email = emailTextField.text, !email.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Debes especificar un email.", style: .warning).show()
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Debes ingresar una contraseña.", style: .warning).show()
            return
        }
        
        let request = LoginRequest(email: email, password: password)
        
        SVProgressHUD.show()
        
        SN.post(endpoint: EndPoints.login, model: request) { ( resposne: SNResultWithEntity<LoginResponse, ErrorResponse>) in
            
            SVProgressHUD.dismiss()
            switch resposne{
                
            case .success(response: let response):
                self.performSegue(withIdentifier: "showHome", sender: nil)
                
            case .error(error: let error):
                NotificationBanner(title: "Error", subtitle: error.localizedDescription, style: .danger).show()
            
             case .errorResult(entity: let entity):
                NotificationBanner(title: "Error", subtitle: entity.error, style: .danger).show()
            }
        }
        
        
    }

}
