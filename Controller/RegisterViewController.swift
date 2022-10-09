//
//  RegisterViewController.swift
//  Trax
//
//  Created by mac on 20/08/2022.
//

import UIKit
import Alamofire
import ProgressHUD
import CountryPicker

var rootUrl = "https://www.bogoship.com/api/"

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var RegisterButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    
    @IBOutlet weak var pinCodeField: UITextField!
    
        
    @IBOutlet weak var firstNameField: UITextField!
    
    @IBOutlet weak var lastNameField: UITextField!
    
    
    @IBOutlet weak var mobileNumberTextField: UITextField!
    
    var seletedCountryCode = "AE"
    var selectedCountry = "UnitedArabEmirates"
    var countries: Countries?
    
    lazy var selectCountry: CountryPicker = {
        let view = CountryPicker()
        return view
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(selectCountry)
        self.setupConstraints()
        self.logoImageView.contentMode = .scaleAspectFit
        self.RegisterButton.addTarget(self, action: #selector(performSignUp), for: .touchUpInside)
        self.passwordField.isSecureTextEntry = true
        self.tabBarController!.tabBar.isHidden = true
        self.navigationController?.navigationBar.barTintColor = UIColor.gray
        self.navigationController?.navigationBar.tintColor = UIColor.gray
       
        setupCountryPicker()
        
    }
 
    
    private func setupCountryPicker(){
      
            let locale = Locale.current
            let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String?
            selectCountry.setCountry("AE")
            let theme = CountryViewTheme(countryCodeTextColor: .gray, countryNameTextColor: .gray, rowBackgroundColor: .white, showFlagsBorder: false)
            selectCountry.theme = theme
            selectCountry.showPhoneNumbers = true
        selectCountry.countryPickerDelegate = self
        self.mobileNumberTextField.text = "+971"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController!.tabBar.isHidden = true
       
    }

    override func viewWillDisappear(_ animated: Bool) {
      
    }
    
    
    @objc func performSignUp(){
     
        self.view.isUserInteractionEnabled = false
        ProgressHUD.show()
        
        
        if self.validateParameters(){
            
            let firstname = self.firstNameField.text!
            let lastname = self.lastNameField.text!
            let email = self.emailTextField.text!
            let password = self.passwordField.text!
            let pincode = self.pinCodeField.text!
            let mobileNumber = self.mobileNumberTextField.text!
        
            
            let trimmedCountry = self.selectedCountry.filter {!$0.isWhitespace}
            
            let param1 = "user_firstname=\(firstname)&user_lastname=\(lastname)&user_email=\(email)&user_password=\(password)&user_mobile=\(mobileNumber)&user_country=\(trimmedCountry)&user_code=\(pincode)"
            
    
            AF.request(rootUrl + "signup_api?" + param1).responseDecodable(of: Register.self) { response in
                
                print(response)
                guard let register = response.value else {
                    return
                }
                
                ProgressHUD.dismiss()
                
                if register.status{
                    ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: register.message)
                    self.view.isUserInteractionEnabled = true
                    self.navigationController?.popViewController(animated: true)
                }else{
                    ShowNotificationMessages.sharedInstance.warningView(message: register.message)
                    self.view.isUserInteractionEnabled = true
                }

            }
    }
}
        
    
    func validateAlphabeticValueOnly(nameValue: String) -> Bool{
        do {
         let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
         if regex.firstMatch(in: nameValue, options: [], range: NSMakeRange(0, nameValue.count)) != nil {
              
             ShowNotificationMessages.sharedInstance.warningView(message: "Name should not include numeric values.")
             ProgressHUD.dismiss()
             self.view.isUserInteractionEnabled = true
             return false
         } else {
             
         }
     }
     catch {
          
     }
        return true
    }
    
    
    private func validateParameters() -> Bool {
        
        
        if self.firstNameField.text?.count == 0 {
            ShowNotificationMessages.sharedInstance.warningView(message: "Please enter first name.")
            ProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
            return false
        }
        
        if self.emailTextField.text?.count == 0 {
            ShowNotificationMessages.sharedInstance.warningView(message: "Please enter email .")
            ProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
            return false
        }
        if self.passwordField.text?.count == 0 {
            ShowNotificationMessages.sharedInstance.warningView(message: "Please enter password.")
            ProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
            return false
        }
        if self.pinCodeField.text?.count == 0  && self.pinCodeField.text?.count != 4{
            ShowNotificationMessages.sharedInstance.warningView(message: "Please enter 4 Digit Pincode.")
            ProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
            return false
        }
        if self.mobileNumberTextField.text?.count == 0 {
            ShowNotificationMessages.sharedInstance.warningView(message: "Please enter mobile number")
            ProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
            return false
        }
   
        if AppManager.sharedInstance.checkValidEmail(data: emailTextField.text!){
            if AppManager.sharedInstance.validateMobileNumber(data: mobileNumberTextField.text!){return true}else{
                ShowNotificationMessages.sharedInstance.warningView(message: "Please enter correct mobile number")
                ProgressHUD.dismiss()
                self.view.isUserInteractionEnabled = true
                return false
            }
        }
        
        if !validateAlphabeticValueOnly(nameValue: firstNameField.text!){
            return false
        }
        if !validateAlphabeticValueOnly(nameValue: lastNameField.text!){
            return false
        }
                
       return false
        
    }
    
}

