//
//  BranchesCell.swift
//  Trax
//
//  Created by mac on 23/08/2022.
//

import Foundation
import UIKit
import FSPagerView

class BranchesCell: FSPagerViewCell {
    
    lazy var branchImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var branchesNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Roboto-Bold", size: 20)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
        
    }()
    
    lazy var branchesAddressLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Roboto-Bold", size: 18)
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    
    lazy var branchesPhoneLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Roboto-Medium", size: 18)
        label.text = "123456789"
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    
    override init(frame: CGRect) {
 
        super.init(frame: frame)
        
        self.addSubview(branchImageView)
        self.addSubview(branchesNameLabel)
        self.addSubview(branchesAddressLabel)
        self.addSubview(branchesPhoneLabel)
        
        
        NSLayoutConstraint.activate([
            
            branchImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            branchImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            branchImageView.topAnchor.constraint(equalTo: self.topAnchor),
            branchImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            
            branchesNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            branchesNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            branchesNameLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.15),
            branchesNameLabel.topAnchor.constraint(equalTo: branchImageView.bottomAnchor, constant: 5),
            
            branchesAddressLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            branchesAddressLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            branchesAddressLabel.topAnchor.constraint(equalTo: branchesNameLabel.bottomAnchor, constant: 5),
            branchesAddressLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.15),
  
            branchesPhoneLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            branchesPhoneLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            branchesPhoneLabel.topAnchor.constraint(equalTo: branchesAddressLabel.bottomAnchor, constant: 5),
            branchesPhoneLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   /* override func layoutSubviews() {
        super.layoutSubviews()

        let margins = UIEdgeInsets(top: 5, left: 8, bottom: 20, right: 8)
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.layer.cornerRadius = 8
    }
    */
}
