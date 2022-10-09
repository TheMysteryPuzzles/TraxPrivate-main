//
//  MyCouponsTableViewController.swift
//  Trax
//
//  Created by mac on 23/08/2022.
//

import UIKit
import EzPopup
import Alamofire
import SDWebImage
import SwiftMessages
import SwiftConfettiView
import ProgressHUD

class MyCouponsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var userId = ""
    var selected_issuance_id = ""
    var v_id = ""
    var m_id = ""
    var myCoupons = [MyCoupon]()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        return view
    }()
    
    lazy var confettiView: SwiftConfettiView = {
       let view = SwiftConfettiView()
       return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        let bottomOffset = (self.tabBarController?.tabBar.bounds.height)!
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -bottomOffset).isActive = true
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableView.register(CouponCell.self, forCellReuseIdentifier: "CouponsCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        //
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = "Coupon"
        
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.gray]
        } else {
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.gray]
        }
        
        if let id = UserDefaults().string(forKey: "user_id") {
            self.userId = id
            print(id)
        }
    }
    
    
     func getMyCoupons(){
        
        ProgressHUD.show()
         self.view.isUserInteractionEnabled = false
        let url = rootUrl + "myprofile_coupon_api?user_id=\(self.userId)&v_id_issuance=\(selected_issuance_id)"
        
        print(url)
        
        AF.request(url).responseDecodable(of: [MyCoupon].self) { response in
            
            print(response)
            
            
            guard let coupons = response.value else {
                return
            }
            self.view.isUserInteractionEnabled = true
            ProgressHUD.dismiss()
            
            self.myCoupons = coupons
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getMyCoupons()
    }
    
  
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
         
         
         return headerView
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }

     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

     func numberOfSections(in tableView: UITableView) -> Int {
        
        return myCoupons.count
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 1
    }
    
    
    func isEven(index: Int) -> Bool {
        if index % 2 == 0 {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
        tableView.animateCells(AnimationFactory.makeSlideIn(duration: 0.5, delayFactor: 0.05), tableView: tableView, cell: cell, indexPath: indexPath)
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponsCell", for: indexPath) as! CouponCell
         
         let index = indexPath.section + 1
         
         if isEven(index: index){
             cell.discountOfferView.image = UIImage(named: "coupon_discount3")
         }else{
             cell.discountOfferView.image = UIImage(named: "coupon_discount2")
         }
         
        cell.redeemButton.isHidden = false
        let coupon = self.myCoupons[indexPath.section]
         
         if (coupon.couponDiscount == "0") {
             cell.discountOfferLabel.text = "FREE"
             cell.discountHeadingLabel.text = "Get"
         }else{
             cell.discountOfferLabel.text = "AED " + coupon.couponDiscount
         }

        cell.couponOfferLabel.text = coupon.couponOffer
        cell.couponQtyLabel.text = "Qty: " + coupon.couponQtyIssuance
        cell.couponSerialLabel.text = coupon.couponID
        cell.coupnValidityLabel.isHidden = false
        
        cell.isUserInteractionEnabled = true
        cell.selectionStyle = .none
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        self.redeemButtonTapped1(index: indexPath.section)
    }
    
    func getCouponValidDays(couponId: String, index: Int){
        
        let url1 = rootUrl + "getsystemdate_api"
        
        AF.request(url1).responseDecodable(of: String.self) { response in
            
            guard let day = response.value else {
                return
            }
            
            
            self.getCouponValidity(couponId: couponId, forDay: day, index: index)
        }
        
  
    }
    
    func getCouponValidity(couponId: String, forDay: String, index: Int){
        
        let url = rootUrl + "getactivedays_api?coupon_id=\(couponId)"
        print(url)
        AF.request(url).responseDecodable(of: CouponValidDays.self) { response in
            
            
            guard let validDays = response.value else {
                return
            }
            
            print(validDays)
            
            if let isValid = validDays.first?.getDayValue(day: forDay){
                
                
                if (isValid == "1"){
                    self.goToRedeemVc(index: index)
                }else{
                    ShowNotificationMessages.sharedInstance.warningView(message: "This Coupon is not valid to reddem on \(forDay)")
                }
            }
        }
    }
    
  
    func redeemButtonTapped1(index: Int){
        
        let coupon = self.myCoupons[index]
        print(myCoupons)
        getCouponValidDays(couponId: coupon.couponID, index: index)
    }
    
    func goToRedeemVc(index: Int){
        
        let vc = RedeemVoucherViewController()
        vc.backController = self
        let coupon = self.myCoupons[index]
        vc.v_id = self.v_id
        vc.merchantId = self.m_id
        vc.coupon_id_issuance = coupon.couponIDIssuance
        vc.coupon_serial = coupon.couponID
       
        let popUpVc = PopupViewController(contentController: vc, popupWidth: self.view.frame.width - 30, popupHeight: self.view.frame.height * AppManager.sharedInstance.getRedemptionPopUpSize())
        self.present(popUpVc, animated: true)
    }


}

