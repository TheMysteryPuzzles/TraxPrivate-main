//
//  MyAccountViewController.swift
//  Trax
//
//  Created by mac on 23/08/2022.
//

import UIKit
import Alamofire
import ProgressHUD
import SDWebImage

class MyAccountViewController: UIViewController {

    var myVouchers = [MyVoucher]()
    var myVouchersDetail = [String : Voucher]()
    var userId = ""
    var selected_vid = ""
    var myHistory = ""
    var userEmail = ""
    var userPin = ""
    var userName = ""
    var pinIsVisible = false

    lazy var myProfileView: UIView = {
        var view = UIView(frame: self.view.frame)
       return view
    }()
    
    lazy var signInView: UIView = {
        let view = UIView(frame: self.view.frame)
        return view
    }()
    
    lazy var topView: UIImageView = {
       let view = UIImageView()
        view.image = UIImage(named: "my_acc_shape")
        view.contentMode = .scaleToFill
        return view
    }()
        
    lazy var showPinButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    lazy var usernameLabel: UILabel = {
       let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = UIFont(name: "Roboto-Bold", size: 25)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var userPinLabel: UILabel = {
       let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Roboto-Medium", size: 20)
        return label
    }()
    
    lazy var userEmailLabel: UILabel = {
       let label = UILabel()
        label.text = "Email: andrew_12@gmail.com"
        label.textColor = .white
        label.font = UIFont(name: "Roboto-Medium", size: 16)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    
    lazy var deleteAccButton: UIButton = {
        var button = UIButton()
        button.setTitle("Delete Account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 16)
        button.layer.cornerRadius = 8
        button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(deleteAccTapped), for: .touchUpInside)
        button.layer.masksToBounds = true
        return  button
    }()
    
    
    lazy var segmentedControl: UISegmentedControl = {
        var control = UISegmentedControl()
        return control
    }()
    
    
    lazy var vouchersView: VouchersView = {
       let view = VouchersView()
       view.controller = self
        return view
    }()
    
    lazy var historyView: CouponView = {
       let view = CouponView()
       return view
    }()
    
    lazy var giftsView: GiftsView = {
       let view = GiftsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "isLogined")
        defaults.set(nil, forKey: "user_id")
        defaults.set(nil, forKey: "user_name")
        defaults.set(nil, forKey: "user_email")
        defaults.set(nil, forKey: "user_code")
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! UITabBarController
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: true, completion: nil)

    }

    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        self.setupConstraints()
       // self.hidesBottomBarWhenPushed = true
        self.showPinButton.addTarget(self, action: #selector(showPinButtonTapped), for: .touchUpInside)
        
        self.segmentedControl.insertSegment(withTitle: "Vouchers", at: 0, animated: true)
        self.segmentedControl.insertSegment(withTitle: "Used Coupons", at: 1, animated: true)
        self.segmentedControl.insertSegment(withTitle: "Gifts", at: 3, animated: true)
        self.segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.sendActions(for: .valueChanged)
        
        if let id = UserDefaults().string(forKey: "user_id") {
            self.userId = id
            print(id)
        }
        
       
        
        if let email = UserDefaults().string(forKey: "user_email"){
            self.userEmail = email
        }
        if let pin = UserDefaults().string(forKey: "user_code"){
            self.userPin = pin
        }
        
        if let name = UserDefaults().string(forKey: "user_name"){
            self.userName = name
        }
        
        
        self.usernameLabel.text = self.userName
        self.userPinLabel.text = "Pin Code"
        self.userEmailLabel.text = self.userEmail
        
        self.navigationController?.navigationBar.barTintColor = UIColor.gray
         self.navigationController?.navigationBar.tintColor = UIColor.gray
        
        let imageView =  UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.image = UIImage(named: "logo_small2")
        imageView.contentMode = .scaleToFill
        //self.navigationItem.titleView = imageView
        
        let logoImage = UIImage(named: "nav_logo")
            let logoImageView = UIImageView.init(image: logoImage)
            logoImageView.frame = CGRectMake(-10, 0, 100, 25)
        logoImageView.contentMode = .scaleToFill
        logoImageView.layer.masksToBounds = true
            let imageItem = UIBarButtonItem.init(customView: logoImageView)
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            negativeSpacer.width = -10
            navigationItem.leftBarButtonItems = [negativeSpacer, imageItem]
        
        
       // getMyVouchers()
        self.getMyHistory()
        self.vouchersView.controller = self
        
    }
    
