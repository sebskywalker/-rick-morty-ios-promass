//
//  MainTabBarController.swift
//  rick-morty-ios-promass
//
//  Created by seb's on 5/6/26.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabs()
    }
    
    private func setupTabs() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let charactersVC = storyboard.instantiateViewController(
            withIdentifier: "CharactersViewController"
        ) as? CharactersViewController else {
            return
        }
        
        let charactersNav = UINavigationController(rootViewController: charactersVC)
        charactersNav.tabBarItem = UITabBarItem(
            title: "Characters",
            image: UIImage(systemName: "person.3"),
            selectedImage: UIImage(systemName: "person.3.fill")
        )
        
        let favoritesVC = FavoritesViewController()
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        favoritesNav.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "star"),
            selectedImage: UIImage(systemName: "star.fill")
        )
        
        viewControllers = [charactersNav, favoritesNav]
    }
}
