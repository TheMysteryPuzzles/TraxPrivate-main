//
//  CouponView.swift
//  Trax
//
//  Created by mac on 27/08/2022.
//
import UIKit
import EzPopup

class CouponView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    
    var couponmodel = [Coupon]()
    var historyModel: MyHistory?
    var isHistory = false
    
    var controller: ProductViewController?
    
    lazy var emptyCouponLabel: UILabel = {
       let label = UILabel()
        label.text = "You currently have no coupons to view."
         label.layer.cornerRadius = 10
         label.layer.masksToBounds = true
         label.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
         label.textAlignment = .center
         label.numberOfLines = 0
         label.font = UIFont(name: "Roboto-Medium", size: 18)
       return label
    }()
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !isHistory{
            let vc = CouponDetailViewController()
            let coupon = self.couponmodel[indexPath.section]
            vc.couponOffer = coupon.couponDetail
            vc.couponQty = coupon.couponQty
            vc.headingText = coupon.couponOffer
            vc.couponDiscount = "AED " + coupon.discount
            
            let popUpVc = PopupViewController(contentController: vc, popupWidth: self.controller!.view.frame.width - 30, popupHeight: self.controller!.view.frame.height * 0.65)
            self.controller!.present(popUpVc, animated: true)
        }
        
        
     
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isHistory {
            return self.historyModel!.message.count
        }
        return couponmodel.count
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponListingCell", for: indexPath) as! CouponCell
        
        let index = indexPath.section + 1
        if isEven(index: index){
            cell.discountOfferView.image = UIImage(named: "coupon_discount3")
        }else{
            cell.discountOfferView.image = UIImage(named: "coupon_discount")
        }
        
        cell.selectionStyle = .none
        if isHistory{
            
            let history = self.historyModel!.message[indexPath.section]
            
            cell.couponOfferLabel.text = history.couponOffer
            cell.coupnValidityLabel.text = "Redeemed on: " + history.redemptionDate
            cell.discountOfferLabel.text = "Redeemed "
            cell.couponQtyLabel.isHidden = true
            cell.discountHeadingLabel.isHidden = true
            cell.couponSerialLabel.isHidden = true
            cell.transactionID.text = "Transaction Id: " + "\(history.transactionID)"
            cell.transactionID.isHidden = false
            
            return cell
            //cell.couponDescriptionLabel.text = history.
        }
        
        cell.couponOfferLabel.font = UIFont(name: "Roboto-Bold", size: CGFloat(cell.getPreferedTitleSizeForCell()))
        
        let coupon = self.couponmodel[indexPath.section]
        cell.couponOfferLabel.text = coupon.couponOffer
        cell.coupnValidityLabel.text = coupon.validityString
        cell.couponQtyLabel.text = "Quantity: " + coupon.couponQty
        cell.couponSerialLabel.text = coupon.couponID
        if (coupon.discount == "0") {
            cell.discountOfferLabel.text = "FREE"
            cell.discountHeadingLabel.text = "Get"
        }else{
            cell.discountOfferLabel.text = "AED " + coupon.discount
        }

        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return self.bounds.height * AppManager.sharedInstance.getCouponsLitingCellSize()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
    return headerView
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.frame)
        view.register(CouponCell.self, forCellReuseIdentifier: "CouponListingCell")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(tableView)
        self.addSubview(emptyCouponLabel)
        
        
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        emptyCouponLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        emptyCouponLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        emptyCouponLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85).isActive = true
        emptyCouponLabel.heightAnchor.constraint(equalToConstant: 150).isActive = true
        emptyCouponLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyCouponLabel.isHidden = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension UITableViewCell {
    
    func getPreferedTitleSizeForCell() -> Int{
        if self.frame.height > 100 {
            return 18
        }else{
            return 15
        }
    }
}
