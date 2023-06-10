//
//  SplashAnimator.swift
//  CustomSplashScreen
//
//  Created by Kirill Khomytsevych on 10.06.2023.
//

import UIKit

protocol SplashAnimatorDiscription {
    func animateAppearance()
    func animateDisappearance(completion: (() -> Void)?)
}

final class SplashAnimator: SplashAnimatorDiscription {

    private unowned let foregroundSplashWindow: UIWindow
    private unowned let foregroundSplashViewController: SplashViewController

    init(foregroundSplashWindow: UIWindow) {
        self.foregroundSplashWindow = foregroundSplashWindow

        guard let foregroundSplashViewController = foregroundSplashWindow.rootViewController as? SplashViewController else {
            fatalError("S plash window does not have root view controller")
        }

        self.foregroundSplashViewController = foregroundSplashViewController
    }

    func animateAppearance() {
        foregroundSplashWindow.isHidden = false

        UIView.animate(withDuration: 0.3) {
            self.foregroundSplashViewController.mainImage.transform  = CGAffineTransform(scaleX: 150 / 100, y: 150 / 100)
        }
    }

    func animateDisappearance(completion: (() -> Void)?) {
        guard let window = UIApplication.shared.delegate?.window,
              let mainWindow = window else {
                  fatalError("App Delegate does not have a window")
              }
        self.foregroundSplashWindow.alpha = 0

        let mask = CALayer()
        mask.frame = self.foregroundSplashViewController.mainImage.frame
        mask.contents = SplashViewController.logoImage?.cgImage
        mainWindow.layer.mask = mask

        let maskImageView = UIImageView(image: SplashViewController.logoImage)
        maskImageView.frame = mask.frame
        mainWindow.addSubview(maskImageView)
        mainWindow.bringSubviewToFront(maskImageView)

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion?()
        }
        mainWindow.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        UIView.animate(withDuration: 0.6) {
            mainWindow.transform = .identity
        }
        [mask, maskImageView.layer].forEach {
            addRotationAnimate(to: $0, duration: 0.6)
            addScalingAnimate(to: $0, duration: 0.6)
        }

        UIView.animate(withDuration: 0.1, delay: 0.1) {
            maskImageView.alpha = 0
        } completion: { _ in
            maskImageView.removeFromSuperview()
        }
        CATransaction.commit()
    }

    private func addRotationAnimate(to layer: CALayer, duration: TimeInterval) {
        let animation = CABasicAnimation()

        let tangent = layer.position.y / layer.position.x
        let angel = atan(tangent)

        animation.beginTime = CACurrentMediaTime()
        animation.duration = duration
        animation.valueFunction = CAValueFunction(name: .rotateZ)
        animation.fromValue = 0
        animation.toValue = angel
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards

        layer.add(animation, forKey: "transform")

    }

    private func addScalingAnimate(to layer: CALayer, duration: TimeInterval) {
        let animation = CAKeyframeAnimation(keyPath: "bounds")
        let width = layer.frame.width
        let height = layer.frame.height
        let coef: CGFloat = 40 / 667
        let finalScale = coef * UIScreen.main.bounds.height
        let scales: [CGFloat] =  [1, 0.7, finalScale]

        animation.beginTime = CACurrentMediaTime()
        animation.duration = duration
        animation.values = scales.map{ NSValue(cgRect: CGRect(x: .zero, y: .zero, width: width * $0, height: height * $0)) }
        animation.timingFunctions = [CAMediaTimingFunction(name: .easeInEaseOut),
                                     CAMediaTimingFunction(name: .easeOut)]
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards

        layer.add(animation, forKey: "bounds")

    }

}
