//
//  SettingLauncher.swift
//  YouTube
//
//  Created by Hanlin Chen on 7/8/20.
//  Copyright © 2020 Hanlin Chen. All rights reserved.
//

import UIKit

class Setting: NSObject {
    let name:SettingName
    let imageName: String
    init(name:SettingName, imageName:String){
        self.name = name
        self.imageName = imageName
    }
}
enum SettingName:String {
    case Cancel = "Cancel"
    case Setting = "Setting"
    case TermsPrivacy = "Terms & Privacy Policies"
    case Help = "Help"
    case Feedback = "Send Feedbacks"
    case SwitchAccount = "Switch Account"
}
class SettingLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let blackView = UIView()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    let settings: [Setting] = {
        return [
                Setting(name: .Setting, imageName: "setting"),
                Setting(name: .TermsPrivacy, imageName: "privacy"),
                Setting(name: .Feedback, imageName: "feedback"),
                Setting(name: .Help, imageName: "help"),
                Setting(name: .SwitchAccount, imageName: "switch_account"),
                Setting(name: .Cancel, imageName: "cancel")
                
               ]
    }()
    let cellHeight : CGFloat = 50
    @objc func showSetting(){
        // show menu
        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            blackView.backgroundColor = UIColor(white: 0, alpha: 1)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handle_dismiss(setting:))))
            window.addSubview(blackView)
            window.addSubview(collectionView)
            let height: CGFloat = CGFloat(settings.count ) * cellHeight
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:
                {
                    self.blackView.alpha = 0.5
                    self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
                , completion: nil)

        }
    }
    
    @objc func handle_dismiss(setting:Any){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:
                {
                    self.blackView.alpha = 0
                    if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first{
                        self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                    }
            }
            , completion: {
                (completed) in
                if let setting = setting as? Setting {
                    if setting.name != .Cancel{
                self.homeController?.showControllerForSetting(setting: setting)
                 }
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! SettingCell
        cell.setting = settings[indexPath.item]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    var homeController: HomeViewController?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let setting = settings[indexPath.item]
        handle_dismiss(setting: setting)
    }
    
    override init() {
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: "cellID")
    }
}
