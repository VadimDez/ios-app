//
//  EditorDelegate.swift
//  UnserAller
//
//  Created by Vadim Dez on 01/02/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import Foundation

protocol UAEditorDelegate {
    func passTextBack(controller: UAEditorViewController, string: String)
}