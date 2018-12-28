//
//  UIView.swift
//  Youtube
//
//  Created by Kyle Thompson on 12/23/18.
//  Copyright © 2018 Kyle Thompson. All rights reserved.
//

import UIKit

extension UIView {
    
    func addConstraints(withformat format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint
            .constraints(withVisualFormat: format,
                         options: NSLayoutConstraint.FormatOptions(),
                         metrics: nil,
                         views: viewsDictionary))
    }
}
