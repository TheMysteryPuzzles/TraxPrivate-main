//
//  ReviewsView.swift
//  Trax
//
//  Created by mac on 27/08/2022.
//

import UIKit

class ReviewsView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var reviews =  [Review]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reviews.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        let review = self.reviews[indexPath.row]
        cell.userReview.text = review.review
        cell.userId.text = review.name
        cell.ratingView.rating = Double(review.rating) ?? 5
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.bounds.height * 0.25
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.frame)
        view.register(ReviewCell.self, forCellReuseIdentifier: "ReviewCell")
        return view
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(tableView)
        
        
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
