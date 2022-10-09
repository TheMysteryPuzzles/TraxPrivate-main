//
//  HomeRootMultiRowCell.swift
//  Trax
//
//  Created by mac on 30/09/2022.
//

import UIKit

class HomeRootMultiSectionCell: UICollectionViewCell {
    
    var dealsWeekModel = [HomeVoucher](){
        didSet{
            self.multiRowsCollectionView.reloadData()
        }
    }
    
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
        collectionView.backgroundColor = .clear
        
        return collectionView
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
        self.addSubview(multiRowsCollectionView)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.multiRowsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.multiRowsCollectionView.delegate = self
        self.multiRowsCollectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            multiRowsCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: homeAlignmentLeading),
            multiRowsCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -homeAlignmentLeading),
            multiRowsCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            multiRowsCollectionView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
    
        ])

        multiRowsCollectionView.register(DealsMultiCell.self, forCellWithReuseIdentifier: "MultiRowDealsCell")
        
    }
    
    
    override func layoutSubviews() {
        print(self.frame.width)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeRootMultiSectionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProductVC") as? ProductViewController
        let voucher = self.dealsWeekModel[indexPath.row]
        vc?.voucherId = voucher.vID
        vc?.merchantId = voucher.mID
        controller?.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dealsWeekModel.count
    }
   
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        var index = 1
        
        for cell in multiRowsCollectionView.visibleCells {
            let indexPath = multiRowsCollectionView.indexPath(for: cell)
            index = indexPath!.row
        }
        //self.pageControl.currentPage = index/2
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
            price = AppManager.sharedInstance.append(left: price, right: attributedText)
            var newprice = AppManager.sharedInstance.append(left: price, right: discounted)
            cell.priceLabel.attributedText = newprice
       
        }
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true
        return cell
    }

}



