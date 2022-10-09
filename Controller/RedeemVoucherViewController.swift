//
//  RedeemVoucherViewController.swift
//  Trax
//
//  Created by mac on 23/08/2022.
//

import UIKit
import Alamofire
import ProgressHUD
import SwiftConfettiView


class RedeemVoucherViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var merchantId = ""
    var v_id = ""
    var branches = [Branch]()
    var selectedB_ID = ""
    var userId = ""
    var coupon_id_issuance = ""
    var coupon_serial = ""
    var backController: MyCouponsTableViewController?
   
    lazy var selectBranch: UILabel = {
       let label = UILabel()
        label.text = "Select Branch"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var confettiView: SwiftConfettiView = {
       let view = SwiftConfettiView()
        view.intensity = 0.75
        return view
    }()
    
    
    lazy var transactionIdLabel: UILabel = {
       let label = UILabel()
       label.font = UIFont(name: "Roboto-Medium", size: 22)
       label.textColor = .white
       label.adjustsFontSizeToFitWidth = true
       return label
    }()
    
    lazy var couponSerialLabel: UILabel = {
       let label = UILabel()
       label.font = UIFont(name: "Roboto-Medium", size: 22)
       label.textColor = .white
       label.adjustsFontSizeToFitWidth = true
       return label
    }()

    lazy var branchName: UIPickerView = {
       let view = UIPickerView()
        view.backgroundColor = .white
       return view
    }()
    
    
    lazy var branchCode:  UITextField = {
       let field = UITextField()
       field.placeholder = "Branch Code"
        field.backgroundColor = .white
       return field
    }()
    
    lazy var redeemButton: UIButton = {
       let button = UIButton()
        button.setTitle("Redeem", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(redeemButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var pinCodeField:  UITextField = {
       let field = UITextField()
       field.placeholder = "Pin Code"
        field.backgroundColor = .white
       return field
    }()
    
    lazy var continueButton: UIButton = {
       let button = UIButton()
        button.setTitle("Continue..", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var successView: UILabel = {
        let view = UILabel()
        view.text = "Your coupon has been redeemed successfully."
        view.numberOfLines = 0
        view.font = UIFont.boldSystemFont(ofSize: 25)
        view.textColor = .white
        return view
    }()
    
    lazy var okButton: UIButton = {
       let button = UIButton()
        button.setTitle("OK", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        
       return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id = UserDefaults().string(forKey: "user_id") {
            self.userId = id
            print(id)
        }
        view.backgroundColor = .lightGray
        setupViewConstraints()
        
        branchName.delegate = self
        branchName.dataSource = self
        branchName.center = self.view.center
        
        self.view.backgroundColor = #colorLiteral(red: 0.2640841901, green: 0.6868806481, blue: 0.9776270986, alpha: 1)
        self.view.isOpaque = false
        
        self.view.layer.cornerRadius = 12
        getBranchData()
        
        self.view.addSubview(confettiView)
        confettiView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        confettiView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        confettiView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -100).isActive = true
        confettiView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.35).isActive = true
        confettiView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func getBranchData(){
        
        let url = rootUrl + "myprofile_coupon_branch_api?v_id=\(self.v_id)&m_id=\(self.merchantId)"
        print(url)
        
        AF.request(url).responseDecodable(of: [Branch].self) { response in
            
            print(response)
            guard let branches = response.value else {
                return
            }
            self.branches = branches
            self.branchName.reloadAllComponents()
        }
    }
    
    @objc func okButtonTapped(){
        self.backController!.getMyCoupons()
        self.dismiss(animated: true)
        
    }
    
    @objc func redeemButtonTapped(){
        
        if selectedB_ID == branchCode.text {
            
            UIView.transition(with: pinCodeField, duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                self.pinCodeField.isHidden = false
                self.continueButton.isHidden = false
                          })
        }else{
            ShowNotificationMessages.sharedInstance.warningView(message: "Invalid Branch Code.")
        }

    }
    
    @objc func continueButtonTapped(){
        ProgressHUD.show()
        let date = Date()
        
        let dateFormatted = date.formatted(date: .abbreviated, time: .standard)
        
        let urlStr = rootUrl + "redemption_api?user_id=\(self.userId)&coupon_id_issuance=\(self.coupon_id_issuance)&v_id=\(self.v_id)&b_id=\(self.selectedB_ID)&user_code=\(pinCodeField.text!)&redemption_date=\(dateFormatted)"
        
        if let encoded = urlStr.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
           let url = URL(string: encoded)
        {
            print(url)
       
           AF.request(url).responseDecodable(of: Redemption.self) { response in
            
            print(response)
            guard let response = response.value else {
                return
            }
            
            if response.status == true {
                
                ProgressHUD.dismiss()
                self.pinCodeField.isHidden = true
                self.redeemButton.isHidden = true
                self.selectBranch.isHidden = true
                self.branchCode.isHidden = true
                self.continueButton.isHidden = true
                self.branchName.isHidden = true
                
                self.transactionIdLabel.text = "Transaction ID: " + response.message
                self.couponSerialLabel.text =  self.coupon_serial
                
                UIView.transition(with: self.successView, duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: {
                    self.transactionIdLabel.isHidden = false
                    self.couponSerialLabel.isHidden = false
                    self.successView.isHidden = false
                    self.okButton.isHidden = false
                    self.showConfetti()
                    
                })
            }else{
                ProgressHUD.dismiss()
                ShowNotificationMessages.sharedInstance.warningView(message: "Invalid Pin Code.")
              }
           }
        }
    }
    
    private func showConfetti(){
       
       confettiView.startConfetti()
    }
    
    
    fileprivate func setupViewConstraints() {
        self.view.addSubview(branchName)
        self.view.addSubview(branchCode)
        self.view.addSubview(selectBranch)
        
        
        self.selectBranch.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.selectBranch.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.selectBranch.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        self.selectBranch.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.selectBranch.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.branchName.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.branchName.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.branchName.topAnchor.constraint(equalTo: self.selectBranch.bottomAnchor, constant: 10).isActive = true
        self.branchName.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.branchName.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.branchCode.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.branchCode.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.branchCode.topAnchor.constraint(equalTo: self.branchName.bottomAnchor, constant: 10).isActive = true
        self.branchCode.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.branchCode.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(redeemButton)
        self.redeemButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
        self.redeemButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
        self.redeemButton.topAnchor.constraint(equalTo: self.branchCode.bottomAnchor, constant: 10).isActive = true
        self.redeemButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.redeemButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.view.addSubview(pinCodeField)
        self.pinCodeField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
        self.pinCodeField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
        self.pinCodeField.topAnchor.constraint(equalTo: self.redeemButton.bottomAnchor, constant: 10).isActive = true
        self.pinCodeField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.pinCodeField.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(continueButton)
        self.continueButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 80).isActive = true
        self.continueButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
        self.continueButton.topAnchor.constraint(equalTo: self.pinCodeField.bottomAnchor, constant: 10).isActive = true
        self.continueButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.pinCodeField.isHidden = true
        self.continueButton.isHidden = true
        
        
        self.view.addSubview(successView)
        self.successView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.successView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 25).isActive = true
        self.successView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        self.successView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        
        self.successView.translatesAutoresizingMaskIntoConstraints = false
        self.successView.isHidden = true
        
        self.view.addSubview(transactionIdLabel)
        self.transactionIdLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.transactionIdLabel.topAnchor.constraint(equalTo: self.successView.bottomAnchor, constant: 5).isActive = true
        self.transactionIdLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        self.transactionIdLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        
        transactionIdLabel.translatesAutoresizingMaskIntoConstraints = false
        transactionIdLabel.isHidden = true
        
        self.view.addSubview(couponSerialLabel)
        self.couponSerialLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.couponSerialLabel.topAnchor.constraint(equalTo: self.transactionIdLabel.bottomAnchor, constant: 5).isActive = true
        self.couponSerialLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        self.couponSerialLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        
        couponSerialLabel.translatesAutoresizingMaskIntoConstraints = false
        couponSerialLabel.isHidden = true
        
        
        self.view.addSubview(okButton)
        self.okButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.okButton.topAnchor.constraint(equalTo: self.couponSerialLabel.bottomAnchor, constant: 5).isActive = true
        self.okButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40).isActive = true
        self.okButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40).isActive = true
        
        self.okButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.okButton.isHidden = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return branches.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.selectedB_ID = branches[row].bID
        //branches[row].
        return branches[row].bTitle
    }
    

}


import Foundation

// MARK: - Voucher
struct Redemption: Codable {
    let message: String
    let status: Bool
    
    

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case status = "status"

    }
}
