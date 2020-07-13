//
//  TrendingCell.swift
//  YouTube
//
//  Created by Hanlin Chen on 7/13/20.
//  Copyright © 2020 Hanlin Chen. All rights reserved.
//

import UIKit

class TrendingCell: FeedCell {
    override func fetchVideo() {
        APIService.sharedInstance.fetchTrendingFeed(completion:
            {
                (videos:[Video])  in
                self.videos = videos
                self.collectionView.reloadData()
                
                }
        )
    }
}
