//
//  CartViewController.swift
//  Trax
//
//  Created by mac on 27/08/2022.
//

import UIKit
import ProgressHUD
import Alamofire
import EzPopup


class CartViewController: UIViewController {
   
    var cartItems: CartItem?
    var userId = ""
        
    lazy var cartItemView: CartItemsView = {
        let view = CartItemsView()
       return view
    }()
    
    lazy var bottomView: UIView = {
       let view = UIView()
       view.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.9254902005, blue: 0.9254902005, alpha: 1)
       return view
        
    }()
    
    lazy var bottomCartSloganLabel: UILabel = {
       let label = UILabel()
        label.text = "Get all these vouchers to avail amazing discounts. PROCEED TO PAYMENT NOW ->"
        label.font = UIFont(name: "Roboto-Bold", size: 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
       return label
    }()
    
    lazy var totalHeadingLabel: UILabel = {
      let label = UILabel()
      label.text = " Total Amount: "
      label.font = UIFont(name: "Roboto-Medium", size: 22)
      label.textAlignment = .center
      label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
      return label
    }()

    lazy var checkoutButton: UIButton = {
       let button = UIButton()
        button.setTitle("Checkout", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = #colorLiteral(red: 0.2639086246, green: 0.6877400279, blue: 0.985373199, alpha: 1)
        button.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 20)
        button.setTitleColor(UIColor.white, for: .normal)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id = UserDefaults().string(forKey: "user_id") {
            self.userId = id
            print(id)
        }
        self.navigationController?.navigationBar.tintColor = .gray
        self.getCartDetail()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "logo_small2"))
        
        setupConstraints()
        self.checkoutButton.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints(){
        self.view.addSubview(cartItemView)
        self.cartItemView.vc = self
        
        self.cartItemView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.cartItemView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.cartItemView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.cartItemView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.75).isActive = true
        self.cartItemView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(bottomView)
        bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        bottomView.topAnchor.constraint(equalTo: self.cartItemView.bottomAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.view.addSubview(checkoutButton)
        checkoutButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        checkoutButton.topAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
        checkoutButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9).isActive = true
        checkoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        checkoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.bottomView.addSubview(totalHeadingLabel)
        totalHeadingLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: 5).isActive = true
        totalHeadingLabel.topAnchor.constraint(equalTo: self.checkoutButton.bottomAnchor, constant: 5).isActive = true
        totalHeadingLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85).isActive = true
        totalHeadingLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        totalHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
 
       
        
        self.bottomView.addSubview(bottomCartSloganLabel)
        bottomCartSloganLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        bottomCartSloganLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        bottomCartSloganLabel.topAnchor.constraint(equalTo: self.totalHeadingLabel.bottomAnchor, constant: 5).isActive = true
        bottomCartSloganLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5).isActive = true
        bottomCartSloganLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    

    @objc func checkoutButtonTapped(){
        
        self.present(CheckoutViewController(), animated: true)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
 
    private func getCartDetail(){
        
        ProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        print(self.userId)
        
        let url = rootUrl + "carttotal_api?user_id=\(self.userId)"
        print(url)
        
        AF.request(url).responseDecodable(of: CartItem.self) { response in
            
            print(response)
            ProgressHUD.dismiss()
            guard let voucher = response.value else {
                return
            }
            print(voucher)
            
            self.cartItems = voucher
            self.cartItemView.model = self.cartItems
            self.totalHeadingLabel.text = "Total Amount : " + "AED" + voucher.totalAmount
            if self.cartItems!.data.count > 0 {
                self.cartItemView.tableView.reloadData()
                self.view.isUserInteractionEnabled = true
            }else{
                self.bottomView.isHidden = true
                self.checkoutButton.isHidden = true
                self.cartItemView.tableView.isHidden = true
                self.cartItemView.emptyCartLabel.isHidden = false
                self.view.isUserInteractionEnabled = false
            }
            
           
            
        }
    }
    
}

class CartItemsView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var model: CartItem?
    
    var vc: CartViewController?
    
    lazy var emptyCartLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 12
        label.text = "You have currently no items in your cart."
        label.textColor = #colorLiteral(red: 0.3832985563, green: 0.3832985563, blue: 0.3832985563, alpha: 1)
        label.font = UIFont(name: "Roboto-Medium", size: 18)
        label.numberOfLines = 0
        label.layer.masksToBounds = true
        label.textAlignment = .center
       
        return label
        
    }()
    
    lazy var itemsLabel: VerticalTopAlignLabel = {
       let label = VerticalTopAlignLabel()
        label.text = "Cart Items"
        label.font = UIFont(name: "Roboto-Bold", size: 20)
        label.textColor = .gray
        label.adjustsFontSizeToFitWidth = true
       return label
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.addSubview(tableView)
        self.addSubview(emptyCartLabel)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(VouchersListingCell.self, forCellReuseIdentifier: "CartItemCell")
        setupConstraints()
    }
  
    
    private func setupConstraints(){
        
        self.addSubview(itemsLabel)
        
        itemsLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        itemsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        itemsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        itemsLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.05).isActive = true
        itemsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: self.itemsLabel.bottomAnchor, constant: 5).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.itemsLabel.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.itemsLabel.trailingAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.emptyCartLabel.isHidden = true
        self.emptyCartLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.emptyCartLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.emptyCartLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75).isActive = true
        self.emptyCartLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.emptyCartLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func isEven(index: Int) -> Bool {
        if index % 2 == 0 {
            return true
        }
        return false
    }
       
    func append (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString
    {
        let result = NSMutableAttributedString()
        result.append(left)
        result.append(right)
        return result
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! VouchersListingCell
        
        cell.buyNowButton.isHidden = true
        cell.selectionStyle = .none
        let voucher = model!.data[indexPath.section]
        
        let index = indexPath.section + 1
        if isEven(index: index){
            cell.backgroundImageView.image = UIImage(named: "v_background-1")
        }else{
            cell.backgroundImageView.image = UIImage(named: "v_background-2")
        }
        
        if model!.data.count > 0{
            cell.titleLabel.text = voucher.vName
           
            let attributedText = NSAttributedString(
                string: voucher.vAmount,
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)]
            )
                
                var price = NSAttributedString(string: "AED ")
            var discounted = NSAttributedString(string: " " +   voucher.vdiscount)
                price = self.append(left: price, right: attributedText)
                var newprice = append(left: price, right: discounted)
                
           
                cell.priceLabel.attributedText = newprice
            
            let trimmedVImage = voucher.vimage.filter {!$0.isWhitespace}
            let url = URL(string: imageRootUrl + trimmedVImage)
            cell.voucherImageView.sd_setImage(with: url)
            
            cell.descriptionLabel.isHidden = true
           
            //let image = voucher. vImage.filter {!$0.isWhitespace}
            return cell
        }
        self.emptyCartLabel.isHidden = false
        return cell
       
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if model != nil {
            return self.model!.data.count
        }
        return 0
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
   
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
