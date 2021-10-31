/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import Foundation
import UIKit
class RootControllerProxy {
    
    static var shared: RootControllerProxy {
        return RootControllerProxy()
    }
    fileprivate init(){}
    
    func rootWithoutDrawer(_ identifier: String){
        
        let blankController = mainStoryboard.instantiateViewController(withIdentifier: identifier)
        var homeNavController:UINavigationController = UINavigationController()
        
        homeNavController = UINavigationController.init(rootViewController: blankController)
        homeNavController.isNavigationBarHidden = true
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                let window:UIWindow =  sd.window!
               window.rootViewController = homeNavController
                window.makeKeyAndVisible()
                
            }
//        } else {
//            KAppDelegate.window!.rootViewController = homeNavController
//            KAppDelegate.window!.makeKeyAndVisible()
//        }
        
    }
    }
//    func rootWithDrawer(_  identifier: String,titleStr: String=""){
//        let mainViewController = mainStoryboard.instantiateViewController(withIdentifier:identifier)
//        let sideViewController = mainStoryboard.instantiateViewController(withIdentifier:DrawerVC.className)
//        let mainNav: UINavigationController = UINavigationController(rootViewController: mainViewController)
//        let sideNav: UINavigationController = UINavigationController(rootViewController: sideViewController)
//        let slideMenuController =
//            SlideMenuController.init(mainViewController: mainNav, leftMenuViewController: sideNav)
//        slideMenuController.delegate = mainViewController as?  SlideMenuControllerDelegate
//        mainViewController.title = titleStr
//        KAppDelegate.sideMenu = slideMenuController
//        mainNav.isNavigationBarHidden = true
//        sideNav.isNavigationBarHidden = true
//        if #available(iOS 13.0, *) {
//            let scene = UIApplication.shared.connectedScenes.first
//            if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
//                let window:UIWindow =  sd.window!
//               window.rootViewController = slideMenuController
//                window.makeKeyAndVisible()
//
//            }
//        } else {
//            KAppDelegate.window?.rootViewController = slideMenuController
//            KAppDelegate.window?.makeKeyAndVisible()
//        }
//    }
    

}