extension RegisterViewController {
    
    private func setupConstraints(){
        
        logoImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.2).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: self.view.bounds.width * 0.2).isActive = true
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        welcomeLabel.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 10).isActive = true
        welcomeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        welcomeLabel.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 65).isActive = true
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.adjustsFontSizeToFitWidth = true
        
        
        firstNameField.topAnchor.constraint(equalTo: self.welcomeLabel.bottomAnchor, constant: 15).isActive = true
        firstNameField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        firstNameField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        firstNameField.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 65).isActive = true
        
        firstNameField.translatesAutoresizingMaskIntoConstraints = false
        
        
        lastNameField.topAnchor.constraint(equalTo: self.firstNameField.bottomAnchor, constant: 15).isActive = true
        lastNameField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        lastNameField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        lastNameField.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 65).isActive = true
        
        lastNameField.translatesAutoresizingMaskIntoConstraints = false
        
        
        emailTextField.topAnchor.constraint(equalTo: self.lastNameField.bottomAnchor, constant: 15).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 65).isActive = true
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        
        passwordField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 15).isActive = true
        passwordField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        passwordField.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 65).isActive = true
        
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        
        
        pinCodeField.topAnchor.constraint(equalTo: self.passwordField.bottomAnchor, constant: 15).isActive = true
        pinCodeField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pinCodeField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        pinCodeField.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 65).isActive = true
        
        pinCodeField.translatesAutoresizingMaskIntoConstraints = false
        
        
        selectCountry.topAnchor.constraint(equalTo: self.pinCodeField.bottomAnchor, constant: 15).isActive = true
        selectCountry.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        selectCountry.heightAnchor.constraint(equalToConstant: 45).isActive = true
        selectCountry.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 65).isActive = true
        
        selectCountry.translatesAutoresizingMaskIntoConstraints = false
        
        
        mobileNumberTextField.topAnchor.constraint(equalTo: self.selectCountry.bottomAnchor, constant: 15).isActive = true
        mobileNumberTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        mobileNumberTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mobileNumberTextField.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 65).isActive = true
        
        mobileNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        
        RegisterButton.topAnchor.constraint(equalTo: self.mobileNumberTextField.bottomAnchor, constant: 25).isActive = true
        RegisterButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        RegisterButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        RegisterButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 100).isActive = true
        
        RegisterButton.translatesAutoresizingMaskIntoConstraints = false
        
    }
}


extension RegisterViewController: CountryPickerDelegate {
    
    public func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        self.seletedCountryCode = phoneCode
        self.selectedCountry = name
        self.mobileNumberTextField.text = phoneCode
      }
    
}

extension String {
    func isValidPhoneNumber() -> Bool {
          let regEx = "^\\+(?:[0-9]?){6,14}[0-9]$"

          let phoneCheck = NSPredicate(format: "SELF MATCHES[c] %@", regEx)
          return phoneCheck.evaluate(with: self)
      }
}

import Foundation

// MARK: - UserData
struct Register: Codable {
    let message: String
    let status: Bool
    

    enum CodingKeys: String, CodingKey {
        case message, status
    }
}



