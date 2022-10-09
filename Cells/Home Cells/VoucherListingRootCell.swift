//
//  VoucherListingRootCell.swift
//  Trax
//
//  Created by mac on 29/09/2022.
//

import UIKit

class VoucherListingRootCell: UICollectionViewCell {
    
    var vouchers = [HomeVoucher](){
        didSet{
            self.voucherListingCollectionView.reloadData()
        }
    }
    var controller: HomeViewController?
    
    
    lazy var tileLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.1737187072, green: 0.2070072258, blue: 0.3068727815, alpha: 1)
        label.text = "Offers"
        label.textColor = #colorLiteral(red: 0.1737187072, green: 0.2070072258, blue: 0.3068727815, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Roboto-Bold", size: 18)
        return label
    }()
    
    lazy var voucherListingCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.tag = 1
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override func layoutSubviews() {
        self.voucherListingCollectionView.setNeedsLayout()
        self.voucherListingCollectionView.setNeedsDisplay()
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        addSubview(tileLabel)
        addSubview(voucherListingCollectionView)
        self.backgroundColor = sectionBackgroundColor
        voucherListingCollectionView.register(HomeVoucherListingCell.self, forCellWithReuseIdentifier: "VoucherListingCell")
        
        
        NSLayoutConstraint.activate([
            tileLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: homeAlignmentLeading),
            tileLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -homeAlignmentLeading),
            tileLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: homeAlignmentSectionTitleTopSpacing),
            tileLabel.heightAnchor.constraint(equalToConstant: homeSectionsTitleHeight),
            
            voucherListingCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: homeAlignmentLeading),
            voucherListingCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -homeAlignmentLeading),
            voucherListingCollectionView.topAnchor.constraint(equalTo: tileLabel.bottomAnchor, constant: homeAlignmentSectionTitleTopSpacing),
            voucherListingCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension VoucherListingRootCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProductVC") as? ProductViewController
        let voucher = self.vouchers[indexPath.row]
        vc?.voucherId = voucher.vID
        vc?.merchantId = voucher.mID
        self.controller?.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.vouchers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VoucherListingCell", for: indexPath) as! HomeVoucherListingCell
        
        var index = indexPath.row
        print(index)
        if index >= colours.count {
            index -= index
            print(index)
        }

        cell.backgroundColor = colours[index]

        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true
        cell.voucherImageView.image = UIImage(named: "placeholder")
        
        if self.vouchers.count > 0{
            let voucher = self.vouchers[indexPath.row]
            let trimmedVImage = voucher.vImage.filter {!$0.isWhitespace}
            let url = URL(string: imageRootUrl + trimmedVImage)
            
            cell.voucherImageView.sd_setImage(with: url)
            cell.titleLabel.text = voucher.vName
           // cell.descriptionLabel.text = voucher.vDesc
                
        let attributedText = NSAttributedString(
            string: voucher.vAmount,
            attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        )
            
            var price = NSAttributedString(string: "AED ")
            var discounted = NSAttributedString(string: " " +  voucher.vDiscount)
            price = AppManager.sharedInstance.append(left: price, right: attributedText)
            var newprice = AppManager.sharedInstance.append(left: price, right: discounted)
            cell.priceLabel.attributedText = newprice
       
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            let frame = collectionView.frame
            let width = frame.width / 1.75
            let height = frame.height * 0.95
            
            return CGSize(width: width, height: height)
    }
    
    
}

