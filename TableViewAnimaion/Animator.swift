//  Froffer
//
//  Created by Omer Khan on 20/08/2022.

import UIKit

class Animator: NSObject {
    typealias Animation = (UITableViewCell, IndexPath, UITableView) -> Void
    private var hasAnimatedAllCells = false
    private let animation: Animation
    
    init(animation: @escaping Animation) {
        self.animation = animation
    }
    
    func animate(cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView) {
        guard !hasAnimatedAllCells else {
            return
        }
        
        animation(cell, indexPath, tableView)
        if let last = tableView.visibleCells.last {
            self.hasAnimatedAllCells = true
        }
    }
}
