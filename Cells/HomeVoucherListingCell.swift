//
//  HomeVoucherListingCell.swift
//  Trax
//
//  Created by mac on 20/09/2022.
//


import Foundation
import UIKit
import Cosmos
import SkeletonView

class HomeVoucherListingCell: UICollectionViewCell {
    
    lazy var voucherImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
       // view.layer.cornerRadius = 6
        view.contentMode = .scaleToFill
        view.layer.masksToBounds = true
        view.image = UIImage(named: "placeholder")
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = UIFont(name: "Roboto-Medium", size: 16)
        //label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
        
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = UIFont(name: "Roboto-Bold", size: 28)
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

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(voucherImageView)
        voucherImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(ratingImageView)
        ratingImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            voucherImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            voucherImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            voucherImageView.topAnchor.constraint(equalTo: self.topAnchor),
            voucherImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.55),
            
            ratingImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            ratingImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            ratingImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1),
            ratingImageView.topAnchor.constraint(equalTo: voucherImageView.topAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3),
            titleLabel.topAnchor.constraint(equalTo: voucherImageView.bottomAnchor),
            
            priceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            priceLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1)
            
        ])
        
        ratingImageView.isHidden = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }


    
}

