//
//  TabBarController.swift
//  XFindr
//
//  Created by Rajat on 3/24/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    @IBOutlet var viewBanner: UIView!
    var filterView: FilterViewController?
    @IBOutlet var btnBarGrid: UIBarButtonItem!
    @IBOutlet var btnBarList: UIBarButtonItem!
    
    let navBarHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
        
        self.resetNavigationBar()
        self.navigationItem.setLeftBarButtonItems([btnBarGrid, btnBarList], animated: true)
        
        //[[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:NSLocalizedString(@"BotonMapas", @"comment")];
        
         //working
        /*
        if let tabs = self.tabBar.items {
            tabs[0].title = "123"
            tabs[0].selectedImage
        }
 */
        
        /*
        tabBar.frame.size.width = self.view.frame.width + 4
        tabBar.frame.origin.x = -2
        let numberOfItems = CGFloat(tabBar.items!.count)
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
        tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: UIColor.white, size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.zero)
*/
        /*
        //working
        if #available(iOS 10.0, *) {
            tabBar.unselectedItemTintColor = UIColor.white
            tabBar.tintColor = PredefinedConstants.navigationColor
        } else {
            // Fallback on earlier versions
            tabBar.barTintColor = UIColor.white
        }
 */

 
        //tabBar.tintColor = UIColor.white
        
        
        //tabBar.backgroundImage = UIImage.imageWithColor(color: PredefinedConstants.navigationColor, size: tabBar.frame.size).resizableImage(withCapInsets: UIEdgeInsets.zero)
        //[[UITabBarItem appearance] setTitleTextAttributes:color forState:UIControlStateNormal];
        
        let arrayOfImageNameForUnselectedState = [#imageLiteral(resourceName: "users_icon"), #imageLiteral(resourceName: "filter_icon"), #imageLiteral(resourceName: "chat_icon"), #imageLiteral(resourceName: "favorite_icon"), #imageLiteral(resourceName: "explore_icon")]
        let arrayOfImageNameForSelectedState = [#imageLiteral(resourceName: "users_icon_active"), #imageLiteral(resourceName: "filter_icon_active"), #imageLiteral(resourceName: "chat_icon_active"), #imageLiteral(resourceName: "favorite_icon_active"), #imageLiteral(resourceName: "explore_active_icon")]
        
        if let count = self.tabBar.items?.count {
            for i in 0 ... (count - 1) {
                let imageNameForSelectedState = arrayOfImageNameForSelectedState[i]
                let imageNameForUnselectedState = arrayOfImageNameForUnselectedState[i]
                self.tabBar.items?[i].selectedImage = imageNameForSelectedState.withRenderingMode(.alwaysOriginal)
                self.tabBar.items?[i].image = imageNameForUnselectedState.withRenderingMode(.alwaysOriginal)
            }
        }
        /*
        let selectedColor   = UIColor(red: 246.0/255.0, green: 155.0/255.0, blue: 13.0/255.0, alpha: 1.0)
        let unselectedColor = UIColor(red: 16.0/255.0, green: 224.0/255.0, blue: 223.0/255.0, alpha: 1.0)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: selectedColor], for: .selected)
        */

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setNavigation()
        
        HMUtilities.hmMainQueue {
            self.tabBar.frame.origin.y = ScreenSize.height - self.tabBar.frame.size.height - self.navBarHeight
            
            //for banner
            //self.tabBar.frame.origin.y = ScreenSize.height - self.viewBanner.frame.size.height - self.tabBar.frame.size.height - self.navBarHeight
            
            if let viewControllers = self.viewControllers {
                for viewController in viewControllers {
                    viewController.view.frame.size.height = self.tabBar.frame.origin.y
                }
            }
        }
        
        
        /*
        addAndRemoveBanner(status: true)
        
 */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        //addAndRemoveBanner(status: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //self.navigationItem.title = ""
    }
    
    // MARK:- Functions..
    
    func setNavigation() {
        self.navigationController?.navigationBar.isTranslucent = false;
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = PredefinedConstants.navigationColor
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func addAndRemoveBanner(status: Bool) {
        if status {
            self.viewBanner.frame = CGRect(x: 0.0, y: ScreenSize.height - self.viewBanner.frame.size.height, width: ScreenSize.width, height: self.viewBanner.frame.size.height)
            PredefinedConstants.appDelegate.window?.addSubview(self.viewBanner)
        } else {
            self.viewBanner.removeFromSuperview()
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController.view.frame.size.height != self.tabBar.frame.origin.y {
            viewController.view.frame.size.height = self.tabBar.frame.origin.y
        }
        self.resetNavigationBar()
        if let filterView = viewController as? FilterViewController {
            filterView.resetFilterView()
        } else if viewController is HomeViewController {
            self.navigationItem.setLeftBarButtonItems([btnBarGrid, btnBarList], animated: true)
        } else if let exploreView = viewController as? ExploreViewController {
            exploreView.setupViewInitially()
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        /*
        if viewController is EmptyFilterViewController {
            if self.filterView == nil {
                self.filterView = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as? FilterViewController
                self.filterView?.delegate = self
            }
            
            //self.navigationController?.setNavigationBarHidden(true, animated: true)
            let animation = CATransition()
            //animation.delegate = self
            animation.type = kCATransitionPush
            animation.subtype = kCATransitionFromTop
            animation.duration = 0.3
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            self.navigationController?.view.layer.add(animation, forKey: "AnimationFromBottomToTop")
            self.navigationController?.pushViewController(self.filterView!, animated: false)
            return false
            
        }
        */
        return true
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //item.i
        
    }
    
    func filterDidCanceled() {
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func resetNavigationBar() {
        self.navigationItem.leftBarButtonItems = nil
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.titleView = nil
        self.navigationItem.title = ""
    }

}

extension UIImage {
    
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}
