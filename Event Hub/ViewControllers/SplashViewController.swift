//
//  SplashViewController.swift
//  Event Hub
//
//  Created by VP on 08.09.2025.
//

import UIKit

class SplashViewController: UIViewController {
    
    let splashImage: UIImageView = {
        let splashImage = UIImageView(image: UIImage(named: "SplashScreen"))
        return splashImage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(splashImage)
        splashImage.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let sceneDelegate = windowScene.delegate as? SceneDelegate,
                  let window = sceneDelegate.window else { return }

            let mainVC = ViewController()
            let nav = UINavigationController(rootViewController: mainVC)

            UIView.transition(with: window,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: {window.rootViewController = nav},
                              completion: nil)
            }
        }
    }
