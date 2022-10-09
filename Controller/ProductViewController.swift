//
//  ProductViewController.swift
//  Trax

//  Developed By OmerKhan on 22/08/2022.


import UIKit
import Alamofire
import ProgressHUD

class ProductViewController: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    
    
    @IBOutlet weak var brandNameLabel: UILabel!
    
    
    @IBOutlet weak var brandDescriptionLabel: UILabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    lazy var shareButton: UIButton = {
       let button = UIButton()
       button.layer.masksToBounds = false
       button.setImage(UIImage(named: "share_ic"), for: .normal)
       return button
    }()
    
    
    lazy var likeButton: UIButton = {
       let button = UIButton()
       button.layer.masksToBounds = false
       button.setImage(UIImage(named: "like_ic"), for: .normal)
       return button
    }()
    
    lazy var quickCheckoutButton: UIButton = {
       let button = UIButton()
      // button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.setTitleColor(UIColor.white, for: .normal)
       button.layer.masksToBounds = false
        button.backgroundColor = #colorLiteral(red: 0.2612288594, green: 0.6843580604, blue: 0.9853752255, alpha: 1)
       button.setTitle("Buy Now", for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 18)
       return button
    }()
    
    lazy var bottomView: UIView = {
       let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.9254902005, blue: 0.9254902005, alpha: 1)
        return view
    }()
    
    lazy var bottomSloganlabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "Roboto-Medium", size: 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
       return label
    }()
    
    var btnBarBadge : CartBadgeBarItem!
    
    
    var voucherId = ""
    var merchantId = ""
    var v_amount = ""
   
    
    var userId = ""
    var isLogined = false
    
    var voucher: VoucherDetail?
    var coupons = [Coupon]()
    var merchantBranches = [Branch]()
    var merchantAbout : MerchantAbout?
    var review = [Review]()
    
    lazy var segmentsContainerView: UIView = {
        let view = UIView(frame: .zero)
        
        return view
    }()
    
    lazy var couponView: CouponView = {
       let view = CouponView()
        view.controller = self
        return view
    }()
    lazy var branchesView: BranchesView = {
       let view = BranchesView()
        view.controller = self
        return view
    }()
    
    lazy var aboutView: AboutView = {
       let view = AboutView()
        return view
    }()
   
    
    lazy var reviewView: ReviewsView = {
       let view = ReviewsView()
        return view
    }()
    
    override func viewDidDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.hidesBottomBarWhenPushed = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       self.tabBarController?.tabBar.isHidden = false
        self.hidesBottomBarWhenPushed = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.hidesBottomBarWhenPushed = true
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        self.couponView.tableView.reloadData()
        self.branchesView.tableView.reloadData()
    }
    
    @objc func cartTapped(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
         newViewController.modalPresentationStyle = .fullScreen
         self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id = UserDefaults().string(forKey: "user_id") {
            self.userId = id
            print(id)
        }
        self.isLogined = UserDefaults().bool(forKey: "isLogined")
        
        self.shareButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        
        self.quickCheckoutButton.addTarget(self, action: #selector(quickCheckoutTapped), for: .touchUpInside)
        
        self.brandNameLabel.font = UIFont(name: "Roboto-Medium", size: 20)
        self.brandNameLabel.textColor = #colorLiteral(red: 0.4272078519, green: 0.4272078519, blue: 0.4272078519, alpha: 1)
        self.brandDescriptionLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        self.brandDescriptionLabel.textColor =  #colorLiteral(red: 0.4361313333, green: 0.4361313333, blue: 0.4361313333, alpha: 1)
        self.brandNameLabel.adjustsFontSizeToFitWidth = true
        
        self.logoImage.layer.cornerRadius = 12
        self.logoImage.layer.masksToBounds = true
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = "Voucher"
        let textAttributes = [NSAttributedString.Key.foregroundColor:  #colorLiteral(red: 0.4072268039, green: 0.4072268039, blue: 0.4072268039, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.tintColor = .gray
        
        self.setupConstraints()
        
        self.logoImage.contentMode = .scaleToFill
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cart_ic"), style: .plain, target: self, action: #selector(cartTapped))

        self.segmentedControl.insertSegment(withTitle: "About", at: 2, animated: true)
        self.segmentedControl.insertSegment(withTitle: "Reviews", at: 3, animated: true)
        self.segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.sendActions(for: .valueChanged)
        
        self.getVoucherDetail()
        self.getCoupons()
        self.getMerchantBranches()
        self.getMerchantAbout()
        setupBadgeItem()
        getCartDetail()
        getReview()
    }
    
    private func getCartDetail(){
        
        ProgressHUD.show()
        
        print(self.userId)
        
        let url = rootUrl + "carttotal_api?user_id=\(self.userId)"
        print(url)
        AF.request(url).responseDecodable(of: CartItem.self) { response in
            
            print(response)
            ProgressHUD.dismiss()
            guard let cart = response.value else {
                return
            }
            self.view.isUserInteractionEnabled = true
            let cartItemCount = cart.data.count
            UserDefaults().set(cartItemCount, forKey: "cart_count")
            self.setCartBadge()
            
        }
    }
    fileprivate func setCartBadge() {
        var cartCount = UserDefaults().integer(forKey: "cart_count")
        print(cartCount)
        
        if cartCount > 0 {self.btnBarBadge.badgeValue = "\(cartCount)"}
    }
    
    
    private func setupBadgeItem(){
        
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
        
        //self.navigationItem.rightBarButtonItem = btnBarBadge
        self.btnBarBadge.tintColor = .white
    }
    
    
    @objc func addToCartTapped(){
        self.view.isUserInteractionEnabled = true
        ProgressHUD.show()
        if isLogined{
            
            print(self.userId)
            
            let param = "user_id=\(self.userId)&v_id=\(self.voucherId)"
            print(rootUrl + "cart_api?" + param)
            AF.request(rootUrl + "cart_api?" + param,
                       method: .post).response { response in
                print(response)
                ProgressHUD.dismiss()
                ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: "Succesfully added to cart.")
                self.view.isUserInteractionEnabled = true
                
                var cartCount = UserDefaults().integer(forKey: "cart_count")
                cartCount += 1
                UserDefaults.standard.set(cartCount, forKey: "cart_count")
                self.btnBarBadge.badgeValue = "\(cartCount)"
                ProgressHUD.dismiss()
                self.view.isUserInteractionEnabled = true
               
            }
        }else{
            ProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
            ShowNotificationMessages.sharedInstance.showView(message: "Please Login First to add to cart.")
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "SignInVc") as! SignInViewController
            
            newViewController.isFromProduct  = true
            
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @objc func quickCheckoutTapped(){
        
        
        if isLogined{
            
            let vc = CheckoutViewController()
            vc.vId = self.voucherId
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true) //present(vc, animated: true)
            
        }else{
            ProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
            ShowNotificationMessages.sharedInstance.showView(message: "Please Login First Checkout.")
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "SignInVc") as! SignInViewController
            newViewController.isGoingForCheckout = true
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
        
    }
    
    
    @objc func segmentedControlChanged(_ sender: UISegmentedControl){
        
        
        self.couponView.isHidden = true
        self.branchesView.isHidden = true
        self.aboutView.isHidden = true
        self.reviewView.isHidden = true
       
        switch sender.selectedSegmentIndex {

        case 0 : self.couponView.isHidden = false
        case 1:  self.branchesView.isHidden = false
        case 2:  self.aboutView.isHidden = false
        case 3:  self.reviewView.isHidden = false
            
        default:
            break;
        }
    }
    
    private func getVoucherDetail(){
        
        ProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        let url = rootUrl + "productdetailpage_api?v_id=\(self.voucherId)"
        print(url)
        
        
       AF.request(url).responseDecodable(of: [VoucherDetail].self) { response in
            
            print(response)
            
            guard let voucher = response.value else {
                return
            }
            self.voucher = voucher.first
            
            if let thisVoucher = voucher.first{
                self.brandNameLabel.text = thisVoucher.mName!
                self.brandDescriptionLabel.text = thisVoucher.mDesc!
                
                var newImage = thisVoucher.vImage
                
                let image = newImage.filter {!$0.isWhitespace}
                
                if let imageUrl = URL(string: imageRootUrl + image){
                    print(imageUrl)
                    
                    self.logoImage.sd_setImage(with: imageUrl)
                }
                
                
                self.v_amount = thisVoucher.vDiscount
                
                
                
                
                ProgressHUD.dismiss()
            }
        }
    }
    
    private func getCoupons(){
        //productdetailpagecoupon_api?v_id=1
        self.view.isUserInteractionEnabled = false
        let url = rootUrl + "productdetailpagecoupon_api?v_id=\(self.voucherId)"
        
        AF.request(url).responseDecodable(of: [Coupon].self) { response in
            
            print(response)
            
            guard let coupons = response.value else {
                return
            }
            self.coupons = coupons
            self.couponView.couponmodel = coupons
            self.couponView.controller = self
            self.couponView.tableView.reloadData()
            
            self.bottomSloganlabel.text = "GET ALL \(coupons.count) COUPONS FOR JUST AED\(self.v_amount), BUY NOW. LIMITED TIME OFFER!"
            
            self.view.isUserInteractionEnabled = true
            ProgressHUD.dismiss()
         }
    }
    
 
    
    private func getMerchantBranches(){
        self.view.isUserInteractionEnabled = false
        let url = rootUrl + "productdetailpagebranch_api?m_id=\(self.merchantId)"
    
        AF.request(url).responseDecodable(of: [Branch].self) { response in
            
            print(response)
            guard let branches = response.value else {
                return
            }
            self.merchantBranches = branches
            self.branchesView.model = branches
            self.branchesView.pageControl.numberOfPages = branches.count
            self.branchesView.tableView.reloadData()
            ProgressHUD.dismiss()
         }
    }
    
    private func getMerchantAbout(){
        self.view.isUserInteractionEnabled = false
        let url = rootUrl + "productdetailpageabout_api?m_id=\(self.merchantId)"
        print(url)
        
        AF.request(url).responseDecodable(of: [MerchantAbout].self) { response in
            
            print(response)
            guard let about = response.value else {
                return
            }
            self.merchantAbout = about.first
            self.aboutView.aboutLabel.text = about.first?.mDesc
            ProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
         }
    }
    
    private func getReview(){
        
        let url = rootUrl + "review_api?v_id=\(self.voucherId)"
        AF.request(url).responseDecodable(of: [Review].self) { response in
            
            print(response)
            guard let reviews = response.value else {
                return
            }
            self.review = reviews
            self.reviewView.reviews = reviews
            self.reviewView.tableView.reloadData()
            
        }
    }
 
    
    func setupConstraints(){
        self.logoImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        self.logoImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15).isActive = true
        self.logoImage.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3).isActive = true
        self.logoImage.heightAnchor.constraint(equalTo: self.logoImage.widthAnchor).isActive = true
        self.logoImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.brandNameLabel.topAnchor.constraint(equalTo: self.logoImage.topAnchor).isActive = true
        self.brandNameLabel.leadingAnchor.constraint(equalTo: self.logoImage.trailingAnchor, constant: 5).isActive = true
        self.brandNameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        self.brandNameLabel.heightAnchor.constraint(equalTo: self.logoImage.heightAnchor, multiplier: 0.2).isActive = true
        self.brandNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.brandDescriptionLabel.topAnchor.constraint(equalTo: self.brandNameLabel.bottomAnchor, constant: 2).isActive = true
        self.brandDescriptionLabel.leadingAnchor.constraint(equalTo: self.brandNameLabel.leadingAnchor).isActive = true
        self.brandDescriptionLabel.trailingAnchor.constraint(equalTo: self.brandNameLabel.trailingAnchor).isActive = true
        self.brandDescriptionLabel.bottomAnchor.constraint(equalTo: self.logoImage.bottomAnchor).isActive = true
        self.brandDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.segmentedControl.topAnchor.constraint(equalTo: self.logoImage.bottomAnchor, constant: 5).isActive = true
        self.segmentedControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        self.segmentedControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        self.segmentedControl.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.06).isActive = true
        self.segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        
        //let bottomOffset = self.tabBarController?.tabBar.bounds.height
        self.view.addSubview(couponView)
        self.couponView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        self.couponView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        self.couponView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -170).isActive = true
        self.couponView.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 2).isActive = true
        
        self.couponView.translatesAutoresizingMaskIntoConstraints = false
        couponView.backgroundColor = .blue
        
        self.view.addSubview(branchesView)
        self.branchesView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        self.branchesView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        self.branchesView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -170).isActive = true
        self.branchesView.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 2).isActive = true
        
        self.branchesView.translatesAutoresizingMaskIntoConstraints = false
        self.branchesView.isHidden = true
        
        self.view.addSubview(aboutView)
        self.aboutView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        self.aboutView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        self.aboutView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -170).isActive = true
        self.aboutView.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 2).isActive = true
        
        self.aboutView.translatesAutoresizingMaskIntoConstraints = false
        self.aboutView.isHidden = true
        
        self.view.addSubview(reviewView)
        self.reviewView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        self.reviewView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        self.reviewView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -170).isActive = true
        self.reviewView.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 2).isActive = true
        
        self.reviewView.translatesAutoresizingMaskIntoConstraints = false
        self.reviewView.isHidden = true
        
        let bottomOffset = (self.tabBarController?.tabBar.bounds.height)!
        
        self.view.addSubview(shareButton)
        shareButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5).isActive = true
        shareButton.topAnchor.constraint(equalTo: self.couponView.bottomAnchor, constant: 5).isActive = true
        shareButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.15).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.view.addSubview(likeButton)
        likeButton.leadingAnchor.constraint(equalTo: self.shareButton.trailingAnchor, constant: 5).isActive = true
        likeButton.topAnchor.constraint(equalTo: self.couponView.bottomAnchor, constant: 5).isActive = true
        likeButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.15).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        

        self.view.addSubview(quickCheckoutButton)
         quickCheckoutButton.leadingAnchor.constraint(equalTo: self.likeButton.trailingAnchor, constant: 5).isActive = true
         quickCheckoutButton.topAnchor.constraint(equalTo: self.couponView.bottomAnchor, constant: 5).isActive = true
         quickCheckoutButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
         quickCheckoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
         quickCheckoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.view.addSubview(bottomView)
        bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        bottomView.topAnchor.constraint(equalTo: self.quickCheckoutButton.bottomAnchor, constant: 5).isActive = true
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        self.bottomView.addSubview(bottomSloganlabel)
        bottomSloganlabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        bottomSloganlabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        bottomSloganlabel.topAnchor.constraint(equalTo: quickCheckoutButton.bottomAnchor, constant: 1).isActive = true
        bottomSloganlabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
        bottomSloganlabel.translatesAutoresizingMaskIntoConstraints = false
    
    }
    

    

}

