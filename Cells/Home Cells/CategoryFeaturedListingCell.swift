//
//  CategoryFeaturedListingCell.swift
//  Trax
//
//  Created by mac on 21/09/2022.
//

import FSPagerView
import UIKit

class CategoryFeaturedListingCell: FSPagerViewCell {
 
    var colours = [#colorLiteral(red: 0.8230586648, green: 0.5021906495, blue: 0.5025299191, alpha: 1), #colorLiteral(red: 0.4698243737, green: 0.8342708349, blue: 0.8899101615, alpha: 1), #colorLiteral(red: 0.9134370685, green: 0.7411263585, blue: 0.5426186919, alpha: 1)]
    
    lazy var dealImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        //view.contentMode = .scaleToFill
        view.layer.masksToBounds = true
        view.image = UIImage(named: "placeholder")
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(name: "Roboto-Medium", size: 17)
        return label
    }()

    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = UIFont(name: "Roboto-Bold", size: 20)
        label.text = ""
        return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.backgroundColor = .white
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = false

        self.addSubview(dealImageView)
        self.addSubview(titleLabel)
        self.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            
            dealImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dealImageView.heightAnchor.constraint(equalTo: self.heightAnchor),
            dealImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.65),
            dealImageView.topAnchor.constraint(equalTo: self.topAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: dealImageView.trailingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            
            priceLabel.leadingAnchor.constraint(equalTo: dealImageView.trailingAnchor, constant: 5),
            priceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            priceLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2),
            priceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
            
        ])
        
        dealImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func populateCell(voucher: HomeVoucher, index: Int) {
        
            
          var thisIndex = index
            if index >= self.colours.count {
                thisIndex -= thisIndex
            }
            self.backgroundColor = self.colours[index]
        
        
            let trimmedVImage = voucher.vImage.filter {!$0.isWhitespace}
            let url = URL(string: imageRootUrl + trimmedVImage)
             
          print(url)
        
        
            self.dealImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "plaeceholder"))
            self.titleLabel.text = voucher.vName
            
            self.priceLabel.text = "AED " + voucher.vDiscount
    
            self.layer.cornerRadius = 10
            self.layer.masksToBounds = true
        
            self.dealImageView.layer.cornerRadius = 10
            self.dealImageView.layer.masksToBounds = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


