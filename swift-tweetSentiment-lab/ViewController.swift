//
//  ViewController.swift
//  swift-tweetSentiment-lab
//
//  Created by susan lovaglio on 7/23/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var polarityLabel: UILabel!
    
    let service = Service.sharedInstance
    
    // MARK: - Functions
    
    func averagePolarity() {
        service.authenticateAndFetch { (tweets) in
            for tweet in tweets {
                self.service.getPolarity(tweet, completion: { (polarity) in
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        var type = ""
                        if (polarity == 0) {
                            type = "Negative"
                        } else if (polarity >= 2 && polarity <= 3) {
                            type = "Neutral"
                        } else if (polarity >= 3 && polarity <= 4) {
                            type = "Positive"
                        }
                        
                        self.polarityLabel.text = "Average Polarity: \(polarity) (About \(type))"
                    })
                })
            }
        }
    }
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        averagePolarity()
    }
}

