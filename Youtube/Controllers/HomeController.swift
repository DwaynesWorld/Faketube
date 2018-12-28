//
//  ViewController.swift
//  Youtube
//
//  Created by Kyle Thompson on 12/23/18.
//  Copyright © 2018 Kyle Thompson. All rights reserved.
//

import UIKit
import AVKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let titles = ["Home", "Trending", "Subscriptions", "Account"]
    fileprivate let FeedCellId = "FeedCellId"
    fileprivate let HomeCellId = "HomeCellId"
    fileprivate let TrendingCellId = "TrendingCellId"
    fileprivate let SubscriptionsCellId = "SubscriptionsCellId"
    
    lazy var settingsController: SettingsController = {
        let controller = SettingsController()
        controller.homeController = self
        return controller
    }()
    
    lazy var menuBar: MenuBar = {
        let menuBar = MenuBar()
        menuBar.homeController = self
        return menuBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        
        setupNavigation()
        setupCollectionView()
    }
    
    private func setupNavigation() {
        navigationController?.hidesBarsOnSwipe = true
        
        setupTitle()
        setupNavbarButtons()
        setupMenuBar()
    }
    
    private func setupTitle() {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height)
        let titleLabel = UILabel(frame: frame)
        titleLabel.text = "Home"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
    }

    private func setupNavbarButtons() {
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search,
                                           target: self,
                                           action: #selector(HomeController.handleSearch))
        searchButton.tintColor = .white

        let moreButton = UIBarButtonItem(barButtonSystemItem: .action,
                                         target: self,
                                         action: #selector(HomeController.handleMore))
        moreButton.tintColor = .white
        
        navigationItem.rightBarButtonItems = [moreButton, searchButton]
    }
    
    private func setupMenuBar() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = ApplicationColor.primary
        
        view.addSubview(backgroundView)
        view.addConstraints(withformat: "H:|[v0]|", views: backgroundView)
        view.addConstraints(withformat: "V:[v0(50)]", views: backgroundView)
        
        view.addSubview(menuBar)
        view.addConstraints(withformat: "H:|[v0]|", views: menuBar)
        view.addConstraints(withformat: "V:[v0(50)]", views: menuBar)
        
        menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    private func setupCollectionView() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
        }
        
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCellId)
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: HomeCellId)
        collectionView.register(TrendingCell.self, forCellWithReuseIdentifier: TrendingCellId)
        collectionView.register(SubscriptionsCell.self, forCellWithReuseIdentifier: SubscriptionsCellId)
    }
    
    private func setTitle(for index: IndexPath) {
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = titles[index.item]
        }
    }
    
    @objc func handleSearch() {
        let indexPath = IndexPath(item: 2, section: 0)
        scrollToMenu(at: indexPath)
    }
    
    @objc func handleMore() {
        settingsController.showSettings()
    }
    
    func showController(forSetting setting: Setting) {
        let dummyViewController = UIViewController()
        dummyViewController.navigationItem.title = setting.name.rawValue
        dummyViewController.view.backgroundColor = .white
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
        navigationController?.pushViewController(dummyViewController, animated: true)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: -view.safeAreaInsets.bottom, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: -view.safeAreaInsets.bottom, right: 0)
    }
}


// MARK: - CollectionView Methods
extension HomeController {
    
    func scrollToMenu(at indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: [], animated: true)
        setTitle(for: indexPath)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.activeBarLeftAnchorConstraint?.constant = (scrollView.contentOffset.x / 4)
    }
    
    override func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = Int(targetContentOffset.pointee.x / view.frame.width)
        let indexPath = IndexPath(item: index, section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        setTitle(for: indexPath)
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        
        return 4
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier: String
        
        switch indexPath.item {
        case 0:
            identifier = HomeCellId
        case 1:
            identifier = TrendingCellId
        case 2:
            identifier = SubscriptionsCellId
        default:
            identifier = FeedCellId
        }
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: identifier,
            for: indexPath)
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
    
    }
}




