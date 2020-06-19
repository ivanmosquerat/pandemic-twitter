//
//  RegisterViewController.swift
//  Twitter
//
//  Created by Ivan Mosquera on 15/6/20.
//  Copyright © 2020 Ivan Mosquera. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import Simple_Networking
import SVProgressHUD

class RegisterViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: Actions
    @IBAction func registerButtonAction(_ sender: Any) {
        perfomRegister()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: Private methods
    
    private func setupUI(){
        view.endEditing(false)
        registerButton.layer.cornerRadius = 25
    }
    
    private func perfomRegister(){
           
        guard let email = emailTextField.text, !email.isEmpty else {
           
           NotificationBanner(title: "Error", subtitle: "Debes especificar un email.", style: .warning).show()
           
           return
        }
        
        guard let name = nameTextField.text, !name.isEmpty else {
            
            NotificationBanner(title: "Error", subtitle: "Debes agregar un nombre.", style: .warning).show()
            
            return
        }
       
        guard let password = passwordTextField.text, !password.isEmpty else {
           
            NotificationBanner(title: "Error", subtitle: "Debes ingresar una contraseña.", style: .warning).show()
           
            return
        }
         
        let request = RegisterRequest(email: email, password: password, names: name)
        SVProgressHUD.show()
        
        SN.post(endpoint: EndPoints.register, model: request) { ( resposne: SNResultWithEntity<LoginResponse, ErrorResponse>) in
        
            SVProgressHUD.dismiss()
            
            switch resposne{
                
            case .success(response: let response):
                self.performSegue(withIdentifier: "showHome", sender: nil)
                SimpleNetworking.setAuthenticationHeader(prefix: "", token: response.token)
                
            case .error(error: let error):
                NotificationBanner(title: "Error", subtitle: error.localizedDescription, style: .danger).show()
            
            case .errorResult(entity: let entity):
                NotificationBanner(title: "Error", subtitle: entity.error, style: .danger).show()
            }
            
        }
       //performSegue(withIdentifier: "showHome", sender: nil)
        
    }
    

    

}
