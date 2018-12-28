//
//  MenuCell.swift
//  Youtube
//
//  Created by Kyle Thompson on 12/23/18.
//  Copyright © 2018 Kyle Thompson. All rights reserved.
//
import UIKit

class MenuCell: BaseCell {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()

    override var isHighlighted: Bool {
        didSet {
            imageView.tintColor = isHighlighted
                ? .white
                : ApplicationColor.inactiveButton
        }
    }
    
    override var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected
                ? .white
                : ApplicationColor.inactiveButton
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(imageView)
        addConstraints(withformat: "H:[v0(40)]", views: imageView)
        addConstraints(withformat: "V:[v0(40)]", views: imageView)
        
        addConstraint(NSLayoutConstraint.init(item: imageView,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        addConstraint(NSLayoutConstraint.init(item: imageView,
                                              attribute: .centerY,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .centerY,
                                              multiplier: 1,
                                              constant: 0))
    }
}