    private func getMyVouchers(){
        
        ProgressHUD.show()
        self.myVouchers = [MyVoucher]()
        
        let url = rootUrl + "myprofile_voucher_api?user_id=\(self.userId)"
        
        
        AF.request(url).responseDecodable(of: [MyVoucher].self) { response in
            
            ProgressHUD.dismiss()
            
            print(response)
            guard let vouchers = response.value else {
                return
            }
            
            var v_ids = [String]()
            for voucher in vouchers {
                v_ids.append(voucher.vID)
            }
            let uniqueVids = v_ids.unique
            
            
          
            
            if vouchers.count > 0 {
                for voucher in vouchers {
                    self.myVouchers.append(voucher)
                    if self.myVouchersDetail[voucher.vID] == nil {
                        self.getMyVoucherDetail(v_id: voucher.vID, count: uniqueVids.count)
                    }
                }
            }else{
                
                self.vouchersView.emptyVouchersLabel.isHidden = false
                ProgressHUD.dismiss()
            }
            print(self.myVouchers)
            
            self.vouchersView.myvoucher = self.myVouchers
        }
    }
    
    
    func getMyVoucherDetail(v_id: String, count: Int){
    
            let url = rootUrl + "productdetailpage_api?v_id=\(v_id)"
            
            self.vouchersView.emptyVouchersLabel.isHidden = true
            self.myVouchersDetail = [String :Voucher]()
            
            AF.request(url).responseDecodable(of: [Voucher].self) { response in
                
                print(response)
                guard let voucher = response.value else {
                    return
                }
                
                self.myVouchersDetail[v_id] = voucher.first!
                if self.myVouchersDetail.count == count {
                    
                    self.vouchersView.vouchers = self.myVouchersDetail
                    self.vouchersView.tableView.reloadData()
                    ProgressHUD.dismiss()
                    
                }
                
                
                
            }
            
        
    }
    
