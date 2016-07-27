//
//  Sentiment.swift
//  swift-tweetSentiment-lab
//
//  Created by Ryan Cohen on 7/27/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

class Sentiment {
    
    enum Polarity: Int {
        case Negative = 0
        case Neutral = 2
        case Positive = 4
    }
    
    var text: String
    var polarity: Polarity
    
    init(text: String, polarity: Polarity) {
        self.text = text
        self.polarity = polarity
    }
}

extension Sentiment {
    
    class func getPolarity(url: NSURL, completion: Sentiment -> Void) {
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        session.dataTaskWithURL(url, completionHandler: { (data, response, error) in
            if let data = data {
                do {
                    let result = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary
                    
                    let text = result["results"]!["text"] as! String
                    let polarity = result["results"]!["polarity"] as! Int
                    
                    let sentiment = Sentiment(text: text, polarity: Polarity(rawValue: polarity)!)
                    completion(sentiment)
                    
                } catch {
                    print("Error fetching sentiment: \(error)")
                }
            }
            
        }).resume()
    }
}