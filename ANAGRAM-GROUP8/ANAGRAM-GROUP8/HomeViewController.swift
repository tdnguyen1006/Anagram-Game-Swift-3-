//
//  HomeViewController.swift
//  ANAGRAM-GROUP8
//
//  Created by Tech on 2018-04-23.
//  Copyright © 2018 Tech. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnExit(_ sender: UIButton) {
        exit(0)
    }
}
