//
//  SliderCell.swift
//  Trax
//
//  Created by mac on 29/09/2022.
//

import UIKit
import ImageSlideshow
import SkeletonView


class SliderCell: UICollectionViewCell, ImageSlideshowDelegate {
    
    var imageSourceForSlider = [BundleImageSource]()
    
    lazy var brandsSlider: ImageSlideshow = {
        var slider = ImageSlideshow()
        slider.contentMode = .scaleToFill
        slider.layer.masksToBounds = true
        slider.isSkeletonable = true
        slider.layer.cornerRadius = 8
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    
    private func setupSlider(){
        //brandsSlider.backgroundColor = .red
        self.brandsSlider.slideshowInterval = 5.0
        //self.brandsSlider.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        self.brandsSlider.contentScaleMode = UIViewContentMode.scaleToFill

        //self.brandsSlider.pageIndicator = UIPageControl.withSlideshowColors()
        self.brandsSlider.activityIndicator = DefaultActivityIndicator()
        self.brandsSlider.delegate = self
        
        self.imageSourceForSlider = [BundleImageSource(imageString: "s1"), BundleImageSource(imageString: "s2"), BundleImageSource(imageString: "s3")]
        self.brandsSlider.setImageInputs(imageSourceForSlider)
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubview(brandsSlider)
        self.isSkeletonable = true
        NSLayoutConstraint.activate([
            brandsSlider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            brandsSlider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            brandsSlider.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            brandsSlider.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
        
        setupSlider()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
