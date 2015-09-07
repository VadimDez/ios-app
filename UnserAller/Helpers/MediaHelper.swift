//
//  MediaHelper.swift
//  UnserAller
//
//  Created by Vadim Dez on 05/09/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

class MediaHelper {
//    var margin: CGFloat = 0.0
    var frameMaxWidth: CGFloat!
    var mediaCount: Int = 0
    
    init() {
        
    }
    
    init(maxWidth: CGFloat, mediaCount: Int) {
        self.frameMaxWidth = maxWidth
        self.mediaCount = mediaCount
    }
    
    func getSizeForIndex(index: Int) -> CGSize {
        
        var size: CGFloat = self.frameMaxWidth
        
        if self.mediaCount == 1 {
            return CGSize(width: size, height: size)
        }
        
        if self.mediaCount == 2 {
            size -= 4.0
            return CGSize(width: size / 2, height: size / 2)
        }
        
        if self.mediaCount == 3 {
            if index == 0 {
                return CGSize(width: size, height: size)
            }
            return CGSize(width: size / 2, height: size / 2)
        }
        
        return CGSize(width: size, height: size)
    }
    
    func getHeightForMedias(mediaCount: Int, maxWidth: CGFloat) -> CGFloat {
        if mediaCount == 0 {
            return 0.0
        }
        
        if mediaCount == 1 {
            return maxWidth
        }
        
        if mediaCount == 2 {
            return maxWidth / 2
        }
        
        if mediaCount == 3 {
            return maxWidth * 1.5
        }
        
        if mediaCount <= 5 {
            return maxWidth / 3 + maxWidth / 2
        }
        
        return 0.0
    }
}