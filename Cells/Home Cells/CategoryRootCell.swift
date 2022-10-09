//
//  CategoryRootCell.swift
//  Trax
//
//  Created by mac on 29/09/2022.
//

import UIKit
import SkeletonView

class CategoryRootCell: UICollectionViewCell {
    
    var categories = [Category](){
        didSet{
            self.categoryCollectionView.reloadData()
        }
    }
    var categoriesImagesUrl = [String]()
    var controller: HomeViewController?
    var categoryNames = [String]()
    
    lazy var categoriesLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.1737187072, green: 0.2070072258, blue: 0.3068727815, alpha: 1)
        label.text = "Categories"
        label.textColor = #colorLiteral(red: 0.1737187072, green: 0.2070072258, blue: 0.3068727815, alpha: 1)
        label.font = UIFont(name: "Roboto-Bold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var categoryCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.tag = 1
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    
    override func layoutSubviews() {
        self.setNeedsLayout()
        self.setNeedsDisplay()
      /*  if self.categories.count == 0 {
            self.showAnimatedSkeleton()
        }*/
    }
  
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        addSubview(categoriesLabel)
        self.backgroundColor = sectionBackgroundColor
        addSubview(categoryCollectionView)
        categoryCollectionView.register(CategoriesCell.self, forCellWithReuseIdentifier: "CategoryCell")
        self.isSkeletonable = true
      
        NSLayoutConstraint.activate([
            categoriesLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: homeAlignmentLeading),
            categoriesLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -homeAlignmentLeading),
            categoriesLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: homeAlignmentSectionTitleTopSpacing),
            categoriesLabel.heightAnchor.constraint(equalToConstant: homeSectionsTitleHeight),
            
            categoryCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: homeAlignmentLeading),
            categoryCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -homeAlignmentLeading),
            categoryCollectionView.topAnchor.constraint(equalTo: categoriesLabel.bottomAnchor, constant: homeAlignmentSectionTitleTopSpacing),
            categoryCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
     
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CategoryRootCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CategoryViewController()
        let categoryId = self.categories[indexPath.row].catID
        vc.categoryId = categoryId
        vc.categoryName = self.categories[indexPath.row].catName
        self.controller?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoriesCell
        let category = self.categories[indexPath.row]
        
        let imageUrl = imageRootUrl +   category.catImage
        let trimmedVImage = imageUrl.trimmingCharacters(in: .whitespacesAndNewlines)
        
        print(trimmedVImage)
        
        
        cell.imageView.sd_setImage(with: URL(string: trimmedVImage))
        cell.imageView.contentMode = .scaleAspectFit
        cell.nameLabel.textAlignment = .center
        cell.nameLabel.text = category.catName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            let frame = collectionView.frame
            let width = frame.width / 4.2
            let height = frame.height * 0.95
          
            return CGSize(width: width, height: height)
    }
    
    
}
