//
//  CategoriesCell.swift
//  Trax
//
//  Created by mac on 20/08/2022.
//

import Foundation
import UIKit
import SkeletonView

class CategoriesCell: UICollectionViewCell {
 
    lazy var imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleToFill
        view.layer.masksToBounds = true
        //view.isSkeletonable = true
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Category Name"
        label.numberOfLines = 0
        label.font = UIFont(name: "Roboto-Medium", size: 12)
        label.adjustsFontSizeToFitWidth = true
        //label.isSkeletonable = true
        label.textColor = #colorLiteral(red: 0.2796882987, green: 0.3118699491, blue: 0.3967152238, alpha: 1)
        return label
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //self.showAnimatedSkeleton()
        self.backgroundColor = .clear
        
        self.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -25).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
       self.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    
    
}
