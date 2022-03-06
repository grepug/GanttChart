//
//  UIKitExtension.swift.swift
//  
//
//  Created by Kai on 2022/3/6.
//

import UIKit

public extension UIMenu {
    static func makeMenu(@MenuBuilder content: () -> [Menu]) -> UIMenu {
        let content = content()
        let children = Self.recursivelyMakeMenu(children: content)
        
        return .init(children: children)
    }
    
    private static func recursivelyMakeMenu(children: [Menu]) -> [UIMenuElement] {
        var elements: [UIMenuElement] = []
        
        for item in children {
            if let children = item.children {
                let menu = UIMenu(children: recursivelyMakeMenu(children: children))
                elements.append(menu)
            } else {
                let action = UIAction(title: item.title) { _ in
                    item.action?()
                }
                elements.append(action)
            }
        }
        
        return elements
    }
}
