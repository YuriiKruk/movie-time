//
//  TabBarViewController.swift
//  Movie Time
//
//  Created by Yury Kruk on 15.01.2022.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    private let layerGradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarLayer()
        setupVCs()
    }
    
    // MARK: - Setup Tab Bar Layer
    private func setupTabBarLayer() {
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = UIColor(cgColor: CGColor(gray: 0.5, alpha: 0.9))
        tabBar.isTranslucent = true
        tabBar.barTintColor = .clear
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()

        
        let darkThemeColors: [CGColor] = [
            CGColor(gray: 0, alpha: 0),
            CGColor(gray: 0, alpha: 0.7),
            CGColor(gray: 0, alpha: 1)
        ]
        
        layerGradient.colors = darkThemeColors
        layerGradient.startPoint = CGPoint(x: 0, y: 0)
        layerGradient.endPoint = CGPoint(x: 0, y: 0.9)
        layerGradient.frame = CGRect(x: 0, y: 0, width: tabBar.bounds.width, height: tabBar.bounds.height+55)
        self.tabBar.layer.insertSublayer(layerGradient, at: 0)
    }
    
    // MARK: - Setup View Controllers
    private func createNavController(for rootViewController: UIViewController,
                                     image: UIImage,
                                     selectedImage: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = image
        navController.tabBarItem.selectedImage = selectedImage
        navController.navigationBar.prefersLargeTitles = false
        navController.isNavigationBarHidden = true
        return navController
    }
    
    private func setupVCs() {
        viewControllers = [
            createNavController(for: TrendingViewController(),
                                   image: UIImage(systemName: "bolt")!,
                                   selectedImage: UIImage(systemName: "bolt.fill")!),
            createNavController(for: TopRatingsViewController(),
                                   image: UIImage(systemName: "chart.bar")!,
                                   selectedImage: UIImage(systemName: "chart.bar.fill")!),
            createNavController(for: SearchViewController(),
                                   image: UIImage(systemName: "magnifyingglass")!,
                                   selectedImage: UIImage(systemName: "magnifyingglass")!),
            createNavController(for: TVShowViewController(),
                                   image: UIImage(systemName: "film")!,
                                   selectedImage: UIImage(systemName: "film.fill")!)
        ]
    }
}

// MARK: - Extension UITabBar
//extension UITabBar {
//    open override func sizeThatFits(_ size: CGSize) -> CGSize {
//        var sizeThatFits = super.sizeThatFits(size)
//        sizeThatFits.height = 90
//
//        return sizeThatFits
//    }
//}
