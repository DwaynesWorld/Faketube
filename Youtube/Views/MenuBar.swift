//
//  MenuBar.swift
//  Youtube
//
//  Created by Kyle Thompson on 12/23/18.
//  Copyright © 2018 Kyle Thompson. All rights reserved.
//

import UIKit

class MenuBar: UIView {
    
    var activeBarLeftAnchorConstraint: NSLayoutConstraint?
    var homeController: HomeController?
    
    let cellId = "cellId"
    let imageNames = ["home", "trending", "subscriptions", "account"]
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = ApplicationColor.primary
        view.dataSource = self
        view.delegate = self
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCollectionView()
        setupActiveBar()
    }
    
    func setupActiveBar() {
        let activeBar = UIView()
        activeBar.backgroundColor = UIColor(white: 0.9, alpha: 1)
        activeBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activeBar)
        
        activeBarLeftAnchorConstraint = activeBar.leftAnchor.constraint(equalTo: self.leftAnchor)
        
        activeBarLeftAnchorConstraint?.isActive = true
        activeBar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        activeBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/4).isActive = true
        activeBar.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    
    private func setupCollectionView() {
        collectionView.register(MenuCell.self,
                                forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        addConstraints(withformat: "H:|[v0]|", views: collectionView)
        addConstraints(withformat: "V:|[v0]|", views: collectionView)
        
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .left)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - CollectionView Methods
extension MenuBar:
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        
        return 4
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellId,
            for: indexPath) as! MenuCell
        
        cell.imageView.image = UIImage(named: imageNames[indexPath.item])?
            .withRenderingMode(.alwaysTemplate)
        
        cell.tintColor = ApplicationColor.inactiveButton
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
        
//        let x = CGFloat(indexPath.item) * (frame.width / 4)
//        activeBarLeftAnchorConstraint?.constant = x
//
//        let animations = {
//            self.layoutIfNeeded()
//        }
//
//        UIView.animate(withDuration: 0.4,
//                       delay: 0,
//                       usingSpringWithDamping: 1,
//                       initialSpringVelocity: 1,
//                       options: .curveEaseOut,
//                       animations: animations,
//                       completion: nil)
        
        homeController?.scrollToMenu(at: indexPath)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: frame.width / 4, height: frame.height)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 0
    }
}
