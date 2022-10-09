//
//  ThemeManager.swift
//  Trax
//
//  Created by mac on 27/08/2022.
//

import Foundation
import UIKit

class ThemeManager {
    
    private init() { }
    
    
    func getHeadingColour() -> UIColor {
        return  #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }
    
    
    func getBodyColour() -> UIColor {
        return  #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }
    
    
    
    static let sharedInstance = ThemeManager()
    
    
    static func applyTheme(bar: UINavigationBar) {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.white
        UITabBar.appearance().barStyle = .default
        UISwitch.appearance().onTintColor =  AppStaticColors.primaryColor.withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor =  AppStaticColors.primaryColor
        UITabBar.appearance().tintColor =   AppStaticColors.primaryColor

        
    }
    
}

struct AppStaticColors {
    static let labelSecondaryColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.58 / 1.0)
    static let accentColor = UIColor(named: "AccentColor") ?? .black
    static let primaryColor = UIColor(named: "primary") ?? .white
    static let priceOrangeColor = UIColor(named: "PriceOrangeColor")
    static let mainHeadingDarkBlack = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.87 / 1.0)
    static let linkColor = UIColor(hexString: "000000")
    static let shadedColor = UIColor(named: "ShadedColor")
    static let itemTintColor = UIColor(named: "itemTintColor") ?? UIColor.black
    static let defaultColor = UIColor(named: "DefaultColor") ?? UIColor.white
    static let disabledColor = UIColor(named: "DisabledColor") ?? UIColor.gray
    
    static let oneStar = UIColor(named: "oneStar")!
    static let twoStar = UIColor(named: "twoStar")!
    static let threeStar = UIColor(named: "threeStar")!
    static let fourStar = UIColor(named: "fourStar")!
    static let fiveStar = UIColor(named: "fiveStar")!
    
    static func applyTheme() {
        UITabBar.appearance().barTintColor = AppStaticColors.primaryColor
        UITabBar.appearance().unselectedItemTintColor = AppStaticColors.disabledColor
        UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
        UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
        UISwitch.appearance().onTintColor = AppStaticColors.accentColor.withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor =  AppStaticColors.accentColor
        UITableView.appearance().backgroundColor = AppStaticColors.defaultColor
        UITableViewCell.appearance().backgroundColor = AppStaticColors.defaultColor
        UICollectionView.appearance().backgroundColor = AppStaticColors.defaultColor
        UICollectionViewCell.appearance().backgroundColor = AppStaticColors.defaultColor
    }
}

import Foundation
import UIKit

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)

        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }

        var color: UInt32 = 0
        scanner.scanHexInt32(&color)

        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask

        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0

        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }

    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

        return String(format:"#%06x", rgb)
    }
}

extension UIView {
    func applyGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(hexString: "#FF512F", alpha: 1.0).cgColor ,
                           UIColor(hexString: "#DD2476", alpha: 1.0).cgColor]
        
        gradient.locations = [0.0, 0.5]
        //gradient.frame = self.bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.insertSublayer(gradient, at: 0)
    }
}

extension UIView{
    func addGradientBackground(firstColor: UIColor, secondColor: UIColor){
        clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        print(gradientLayer.frame)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