    @objc private func showPinButtonTapped(){
        
        
        if pinIsVisible{
            self.userPinLabel.text = "Pin Code"
            self.showPinButton.setImage(UIImage(named: "eye_visible"), for: .normal)
            pinIsVisible = false
        }else{
            print(self.userPin)
            self.userPinLabel.text = self.userPin
            self.showPinButton.setImage(UIImage(named: "eye_hidden"), for: .normal)
            pinIsVisible = true
        }
    }
    
    
    func getMyHistory(){
        ProgressHUD.show()
        let url = rootUrl + "getredemptionhistory_api?user_id=\(self.userId)"
        
        print(url)
        
        AF.request(url).responseDecodable(of: MyHistory.self) { response in
            
            print(response)
            guard let history = response.value else {
                return
            }
            ProgressHUD.dismiss()
            if history.message.count > 0 {
                self.historyView.historyModel = history
                self.historyView.isHistory = true
                self.historyView.tableView.reloadData()
            }else{
                self.historyView.emptyCouponLabel.isHidden = false
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        if UserDefaults().bool(forKey: "isLogined"){
            
            self.myProfileView.isHidden = false
            getMyVouchers()
            
        }else{
           
            self.myProfileView.isHidden = true
            self.navigationController?.navigationItem.rightBarButtonItem = nil
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "SignInVc") as! SignInViewController
            newViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(newViewController, animated: false)
        }
        
        self.myProfileView.isHidden = false
        self.showPinButton.setImage(UIImage(named: "eye_visible"), for: .normal)
        self.showPinButton.imageView?.contentMode = .scaleAspectFit
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if UserDefaults().bool(forKey: "isLogined") {
            
        }

    }
    
    @objc func deleteAccTapped(){
        ProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        AF.request(rootUrl + "deleteUser_api?user_id=\(self.userId)").response { response in
            print(response)
            ProgressHUD.dismiss()
            
            ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: "Your account at Froffer.com is deleted successfully.")
            
            self.view.isUserInteractionEnabled = true
            
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "isLogined")
            defaults.set(nil, forKey: "user_id")
            defaults.set(nil, forKey: "user_name")
            defaults.set(nil, forKey: "user_email")
            defaults.set(nil, forKey: "user_code")
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarViewController") as! UITabBarController
            newViewController.modalPresentationStyle = .fullScreen
            self.present(newViewController, animated: true, completion: nil)
            
        }
    }
    
    
    @objc func segmentedControlChanged(_ sender: UISegmentedControl){
        
        self.vouchersView.isHidden = true
        self.historyView.isHidden = true
        self.giftsView.isHidden = true
        
        switch sender.selectedSegmentIndex {

        case 0 : self.vouchersView.isHidden = false
                 self.vouchersView.emptyVouchersLabel.isHidden = true
                 self.getMyVouchers()
        case 1:  self.historyView.isHidden = false
                 self.getMyHistory()
        case 2:  self.giftsView.isHidden = false
            
        default:
            break;
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
      
        //elf.navigationController?.navigationItem.title = "My Profile"
        //self.title = "My Profile"
       // self.navigationItem.titleView?.tintColor = .gray
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupConstraints(){
        self.view.addSubview(myProfileView)
        
        self.myProfileView.addSubview(topView)
        self.topView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.topView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.topView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.topView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25).isActive = true
        self.topView.translatesAutoresizingMaskIntoConstraints = false
        
        self.myProfileView.addSubview(segmentedControl)
        self.segmentedControl.topAnchor.constraint(equalTo: self.topView.bottomAnchor, constant: -15).isActive = true
        self.segmentedControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive = true
        self.segmentedControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        self.segmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.bringSubviewToFront(segmentedControl)
        
        self.topView.addSubview(usernameLabel)
        self.usernameLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        self.usernameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        self.usernameLabel.widthAnchor.constraint(equalTo: self.topView.widthAnchor, multiplier: 0.5).isActive = true
        self.usernameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.topView.addSubview(userPinLabel)
        self.userPinLabel.topAnchor.constraint(equalTo: self.usernameLabel.topAnchor).isActive = true
        self.userPinLabel.leadingAnchor.constraint(equalTo: self.usernameLabel.trailingAnchor, constant: 23).isActive = true
        self.userPinLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.userPinLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.userPinLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(showPinButton)
        showPinButton.topAnchor.constraint(equalTo: userPinLabel.topAnchor).isActive = true
        showPinButton.leadingAnchor.constraint(equalTo: userPinLabel.trailingAnchor, constant: 10).isActive = true
        showPinButton.heightAnchor.constraint(equalTo: userPinLabel.heightAnchor).isActive = true
        showPinButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        showPinButton.translatesAutoresizingMaskIntoConstraints = false
        
        showPinButton.isUserInteractionEnabled = true
        view.bringSubviewToFront(showPinButton)
        
        self.topView.addSubview(userEmailLabel)
        self.userEmailLabel.topAnchor.constraint(equalTo: self.usernameLabel.bottomAnchor, constant: 10).isActive = true
        self.userEmailLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        self.userEmailLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        self.userEmailLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        self.userEmailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.view.addSubview(deleteAccButton)
        deleteAccButton.leadingAnchor.constraint(equalTo: userPinLabel.leadingAnchor).isActive = true
        deleteAccButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        deleteAccButton.heightAnchor.constraint(equalTo: userEmailLabel.heightAnchor).isActive = true
        deleteAccButton.topAnchor.constraint(equalTo: userEmailLabel.topAnchor).isActive = true
        deleteAccButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.myProfileView.addSubview(vouchersView)
        self.vouchersView.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 10).isActive = true
        self.vouchersView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5).isActive = true
        self.vouchersView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5).isActive = true
        let bottomOffset = self.tabBarController?.tabBar.bounds.height
        self.vouchersView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -bottomOffset!).isActive = true
        self.vouchersView.translatesAutoresizingMaskIntoConstraints = false
        
        self.myProfileView.addSubview(historyView)
        self.historyView.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 10).isActive = true
        self.historyView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5).isActive = true
        self.historyView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5).isActive = true
        self.historyView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -bottomOffset!).isActive = true
        self.historyView.translatesAutoresizingMaskIntoConstraints = false
        self.historyView.isHidden = true
        
        self.myProfileView.addSubview(giftsView)
        
        
        
        NSLayoutConstraint.activate([
            
            self.giftsView.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 10),
            self.giftsView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            self.giftsView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
            self.giftsView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -bottomOffset!)
        ])
        
        self.giftsView.isHidden = true
        
        
        
        
    }

}

