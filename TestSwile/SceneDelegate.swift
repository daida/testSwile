//
//  SceneDelegate.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var coordinator: Coordinator?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let aScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: aScene)

        // This method will set NavigationController naviagtion title style
        SWKit.setup()

        // Retrive transaction coordinator as Coordinator
        // object (the sceneDelegate doesn't know the concrete type of the transaction Coordinator)
		let coordinator = CoordinatorFactory().generateTransactionCoordinator()
        coordinator.start()

        // The coordinator is set to keep the obejct instanciate
        self.coordinator = coordinator

        window?.rootViewController = coordinator.navigationController
        window?.makeKeyAndVisible()
    }
}
