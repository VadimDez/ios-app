//
//  StringExtensions.swift
//  UnserAller
//
//  Created by Vadim Dez on 31/05/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

extension String {
    /**
    *  Get NSDate from string
    *
    */
    func getDateFromString() -> NSDate {
        var formatter:NSDateFormatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(name: "Europe/Berlin")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.dateFromString(self)!
    }
    
    /**
    *  Get NSDate from string
    *
    */
    func getDateFromLongString() -> NSDate {
        var formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        return formatter.dateFromString(self)!
    }
    
    
    func stripHTML() -> String {
        // title
        var str = self.stringByReplacingOccurrencesOfString("</h3>", withString: " ", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
        // rest
        return str.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
    }
    
    func html2String() -> String {
//        var html = self
//        
//        // Replace newline character by HTML line break
//        while let range = html.rangeOfString("\n") {
//            html.replaceRange(range, with: "<br />")
//        }
//        
//        // Embed in a <span> for font attributes:
//        html = "<span style=\"font-family: Helvetica; font-size:14pt;\">" + html + "</span>"
//        
//        let data = html.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!
//        let attrStr = NSAttributedString(
//            data: data,
//            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
//            documentAttributes: nil,
//            error: nil)!
//        return attrStr.string
        
        return NSAttributedString(data: self.dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil, error: nil)!.string
    }
    var html2NSAttributedString:NSAttributedString {
        return NSAttributedString(data: dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil, error: nil)!
    }
    
    func getHeightForView(width: CGFloat, font: UIFont) -> CGFloat {
        // count text
        var frame: CGRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        var label: UILabel = UILabel(frame: frame)
        
        label.text = self
        label.font = font
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.sizeToFit()
        
        return label.frame.size.height
    }
    
    func getWidthForView(height: CGFloat, font: UIFont) -> CGFloat {
        // count text
        var frame: CGRect = CGRect(x: 0, y: 0, width: CGFloat(MAXFLOAT), height: height)
        var label: UILabel = UILabel(frame: frame)
        
        label.text = self
        label.font = font
        label.numberOfLines = 1
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.sizeToFit()
        
        return label.frame.size.width
    }
}
