//
//  VideoCell.swift
//  YouTube
//
//  Created by Hanlin Chen on 7/6/20.
//  Copyright © 2020 Hanlin Chen. All rights reserved.
//
import UIKit

class BaseCell : UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    func setupView() {
        
        
    }
        
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


class VideoCell : BaseCell{

    var video: Video? {
        didSet {
            titleLabel.text = video?.title
            setupThumbnailImage()
            setupProfileImage()
            if let channelName = video?.channel?.name , let numberofviews = video?.numberOfViews {
               
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                let subtitleText = "\(channelName) • \(numberFormatter.string(from: numberofviews)!) • 2 years ago"
            subtitle.text = subtitleText
            }
            
            if let title = video?.title {
                let size  = CGSize(width: (frame.width - 16 -  44 - 8 - 16), height: 1000)
                let eastimateRec = NSString(string: title).boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)], context: nil)
                
                if eastimateRec.size.height > 20 {
                    labelHeightConstraint?.constant = 44
                }else{
                    labelHeightConstraint?.constant = 20
                }
                
            }
            
        }
    }
    
    func setupThumbnailImage(){
        if let thunnailImageUrl = video?.thumbnailImageName {
            
            thumnailImageView.loadURLImage(urlstr: thunnailImageUrl)
        }
    }
    
    func setupProfileImage(){
        if let profilImageUrl = video?.channel?.profileImageName {
            userProfile.loadURLImage(urlstr: profilImageUrl)
        }
    }
    let thumnailImageView: CustomImageView = {
            let imageView = CustomImageView()
        imageView.image = UIImage(named: "blank_space")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    let seperatorView : UIView = {
            let uiview = UIView()
        uiview.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return uiview
    }()
    
    let userProfile : CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = UIImage(named: "taylor_profile")
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let titleLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Black Space - Taylor Swift"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
        
    }()
    
    let subtitle : UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "TaylorSwiftVEVO • 1,604,684,607 views • 2 years ago"
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        textView.textColor = .lightGray
        textView.isEditable = false
        return textView
    }()
    
    var labelHeightConstraint: NSLayoutConstraint?
    override func setupView(){
        addSubview(thumnailImageView)
        addSubview(userProfile)
        addSubview(seperatorView)
        addSubview(titleLabel)
        addSubview(subtitle)
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: thumnailImageView)
        addConstraintsWithFormat(format: "H:|-16-[v0(44)]", views: userProfile)
        addConstraintsWithFormat(format: "H:|[v0]|", views: seperatorView)
        addConstraintsWithFormat(format: "V:|-16-[v0]-8-[v1(44)]-36-[v2(1)]|", views: thumnailImageView, userProfile, seperatorView)
        
        
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: thumnailImageView, attribute: .bottom, multiplier: 1, constant: 8))
        
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: userProfile, attribute: .right, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: thumnailImageView, attribute: .right, multiplier: 1, constant: 0))
        labelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 44)
        addConstraint(labelHeightConstraint!)
        
        
        addConstraint(NSLayoutConstraint(item: subtitle, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 4))
        
        addConstraint(NSLayoutConstraint(item: subtitle, attribute: .left, relatedBy: .equal, toItem: userProfile, attribute: .right, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: subtitle, attribute: .right, relatedBy: .equal, toItem: thumnailImageView, attribute: .right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: subtitle, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30))
        

    }

}
let imageCache = NSCache<NSString, UIImage>()
class CustomImageView: UIImageView {
    var imageURLString: String?
    func loadURLImage (urlstr:String){
        imageURLString = urlstr
        image = nil
        if let imageFromCache = imageCache.object(forKey: urlstr as NSString){
            image =  imageFromCache
        }
        else{
          let url = URL(string: urlstr)
          URLSession.shared.dataTask(with: url!, completionHandler:
              {
                  (data, response, error) in
                  
                  if error != nil {
                    print(error ?? "")
                      return
                  }
                  DispatchQueue.main.sync {
                    let imageToCache =  UIImage(data: data!)
                    if self.imageURLString == urlstr {
                        self.image = imageToCache
                    }
                    imageCache.setObject(imageToCache!, forKey: urlstr as NSString)
                  }
              }).resume()
        }
    }
}
