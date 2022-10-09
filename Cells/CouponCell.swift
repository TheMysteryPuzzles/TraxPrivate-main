//
//  CouponCell.swift
//  Trax
//
//  Created by mac on 22/08/2022.
//

import Foundation
import UIKit

class CouponCell: UITableViewCell {
    
    lazy var couponBodyContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1.2
       return view
    }()
    
    lazy var discountOfferView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "coupon_discount"))
        view.contentMode = .scaleToFill
        view.backgroundColor = .white
        //view.layer.cornerRadius = 12
        //view.backgroundColor = #colorLiteral(red: 0.3282429576, green: 0.6387748122, blue: 0.09363425523, alpha: 1)
        
        return view
    }()
    
    lazy var discountOfferLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Gill Sans Bold", size: 20)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var discountHeadingLabel: UILabel = {
       let label = UILabel()
        label.text = "Discount"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "Roboto-Medium", size: 17)
        return label
    }()
    
    lazy var couponOfferLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Roboto-Bold", size: 15)
        label.textColor = #colorLiteral(red: 0.4114518123, green: 0.4114518123, blue: 0.4114518123, alpha: 1)
        label.numberOfLines = 0
        return label
        
    }()
    
    lazy var coupnValidityLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Roboto-Medium", size: 15)
        label.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        label.adjustsFontSizeToFitWidth = true
        return label
        
    }()
    
    lazy var couponQtyLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.text = ""
        return label
        
    }()
    
    
    lazy var redeemButton: UIButton = {
        let button = UIButton()
        button.setTitle("Redeem Now!", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    lazy var couponSerialLabel: UILabel = {
      let label = UILabel()
      label.font = UIFont(name: "Roboto-Regular", size: 16)
      label.adjustsFontSizeToFitWidth = true
      label.textAlignment = .right
        label.textColor = #colorLiteral(red: 0.4427759484, green: 0.4427759484, blue: 0.4427759484, alpha: 1)
      return label
    }()
    
    lazy var transactionID: UILabel = {
      let label = UILabel()
      label.font = UIFont(name: "Roboto-Medium", size: 16)
      label.adjustsFontSizeToFitWidth = true
      label.textAlignment = .left
      label.textColor = #colorLiteral(red: 0.3686924273, green: 0.3686924273, blue: 0.3686924273, alpha: 1)
      label.isHidden = true
      return label
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "CouponListingCell")
        
        self.backgroundColor = .white
     
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        
        self.addSubview(discountOfferView)
        self.discountOfferView.addSubview(discountOfferLabel)
        self.discountOfferView.addSubview(discountHeadingLabel)
        self.discountOfferView.addSubview(couponSerialLabel)
        self.addSubview(couponOfferLabel)
        self.addSubview(coupnValidityLabel)
        self.addSubview(couponQtyLabel)
        self.contentView.addSubview(redeemButton)

        self.discountOfferView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.discountOfferView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.discountOfferView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        self.discountOfferView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.32).isActive = true
        self.discountOfferView.translatesAutoresizingMaskIntoConstraints = false
       
        
        
        self.discountHeadingLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        self.discountHeadingLabel.leadingAnchor.constraint(equalTo: self.discountOfferView.leadingAnchor, constant: 5).isActive = true
        self.discountHeadingLabel.trailingAnchor.constraint(equalTo: self.discountOfferView.trailingAnchor, constant: -5).isActive = true
        self.discountHeadingLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
       // discountHeadingLabel.backgroundColor = .white
        
        self.discountHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
       
        
        
       self.discountOfferLabel.centerXAnchor.constraint(equalTo: self.discountOfferView.centerXAnchor).isActive = true
        self.discountOfferLabel.centerYAnchor.constraint(equalTo: self.discountOfferView.centerYAnchor).isActive = true
        self.discountOfferLabel.heightAnchor.constraint(equalTo: self.discountOfferView.heightAnchor, multiplier: 0.45).isActive = true
        self.discountOfferLabel.widthAnchor.constraint(equalTo: self.discountOfferView.widthAnchor, constant: -10).isActive = true
        //discountOfferLabel.backgroundColor = .white
 
        self.discountOfferLabel.translatesAutoresizingMaskIntoConstraints = false
                
        self.couponQtyLabel.widthAnchor.constraint(equalTo: discountOfferView.widthAnchor, constant: -10).isActive = true
        self.couponQtyLabel.leadingAnchor.constraint(equalTo: discountOfferView.leadingAnchor, constant: 5).isActive = true
        self.couponQtyLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.couponQtyLabel.bottomAnchor.constraint(equalTo: discountOfferView.bottomAnchor, constant: -2).isActive = true
        self.couponQtyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //self.couponQtyLabel.backgroundColor = .red
        
        self.addSubview(couponBodyContainerView)
        couponBodyContainerView.leadingAnchor.constraint(equalTo: discountOfferView.trailingAnchor).isActive = true
        couponBodyContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        couponBodyContainerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        couponBodyContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        couponBodyContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        couponSerialLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        couponSerialLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        couponSerialLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
        couponSerialLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        couponSerialLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.couponOfferLabel.leadingAnchor.constraint(equalTo: self.discountOfferView.trailingAnchor, constant: 5).isActive = true
        self.couponOfferLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -1).isActive = true
        self.couponOfferLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 3).isActive = true
        self.couponOfferLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6).isActive = true
        self.couponOfferLabel.translatesAutoresizingMaskIntoConstraints = false
    
        self.addSubview(transactionID)
        transactionID.leadingAnchor.constraint(equalTo: couponOfferLabel.leadingAnchor).isActive = true
        transactionID.trailingAnchor.constraint(equalTo: couponOfferLabel.trailingAnchor).isActive = true
        transactionID.topAnchor.constraint(equalTo: couponOfferLabel.bottomAnchor, constant: 3).isActive = true
        transactionID.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        transactionID.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.coupnValidityLabel.leadingAnchor.constraint(equalTo: self.discountOfferView.trailingAnchor, constant: 5).isActive = true
        self.coupnValidityLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -3).isActive = true
        self.coupnValidityLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        self.coupnValidityLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
        self.coupnValidityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.redeemButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.35).isActive = true
        self.redeemButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.redeemButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25).isActive = true
        self.redeemButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.redeemButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.redeemButton.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let margins = UIEdgeInsets(top: 5, left: 8, bottom: 20, right: 8)
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.layer.cornerRadius = 8
    }
    
}
