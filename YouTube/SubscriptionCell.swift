//
//  SubscriptionCell.swift
//  YouTube
//
//  Created by Hanlin Chen on 7/13/20.
//  Copyright © 2020 Hanlin Chen. All rights reserved.
//

import UIKit

class SubscriptionCell: FeedCell {
    override func fetchVideo() {
        APIService.sharedInstance.fetchSubscriptionFeed(completion:
            {
                (videos:[Video])  in
                self.videos = videos
                self.collectionView.reloadData()
                
                }
        )
    }
}
