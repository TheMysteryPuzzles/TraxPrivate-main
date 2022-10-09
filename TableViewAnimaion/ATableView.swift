//  Froffer
//
//  Created by Omer Khan on 20/08/2022.



import UIKit

extension UITableView {

    func animateCells(_ animationFactory: @escaping Animator.Animation, tableView: UITableView, cell: UITableViewCell, indexPath: IndexPath ) {
        let animation = animationFactory
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }

    
}
