//
//  TabBarController.swift
//  StoreApp
//
//  Created by Giri on 4/19/25.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
           UITabBar.appearance().barTintColor = .systemBackground
           tabBar.tintColor = .label
           setupVC()
    }
    
    func setupVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: Screens.home) as! HomeViewController
        let searchVC = storyboard.instantiateViewController(withIdentifier: Screens.emptyView) as! ViewController
        let profileVC = storyboard.instantiateViewController(withIdentifier: Screens.emptyView) as! ViewController
        viewControllers = [
            createNavController(for: searchVC, title: "Search", image: UIImage(systemName: "magnifyingglass")!),
            createNavController(for: homeVC, title: "Home", image: UIImage(systemName: "house")!),
            createNavController(for: profileVC, title: "Profile", image: UIImage(systemName: "person")!)
        ]
    }


    fileprivate func createNavController(for rootViewController: UIViewController,
                                         title: String,
                                         image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        rootViewController.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        return navController
    }


}
