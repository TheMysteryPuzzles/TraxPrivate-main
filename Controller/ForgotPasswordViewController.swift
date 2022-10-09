//
//  ForgotPasswordViewController.swift
//  Trax
//
//  Created by mac on 20/08/2022.
//

import UIKit
import Alamofire
import SwiftMessages
import ProgressHUD

class ForgotPasswordViewController: UIViewController {

    
    @IBOutlet weak var logoImageView: UIImageView!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var recoverButton: UIButton!
    
    
    var email = ""
    
    private func setupConstraints(){
        
        
        logoImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.55).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: self.view.bounds.width * 0.55).isActive = true
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
      
        emailTextField.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 50).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 65).isActive = true
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        
        recoverButton.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 25).isActive = true
        recoverButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        recoverButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        recoverButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 100).isActive = true
        
        recoverButton.translatesAutoresizingMaskIntoConstraints = false

        }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        self.setupConstraints()
        logoImageView.contentMode = .scaleAspectFit
        recoverButton.addTarget(self, action: #selector(recoverButtonTapped), for: .touchUpInside)
    }
    
    @objc func recoverButtonTapped(){
        
        if let emailStr = self.emailTextField.text {
           if emailStr.count > 0{
               if( AppManager.sharedInstance.checkValidEmail(data: self.emailTextField.text!)){
                   self.email = emailStr
                   
                   ProgressHUD.show()
                   self.view.isUserInteractionEnabled = false
                   
                   
                   AF.request(rootUrl + "forgotpasswordverify?user_email=\(self.email)").response { response in
                      
                       
                       ProgressHUD.dismiss()
                       
                       ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: "Please check your email to reset your password.")
                       
                       self.view.isUserInteractionEnabled = true
                       
                       self.navigationController?.popViewController(animated: true)
                       
                   }
                   
                   
               }else{
                   ShowNotificationMessages.sharedInstance.warningView(message: "Kindy enter valid email.")
               }
           }else{
                  ShowNotificationMessages.sharedInstance.warningView(message: "Kindy enter valid email.")
           }
       }
        
        
        
   
        
        
    }
    

}
