//
//  UACellSuggest.swift
//  UnserAller
//
//  Created by Vadim Dez on 02/06/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

class UACellSuggest: UACell {
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeImage: UIImageView!

    var suggestionId: UInt = 0
    var projectId: UInt = 0
    var suggestion: UASuggestion!
    
    /**
    Like suggestion
    
    :param: sender
    */
    @IBAction func like(sender: AnyObject) {
        let active: Bool = !(suggestion.userVotes > 0)
        self.updateLike(active)
        
        self.sendLike(self.suggestion.suggestionId, success: { (active) -> Void in
            }) { () -> Void in
                self.tintLike(!active)
        }
    }
    
    func updateLike(active: Bool) {
        let increment = (active) ? 1 : -1
        self.suggestion.userVotes += increment
        self.suggestion.likeCount = self.suggestion.likeCount + increment;
        self.likeLabel.text = "\(self.suggestion.likeCount)"
        
        self.tintLike(active)
    }
    
    /**
    Set image for like image view based on state
    
    :param: active  state
    */
    func tintLike(active: Bool) {
        // if liked - tint heart
        if (active) {
            self.likeImage.image = UIImage(named: "heart_red")
        } else {
            self.likeImage.image = UIImage(named: "heart_black_32")
        }
    }
}