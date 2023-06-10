//
//  AppDelegate.swift
//  CustomSplashScreen
//
//  Created by Kirill Khomytsevych on 10.06.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var splashPresenter: SplashPresenterDiscriprion? = SplashPresenter()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        guard let splashPresenter = self.splashPresenter else {
            print("print no view in AppDelegate")
            return false
        }
        splashPresenter.present()

        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2.0) {
            splashPresenter.dismiss { [weak self] in
                guard let sSelf = self else { return }

                sSelf.splashPresenter = nil
            }
        }

        return true
    }

}
