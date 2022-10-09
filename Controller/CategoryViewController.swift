//
//  CategoryViewController.swift
//  Trax
//
//  Created by mac on 22/08/2022.
//

import UIKit
import Alamofire

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let searchController = UISearchController(searchResultsController: nil)
    var categoryId =  ""
    var categoryName = ""
    var vouchers = [CategoryListing]()
    
    lazy var emptyCategoryLabel: UILabel = {
       let label = UILabel()
        label.text = "There are currently no vouchers in this category."
        label.font = UIFont(name: "Roboto-Medium", size: 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
       // label.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return label
    }()
    
    lazy var tableView: UITableView = {
       let tableView = UITableView()
       
        return tableView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = self.categoryName
        self.view.addSubview(tableView)
        let textAttributes = [NSAttributedString.Key.foregroundColor:  #colorLiteral(red: 0.4072268039, green: 0.4072268039, blue: 0.4072268039, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        tableView.separatorColor = .clear
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        let bottomOffset = (self.tabBarController?.tabBar.bounds.height)!
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -bottomOffset).isActive = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableView.register(VouchersListingCell.self, forCellReuseIdentifier: "CategoryCell")
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.navigationBar.tintColor = .gray
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search Vouchers"
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
        
        //let searchBar = searchController.searchBar
        
        self.tableView.addSubview(emptyCategoryLabel)
        
        emptyCategoryLabel.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor).isActive = true
        emptyCategoryLabel.centerYAnchor.constraint(equalTo: self.tableView.centerYAnchor).isActive = true
        emptyCategoryLabel.widthAnchor.constraint(equalTo: self.tableView.widthAnchor, multiplier: 0.8).isActive = true
        emptyCategoryLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        emptyCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        emptyCategoryLabel.isHidden = true
        
        
        self.getAllVouchers()
        
    }
    func append (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString
    {
        let result = NSMutableAttributedString()
        result.append(left)
        result.append(right)
        return result
    }
    private func getAllVouchers(){
        
        let url: String = rootUrl + "detailcatpage_api?cat_id=\(self.categoryId)"
        
        AF.request(url).responseDecodable(of: [CategoryListing].self) { response in
            
            print(response)
                    guard let vouchers = response.value else {
                        return
                    }
            self.vouchers = vouchers
            print(vouchers.count)
            if vouchers.count < 1 {
                self.emptyCategoryLabel.isHidden = false
            }
            self.tableView.reloadData()
      }
        
    
    
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return vouchers.count
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.view.bounds.height * 0.2
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProductVC") as? ProductViewController
        let voucher = self.vouchers[indexPath.section]
        vc?.voucherId = voucher.vID
        vc?.merchantId = voucher.mID
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! VouchersListingCell
        
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true
        let voucher = self.vouchers[indexPath.section]
        cell.titleLabel.text = voucher.vName
         cell.selectionStyle = .none
        let attributedText = NSAttributedString(
            string: voucher.vAmount,
            attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)]
        )
            
            var price = NSAttributedString(string: "AED ")
            var discounted = NSAttributedString(string: " 75 ")
            price = self.append(left: price, right: attributedText)
            var newprice = append(left: price, right: discounted)
        
        cell.priceLabel.attributedText = newprice
        cell.descriptionLabel.text = voucher.vDesc
        let imageUrl = URL(string: imageRootUrl + voucher.vImage)
        cell.voucherImageView.sd_setImage(with: imageUrl)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
        tableView.animateCells(AnimationFactory.makeSlideIn(duration: 0.5, delayFactor: 0.05), tableView: tableView, cell: cell, indexPath: indexPath)
    }
    

    
    
}

extension CategoryViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
   
  }
}

