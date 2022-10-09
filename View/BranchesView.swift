//
//  BranchesView.swift
//  Trax
//
//  Created by mac on 27/08/2022.
//

import UIKit
import FSPagerView
import SDWebImage

class BranchesView: UIView, FSPagerViewDelegate, FSPagerViewDataSource {
    
    var controller: ProductViewController?
    var model =  [Branch]()
    
    var colours = [#colorLiteral(red: 0.8230586648, green: 0.5021906495, blue: 0.5025299191, alpha: 1), #colorLiteral(red: 0.4698243737, green: 0.8342708349, blue: 0.8899101615, alpha: 1), #colorLiteral(red: 0.9134370685, green: 0.7411263585, blue: 0.5426186919, alpha: 1)]
    
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return model.count
    }
    var thisIndex = 0
    
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        
        let branch = model[index]
        openGoogleMap(lat: branch.bLat, long: branch.bLong)
    }
    
    func openGoogleMap(lat: String, long: String) {
       
        print(lat, long)
          if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {

              if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(long),\(lat)") {
                        UIApplication.shared.open(url, options: [:])
               }}
        else {
             
                if let urlDestination = URL.init(string: "https://www.google.com/maps/@\(long),\(lat),18z") {
                    print(urlDestination)
                    
                                   UIApplication.shared.open(urlDestination)
                         }
                }
        }
    
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "BranchesListingCell", at: index) as! BranchesCell
        
        self.thisIndex += 1
        if thisIndex >= self.colours.count {
            self.thisIndex = 0
        }

        cell.backgroundColor = self.colours[thisIndex]
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true
        let branch = model[index]
        
        let url = imageRootUrl + branch.bImage
        let trimmedUrl = url.filter{!$0.isWhitespace}
        if let URL = URL(string: trimmedUrl){
            cell.branchImageView.sd_setImage(with: URL, placeholderImage: UIImage(named: "placeholder"))
        }
        cell.branchesNameLabel.text = branch.bTitle
        cell.branchesPhoneLabel.text = "Phone: " + branch.bPhone
        cell.branchesAddressLabel.text = "Address: " + branch.bAddress
        return cell
    }
    
    lazy var tableView: FSPagerView = {
        let view = FSPagerView(frame: self.frame)
        view.register(BranchesCell.self, forCellWithReuseIdentifier: "BranchesListingCell")
        return view
    }()
    
    lazy var pageControl: FSPageControl = {
       let view = FSPageControl()
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(tableView)
        self.addSubview(pageControl)
        
        self.backgroundColor = #colorLiteral(red: 0.980392158, green: 0.980392158, blue: 0.980392158, alpha: 1)
        
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.transformer = FSPagerViewTransformer(type: .coverFlow)
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            pageControl.widthAnchor.constraint(equalTo: tableView.widthAnchor, multiplier: 0.6),
            pageControl.heightAnchor.constraint(equalToConstant: 40)
        
        ])
        
        pageControl.numberOfPages = 3
        
        self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        pageControl.setImage(UIImage(named: "page_selected"), for: .selected)
        
        pageControl.interitemSpacing = 10.0
    }
    
    override func layoutSubviews() {
        self.tableView.itemSize = CGSize(width: self.frame.width * 0.85 , height: self.frame.height * 0.78)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
