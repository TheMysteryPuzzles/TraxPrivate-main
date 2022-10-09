//
//  DealsOfTheWeekView.swift
//  Trax
//
//  Created by mac on 20/09/2022.
//

import UIKit
import FSPagerView
import SDWebImage

class HomeGenericSectionCell: UICollectionViewCell {
    
    var dealsWeekModel = [HomeVoucher](){
        didSet{
            self.multiRowsCollectionView.reloadData()
            self.collectionView.reloadData()
        }
    }
    var sectionType: SectionTypes?
    var section: HomeSection?{
        didSet{
            self.titleLabel.text = section!.sectionTitle
        }
    }
    var controller: HomeViewController?
    
    
    lazy var multiRowsCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10.0
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        //collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    lazy var collectionView: FSPagerView = {
       let view = FSPagerView()
        view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()
    
    
    lazy var pageControl: FSPageControl = {
       let view = FSPageControl()
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = #colorLiteral(red: 0.1737187072, green: 0.2070072258, blue: 0.3068727815, alpha: 1)
        label.font = UIFont(name: "Roboto-Bold", size: 18)
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = #colorLiteral(red: 0.980392158, green: 0.980392158, blue: 0.980392158, alpha: 1)
        
        self.addSubview(titleLabel)
        self.addSubview(collectionView)
        self.addSubview(multiRowsCollectionView)
        self.addSubview(pageControl)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.multiRowsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.multiRowsCollectionView.isHidden = true
        
        self.multiRowsCollectionView.delegate = self
        self.multiRowsCollectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: homeAlignmentLeading),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -homeAlignmentLeading),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            collectionView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.65),
            
            multiRowsCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: homeAlignmentLeading),
            multiRowsCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -homeAlignmentLeading),
            multiRowsCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            multiRowsCollectionView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            
            
            pageControl.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            pageControl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 5)
            
        ])
        
        collectionView.register(DealsCell.self, forCellWithReuseIdentifier: "DealsCell")
        collectionView.register(CategoryFeaturedListingCell.self, forCellWithReuseIdentifier: "CategoryFeaturedListingCell")
        
        
        multiRowsCollectionView.register(DealsMultiCell.self, forCellWithReuseIdentifier: "MultiRowDealsCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.transformer = FSPagerViewTransformer(type: .coverFlow)
       
        self.pageControl.contentHorizontalAlignment = .right
        self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        pageControl.setImage(UIImage(named: "page_selected"), for: .selected)
        //pageControl.setImage(UIImage(named: "page_normal"), for: .normal)
        
       // pageControl.itemSpacing = 10.0
        pageControl.interitemSpacing = 10.0
        
       /* if isMutiRows{
            pageControl.topAnchor.constraint(equalTo: multiRowsCollectionView.bottomAnchor, constant: 5).isActive = true
            layoutIfNeeded()
        }*/
    }
    
    
    override func layoutSubviews() {
        print(self.frame.width)
        
        if let sectionType = self.sectionType {
            
            switch sectionType {
                case .sigle_row:
                    self.collectionView.itemSize = CGSize(width: self.frame.width * 0.92, height: self.frame.height * 0.8)
                case .multi_row:
                 self.collectionView.itemSize = CGSize(width: self.frame.width * 0.92, height: self.frame.height * 0.38)
                    self.multiRowsCollectionView.setNeedsLayout()
                    self.multiRowsCollectionView.setNeedsDisplay()
                case .concise:
                    self.collectionView.itemSize = CGSize(width: self.frame.width * 0.92, height: self.frame.height * 0.8)
                case .detailed:
                    self.collectionView.itemSize = CGSize(width: self.frame.width * 0.92, height: self.frame.height * 0.8)
                case .Categories: break;
                case .Vouchers: break;
                case .TopSlider: break;
            }
        }
        
      
 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeGenericSectionCell: FSPagerViewDelegate, FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return dealsWeekModel.count
    }
   
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProductVC") as? ProductViewController
        let voucher = self.dealsWeekModel[index]
        vc?.voucherId = voucher.vID
        vc?.merchantId = voucher.mID
        controller?.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        let voucher = self.dealsWeekModel[index]
        
        if let sectionType = self.sectionType {
            
            switch sectionType {
                
                case .sigle_row:
                     let cell =  pagerView.dequeueReusableCell(withReuseIdentifier: "DealsCell", at: index) as! DealsCell
                     cell.populateCell(voucher: voucher)
                    return cell
                case .concise:
                     let cell =  pagerView.dequeueReusableCell(withReuseIdentifier: "DealsCell", at: index) as! DealsCell
                     cell.populateCell(voucher: voucher)
                     return cell
                case .detailed:
                     let  cell =  pagerView.dequeueReusableCell(withReuseIdentifier: "CategoryFeaturedListingCell", at: index) as! CategoryFeaturedListingCell
                     cell.populateCell(voucher: voucher, index: index)
                     return cell
                case .Categories: break;
                case .Vouchers: break;
                case .TopSlider: break;
                case .multi_row: break;
                                    
            }
        }
      
        return FSPagerViewCell()
    }
    
    
    func append (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString
    {
        let result = NSMutableAttributedString()
        result.append(left)
        result.append(right)
        return result
    }
    
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
    }
    
}

extension HomeGenericSectionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dealsWeekModel.count
        
    }
   
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        var index = 1
        
        for cell in multiRowsCollectionView.visibleCells {
            let indexPath = multiRowsCollectionView.indexPath(for: cell)
            index = indexPath!.row
        }
        
        self.pageControl.currentPage = index/2
        
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        print(collectionView.frame.height)
        
        return CGSize(width: collectionView.frame.width * 0.9, height: (collectionView.frame.height * 0.42))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MultiRowDealsCell", for: indexPath) as! DealsMultiCell
        
        if self.dealsWeekModel.count > 0{
            
            let voucher = self.dealsWeekModel[indexPath.row]
            let trimmedVImage = voucher.vImage.filter {!$0.isWhitespace}
            let url = URL(string: imageRootUrl + trimmedVImage)
            
            cell.dealImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "plaeceholder"))
            cell.titleLabel.text = voucher.vName
           // cell.descriptionLabel.text = voucher.vDesc
                
        let attributedText = NSAttributedString(
            string: voucher.vAmount,
            attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1640942097, green: 0.1912219524, blue: 0.2755365372, alpha: 1)]
        )
            
            print(voucher.vAmount + voucher.vDiscount)
            
            
            var price = NSAttributedString(string: "AED ")
            var discounted = NSAttributedString(string: " " +  voucher.vDiscount)
            price = self.append(left: price, right: attributedText)
            var newprice = append(left: price, right: discounted)
            cell.priceLabel.attributedText = newprice
       
        }
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true
        return cell
    }

}


