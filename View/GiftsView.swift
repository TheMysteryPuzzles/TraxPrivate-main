//
//  GiftsView.swift
//  Trax
//
//  Created by mac on 07/10/2022.
//

import UIKit

class GiftsView: UIView {
    
    lazy var emptyGiftsLabel: UILabel = {
        
        let label = UILabel()
        label.text = "There are currently no gifts available."
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.4059236414, green: 0.4059236414, blue: 0.4059236414, alpha: 1)
        label.font = UIFont(name: "Roboto-Medium", size: 15)
        return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(emptyGiftsLabel)
        
        self.emptyGiftsLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        self.emptyGiftsLabel.centerYAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.emptyGiftsLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.emptyGiftsLabel.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        self.emptyGiftsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
