//
//  DB.swift
//  UnserAller
//
//  Created by Vadim Dez on 19/03/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import Foundation
import CoreData

@objc(User)
class User: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var firstname: String
    @NSManaged var lastname: String
    @NSManaged var email: String
    
}
