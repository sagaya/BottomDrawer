//
//  ViewController.swift
//  BottomDrawer
//
//  Created by sagaya on 12/19/2018.
//  Copyright (c) 2018 sagaya. All rights reserved.
//

import UIKit
import BottomDrawer

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func showBottom(_ sender: Any) {
        let request = self.storyboard?.instantiateViewController(withIdentifier: "test") as? TestViewController
        let v = BottomController()
        request?.view.backgroundColor = .red
        v.destinationController = request
        v.sourceController = self
        v.startingHeight = 200
        v.cornerRadius = 10
        v.modalPresentationStyle = .overCurrentContext
        self.present(v, animated: true, completion: nil)
    }
    
}

