//
//  APIService.swift
//  YouTube
//
//  Created by Hanlin Chen on 7/9/20.
//  Copyright © 2020 Hanlin Chen. All rights reserved.
//

import UIKit

class APIService: NSObject {
  static let sharedInstance = APIService()
    func fetchVideo(completion: @escaping ([Video]) ->Void){
        fetchFeedForUrlString(urlString: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json", completion: completion)
  
  }
    func fetchTrendingFeed(completion: @escaping ([Video]) ->Void){
         fetchFeedForUrlString(urlString: "https://s3-us-west-2.amazonaws.com/youtubeassets/trending.json", completion:  completion )
    
    }
    func fetchSubscriptionFeed(completion: @escaping ([Video]) ->Void){

        fetchFeedForUrlString(urlString: "https://s3-us-west-2.amazonaws.com/youtubeassets/subscriptions.json", completion: completion)

    }
    
    func fetchFeedForUrlString(urlString:String, completion: @escaping ([Video]) ->Void){
        let url = URL(string:urlString)
            URLSession.shared.dataTask(with: url!, completionHandler:
            {
                (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }

                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [.mutableContainers])
                  var videos  = [Video]()
                  for  dict in json  as! [[String:AnyObject]] {
                        let video = Video()
                        video.title = dict["title"] as? String
                        video.thumbnailImageName = dict["thumbnail_image_name"] as? String
                    video.numberOfViews = dict["number_of_views"] as? NSNumber
                        let channeldict = dict["channel"] as! [String:AnyObject]
                        let channel = Channel()
                        channel.name = channeldict["name"] as? String
                        channel.profileImageName = channeldict["profile_image_name"] as? String
                        video.channel = channel
                        videos.append(video)
                        
                    }
                    DispatchQueue.main.async {
                        completion(videos)
                    }
                } catch let  jsonerror {
                    print(jsonerror)
                }
            
            }
            ).resume()
        
        
    }
}
