//  VSCore.swift
//  LTW
//  Created by Ranjeet Raushan on 21/04/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit

 var tabBarController: UITabBarController?
 var timeTZone: TimeZone?
class VSCore: NSObject
{
    func sharedClass() -> UITabBarController{
        if tabBarController == nil {
            tabBarController = UITabBarController()
            return tabBarController!
        }
        return tabBarController!
    }
   // get the height of the tab bar - useful in Moving Floating Button(Ask Question Button) in Home Screen 
    func returnTabBarHeight() -> CGFloat{
        return (tabBarController?.tabBar.frame.size.height)!
    }
    // Home Page
    func launchHomePage(index: NSInteger) -> UITabBarController {
        let tabBar = sharedClass()
        tabBar.delegate = self as? UITabBarControllerDelegate
        let story = UIStoryboard(name: "Main", bundle:nil)
        let tabOneBarItem0 = UITabBarItem(title: "Home", image:UIImage(named: "home")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "home-active")?.withRenderingMode(.alwaysOriginal))
        let navtab = story.instantiateViewController(withIdentifier: "homeNav") as! HomeNavigationController
        let home = navtab.topViewController  as! HomeVC
        home.tabBarItem = tabOneBarItem0
     
        // Help/Info/Shortcut Page
//        let info = story.instantiateViewController(withIdentifier: "helpInfoShrtct") as! InfoOrHelpOrShortcutVC
//        let tabOneBarItem1 = UITabBarItem(title: "", image:UIImage(named: "info")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "info-active")?.withRenderingMode(.alwaysOriginal))
//        info.tabBarItem = tabOneBarItem1
//        let navtab1 = UINavigationController.init(rootViewController: info)

        
        // Account Page
        let account = story.instantiateViewController(withIdentifier: "account") as! AccountVC
        let tabOneBarItem2 = UITabBarItem(title: "Account", image:UIImage(named: "account")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "account-active")?.withRenderingMode(.alwaysOriginal))
        account.tabBarItem = tabOneBarItem2
        let navtab2 = UINavigationController.init(rootViewController: account)
        
        
        
        //tabBar.viewControllers = [navtab, navtab1, navtab2]
        tabBar.viewControllers = [navtab, navtab2]
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], for: .selected)
        UITabBar.appearance().tintColor = UIColor.init(hex: "2DA9EC")
        UITabBar.appearance().barTintColor = UIColor.white
        tabBar.selectedIndex = index
        return tabBar
    }
}

