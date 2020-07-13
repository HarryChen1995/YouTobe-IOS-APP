//
//  SettingCell.swift
//  YouTube
//
//  Created by Hanlin Chen on 7/9/20.
//  Copyright © 2020 Hanlin Chen. All rights reserved.
//

import UIKit

class SettingCell: BaseCell {
    override var isHighlighted: Bool {
        didSet{
            backgroundColor = isHighlighted ? .darkGray : .white
            nameLabel.textColor = isHighlighted ? .white : .darkGray
            iconImageView.tintColor  = isHighlighted ? .white : .darkGray
        }
    }
    var setting:Setting?{
        didSet {
            nameLabel.text = setting?.name.rawValue
            iconImageView.image = UIImage(named: (setting?.imageName)!)?.withRenderingMode(.alwaysTemplate)
            iconImageView.tintColor = .darkGray
        }
    }
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Setting"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    let iconImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "setting")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    override func setupView() {
        super.setupView()
        addSubview(nameLabel)
        addSubview(iconImageView)
        addConstraintsWithFormat(format: "H:|-8-[v0(30)]-8-[v1]|", views: iconImageView, nameLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
        addConstraintsWithFormat(format: "V:[v0(30)]", views: iconImageView)
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    

    }
}
