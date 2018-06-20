//
//  ViewController.swift
//  PracticePro
//
//  Created by Jason Crouse on 4/28/16.
//  Copyright © 2016 Jason Crouse. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "iPhone 6 Copy")
        self.view.insertSubview(backgroundImage, at: 0)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

