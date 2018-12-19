//
//  TestViewController.swift
//  BottomDrawer_Example
//
//  Created by Sagaya Abdulhafeez on 19/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import BottomDrawer

class TestViewController: BottomController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .green
    }
}
