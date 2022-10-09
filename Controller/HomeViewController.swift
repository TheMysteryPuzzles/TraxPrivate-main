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

var homeAlignmentLeading = 10.0
var homeAlignmentVerticalSpacing = 15.0
var homeSectionTitleNCollectionSpacing = 5.0
var homeAlignmentSectionTitleTopSpacing = 5.0
var homeSectionsTitleHeight = 25.0
var colours = [#colorLiteral(red: 0.8230586648, green: 0.5021906495, blue: 0.5025299191, alpha: 1), #colorLiteral(red: 0.4698243737, green: 0.8342708349, blue: 0.8899101615, alpha: 1), #colorLiteral(red: 0.9134370685, green: 0.7411263585, blue: 0.5426186919, alpha: 1)]
var sectionBackgroundColor = #colorLiteral(red: 0.980392158, green: 0.980392158, blue: 0.980392158, alpha: 1)

var imageRootUrl = "http://www.bogoship.com/admin/uploads/"

class HomeViewController: UIViewController{
    
    var userId = ""
    var isLogined = false
    
    var homeSections = [HomeSection]()
    var homeSectionCount = 3
    var homeSectionVouchers = [String: [HomeSectionVoucher]]()
    var homeSectionTypes = [SectionTypes]()
    
    lazy var rootCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let bottomOffset = (self.tabBarController?.tabBar.bounds.height)! + 5.0
        
        var collectionView = UICollectionView(frame: CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: self.view.frame.width, height: self.view.frame.height - bottomOffset), collectionViewLayout: layout)
        collectionView.tag = 0
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    var categoriesAndIds = [String : String]()
    var btnBarBadge : CartBadgeBarItem!

    lazy var voucherListingPageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    fileprivate func setCartBadge() {
        var cartCount = UserDefaults().integer(forKey: "cart_count")
        print(cartCount)
        
        if cartCount > 0 {self.btnBarBadge.badgeValue = "\(cartCount)"}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(rootCollectionView)
        ProgressHUD.show()
        createBarItems()
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .gray
        self.isLogined = UserDefaults().bool(forKey: "isLogined")
        if let id = UserDefaults().string(forKey: "user_id") {
            self.userId = id
            print(id)
        }
        
        let staticSectionSlider = HomeSection(sectionID: "0", sectionTitle: "TopSlider", sectionSerial: "Top-01", sectionDescription: "TopSlider", sectionType: "slider")
        self.homeSections.append(staticSectionSlider)
        
        let staticCategorySlider = HomeSection(sectionID: "0", sectionTitle: "Categories", sectionSerial: "Category-01", sectionDescription: "Categories ", sectionType: "slider")
        self.homeSections.append(staticCategorySlider)
        
        let staticVoucherCollection = HomeSection(sectionID: "0", sectionTitle: "Vouchers", sectionSerial: "voucher-01", sectionDescription: "HomeVouchers", sectionType: "vouchers")
        
        self.homeSections.append(staticVoucherCollection)
        
        self.homeSectionTypes.append(SectionTypes.TopSlider)
        self.homeSectionTypes.append(SectionTypes.Categories)
        self.homeSectionTypes.append(SectionTypes.Vouchers)
        
        self.rootCollectionView.register(SliderCell.self, forCellWithReuseIdentifier: "SliderSectionCell")
        self.rootCollectionView.register(VoucherListingRootCell.self, forCellWithReuseIdentifier: "FeaturedSectionVoucherCell")
        self.rootCollectionView.register(CategoryRootCell.self, forCellWithReuseIdentifier: "CategoriesSectionCell")
        self.rootCollectionView.register(HomeGenericSectionCell.self, forCellWithReuseIdentifier: "HomeGenericSectionCell")
        self.rootCollectionView.register(HomeRootMultiSectionCell.self, forCellWithReuseIdentifier: "HomeRootMultiSectionCell")
        
        rootCollectionView.delegate = self
        rootCollectionView.dataSource = self
        
        setupView()
        self.getHomeSections()
    }

    @objc func cartTapped(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
         newViewController.modalPresentationStyle = .fullScreen
         self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    var categories = [Category]()
    var categoriesImagesUrl = [String]()
    var imageSourceForSlider = [BundleImageSource]()
    var categoryNames = [String]()
    var vouchers = [HomeVoucher]()
 
    
    override func viewDidAppear(_ animated: Bool) {
   
        //self.categoryCollectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
       // self.categoryCollectionView.setNeedsLayout()
        //self.categoryCollectionView.setNeedsDisplay()
    }
    
    fileprivate func setupView() {
       
    /*    let imageView =  UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.image = UIImage(named: "logo_small2")
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        */
        
        
        let logoImage = UIImage(named: "nav_logo")
            let logoImageView = UIImageView.init(image: logoImage)
            logoImageView.frame = CGRectMake(-10, 0, 100, 25)
        logoImageView.contentMode = .scaleToFill
        logoImageView.layer.masksToBounds = true
            let imageItem = UIBarButtonItem.init(customView: logoImageView)
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            negativeSpacer.width = -10
            navigationItem.leftBarButtonItems = [negativeSpacer, imageItem]
        
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9254902005, green: 0.9254902005, blue: 0.9254902005, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.gray
        let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
        statusBar.backgroundColor = #colorLiteral(red: 0.9236147613, green: 0.9236147613, blue: 0.9236147613, alpha: 1)
        UIApplication.shared.keyWindow?.addSubview(statusBar)
    }
 
    @objc func searchTapped(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
         newViewController.modalPresentationStyle = .fullScreen
         self.navigationController?.pushViewController(newViewController, animated: true)
         //self.present(newViewController, animated: true, completion: nil)
    }
}

extension HomeViewController: SkeletonCollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    fileprivate func getFilteredVouchers(_ indexPath: IndexPath) -> [HomeVoucher] {
       
        let currentSection = self.homeSections[indexPath.row]
        print(currentSection)
        print(homeSectionVouchers)
        if let vouchersArr = self.homeSectionVouchers[currentSection.sectionID] {
            print(homeSectionVouchers)
            print(vouchersArr)
            var vid = [String]()
            for voucher in vouchersArr {
                vid.append(voucher.vID)
            }
            let arr = self.vouchers.filter({vid.contains($0.vID)})
            print(arr)
            return arr
            
        }
        return [HomeVoucher]()
    }
    
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        
        let section = self.homeSectionTypes[indexPath.row]
        let sectionName = self.homeSections[indexPath.row]
        
        self.rootCollectionView.register(SliderCell.self, forCellWithReuseIdentifier: "SliderSectionCell")
        self.rootCollectionView.register(VoucherListingRootCell.self, forCellWithReuseIdentifier: "FeaturedSectionVoucherCell")
        self.rootCollectionView.register(CategoryRootCell.self, forCellWithReuseIdentifier: "CategoriesSectionCell")
        self.rootCollectionView.register(HomeGenericSectionCell.self, forCellWithReuseIdentifier: "HomeGenericSectionCell")
        self.rootCollectionView.register(HomeRootMultiSectionCell.self, forCellWithReuseIdentifier: "HomeRootMultiSectionCell")
        switch section {
            
        case .TopSlider:
            return "SliderSectionCell"
        case .Vouchers:
            return "FeaturedSectionVoucherCell"
        case .Categories:
            return "CategoriesSectionCell"
            
        case .sigle_row:
           
            return "HomeGenericSectionCell"
        case .multi_row:
            return "HomeRootMultiSectionCell"
        case .concise:
            return "HomeGenericSectionCell"
        case .detailed:
            return "HomeGenericSectionCell"
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           // print(homeSections.count)
            return self.homeSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = self.homeSectionTypes[indexPath.row]
        let sectionName = self.homeSections[indexPath.row]
        
        switch section {
            
        case .TopSlider:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderSectionCell", for: indexPath) as! SliderCell
            return cell
        case .Vouchers:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedSectionVoucherCell", for: indexPath) as! VoucherListingRootCell
            cell.vouchers = self.vouchers
            cell.controller = self
            return cell
        case .Categories:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesSectionCell", for: indexPath) as! CategoryRootCell
            cell.categories = self.categories
            cell.controller = self
            return cell
            
        case .sigle_row:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeGenericSectionCell", for: indexPath) as! HomeGenericSectionCell
            let model = getFilteredVouchers(indexPath)
            cell.dealsWeekModel = model
            cell.section = sectionName
            cell.sectionType = section
            cell.controller = self
            return cell
            
        case .multi_row:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeRootMultiSectionCell", for: indexPath) as! HomeRootMultiSectionCell
            let model = getFilteredVouchers(indexPath)
            cell.section = sectionName
            cell.dealsWeekModel = model
            cell.controller = self
            return cell
        case .concise:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeGenericSectionCell", for: indexPath) as! HomeGenericSectionCell
            let model = getFilteredVouchers(indexPath)
            cell.dealsWeekModel = model
            cell.section = sectionName
            cell.sectionType = section
            cell.controller = self
            return cell
        case .detailed:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeGenericSectionCell", for: indexPath) as! HomeGenericSectionCell
            let model = getFilteredVouchers(indexPath)
            cell.dealsWeekModel = model
            cell.section = sectionName
            cell.sectionType = section
            cell.controller = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
   
        let section = self.homeSectionTypes[indexPath.row]
        
        switch section {
        case .TopSlider:
            return CGSize(width: self.view.frame.width, height: self.view.frame.height * 0.28)
        case .Vouchers:
            return CGSize(width: self.view.frame.width, height: self.view.frame.height * AppManager.sharedInstance.getBrandsSectionSize())
        case .Categories:
            return CGSize(width: self.view.frame.width, height: self.view.frame.height * AppManager.sharedInstance.getCategorySectionSize())
        case .sigle_row:
            return CGSize(width: self.view.frame.width, height: self.view.frame.height * AppManager.sharedInstance.getSingleRowSectionSizeAndFont())
        case .multi_row:
            return CGSize(width: self.view.frame.width, height: self.view.frame.height * 0.44)
        case .concise:
            return CGSize(width: self.view.frame.width, height: self.view.frame.height * 0.23)
        case .detailed:
            return CGSize(width: self.view.frame.width, height: self.view.frame.height * AppManager.sharedInstance.getDetailedSectionSize())
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, prepareCellForSkeleton cell: UICollectionViewCell, at indexPath: IndexPath) {
        
        print(homeSectionTypes.count)
        print(indexPath.row)
        
        let section = self.homeSectionTypes[indexPath.row]
        
        switch section {
        case .TopSlider:
            let cell = cell as! SliderCell
            if self.vouchers.count > 0 {
                cell.isSkeletonable = false
              //  cell.showAnimatedSkeleton()
            }else{
                cell.isSkeletonable = true
                cell.showAnimatedSkeleton()
            }
            
        case .Vouchers:
            let cell = cell as! VoucherListingRootCell
            if self.vouchers.count > 0 {
                cell.isSkeletonable = false
            }else{
                cell.isSkeletonable = true
            }
        case .Categories:
            let cell = cell as! CategoryRootCell
            if self.vouchers.count > 0 {
                cell.isSkeletonable = false
            }else{
                cell.isSkeletonable = true
            }
        case .sigle_row:
            let cell = cell as! HomeGenericSectionCell
            if self.vouchers.count > 0 {
                cell.isSkeletonable = false
            }else{
                cell.isSkeletonable = true
            }
    
        case .multi_row:
            break;
        case .concise:
            break;
        case .detailed:
            break;
        }
    }
    
    
}

/*
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.homeSections.count
        
    }
    
    fileprivate func getFilteredVouchers(_ indexPath: IndexPath) -> [HomeVoucher] {
       
        let currentSection = self.homeSections[indexPath.row]
        print(currentSection)
        print(homeSectionVouchers)
        if let vouchersArr = self.homeSectionVouchers[currentSection.sectionID] {
            print(homeSectionVouchers)
            print(vouchersArr)
            var vid = [String]()
            for voucher in vouchersArr {
                vid.append(voucher.vID)
            }
            let arr = self.vouchers.filter({vid.contains($0.vID)})
            print(arr)
            return arr
            
        }
        return [HomeVoucher]()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = self.homeSectionTypes[indexPath.row]
        let sectionName = self.homeSections[indexPath.row]
        
        switch section {
            
        case .TopSlider:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderSectionCell", for: indexPath) as! SliderCell
            return cell
        case .Vouchers:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedSectionVoucherCell", for: indexPath) as! VoucherListingRootCell
            cell.vouchers = self.vouchers
            cell.controller = self
            return cell
        case .Categories:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesSectionCell", for: indexPath) as! CategoryRootCell
            cell.categories = self.categories
            cell.controller = self
            return cell
            
        case .sigle_row:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeGenericSectionCell", for: indexPath) as! HomeGenericSectionCell
            let model = getFilteredVouchers(indexPath)
            cell.dealsWeekModel = model
            cell.section = sectionName
            cell.sectionType = section
            cell.controller = self
            return cell
            
        case .multi_row:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeRootMultiSectionCell", for: indexPath) as! HomeRootMultiSectionCell
            let model = getFilteredVouchers(indexPath)
            cell.section = sectionName
            cell.dealsWeekModel = model
            cell.controller = self
            return cell
        case .concise:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeGenericSectionCell", for: indexPath) as! HomeGenericSectionCell
            let model = getFilteredVouchers(indexPath)
            cell.dealsWeekModel = model
            cell.section = sectionName
            cell.sectionType = section
            cell.controller = self
            return cell
        case .detailed:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeGenericSectionCell", for: indexPath) as! HomeGenericSectionCell
            let model = getFilteredVouchers(indexPath)
            cell.dealsWeekModel = model
            cell.section = sectionName
            cell.sectionType = section
            cell.controller = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        print(homeSectionTypes.count)
        print(indexPath.row)
        
        let section = self.homeSectionTypes[indexPath.row]
        
        switch section {
        case .TopSlider:
            return CGSize(width: self.view.frame.width, height: self.view.frame.height * 0.28)
        case .Vouchers:
            return CGSize(width: self.view.frame.width, height: self.view.frame.height * AppManager.sharedInstance.getBrandsSectionSize())
        case .Categories:
            return CGSize(width: self.view.frame.width, height: self.view.frame.height * AppManager.sharedInstance.getCategorySectionSize())
        case .sigle_row:
            return CGSize(width: self.view.frame.width, height: self.view.frame.height * AppManager.sharedInstance.getSingleRowSectionSizeAndFont())
        case .multi_row:
            return CGSize(width: self.view.frame.width, height: self.view.frame.height * 0.44)
        case .concise:
            return CGSize(width: self.view.frame.width, height: self.view.frame.height * 0.23)
        case .detailed:
            return CGSize(width: self.view.frame.width, height: self.view.frame.height * AppManager.sharedInstance.getDetailedSectionSize())
        }
    }
}

*/
extension HomeViewController {
    
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
    
    private func getHomeSections(){
        
        let url = rootUrl + "homesections_api"
        AF.request(url).responseDecodable(of: [HomeSection].self) { response in
            
            print(response)
            guard let sections = response.value else {
                return
            }
            self.homeSections.append(contentsOf: sections)
            
            print(self.homeSections)
            
            self.homeSectionCount = sections.count
            
            for section in sections {
                print(section.sectionType)
                
                switch section.sectionType {
                
                case "single_row":
                    self.homeSectionTypes.append(.sigle_row)
                case "multi_row":
                    self.homeSectionTypes.append(.multi_row)
                case "concise":
                    self.homeSectionTypes.append(.concise)
                case "detailed":
                    self.homeSectionTypes.append(.detailed)
                default:
                    break;
                }
            }
            
            self.getCategories()
            self.getHomeSectionsVouchers()
            
            
           /*)/ self.rootCollectionView.prepareSkeleton(completion: { done in
                self.rootCollectionView.showAnimatedSkeleton()
            })*/
        }
    }
    
    
    private func getHomeSectionsVouchers(){
        
        let url = rootUrl + "homesectionsvouchers_api"
        AF.request(url).responseDecodable(of: [HomeSectionVoucher].self) { response in
            
           
            guard let vouchers = response.value else {
                return
            }
            
            print(vouchers)
            
            
            for section in self.homeSections {
                
                var vouchersArr = [HomeSectionVoucher]()
                
                for voucher in vouchers {
                    
                    if voucher.sectionID == section.sectionSerial {
                        vouchersArr.append(voucher)
                    }
                }
                print(vouchersArr)
                self.homeSectionVouchers[section.sectionID] = vouchersArr
            }
            
            print(self.homeSectionVouchers)
            
           
        }
    }
    
    private func getCategories(){
        
        let url: String = rootUrl + "homecategory_api"
        
        AF.request(url).responseDecodable(of: [Category].self) { response in
            
            print(response)
                    guard let categories = response.value else {
                        return
                    }
            self.categories = categories
            for category in categories {
                
            self.categoriesAndIds[category.catName] = category.catID
            self.categoryNames.append(category.catName)
            self.categoriesImagesUrl.append(category.catImage)
                
        }
            self.getAllVouchers()
      }
   }
    
    private func getAllVouchers(){
        
        let url: String = rootUrl + "hometopproduct_api"
        
        AF.request(url).responseDecodable(of: [HomeVoucher].self) { response in
            
            print(response)
                    guard let vouchers = response.value else {
                        return
                    }
            
            self.vouchers = vouchers
            self.voucherListingPageControl.numberOfPages = vouchers.count
            self.view.isUserInteractionEnabled = true
            ProgressHUD.dismiss()
            
            self.rootCollectionView.reloadData()
      }

    }
    
}
