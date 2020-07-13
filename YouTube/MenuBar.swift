//
//  MenuBar.swift
//  YouTube
//
//  Created by Hanlin Chen on 7/6/20.
//  Copyright © 2020 Hanlin Chen. All rights reserved.
//

import UIKit


class MenuBar :  UIView , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    var homeController: HomeViewController? 
    let imageNames = ["home", "trending", "subscription", "identity"]
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame : .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(red: 230/255, green: 32/255, blue: 31/255, alpha: 2)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    let  cellID = "cellID"
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellID)
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: indexPath , animated: false, scrollPosition: [])

        setupHorizontalBar()
    }
    var horizontalLeftConstraint: NSLayoutConstraint?
    func setupHorizontalBar(){
        let horizontalBar = UIView()
        horizontalBar.backgroundColor  = UIColor(white: 0.9, alpha: 1)
        horizontalBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBar)
        horizontalLeftConstraint = horizontalBar.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalLeftConstraint?.isActive = true
        horizontalBar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/4).isActive = true
        horizontalBar.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {        
        homeController?.scrollToMenuIndex(menuIndex: indexPath.item)
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MenuCell
        
        cell.imageView.image = UIImage(named: imageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        cell.tintColor = UIColor(red: 91/255, green: 14/255, blue: 13/255, alpha: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/4 , height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

class MenuCell : BaseCell {
    let imageView : UIImageView = {
        let imagev = UIImageView()
        imagev.image = UIImage(named: "home")?.withRenderingMode(.alwaysTemplate)
        imagev.tintColor = UIColor(red: 91/255, green: 14/255, blue: 13/255, alpha: 1)
        return imagev
    }()
    
    override var isHighlighted: Bool{
        didSet {
            imageView.tintColor = isHighlighted ? .white : UIColor(red: 91/255, green: 14/255, blue: 13/255, alpha: 1)
        }
    }
    
    override var isSelected: Bool{
        didSet {
            imageView.tintColor = isSelected ? .white : UIColor(red: 91/255, green: 14/255, blue: 13/255, alpha: 1)
        }
    }
    override func setupView(){
        super.setupView()
        addSubview(imageView)
        addConstraintsWithFormat(format: "H:[v0(28)]", views: imageView)
        addConstraintsWithFormat(format: "V:[v0(28)]", views: imageView)
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
}
