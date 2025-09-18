//
//  SceneDelegate.swift
//  Event Hub
//
//  Created by VP on 08.09.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let root = FavoritesViewController()
        let nav = UINavigationController(rootViewController: root)
        window.rootViewController = nav
        window.makeKeyAndVisible()
        self.window = window
    }
    
}
