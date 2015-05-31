//
//  MediaHelper.swift
//  UnserAller
//
//  Created by Vadim Dez on 31/05/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

class UIViewControllerWithMedia: UIViewController, MWPhotoBrowserDelegate {
    var photos: [MWPhotoObj] = []
    
    
    func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didSelectItemFromCollectionView:", name: "didSelectItemFromCollectionView", object: nil)
    }
    
    func removeNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "didSelectItemFromCollectionView", object: nil)
    }
    
    // MARK: MWPhotoBrowser delegates
    /**
    * MWPhotoBrowser delegates
    */
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser) -> UInt {
        return UInt(self.photos.count)
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhoto! {
        if (Int(index) < self.photos.count) {
            return self.photos[Int(index)];
        }
        return nil;
    }
    
    func didSelectItemFromCollectionView(notification: NSNotification) -> Void {
        let cellData: Dictionary<String, AnyObject> = notification.object as! Dictionary<String, AnyObject>
        self.photos = []
        if (!cellData.isEmpty) {
            
            if let medias: [UAMedia] = cellData["media"] as? [UAMedia] {
                
                for media: UAMedia in medias {
                    let photo: MWPhotoObj = MWPhotoObj.photoWithURL(NSURL(string: "\(APIPROTOCOL)://\(APIURL)/media/crop/\(media.hash)/\(media.width)/\(media.height)"))
                    self.photos.append(photo)
                }
                
                var browser: MWPhotoBrowser = MWPhotoBrowser(delegate: self)
                
                browser.showPreviousPhotoAnimated(true)
                browser.showNextPhotoAnimated(true)
                browser.setCurrentPhotoIndex(cellData["actual"] as! UInt)
                self.navigationController?.pushViewController(browser, animated: false)
            }
        }
    }
}