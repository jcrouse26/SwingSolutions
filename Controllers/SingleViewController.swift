//
//  SingleViewController.swift
//  PracticePro
//
//  Created by Jason Crouse on 5/22/16.
//  Copyright © 2016 Jason Crouse. All rights reserved.
//

import UIKit

class SingleViewController: UIViewController {
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @IBAction func unwind(_ segue:UIStoryboardSegue) {
        
    }
    
    var currentPracticeMode = ""

    @IBAction func putting(_ sender: AnyObject) {
        currentPracticeMode = GlobalVariables.practiceModes.putting
        self.performSegue(withIdentifier: "manualSegue", sender: sender)
    }
    
    @IBAction func finesse(_ sender: AnyObject) {
        currentPracticeMode = GlobalVariables.practiceModes.finesse
        self.performSegue(withIdentifier: "manualSegue", sender: sender)
    }
    
    @IBAction func wedges(_ sender: AnyObject) {
        currentPracticeMode = GlobalVariables.practiceModes.wedges
        self.performSegue(withIdentifier: "manualSegue", sender: sender)
    }
    
    @IBAction func approach(_ sender: AnyObject) {
        currentPracticeMode = GlobalVariables.practiceModes.approach
        self.performSegue(withIdentifier: "manualSegue", sender: sender)
    }
    
    @IBAction func driving(_ sender: AnyObject) {
        currentPracticeMode = GlobalVariables.practiceModes.driving
        self.performSegue(withIdentifier: "manualSegue", sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? PPViewController {
            nextViewController.practiceMode = currentPracticeMode
            print(nextViewController.practiceMode)
        }
    }
    
}
