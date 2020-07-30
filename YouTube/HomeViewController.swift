//
//  ViewController.swift
//  YouTube
//
//  Created by Hanlin Chen on 7/6/20.
//  Copyright © 2020 Hanlin Chen. All rights reserved.
//

import UIKit

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.backgroundColor = .white
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "  Home"
        
        navigationItem.titleView = label
        navigationItem.title = "Home"
        navigationController?.navigationBar.isTranslucent = false
        
        setupCollectionView()
        setUpMenuBar()
        setUpNavbar()
        
    
    }
    let cellID = "cellID"
    let trendingCellID = "tc"
    let subscriptionCellID = "sc''"
    func setupCollectionView(){
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
        }
        collectionView.isPagingEnabled = true
        collectionView.delegate = self

        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(TrendingCell.self, forCellWithReuseIdentifier: trendingCellID)
        collectionView.register(SubscriptionCell.self, forCellWithReuseIdentifier: subscriptionCellID)
        collectionView.contentInset = UIEdgeInsets(top: 50, left:0, bottom: 0, right: 0)
         collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left:0, bottom: 0, right: 0)
    }
    func setUpNavbar(){
        let searchImage = UIImage(named: "search")?.withRenderingMode(.alwaysOriginal)
     let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handle_search))
        
        let moreImage = UIImage(named: "nav_more")?.withRenderingMode(.alwaysOriginal)
        let moreBarButtonItem = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(handle_more))
        navigationItem.rightBarButtonItems = [moreBarButtonItem, searchBarButtonItem]
        
    }
    lazy var settingLauncher : SettingLauncher =  {
        let sl = SettingLauncher()
        sl.homeController = self
            return sl
    }()
    @objc func handle_more(){
        // show menu
        settingLauncher.showSetting()
        
    }
    
    func showControllerForSetting(setting:Setting){
        let dummy = UIViewController()
        dummy.navigationItem.title = setting.name.rawValue
        dummy.view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.pushViewController(dummy, animated: true)
    }

    @objc func handle_search(){
        print(123)
    }
    
    lazy var  menuBar: MenuBar = {
       let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    func scrollToMenuIndex(menuIndex:Int){
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: [], animated: true)
        if let label = navigationItem.titleView as? UILabel {
            label.text = titles[indexPath.item]
        }
    }
    private func setUpMenuBar(){
        
        navigationController?.hidesBarsOnSwipe = true
        let redView = UIView()
        redView.backgroundColor = UIColor(red: 230/255, green: 32/255, blue: 31/255, alpha: 1)
        
        view.addSubview(redView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: redView)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: redView)
        
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: menuBar)
        menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var identifier:String
        identifier = cellID
        if indexPath.item == 1 {
            identifier = trendingCellID
            
        }
        
        if indexPath.item == 2 {
            identifier = subscriptionCellID
            
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        return cell
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalLeftConstraint?.constant = scrollView.contentOffset.x / 4
    }
    let titles = ["  Home", "  Trending", "  Subscriptions", "  Account"]
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        if let label = navigationItem.titleView as? UILabel {
            label.text = titles[indexPath.item]
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height-50)
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...){
        var viewDict = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewDict[key] = view
            
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: [], metrics: nil, views: viewDict))
    }
}
