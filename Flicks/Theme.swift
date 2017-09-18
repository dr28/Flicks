//
//  Theme.swift
//  Flicks
//
//  Created by Deepthy on 9/14/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
import ARSLineProgress


struct ThemeManager {
    
    static func applyTheme() {
        
        UITabBar.appearance().barTintColor = UIColor.black
        //UIColor(red: 0.00, green: 0.16, blue: 0.29, alpha: 1.0)//UIColor(red: 10.0/255.0, green: 10.0/255.0, blue: 10.0/255.0, alpha: 1.0)//

        UITabBar.appearance().tintColor = /*UIColor(red: (198.0/255.0), green: (21.0/255.0), blue: (19.0/255.0), alpha: 1.0).withAlphaComponent(0.9)*/
        UIColor(red: 255.0/255.0, green: 194.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        
        let fontColor/*: NSForegroundColorAttributeName*/ = UIColor(red: 255.0/255.0, green: 194.0/255.0, blue: 63.0/255.0, alpha: 1.0)

        let titleHighlightedColor = UIColor(red: 153/255.0 ,green: 192/255.0, blue: 48/255.0, alpha: 1.0)

        let attributes: [String: AnyObject] = [NSFontAttributeName:UIFont(name: "American Typewriter", size: 14)!/*, NSForegroundColorAttributeName: titleHighlightedColor*/]
        
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .highlighted)

        
        let attributesSeg: [String: AnyObject] = [NSFontAttributeName:UIFont(name: "American Typewriter", size: 14)!]
        
        UISegmentedControl.appearance().setTitleTextAttributes(attributesSeg, for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes(attributesSeg, for: .normal)
        
        let attributesNav: [String: AnyObject] = [NSFontAttributeName:UIFont(name: "American Typewriter", size: 25)!]
        UINavigationBar.appearance().titleTextAttributes = attributesNav
        //UINavigationBar.appearance().backgroundColor = UIColor.black
        UINavigationBar.appearance().tintColor = UIColor.red
        
        
        ARSLineProgressConfiguration.circleColorOuter = UIColor(red: 1.0, green: 0.76, blue: 0.247, alpha: 1.0).cgColor//UIColor.ars_colorWithRGB(130.0, green: 149.0, blue: 173.0, alpha: 1.0).cgColor
        ARSLineProgressConfiguration.circleColorMiddle = UIColor(red: (198.0/255.0), green: (21.0/255.0), blue: (19.0/255.0), alpha: 1.0).withAlphaComponent(0.8).cgColor
        //ARSLineProgressConfiguration.circleColorMiddle = UIColor(red: 1.0, green: 0.76, blue: 0.247, alpha: 1.0).withAlphaComponent(0.8).cgColor
        
        //UIColor.ars_colorWithRGB(82.0, green: 124.0, blue: 194.0, alpha: 1.0).cgColor
        ARSLineProgressConfiguration.circleColorInner = UIColor(red: 1.0, green: 0.76, blue: 0.247, alpha: 1.0).cgColor//UIColor.ars_colorWithRGB(60.0, green: 132.0, blue: 196.0, alpha: 1.0).cgColor
        
        
    }
}
