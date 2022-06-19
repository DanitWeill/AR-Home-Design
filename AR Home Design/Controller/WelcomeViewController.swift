//
//  WelcomeViewController.swift
//  AR Home Design
//
//  Created by Danit on 19/06/2022.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var homeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeLabel.text = "Home Design"
//        homeLabel.font.withSize(100)
    }
}

