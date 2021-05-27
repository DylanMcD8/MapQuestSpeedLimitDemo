//
//  ViewController.swift
//  MQSpeedLimitTest
//
//  Created by Dylan McDonald on 5/27/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var speedLimitLabel: UILabel!
    @IBOutlet weak var SLLTrailing: NSLayoutConstraint!
    @IBOutlet weak var SLLLeading: NSLayoutConstraint!
    @IBOutlet weak var SLLBottom: NSLayoutConstraint!
    @IBOutlet weak var SLLHeight: NSLayoutConstraint!
    
    override func viewDidAppear(_ animated: Bool) {
        let totalScale = ((mainImage.bounds.width / 326) + (mainImage.bounds.height / 407)) / 2
        
        SLLLeading.constant = 70 * (mainImage.bounds.width / 326)
        SLLTrailing.constant = 70 * (mainImage.bounds.width / 326)
        SLLBottom.constant = 235 * (mainImage.bounds.height / 407)
        SLLHeight.constant = 182 * (mainImage.bounds.height / 407)
        
        speedLimitLabel.font = speedLimitLabel.font.withSize(190 * totalScale)
    }

}

