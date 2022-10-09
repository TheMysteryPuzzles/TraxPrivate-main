//
//  BrandsListingCell.swift
//  Trax
//
//  Created by mac on 22/08/2022.
//

import Foundation
import UIKit
import Cosmos
import SkeletonView

class VouchersListingCell: UITableViewCell {
    
    lazy var voucherImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.layer.cornerRadius = 6
        view.contentMode = .scaleToFill
        view.layer.masksToBounds = true
        view.image = UIImage(named: "placeholder")
        return view
    }()
    
    lazy var backgroundImageView: UIImageView = {
       let view = UIImageView() //image: UIImage(named: "voucher_bg")
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
       view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.lightGray.cgColor
       return view
    }()
    
    lazy var lineView: UIImageView = {
       let view = UIImageView(image: UIImage(named: "line_image"))
        view.contentMode = .scaleAspectFit
        //view.backgroundColor = .black
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = #colorLiteral(red: 0.1562054455, green: 0.1834367216, blue: 0.2677125633, alpha: 1)
        label.font = UIFont(name: "Roboto-Medium", size: 15)
        //label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
        
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Roboto-Medium", size: 16)
        label.adjustsFontSizeToFitWidth = true
        label.isHidden = true
        label.textColor = #colorLiteral(red: 0.4847488999, green: 0.4847488999, blue: 0.4847488999, alpha: 1)
        return label
        
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.1562054455, green: 0.1834367216, blue: 0.2677125633, alpha: 1)
        //label.backgroundColor = #colorLiteral(red: 0.849591819, green: 0.2783285964, blue: 0.09220804205, alpha: 1)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.font = UIFont(name: "Roboto-Bold", size: 20)
        label.text = ""
        return label
        
    }()
    
    lazy var ratingImageView: CosmosView = {
       let view = CosmosView()
        view.settings.updateOnTouch = false
        view.settings.filledImage = UIImage(named: "star1")
        view.rating = 4
        return view
    }()
    
    lazy var discountPercentageLabel: UILabel = {
       let label = UILabel()
        label.backgroundColor = #colorLiteral(red: 0.2578753697, green: 0.6859834905, blue: 1, alpha: 1)
        label.text = "25%"
        label.textColor = .white
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.font = UIFont(name: "Roboto-Bold", size: 16)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
       return label
    }()
    
    
    lazy var buyNowButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        button.layer.cornerRadius = 2
        button.layer.masksToBounds = true
        button.setTitle(" Add To Cart ", for: .normal)
        button.titleLabel?.font = UIFont(name: "Copperplate Bold", size: 14)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: .default, reuseIdentifier: "voucherListingCell")
        
        self.backgroundImageView = UIImageView(image: UIImage(named: "v_background"))
        
        self.addSubview(backgroundImageView)
        self.addSubview(voucherImageView)
       // self.addSubview(lineView)
        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)
         self.addSubview(ratingImageView)
         self.addSubview(priceLabel)
       // self.contentView.addSubview(buyNowButton)
        

        self.backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.voucherImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.voucherImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: -1).isActive = true
        self.voucherImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor , constant: -10).isActive = true
        self.voucherImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4).isActive = true
        
        self.voucherImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel.leadingAnchor.constraint(equalTo: self.voucherImageView.trailingAnchor, constant: 5).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.ratingImageView.leadingAnchor.constraint(equalTo: self.voucherImageView.trailingAnchor, constant: 5).isActive = true
        self.ratingImageView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 5).isActive = true
        self.ratingImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.ratingImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4).isActive = true
        
        self.ratingImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.descriptionLabel.topAnchor.constraint(equalTo: self.ratingImageView.bottomAnchor, constant: 1).isActive = true
        self.descriptionLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor).isActive = true
        self.descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        self.descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        self.priceLabel.leadingAnchor.constraint(equalTo: self.voucherImageView.trailingAnchor, constant: 5).isActive = true
        self.priceLabel.topAnchor.constraint(equalTo: self.ratingImageView.bottomAnchor, constant: 1).isActive = true
        self.priceLabel.widthAnchor.constraint(equalToConstant: 130).isActive = true
        self.priceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6).isActive = true
        
        self.priceLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }


    
}
