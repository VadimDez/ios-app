//
//  MediaHelper.swift
//  UnserAller
//
//  Created by Vadim Dez on 31/05/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

class UIViewControllerWithMedia: UIViewController, IDMPhotoBrowserDelegate {
    
    
    func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didSelectItemFromCollectionView:", name: "didSelectItemFromCollectionView", object: nil)
    }
    
    func removeNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "didSelectItemFromCollectionView", object: nil)
    }

    
    func didSelectItemFromCollectionView(notification: NSNotification) -> Void {
        let cellData: Dictionary<String, AnyObject> = notification.object as! Dictionary<String, AnyObject>
        var photos: [IDMPhoto] = []
        
        if (!cellData.isEmpty) {
            
            if let medias: [UAMedia] = cellData["media"] as? [UAMedia] {
                
                for media: UAMedia in medias {
                    let photo: IDMPhoto = IDMPhoto(URL: NSURL(string: "\(APIPROTOCOL)://\(APIURL)/media/crop/\(media.hash)/\(media.width)/\(media.height)"))
                    photos.append(photo)
                }
                
                
                var browser: IDMPhotoBrowser = IDMPhotoBrowser(photos: photos)
                browser.delegate = self
//                browser.forceHideStatusBar = true // not sure
                browser.setInitialPageIndex(cellData["actual"] as! UInt)
                browser.displayCounterLabel = true
                browser.usePopAnimation = true
//                browser.doneButtonImage = UIImage(named: "selected")
                
                
                self.presentViewController(browser, animated: true, completion: nil)
            }
        }
    }
}