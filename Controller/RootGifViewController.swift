//
//  RootGifViewController.swift
//  Trax
//
//  Created by Omer Khan on 09/10/2022.
//

import UIKit
import SwiftyGif

class RootGifViewController: UIViewController {

    lazy var gifView: UIImageView =  {
    
        let view = UIImageView()
        view.frame = self.view.bounds
        view.backgroundColor = .red
       
        return view
    }()
    var isFirstLaunched = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(gifView)
        let gif = try! UIImage(gifName: "launchgif.gif")
        self.gifView.setGifImage(gif, loopCount: 1)
        self.gifView.delegate = self
        
        let defaults = UserDefaults.standard
        
        var isFirstTimeLaunched = defaults.bool(forKey: "isFirstTimeLaunched")
        
        if !isFirstTimeLaunched {
            defaults.set(true, forKey: "isFirstTimeLaunched")
            self.isFirstLaunched = false
        }
     
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }


}
extension RootGifViewController : SwiftyGifDelegate {
    
 
    func gifDidStop(sender: UIImageView) {
        print(self.isFirstLaunched)
        
        if self.isFirstLaunched {
            DispatchQueue.main.async {
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabBarViewController")
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false)
            }
        }else{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "WalkthroughViewController") as! WalkthroughViewController
            newViewController.modalPresentationStyle = .fullScreen
            self.present(newViewController, animated: false)
        }
        
        
        
        
       
    }
}
