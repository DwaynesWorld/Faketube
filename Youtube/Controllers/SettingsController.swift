//
//  SettingsController.swift
//  Youtube
//
//  Created by Kyle Thompson on 12/24/18.
//  Copyright © 2018 Kyle Thompson. All rights reserved.
//

import UIKit


class SettingsController: NSObject {
    
    let settings: [Setting] = {
        return [
            Setting(name: .settings, imageName: "settings"),
            Setting(name: .terms, imageName: "terms"),
            Setting(name: .feedback, imageName: "feedback"),
            Setting(name: .help, imageName: "help"),
            Setting(name: .switchAccounts, imageName: "account"),
            Setting(name: .cancel, imageName: "close"),
        ]
    }()
    
    let dimmedView = UIView()
    
    lazy var collectionViewHeight: CGFloat = {
        let bottomPadding: CGFloat = 20
        return CGFloat(self.settings.count) * self.cellHeight + bottomPadding
    }()
    
    let cellHeight: CGFloat = 50

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .white
        view.isScrollEnabled = false
        view.delegate = self
        view.dataSource = self
        view.register(SettingsCell.self, forCellWithReuseIdentifier: cellId)
        return view
    }()
    
    let cellId: String = "CellID"
    
    var homeController: HomeController?
    
    override init() {
        super.init()
    }
    
    
    /// Shows the dimmed view and the settings collection view with animation
    @objc func showSettings() {
        if let window = UIApplication.shared.keyWindow {
            dimmedView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            dimmedView.frame = window.frame
            dimmedView.alpha = 0
            dimmedView.addGestureRecognizer(
                UITapGestureRecognizer(target: self,
                                       action: #selector(handleCancelDismiss)))

            collectionView.frame = CGRect(x: 0,
                                          y: window.frame.height,
                                          width: window.frame.width,
                                          height: 200)
            
            window.addSubview(dimmedView)
            window.addSubview(collectionView)
            
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveEaseOut,
                           animations: {
                                let frame = CGRect(x: 0,
                                                   y: window.frame.height - self.collectionViewHeight,
                                                   width: window.frame.width,
                                                   height: self.collectionViewHeight)

                                self.collectionView.frame = frame
                                self.dimmedView.alpha = 1
            }, completion: nil)
            
        }
    }
    
    /// Handles the dismissing of dimmed view and the collection view
    @objc func handleCancelDismiss() {
        handleDismiss(completion: nil)
    }
    
    func handleDismiss(completion: ((Bool) -> Void)?) {
        
        let animations = {
            self.dimmedView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0,
                                                   y: window.frame.height,
                                                   width: window.frame.width,
                                                   height: self.collectionViewHeight)
            }
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveLinear,
                       animations: animations,
                       completion: completion)
    }
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension SettingsController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: cellId,
                for: indexPath) as! SettingsCell
        
        cell.setting = settings[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        let setting = self.settings[indexPath.item]
        if setting.name == .cancel {
            handleDismiss(completion: nil)
        } else {
            handleDismiss { (completed) in
                self.homeController?.showController(forSetting: setting)
            }
        }
    }

}
