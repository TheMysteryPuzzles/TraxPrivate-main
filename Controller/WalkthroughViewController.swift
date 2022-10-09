//
//  WalkthroughViewController.swift
//  Trax
//
//  Created by mac on 13/09/2022.
//

import UIKit

class WalkthroughViewController: UIViewController {

    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Get Started", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 15)
        button.backgroundColor =  #colorLiteral(red: 0.2612288594, green: 0.6843580604, blue: 0.9853752255, alpha: 1)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        return button
    }()
    
    lazy var skipButton: UIButton = {
       let button = UIButton()
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 15)
        button.backgroundColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
       return button
    }()
    
    lazy var detailImageView: UIImageView = {
       let imageView = UIImageView()
       imageView.contentMode = .scaleAspectFit
       return imageView
    }()
    
    let walkthroughImages = ["w1", "w2", "w3", "w4", "w5"]
    var currentIndex = 0
    

    var isFirstLaunched = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(skipButton)
        self.view.addSubview(detailImageView)
        self.view.addSubview(nextButton)
        
        skipButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        skipButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        skipButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        detailImageView.topAnchor.constraint(equalTo: self.skipButton.bottomAnchor, constant: 10).isActive = true
        detailImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive = true
        detailImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        detailImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.7).isActive = true
        detailImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        nextButton.leadingAnchor.constraint(equalTo: self.detailImageView.leadingAnchor, constant: 15).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: self.detailImageView.trailingAnchor, constant: -15).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nextButton.topAnchor.constraint(equalTo: detailImageView.bottomAnchor, constant: 10).isActive = true
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
       
        self.detailImageView.image = UIImage(named: self.walkthroughImages.first!)
        
        self.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        self.skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        
    }
    
    @objc private func skipButtonTapped(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabBarViewController")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
    
    
    @objc func nextButtonTapped(){
        currentIndex += 1
        
        if currentIndex == 1{
            self.nextButton.setTitle("Next", for: .normal)
        }
        if currentIndex == 4 {
            self.nextButton.setTitle("Buy Vouchers & Enjoy!", for: .normal)
        }
        
        if currentIndex < walkthroughImages.count {
            
            UIView.transition(with: self.detailImageView,
                              duration: 0.5,
                              options: .transitionFlipFromTop,
                                    animations: {
                self.detailImageView.image = UIImage(named: self.walkthroughImages[self.currentIndex])
                  }, completion: nil)
        
        }else{
            
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabBarViewController")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
        }
       
    }


}