class VouchersView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var controller: MyAccountViewController? = nil
    var vouchers = [String : Voucher]()
    var myvoucher = [MyVoucher]()
    
    lazy var emptyVouchersLabel: UILabel = {
       let label = UILabel()
       label.text = "You currently have no active vouchers."
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        label.font = UIFont(name: "Roboto-Medium", size: 18)
        return label
    }()
    
    func isEven(index: Int) -> Bool {
        if index % 2 == 0 {
            return true
        }
        return false
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myvoucher.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let vc = MyCouponsTableViewController()
        vc.modalPresentationStyle = .fullScreen
        print(self.myvoucher[indexPath.row].vIDIssuance)
        
        vc.selected_issuance_id = self.myvoucher[indexPath.row].vIDIssuance
       
        vc.v_id = self.myvoucher[indexPath.row].vID
        let v_id = self.myvoucher[indexPath.row].vID
        vc.m_id = self.vouchers[v_id]!.mID
        self.controller?.navigationController?.pushViewController(vc, animated: true)
        
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VoucherCell", for: indexPath) as! VouchersListingCell
        
        
        let index = indexPath.row + 1
        print(index)
        if isEven(index: index){
            cell.backgroundImageView.image = UIImage(named: "v_background-1")
        }else{
            cell.backgroundImageView.image = UIImage(named: "v_background")
        }
        
        
        let v_id = self.myvoucher[indexPath.row].vID
        let voucher = self.vouchers[v_id]!
        cell.titleLabel.text = voucher.vName
        cell.descriptionLabel.text = voucher.vDesc
        cell.priceLabel.isHidden = true
        
        let trimmedVImage = voucher.vImage.filter {!$0.isWhitespace}
        let imageURL = URL(string: imageRootUrl + trimmedVImage)
        cell.voucherImageView.sd_setImage(with: imageURL)
        cell.buyNowButton.isHidden = true
        cell.discountPercentageLabel.isHidden = true
        cell.descriptionLabel.isHidden = false
        cell.descriptionLabel.text = "Redeem your coupons."
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.bounds.height * 0.35
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.frame)
        view.register(VouchersListingCell.self, forCellReuseIdentifier: "VoucherCell")
        return view
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(tableView)
        self.addSubview(emptyVouchersLabel)
        self.emptyVouchersLabel.isHidden = true
        
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.emptyVouchersLabel.isHidden = true
        
        emptyVouchersLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        emptyVouchersLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        emptyVouchersLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        emptyVouchersLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75).isActive = true
        emptyVouchersLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


extension Array where Element: Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        return uniqueValues
    }
}
