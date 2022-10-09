//
//  CouponDetailViewController.swift
//  Trax
//
//  Created by mac on 01/09/2022.
//

import UIKit

class CouponDetailViewController: UIViewController {
    
    var couponOffer = ""
    var couponDiscount = ""
    var couponQty = ""
    var headingText = ""
    
    lazy var topContainerView: UIView = {
       let view = UIView()
       view.backgroundColor = #colorLiteral(red: 0.2639086246, green: 0.6877400279, blue: 0.985373199, alpha: 1)
       return view
    }()
    
    lazy var estimatedSavingsLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        //label.adjustsFontSizeToFitWidth = true
        label.text = "Estimated Savings"
        label.font = UIFont(name: "Roboto-Regular", size: 16)
        label.textAlignment = .center
       return label
    }()
    
    lazy var discountLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Roboto-Bold", size: 30)
        label.text = "AED 200"
        label.textAlignment = .center
       return label
    }()
   
    lazy var headingLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Roboto-Bold", size: 22)
        label.text = headingText
        label.numberOfLines = 0
        label.textAlignment = .center
       return label
    }()
    
    lazy var couponOfferLabel: UILabel = {
       let view = UILabel()
        view.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        view.backgroundColor = .white
        view.text = couponOffer
        view.textAlignment = .center
        view.font = UIFont(name: "Roboto-Medium", size: 18)
        view.numberOfLines = 0
       
        return view
    }()
    
    lazy var couponQtyLabel: UILabel = {
       let label = UILabel()
        label.text = "Quantity: " + couponQty
        //label.font = UIFont(name: "Vonique 64 Bold Italic", size: 15)
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    lazy var dismissViewButton: UIButton = {
       let button = UIButton()
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: "cancel_btn_ic"), for: .normal)
        return button
    }()
    
    @objc func dismissButtonTapped(){
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.2639086246, green: 0.6877400279, blue: 0.985373199, alpha: 1)
        self.view.layer.cornerRadius = 12
        
        self.view.addSubview(topContainerView)
        self.topContainerView.addSubview(estimatedSavingsLabel)
        self.topContainerView.addSubview(discountLabel)
        self.topContainerView.addSubview(headingLabel)
        self.view.addSubview(couponOfferLabel)
        self.view.addSubview(couponQtyLabel)
        self.topContainerView.addSubview(dismissViewButton)
        
        topContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        topContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        topContainerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.35).isActive = true
        topContainerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        topContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        discountLabel.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 15).isActive = true
        discountLabel.centerXAnchor.constraint(equalTo: topContainerView.centerXAnchor).isActive = true
        discountLabel.widthAnchor.constraint(equalTo: topContainerView.widthAnchor).isActive = true
        discountLabel.heightAnchor.constraint(equalTo: topContainerView.heightAnchor, multiplier: 0.25).isActive = true
        
        discountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        estimatedSavingsLabel.topAnchor.constraint(equalTo: discountLabel.bottomAnchor, constant: 2).isActive = true
        estimatedSavingsLabel.centerXAnchor.constraint(equalTo: topContainerView.centerXAnchor).isActive = true
        estimatedSavingsLabel.widthAnchor.constraint(equalTo: topContainerView.widthAnchor).isActive = true
        estimatedSavingsLabel.heightAnchor.constraint(equalTo: topContainerView.heightAnchor, multiplier: 0.2).isActive = true
        
        estimatedSavingsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headingLabel.topAnchor.constraint(equalTo: estimatedSavingsLabel.bottomAnchor, constant: 2).isActive = true
        headingLabel.centerXAnchor.constraint(equalTo: topContainerView.centerXAnchor).isActive = true
        headingLabel.widthAnchor.constraint(equalTo: topContainerView.widthAnchor).isActive = true
        headingLabel.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor).isActive = true
        
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        couponOfferLabel.topAnchor.constraint(equalTo: topContainerView.bottomAnchor).isActive = true
        couponOfferLabel.centerXAnchor.constraint(equalTo: topContainerView.centerXAnchor).isActive = true
        couponOfferLabel.widthAnchor.constraint(equalTo: topContainerView.widthAnchor).isActive = true
        couponOfferLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true
        
        couponOfferLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dismissViewButton.rightAnchor.constraint(equalTo: self.topContainerView.rightAnchor, constant: -5).isActive = true
        dismissViewButton.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 5).isActive = true
        dismissViewButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        dismissViewButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dismissViewButton.translatesAutoresizingMaskIntoConstraints = false
        
        couponQtyLabel.topAnchor.constraint(equalTo: self.couponOfferLabel.bottomAnchor).isActive = true
        couponQtyLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        couponQtyLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        couponQtyLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        couponQtyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.discountLabel.text = self.couponDiscount
        
       
    }

}
class VerticalTopAlignLabel: UILabel {

    override func drawText(in rect:CGRect) {
        guard let labelText = text else {  return super.drawText(in: rect) }

        let attributedText = NSAttributedString(string: labelText, attributes: [NSAttributedString.Key.font: font])
        var newRect = rect
        newRect.size.height = attributedText.boundingRect(with: rect.size, options: .usesLineFragmentOrigin, context: nil).size.height

        if numberOfLines != 0 {
            newRect.size.height = min(newRect.size.height, CGFloat(numberOfLines) * font.lineHeight)
        }

        super.drawText(in: newRect)
    }

}
