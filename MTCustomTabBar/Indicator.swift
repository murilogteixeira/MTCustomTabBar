//
//  Indicator.swift
//  MTCustomTabBarController
//
//  Created by Murilo Teixeira on 15/07/19.
//  Copyright © 2019 Murilo Teixeira. All rights reserved.
//

import UIKit

class Indicator: UIView {
    
    var fromIndex = 0
    var toIndex = 0
    
    var leftConstraint: NSLayoutConstraint?
    var rightConstraint: NSLayoutConstraint?
    var topConstraint: NSLayoutConstraint?
    var bottomConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    var proportionalWidth: CGFloat = 0
    var height: CGFloat = 2.0
    var widthItem: CGFloat = 0
    
    var tabBar: UITabBar = UITabBar()
    
    var cornerRadius: Bool = false {
        didSet{
            self.layer.cornerRadius = self.cornerRadius ? self.height / 2 : 0
        }
    }
    
    var color: UIColor = .black {
        didSet{
            self.backgroundColor = self.color
        }
    }
    
    enum Direction {
        case right, left
    }
    
    func animar(fromIndex: Int, toIndex: Int, withDuration: Double){
        guard toIndex != fromIndex else { return }
        let direction: Direction = fromIndex < toIndex ? .right : .left
        UIView.animate(withDuration: withDuration,
                       animations: {
                        if direction == .right {
                            self.rightConstraint?.constant += self.widthItem * CGFloat(toIndex - fromIndex)
                        } else {
                            self.leftConstraint?.constant -= self.widthItem * CGFloat(fromIndex - toIndex)
                        }
                        self.tabBar.layoutIfNeeded()
        })
        UIView.animate(withDuration: withDuration,
                       delay: withDuration,
                       animations: {
                        if direction == .right {
                            self.leftConstraint?.constant += self.widthItem * CGFloat(toIndex - fromIndex)
                        } else {
                            self.rightConstraint?.constant -= self.widthItem * CGFloat(fromIndex - toIndex)
                        }
                        self.tabBar.layoutIfNeeded()
        })
    }
    
    func didCchangeOrientation(toOrientation: UIDeviceOrientation, selectedIndex: Int){
        guard let items = tabBar.items, items.count > 0 else { return }
        widthItem = tabBar.frame.width / CGFloat(items.count)
        
        // valor da constante da margem esquerda até o inicio do indicador (esq do indicador)
        var leftConstant: CGFloat = 0
        leftConstant += widthItem * proportionalWidth
        // valor da constante da margem direita até o fim do indicador (dir do indicador)
        var rightConstant: CGFloat = -(widthItem * CGFloat(items.count - 1))
        rightConstant += widthItem * proportionalWidth
        
        leftConstant += widthItem * CGFloat(selectedIndex)
        rightConstant += widthItem * CGFloat(selectedIndex)
        leftConstraint?.constant = leftConstant
        rightConstraint?.constant = rightConstant
        self.tabBar.layoutIfNeeded()
    }
    
    func setConstraints(){
        self.translatesAutoresizingMaskIntoConstraints = false
        
        guard let items = tabBar.items, items.count > 0 else { return }
        
        widthItem = tabBar.frame.width / CGFloat(items.count)
        let topConstant: CGFloat = 1
        
        // valor da constante da margem esquerda até o inicio do indicador (esq do indicador)
        var leftConstant: CGFloat = 0
        leftConstant += widthItem * proportionalWidth
        // valor da constante da margem direita até o fim do indicador (dir do indicador)
        var rightConstant: CGFloat = widthItem * CGFloat(items.count - 1)
        rightConstant += widthItem * proportionalWidth

        // configurar constraints
        leftConstraint = self.leftAnchor.constraint(equalTo: tabBar.leftAnchor, constant: leftConstant)
        leftConstraint?.isActive = true
        rightConstraint = self.rightAnchor.constraint(equalTo: tabBar.rightAnchor, constant: -(rightConstant))
        rightConstraint?.isActive = true
        topConstraint = self.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: topConstant)
        topConstraint?.isActive = true
        heightConstraint = self.heightAnchor.constraint(equalToConstant: height)
        heightConstraint?.isActive = true
    }
}

