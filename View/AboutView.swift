//
//  AboutView.swift
//  Trax
//
//  Created by mac on 27/08/2022.
//

import UIKit

class AboutView: UIView {
    
    
    lazy var aboutLabel: UILabel = {
       
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        label.font = UIFont(name: "Roboto-Medium", size: 18)
        return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(aboutLabel)
        
        self.aboutLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.aboutLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.aboutLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.aboutLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
