//
//  ViewController.swift
//  Trax
//
//  Created by mac on 20/08/2022.
//

import UIKit
import Alamofire
import ProgressHUD

class SignInViewController: UIViewController {

    var topbarHeight: CGFloat {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        }
    
    struct SignInResponse: Codable {
        let message: String
        let status: Bool
    }

    var email = ""
    var password = ""
    var pinCode = ""
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var letsExplore: UILabel!
    
    
    
    @IBOutlet weak var newAccButton: UIButton!
    
    
    @IBOutlet weak var forgotPassword: UIButton!
    
    var goingForward = false
    var isGoingForCheckout = false
    
    
    var isFromProduct  = false
    
    private func setupConstraints(){
        
        
        logoImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.25).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: self.view.bounds.width * 0.25).isActive = true
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        welcomeLabel.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 10).isActive = true
        welcomeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        welcomeLabel.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 65).isActive = true
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.adjustsFontSizeToFitWidth = true
        
        
        letsExplore.topAnchor.constraint(equalTo: self.welcomeLabel.bottomAnchor, constant: 10).isActive = true
        letsExplore.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        letsExplore.heightAnchor.constraint(equalToConstant: 30).isActive = true
        letsExplore.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 65).isActive = true
        
        letsExplore.translatesAutoresizingMaskIntoConstraints = false
        
        emailTextField.topAnchor.constraint(equalTo: self.letsExplore.bottomAnchor, constant: 50).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 65).isActive = true
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        passwordField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 20).isActive = true
        passwordField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordField.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 65).isActive = true
        
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        
        
        signInButton.topAnchor.constraint(equalTo: self.passwordField.bottomAnchor, constant: 25).isActive = true
        signInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signInButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 100).isActive = true
        
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        forgotPassword.topAnchor.constraint(equalTo: self.signInButton.bottomAnchor, constant: 25).isActive = true
        forgotPassword.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        forgotPassword.heightAnchor.constraint(equalToConstant: 35).isActive = true
        forgotPassword.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 100).isActive = true
        
        forgotPassword.translatesAutoresizingMaskIntoConstraints = false
        
        
        newAccButton.topAnchor.constraint(equalTo: self.forgotPassword.bottomAnchor, constant: -15).isActive = true
        newAccButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        newAccButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        newAccButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 100).isActive = true
        
        newAccButton.translatesAutoresizingMaskIntoConstraints = false

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hidesBottomBarWhenPushed = true
        self.tabBarController!.tabBar.isHidden = true
        
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
   
    }
    
    override func viewDidLoad() {
        ProgressHUD.dismiss()
        self.hidesBottomBarWhenPushed = true
        self.tabBarController?.tabBar.isHidden = true
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "cancel"), style: .done, target: self, action: #selector(cancelButtonPressed)), animated: true)
        self.navigationController?.navigationBar.tintColor = .white
        self.setupConstraints()
        signInButton.layer.cornerRadius = 12
        self.signInButton.addTarget(self, action: #selector(presentHomeVC), for: .touchUpInside)
        self.passwordField.isSecureTextEntry = true
        
        self.newAccButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        self.navigationController?.navigationBar.barTintColor = UIColor.gray
         self.navigationController?.navigationBar.tintColor = UIColor.gray
        
        logoImageView.contentMode = .scaleAspectFit
    }
    
    @objc func signUpButtonTapped(){
        
        goingForward =  true
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "registerVC") as! RegisterViewController
         newViewController.modalPresentationStyle = .fullScreen
       
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @objc func cancelButtonPressed(){
        
        if isFromProduct {
            self.navigationController?.popViewController(animated: true)
        }else{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! UITabBarController
             newViewController.modalPresentationStyle = .fullScreen
            newViewController.selectedIndex = 0
             self.present(newViewController, animated: false, completion: nil)
        }

    }
    
    
    @objc func presentHomeVC(sender: UIButton!){
        
        self.authenticate()
    }

    func authenticate(){
   
        ProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        
        if let email = self.emailTextField.text {
            
            if let password = self.passwordField.text{
                
                if AppManager.sharedInstance.checkValidEmail(data: email){
                    
                    let param1 = "signin_api?user_email=\(email)&user_password=\(password)"
                    let url = rootUrl + param1
                    print(url)
                    
                    AF.request(url, method: .post).responseDecodable(of: UserData.self) { response in
                        
                        print(response.result)
                        guard let validation = response.value else {
                            return
                        }
                        
                        if validation.status{
                            ProgressHUD.dismiss()
                            self.view.isUserInteractionEnabled = true
                            
                            let defaults = UserDefaults.standard
                            defaults.set(true, forKey: "isLogined")
                            defaults.set(validation.userData.first!.userID, forKey: "user_id")
                            
                            let userName = validation.userData.first!.userFirstname + " " + validation.userData.first!.userLastname
                            defaults.set(userName, forKey: "user_name")
                            
                            defaults.set(validation.userData.first!.userEmail, forKey: "user_email")
                            defaults.set(validation.userData.first!.userCode, forKey: "user_code")
                            
                            
                            ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: "Successfully Logined.")
                            
                            if !self.isGoingForCheckout {
                                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                
                                let newViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! UITabBarController
                                newViewController.modalPresentationStyle = .fullScreen
                                newViewController.selectedIndex = 2
                                self.present(newViewController, animated: true, completion: nil)
                                
                            }else{
                                let newViewController = CheckoutViewController()
                                newViewController.modalPresentationStyle = .fullScreen
                                self.present(newViewController, animated: true, completion: nil)
                            }
                        }else{
                            ShowNotificationMessages.sharedInstance.warningView(message: validation.message)
                            ProgressHUD.dismiss()
                            self.view.isUserInteractionEnabled = true
                            self.passwordField.text = ""
                            self.emailTextField.text = ""
                        }
                    }
                    
                }else{
                    ShowNotificationMessages.sharedInstance.warningView(message: "Please Enter correct email.")
                    ProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                }
            }
            
     
        }
        
     
        
    }
    
 

}

