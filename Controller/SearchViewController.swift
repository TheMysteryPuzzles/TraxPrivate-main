//
//  SearchViewController.swift
//  Trax
//
//  Created by mac on 22/08/2022.
//

import UIKit
import Alamofire
import SDWebImage

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let searchController = UISearchController(searchResultsController: nil)
    var vouchers = [HomeVoucher]()
    var filteredVouchers =  [HomeVoucher]()

    lazy var tableView: UITableView = {
       let view = UITableView()
       return view
    }()
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        
        tableView.separatorColor = .clear
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        let bottomOffset = (self.tabBarController?.tabBar.bounds.height)!
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -bottomOffset).isActive = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.isTranslucent = false
        //self.navigationController?.navigationItem.title = "Search"
        self.navigationItem.title = "Search"
        
        self.tableView.register(VouchersListingCell.self, forCellReuseIdentifier: "VouchersListingCell")
        
        self.navigationController?.navigationBar.tintColor = .gray
        
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search Vouchers"
        
        self.searchController.searchBar.barTintColor = .white
        self.searchController.searchBar.backgroundColor = .white
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
        let logoImage = UIImage(named: "nav_logo")
            let logoImageView = UIImageView.init(image: logoImage)
            logoImageView.frame = CGRectMake(-10, 0, 100, 25)
        logoImageView.contentMode = .scaleToFill
        logoImageView.layer.masksToBounds = true
            let imageItem = UIBarButtonItem.init(customView: logoImageView)
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            negativeSpacer.width = -10
            navigationItem.leftBarButtonItems = [negativeSpacer, imageItem]
        self.getAllVouchers()
        
        
    }
    
    func isEven(index: Int) -> Bool {
        if index % 2 == 0 {
            return true
        }
        return false
    }
    
    private func getAllVouchers(){
        
        let url = rootUrl + "hometopproduct_api"
        print(url)
        AF.request(url).responseDecodable(of: [HomeVoucher].self) { response in
            
            print(response)
            guard let vouchers = response.value else {
                return
            }
  
            self.vouchers = vouchers
            self.filteredVouchers = vouchers
            print(self.vouchers)
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProductVC") as? ProductViewController
        let voucher = self.filteredVouchers[indexPath.section]
        vc?.voucherId = voucher.vID
        vc?.merchantId = voucher.mID
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        if self.isFiltering {
            return filteredVouchers.count
          }
            
        return self.vouchers.count
    }
    
    func append (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString
    {
        let result = NSMutableAttributedString()
        result.append(left)
        result.append(right)
        return result
    }
 
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.view.bounds.height * 0.2
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1    }
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
        tableView.animateCells(AnimationFactory.makeSlideIn(duration: 0.5, delayFactor: 0.05), tableView: tableView, cell: cell, indexPath: indexPath)


    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VouchersListingCell", for: indexPath) as! VouchersListingCell
        //cell.layer.cornerRadius = 12
        //cell.layer.masksToBounds = true
        
        let index = indexPath.section + 1
        if isEven(index: index){
            cell.backgroundImageView.image = UIImage(named: "v_background")
        }else{
            cell.backgroundImageView.image = UIImage(named: "v_background-2")
        }
        
        
        let voucher: HomeVoucher
        if isFiltering {
            voucher = self.filteredVouchers[indexPath.section]
        }else{
            voucher = self.vouchers[indexPath.section]
        }
        
         let attributedText = NSAttributedString(
             string: voucher.vAmount,
             attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)]
         )
             var price = NSAttributedString(string: "AED ")
             var discounted = NSAttributedString(string: " 75 ")
             price = self.append(left: price, right: attributedText)
             var newprice = append(left: price, right: discounted)
        
        cell.titleLabel.text = voucher.vName
        cell.priceLabel.attributedText = newprice
        cell.descriptionLabel.text = voucher.vDesc
        
        let trimmedVImage = voucher.vImage.filter {!$0.isWhitespace}
        
        if let imageUrl = URL(string: imageRootUrl + trimmedVImage){
            cell.voucherImageView.sd_setImage(with: imageUrl)
        }
        cell.selectionStyle = .none
        return cell
    }
    

    
    
}

extension SearchViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
      let searchBar = searchController.searchBar
      filterContentForSearchText(searchBar.text!)
  }
    
    func filterContentForSearchText(_ searchText: String){
       
        filteredVouchers = vouchers.filter { (voucher: HomeVoucher) -> Bool in
            return voucher.vName.lowercased().contains(searchText.lowercased())
      }
      
      tableView.reloadData()
    }
}

