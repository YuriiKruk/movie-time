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
        tabBar.tintColor = .label
        tabBar.unselectedItemTintColor = .secondaryLabel
        tabBar.isTranslucent = true
        tabBar.barTintColor = .clear
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        
        layerGradient.colors = [CGColor(gray: 0, alpha: 0), CGColor(gray: 0, alpha: 0.7), CGColor(gray: 0, alpha: 1)]
        layerGradient.startPoint = CGPoint(x: 0, y: 0)
        layerGradient.endPoint = CGPoint(x: 0, y: 0.9)
        layerGradient.frame = CGRect(x: 0, y: 0, width: tabBar.bounds.width, height: tabBar.bounds.height+55)
        self.tabBar.layer.addSublayer(layerGradient)
    }
    
    // MARK: - Setup View Controllers
    private func createNavController(for rootViewController: UIViewController,
                                     title: String,
                                     image: UIImage,
                                     selectedImage: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.tabBarItem.selectedImage = selectedImage
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }
    
    private func setupVCs() {
        viewControllers = [
            createNavController(for: TrendingViewController(),
                                   title: NSLocalizedString("Trend", comment: ""),
                                   image: UIImage(systemName: "bolt")!,
                                   selectedImage: UIImage(systemName: "bolt.fill")!),
            createNavController(for: TopRatingsViewController(),
                                   title: NSLocalizedString("Top", comment: ""),
                                   image: UIImage(systemName: "chart.bar")!,
                                   selectedImage: UIImage(systemName: "chart.bar.fill")!),
            createNavController(for: SearchViewController(),
                                   title: NSLocalizedString("Search", comment: ""),
                                   image: UIImage(systemName: "magnifyingglass")!,
                                   selectedImage: UIImage(systemName: "magnifyingglass")!),
            createNavController(for: TVShowViewController(),
                                   title: NSLocalizedString("TV", comment: ""),
                                   image: UIImage(systemName: "film")!,
                                   selectedImage: UIImage(systemName: "film.fill")!)
        ]
    }
}

// MARK: - Extension UITabBar
extension UITabBar {
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 100
        
        return sizeThatFits
    }
}
