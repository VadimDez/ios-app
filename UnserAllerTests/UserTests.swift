//
//  UserTests.swift
//  UnserAller
//
//  Created by Vadim Dez on 09/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit
import XCTest

class UserTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUserInitWithParams() {
        let user: UAUser = UAUser()
        let id: UInt = 1
        let fullname = "First last"
        let profileImageURL = "profileImageURL"
        let profileImageView = UIImageView()
        
        user.initWithParams(id, usrFullname: fullname, usrProfileImageUrl: profileImageURL, usrProfileImageView: profileImageView)
        
        XCTAssertTrue((user.id == id && user.fullName == fullname && user.profileImageURL == profileImageURL), "test initWithParams")
    }
    
    func testCheckStringsWithSpace() {
        let user: UAUser = UAUser()
        let string: String = " "
        XCTAssertFalse(user.checkStringsWithString(string), "check string with space")
    }
    
    func testCheckStringsWithEmptyString() {
        let user: UAUser = UAUser()
        let str = ""
        XCTAssertFalse(user.checkStringsWithString(str), "check empty string")
    }

}
