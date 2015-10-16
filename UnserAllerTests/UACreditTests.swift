//
//  UACredit.swift
//  UnserAller
//
//  Created by Vadim Dez on 16/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit
import XCTest

class UACreditTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInstansiate() {
        let credit: UACredit = UACredit()
        XCTAssert(((credit as Any) is UACredit), "Check if instansiated")
    }

}
