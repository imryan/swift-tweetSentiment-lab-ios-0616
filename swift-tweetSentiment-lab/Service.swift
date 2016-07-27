//
//  Service.swift
//  swift-tweetSentiment-lab
//
//  Created by Ryan Cohen on 7/27/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import STTwitter

class Service {
    
    static let sharedInstance = Service()
    var sentiments: [Sentiment] = []
    
    func authenticateAndFetch(completion: [Tweet] -> Void) {
        let twitter = STTwitterAPI(appOnlyWithConsumerKey: API_KEY, consumerSecret: API_SECRET)
        var allTweets: [Tweet] = []
        
        twitter.verifyCredentialsWithUserSuccessBlock({ (username, userId) in
            twitter.getSearchTweetsWithQuery("FlatironSchool", successBlock: { (metadata: [NSObject : AnyObject]?, statuses: [AnyObject]?) in
                if let tweets = statuses {
                    for post in tweets {
                        if let text = post["text"] {
                            allTweets.append(Tweet(text: String(text!)))
                        }
                    }
                    
                    if (allTweets.count > 1) {
                        completion(allTweets)
                    }
                }
                
            }) { (error) in
                print("Error: \(error.localizedDescription)")
            }
            
        }) { (error) in
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func getPolarity(tweet: Tweet, completion: Int -> Void) {
        if let text = tweet.text {
            if let encodedText = text.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet()) {
                let sentimentURL = "http://www.sentiment140.com/api/classify?text=\(encodedText)&query=FlatironSchool"
                
                Sentiment.getPolarity(NSURL(string: sentimentURL)!, completion: { (sentiment) in
                    self.sentiments.append(sentiment)
                    
                    if (self.sentiments.count == 10) {
                        let average = self.averagePolarity(self.sentiments)
                        completion(average)
                    }
                })
            }
        }
    }
    
    func averagePolarity(sentiments: [Sentiment]) -> Int {
        var total = 0
        
        for sentiment in sentiments {
            total += sentiment.polarity.rawValue
        }
        
        total /= sentiments.count
        
        
        
        return total
    }
}