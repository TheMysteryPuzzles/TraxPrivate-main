//
//  ReviewCell.swift
//  Trax
//
//  Created by mac on 23/08/2022.
//

import Foundation
import UIKit
import Cosmos

class ReviewCell: UITableViewCell {
    
    lazy var userId: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.font = UIFont(name: "Roboto-Bold", size: 20)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = #colorLiteral(red: 0.2514581842, green: 0.2730713885, blue: 0.30074726, alpha: 1)
        return label
    }()
    
    lazy var userReview: UILabel = {
        let label = UILabel()
        label.text  = ""
        label.font = UIFont(name: "Roboto-Medium", size: 18)
        label.textColor = #colorLiteral(red: 0.2946723924, green: 0.319999922, blue: 0.3524320152, alpha: 1)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var ratingView: CosmosView = {
       let view = CosmosView()
       view.settings.updateOnTouch = false
       view.settings.filledImage = UIImage(named: "star1")
       return view
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "ReviewCell")
        
        self.addSubview(userId)
        self.addSubview(userReview)
        self.addSubview(ratingView)
        
        self.userId.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        self.userId.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.35).isActive = true
        self.userId.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.userId.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25).isActive = true
        
        self.userId.translatesAutoresizingMaskIntoConstraints = false
        
        ratingView.leadingAnchor.constraint(equalTo: self.userId.trailingAnchor, constant: 5).isActive = true
        ratingView.topAnchor.constraint(equalTo: self.userId.topAnchor).isActive = true
        ratingView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        ratingView.heightAnchor.constraint(equalTo: self.userId.heightAnchor).isActive = true
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        
        self.userReview.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        self.userReview.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        self.userReview.topAnchor.constraint(equalTo: self.userId.bottomAnchor, constant: 5).isActive = true
        self.userReview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        self.userReview.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
