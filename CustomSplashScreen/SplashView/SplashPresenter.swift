//
//  SplashPresenter.swift
//  CustomSplashScreen
//
//  Created by Kirill Khomytsevych on 10.06.2023.
//

import UIKit

protocol SplashPresenterDiscriprion {
    func present()
    func dismiss(completion: (() -> Void)?)
}

class SplashPresenter: SplashPresenterDiscriprion {

    private lazy var animator: SplashAnimatorDiscription = SplashAnimator(foregroundSplashWindow: foregroundSplashWindow)

    private lazy var foregroundSplashWindow: UIWindow = {
        let viewController = self.makeSplashViewController()
        return splashWindow(level: .normal + 1, rootViewController: viewController)
    }()

    private func makeSplashViewController() -> SplashViewController? {
        let storyboaed = UIStoryboard (name: "Main", bundle: nil)
        let splashViewController = storyboaed.instantiateViewController(identifier: "SplashViewController") as? SplashViewController
        return splashViewController
    }

    private func splashWindow(level: UIWindow.Level, rootViewController: SplashViewController?) -> UIWindow {
        let splashWindow = UIWindow()
        splashWindow.windowLevel = level
        splashWindow.rootViewController = rootViewController
        return splashWindow
    }

    func present() {
        animator.animateAppearance()
    }

    func dismiss(completion: (() -> Void)?) {
        animator.animateDisappearance(completion: completion)
    }

}
