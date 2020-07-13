//
//  Video.swift
//  YouTube
//
//  Created by Hanlin Chen on 7/8/20.
//  Copyright © 2020 Hanlin Chen. All rights reserved.
//

import UIKit

class Video: NSObject {
    var thumbnailImageName: String?
    var title: String?
    var channel: Channel?
    var numberOfViews: NSNumber?
    var uploadDate: NSDate?
    
}

class Channel: NSObject{
    var name: String?
    var profileImageName: String?
}
