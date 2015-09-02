//
//  UserShared.swift
//  UnserAller
//
//  Created by Vadym on 28/08/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//


class UserShared {
    static let sharedInstance = UserShared()
    
    var id: UInt = 0
    var suggestionCredits: UInt = 0
    var commentCredits: UInt = 0
    var mediaCredits: UInt = 0
    var likeCredits: UInt = 0
    var voteCredits: UInt = 0
    
    
    private init() {
        
    }
    
    func setId(userId: UInt) {
        self.id = userId
    }
    
    func setSuggestionCredits(credits: UInt) -> Void {
        self.suggestionCredits = credits
    }
    
    func setCommentCredits(credits: UInt) -> Void {
        self.commentCredits = credits
    }
    
    func setLikeCredits(credits: UInt) -> Void {
        self.likeCredits = credits
    }
    
    func setVoteCredits(credits: UInt) -> Void {
        self.voteCredits = credits
    }
}