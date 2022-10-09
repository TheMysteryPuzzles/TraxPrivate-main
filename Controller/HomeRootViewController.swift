//
//  HomeRootViewController.swift
//  Trax
//
//  Created by mac on 29/09/2022.
//

import UIKit

//
//  HomeViewController.swift
//  Trax
//
//  Created by mac on 20/08/2022.
//

import UIKit
import ImageSlideshow
import Alamofire
import SDWebImage
import ProgressHUD
import SkeletonView

extension HomeViewController {
    
    func createBarItems(){
       
       let customButton = UIButton(type: .custom)
       customButton.frame = CGRect(x: 0, y: 0, width: 35.0, height: 35.0)
        customButton.addTarget(self, action: #selector(cartTapped), for: .touchUpInside)
       customButton.setImage(UIImage(named: "cart_ic"), for: .normal)
       customButton.tintColor = .white
       
       self.btnBarBadge = CartBadgeBarItem()
       self.btnBarBadge.setup(customButton: customButton)
       
       self.btnBarBadge.badgeValue = "0"
       self.btnBarBadge.badgeOriginX = 20.0
       self.btnBarBadge.badgeOriginY = -4
        
        
       let searchItem = UIBarButtonItem(image: UIImage(named: "searchTabBarIcon"), style: .done, target: self, action: #selector(searchTapped))
        
       
       self.navigationItem.rightBarButtonItems = [searchItem]
       self.btnBarBadge.tintColor = .white
   }
    
    
}
