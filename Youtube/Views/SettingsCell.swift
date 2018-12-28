//
//  SettingsCell.swift
//  Youtube
//
//  Created by Kyle Thompson on 12/24/18.
//  Copyright © 2018 Kyle Thompson. All rights reserved.
//

import UIKit

class SettingsCell: BaseCell {
    
    var setting: Setting? {
        didSet {
            if let setting = setting {
                iconImageView.image = UIImage(named: setting.imageName)?.withRenderingMode(.alwaysTemplate)
                nameLabel.text = setting.name.rawValue
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .darkGray : .white
            nameLabel.textColor = isHighlighted ? .white : .black
            iconImageView.tintColor = isHighlighted ? .white : .darkGray
        }
    }
    
    let iconImageView: UIImageView = {
        let view = UIImageView()
        view.tintColor = .darkGray
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(iconImageView)
        addSubview(nameLabel)
        
        addConstraints(withformat: "H:|-16-[v0(30)]-8-[v1]|", views: iconImageView, nameLabel)
        addConstraints(withformat: "V:[v0(30)]", views: iconImageView)
        addConstraints(withformat: "V:|[v0]|", views: nameLabel)
        
        addConstraint(NSLayoutConstraint.init(item: iconImageView,
                                              attribute: .centerY,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .centerY,
                                              multiplier: 1,
                                              constant: 0))
    }
    
}
