//
//  ViewController.swift
//  MTCustomTabBarController
//
//  Created by Murilo Teixeira on 15/07/19.
//  Copyright © 2019 Murilo Teixeira. All rights reserved.
//

import UIKit

@IBDesignable
class MTCustomTabBarController: UITabBarController {
    
    var indicator = Indicator()
    
    @IBInspectable
    public var showIndicator: Bool = false {
        didSet{
            if self.showIndicator {
                self.indicator.tabBar = self.tabBar
                self.tabBar.addSubview(self.indicator)
            }
        }
    }
    
    @IBInspectable
    public var indicatorWidthPercentage: CGFloat = 100.0 {
        didSet{
            self.indicator.proportionalWidth = self.indicatorWidthPercentage / 100.0
        }
    }
    
    @IBInspectable
    public var colorIndicator: UIColor = .black {
        didSet{
            self.indicator.backgroundColor = self.colorIndicator
        }
    }
    
    @IBInspectable
    public var cornerRadiusIndicator: Bool = false {
        didSet{
            self.indicator.cornerRadius = self.cornerRadiusIndicator
        }
    }
    
    var transition: SwipeTransition?
    
    @IBInspectable
    var swipeTransition: Bool = false {
        didSet{
            if self.swipeTransition {
                self.transition = SwipeTransition(viewControllers: self.viewControllers)
            }
        }
    }
    
    var fromIndex = 0
    
    @objc func orientationDidRotate() {
        //        if UIDevice.current.orientation.isLandscape {
        //            print("landscape")
        //        } else if UIDevice.current.orientation.isPortrait {
        //            print("portrait")
        //        }
        indicator.didCchangeOrientation(toOrientation: UIDevice.current.orientation, selectedIndex: selectedIndex)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        // define toque exclusivo na view
        UIView.appearance().isExclusiveTouch = true
        
        // set gestos para troca de view
        setSwipeGestures()
        
        // set constraints do indicador
        if showIndicator {
            indicator.setConstraints()
        }
        
        // adicionar observador para mudança de orientaçao da tela
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidRotate), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        fromIndex = selectedIndex
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        indicator.animar(fromIndex: fromIndex, toIndex: selectedIndex, withDuration: 0.2)
    }
    
    func setSwipeGestures(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeRight.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        let tabBarController = self
        let fromIndex = selectedIndex
        guard let viewControllers = self.viewControllers else { return }
        let tabs = viewControllers.count
        if gesture.direction == .left {
            if tabBarController.selectedIndex < tabs {
                tabBarController.selectedIndex += 1
            }
        } else if gesture.direction == .right {
            if tabBarController.selectedIndex > 0 {
                tabBarController.selectedIndex -= 1
            }
        }
        indicator.animar(fromIndex: fromIndex, toIndex: selectedIndex, withDuration: 0.2)
    }
}

extension MTCustomTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard fromVC != toVC else { return nil }
        self.view.backgroundColor = toVC.view.backgroundColor
        return transition
    }
}


