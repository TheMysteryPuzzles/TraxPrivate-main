//
//  DealsCell.swift
//  Trax
//
//  Created by mac on 20/09/2022.
//

import UIKit
import FSPagerView
import Cosmos


class DealsCell: FSPagerViewCell {
 
    
    lazy var dealImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleToFill
        view.layer.masksToBounds = true
        view.image = UIImage(named: "placeholder")
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.2632926438, green: 0.3086138353, blue: 0.458655578, alpha: 1)
        label.numberOfLines = 0
        label.font = UIFont(name: "Roboto-Medium", size: 16)
        return label
    }()

    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.2632926438, green: 0.3086138353, blue: 0.458655578, alpha: 1)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.font = UIFont(name: "Roboto-Bold", size: 16)
        label.text = ""
        return label
        
    }()
    
    lazy var ratingImageView: CosmosView = {
       let view = CosmosView()
        view.settings.updateOnTouch = false
        view.layer.masksToBounds = true
        view.settings.filledImage = UIImage(named: "star1")
        view.settings.starSize = 15
        view.rating = 4
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        self.addSubview(dealImageView)
        self.addSubview(titleLabel)
        self.addSubview(ratingImageView)
        self.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            
            dealImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dealImageView.heightAnchor.constraint(equalTo: self.heightAnchor),
            dealImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4),
            dealImageView.topAnchor.constraint(equalTo: self.topAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: dealImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.46),
            
            
            ratingImageView.leadingAnchor.constraint(equalTo: dealImageView.trailingAnchor, constant: 10),
            ratingImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            ratingImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.16),
            ratingImageView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 2),
            
            priceLabel.leadingAnchor.constraint(equalTo: dealImageView.trailingAnchor, constant: 10),
            priceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            priceLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25),
            priceLabel.topAnchor.constraint(equalTo: self.ratingImageView.bottomAnchor, constant: 3)
            
        ])
        
        //ratingImageView.backgroundColor = .red
        
        dealImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingImageView.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func populateCell(voucher: HomeVoucher) {
        
    
            let trimmedVImage = voucher.vImage.filter {!$0.isWhitespace}
            let url = URL(string: imageRootUrl + trimmedVImage)
            
            self.dealImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "plaeceholder"))
            self.titleLabel.text = voucher.vName
            // cell.descriptionLabel.text = voucher.vDesc
            
            let attributedText = NSAttributedString(
                string: voucher.vAmount,
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2646299005, green: 0.310806334, blue: 0.4579058886, alpha: 1)]
            )
            
            print(voucher.vAmount + voucher.vDiscount)
            
            var price = NSAttributedString(string: "AED ")
            var discounted = NSAttributedString(string: " " +  voucher.vDiscount)
            price = AppManager.sharedInstance.append(left: price, right: attributedText)
            var newprice = AppManager.sharedInstance.append(left: price, right: discounted)
            self.priceLabel.attributedText = newprice
        
            self.layer.cornerRadius = 10
            self.layer.masksToBounds = true
        
            self.dealImageView.layer.cornerRadius = 10
            self.dealImageView.layer.masksToBounds = true
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class DealsMultiCell: UICollectionViewCell {
 
    
    lazy var dealImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleToFill
        view.layer.masksToBounds = true
        view.image = UIImage(named: "placeholder")
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.2632926438, green: 0.3086138353, blue: 0.458655578, alpha: 1)
        label.numberOfLines = 0
        label.font = UIFont(name: "Roboto-Medium", size: 16)
        return label
    }()

    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.2632926438, green: 0.3086138353, blue: 0.458655578, alpha: 1)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.font = UIFont(name: "Roboto-Bold", size: 16)
        label.text = ""
        return label
        
    }()
    
    lazy var ratingImageView: CosmosView = {
       let view = CosmosView()
        view.settings.updateOnTouch = false
        view.layer.masksToBounds = true
        view.settings.filledImage = UIImage(named: "star1")
        view.settings.starSize = 15
        view.rating = 4
        return view
    }()
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.backgroundColor = .white
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        self.addSubview(dealImageView)
        self.addSubview(titleLabel)
        self.addSubview(ratingImageView)
        self.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            
            dealImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dealImageView.heightAnchor.constraint(equalTo: self.heightAnchor),
            dealImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4),
            dealImageView.topAnchor.constraint(equalTo: self.topAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: dealImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.46),
            
            
            ratingImageView.leadingAnchor.constraint(equalTo: dealImageView.trailingAnchor, constant: 10),
            ratingImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            ratingImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.16),
            ratingImageView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 2),
            
            priceLabel.leadingAnchor.constraint(equalTo: dealImageView.trailingAnchor, constant: 10),
            priceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            priceLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25),
            priceLabel.topAnchor.constraint(equalTo: self.ratingImageView.bottomAnchor, constant: 3)
            
        ])
        
        //ratingImageView.backgroundColor = .red
        
        dealImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingImageView.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func populateCell(voucher: HomeVoucher) {
        
    
            let trimmedVImage = voucher.vImage.filter {!$0.isWhitespace}
            let url = URL(string: imageRootUrl + trimmedVImage)
            
            self.dealImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "plaeceholder"))
            self.titleLabel.text = voucher.vName
            // cell.descriptionLabel.text = voucher.vDesc
            
            let attributedText = NSAttributedString(
                string: voucher.vAmount,
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2646299005, green: 0.310806334, blue: 0.4579058886, alpha: 1)]
            )
            
            print(voucher.vAmount + voucher.vDiscount)
            
            var price = NSAttributedString(string: "AED ")
            var discounted = NSAttributedString(string: " " +  voucher.vDiscount)
            price = AppManager.sharedInstance.append(left: price, right: attributedText)
            var newprice = AppManager.sharedInstance.append(left: price, right: discounted)
            self.priceLabel.attributedText = newprice
        
            self.layer.cornerRadius = 10
            self.layer.masksToBounds = true
        
            self.dealImageView.layer.cornerRadius = 10
            self.dealImageView.layer.masksToBounds = true
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
