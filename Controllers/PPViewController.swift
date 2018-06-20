//
//  PPViewController.swift
//  PracticePro
//
//  Created by Jason Crouse on 5/22/16.
//  Copyright © 2016 Jason Crouse. All rights reserved.
//

import UIKit
import CoreData

class PPViewController: UIViewController {
    
    
    override func viewDidLoad() {
        // Do any additional setup after leading the view, typically from a nib
        
        print(practiceMode)
        print(viewDidLoad)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(PPViewController.handleSwipes(_:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(PPViewController.handleSwipes(_:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(PPViewController.handleSwipes(_:)))
        downSwipe.direction = .down
        view.addGestureRecognizer(downSwipe)
        
        // Hide results view objects
        clubface.isHidden = true
        landResultSlider.isHidden = true
        peakResultSlider.isHidden = true
        heelToeSlider.isHidden = true
        fatThinSlider.isHidden = true
        clubContactButton.isHidden = true
    }
    
    // Declare array for shot memory
    var shotsList : [Shot] = []
    var shotCounter = 0
    
    // Hide the status bar
    override var prefersStatusBarHidden : Bool {
        return true
    }
    // Declare practice mode
    var practiceMode = ""
    
    // Declare Image Sets
    var shotImageTitles: [String] = [""]
    
    // Declare view objects
    @IBOutlet weak var shotImagePrev: UIImageView!
    @IBOutlet weak var shotImageNext: UIImageView!
    @IBOutlet weak var shotImageCurrent: UIImageView!
    
    @IBOutlet weak var yardsLabel: UILabel!
    @IBOutlet weak var swipeToBegin: UIImageView!
    @IBOutlet weak var shotCounterLabel: UILabel!
    
    @IBOutlet weak var landResultSlider: UISlider!
    @IBOutlet weak var peakResultSlider: UISlider!
    
    @IBOutlet weak var clubface: UIImageView!
    
    @IBOutlet weak var fatThinSlider: UISlider!{
        didSet{
            fatThinSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        }
    }
    
    @IBOutlet weak var heelToeSlider: UISlider!
    
    
    @IBAction func landResultSlider(_ sender: Any) {
        // set current shot result to Int
        let currentShot = shotsList[shotCounter-1]
        currentShot.landResult = Int(landResultSlider.value)
    }
    @IBAction func peakResultSlider(_ sender: Any) {
        // set current shot result to Int
        let currentShot = shotsList[shotCounter-1]
        currentShot.peakResult = Int(peakResultSlider.value)
    }
    
    @IBAction func heelToeSlider(_ sender: Any) {
    }
    
    @IBAction func fatThinSlider(_ sender: Any) {
    }
    
    @IBAction func clubContactButton(_ sender: Any) {
        if clubface.isHidden == true {
            clubface.isHidden = false
            fatThinSlider.isHidden = false
            heelToeSlider.isHidden = false
        } else {
            clubface.isHidden = true
            fatThinSlider.isHidden = true
            heelToeSlider.isHidden = true
        }
        
    }
    @IBOutlet weak var clubContactButton: UIButton!
    
    // Display landResultSlider
    func displayLandResultSlider() {
        landResultSlider.isHidden = false
    }
    // Display peakResultSlider
    func displayPeakResultSlider() {
        peakResultSlider.isHidden = false
    }
    
    @objc func handleSwipes(_ gesture: UISwipeGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                // Cannot go back to shot 0
                if shotCounter > 1 {
                    prev()
                    shotCounterLabel.text = String(shotCounter)
                }
                
            case UISwipeGestureRecognizerDirection.left:
                
                // Viewing the newest shot
                if shotCounter == shotsList.count {
                    next()
                    
                    // Save the shot with current peak button/slider results if it's not the first shot
                    if shotsList.count != 1 && practiceMode == GlobalVariables.practiceModes.approach || shotsList.count != 1 && practiceMode == GlobalVariables.practiceModes.driving {
                        
                        // Save the shot and result to core data
                        let currentShot = shotsList[shotCounter-1]
                        saveShot(currentShot.distance!, practiceMode: currentShot.practiceType, randomCardIndex: currentShot.randomCardNumber, peakResult: currentShot.peakResult!, landResult: currentShot.landResult!, fatThinResult: currentShot.fatThinResult!, heelToeResult: currentShot.heelToeResult!)
                        
                        // Reset the slider
                        landResultSlider.value = 0
                        peakResultSlider.value = 0
                        heelToeSlider.value = 0.5
                        fatThinSlider.value = 0.5
            
                    }
                    
                } else { // Viewing a previous shot
                    shotImageCurrent.image = UIImage(named: shotImageTitles[shotsList[shotCounter].randomCardNumber])
                    yardsLabel.text = String(clubs[shotsList[shotCounter].distance!])
                    
                }
                shotCounter += 1
                shotCounterLabel.text = String(shotCounter)
                
            case UISwipeGestureRecognizerDirection.down:
                exit()
            default:
                break
            }
        }
    }
    

    func prev() {
        shotCounter -= 1
        // declare new current shot
        let newCurrentShot = shotsList[shotCounter-1]
        
        // set labels and image
        yardsLabel.text = String(clubs[newCurrentShot.distance!])
        shotImageCurrent.image = UIImage(named: shotImageTitles[newCurrentShot.randomCardNumber])
        
    }
    
    func exit() {
        
        self.performSegue(withIdentifier: "unwindToPrev", sender: self)
    }
    
    func clearDisplays() {
        swipeToBegin.image = nil
        clubface.isHidden = true
        fatThinSlider.isHidden = true
        heelToeSlider.isHidden = true
    }
    func showDisplays() {
        displayLandResultSlider()
        displayPeakResultSlider()
        clubContactButton.isHidden = false
    }
    
    func next() {
        
        clearDisplays()
        
        // Declare needed variables
        var maxLength: Int = 0
        var minLength: Int = 0
        var unit = ""
        var distance = ""
        var dist = 0
        
        // Check practice mode and do what's needed based on that
        if practiceMode == GlobalVariables.practiceModes.putting {
            shotImageTitles = PracticeType.putting.possibleShotCardArray
            // Pick a shot between 3 and 20 feet
            maxLength = 20
            minLength = 3
            unit = "ft"
        } else if practiceMode == GlobalVariables.practiceModes.finesse {
            shotImageTitles = PracticeType.finesse.possibleShotCardArray
            maxLength = 30
            minLength = 4
            unit = "y"
        } else if practiceMode == GlobalVariables.practiceModes.wedges {
            shotImageTitles = PracticeType.wedges.possibleShotCardArray
            maxLength = 120
            minLength = 30
            unit = "y"
            
        } else if practiceMode == GlobalVariables.practiceModes.approach {
            showDisplays()
            
            // pick the long shot shapes
            shotImageTitles = PracticeType.approach.possibleShotCardArray
            
            // Pick a club
            maxLength = 12
            minLength = 0
            unit = " iron"
            
        } else if practiceMode == GlobalVariables.practiceModes.driving {
            displayLandResultSlider()
            displayPeakResultSlider()
            clubContactButton.isHidden = false
            
            shotImageTitles = PracticeType.driving.possibleShotCardArray
        }
        
        // Randomly pick a shot card to show
        let randomCardNumber = Int(arc4random_uniform(UInt32(shotImageTitles.count)))
        shotImageCurrent.image = UIImage(named: shotImageTitles[randomCardNumber])
        
        // Randomly generate and display club
        if practiceMode == GlobalVariables.practiceModes.approach {
            // Random dist
            dist = Int(arc4random_uniform(UInt32(maxLength) - UInt32(minLength))) + minLength
            
            // Update Club Selection
            yardsLabel.text = clubs[dist]
            
            // Store shot
            shotsList.append(Shot(distance: dist, randomCardNumber: randomCardNumber, practiceType: self.practiceMode, landResult: 0, peakResult: 0, heelToeResult: 0, fatThinResult: 0))
            
        }
        
        // If practiceMode == putting, short game, or wedges
        if practiceMode != GlobalVariables.practiceModes.driving && practiceMode != GlobalVariables.practiceModes.approach {
            // Random dist
            dist = Int(arc4random_uniform(UInt32(maxLength) - UInt32(minLength))) + minLength
            
            // Update yardsLabel
            distance = String(dist)
            yardsLabel.text = String(distance) + unit
            
            // Store shot
            shotsList.append(Shot(distance: dist, randomCardNumber: randomCardNumber, practiceType: self.practiceMode, landResult: nil, peakResult: nil, heelToeResult: 0, fatThinResult: 0))
            
            //I changed the below distance, landResult and Peakresult vairables to dist and 0
        } else if practiceMode == GlobalVariables.practiceModes.driving {
            // Store Shot
            shotsList.append(Shot(distance: dist, randomCardNumber: randomCardNumber, practiceType: self.practiceMode, landResult: 0, peakResult: 0, heelToeResult: 0, fatThinResult: 0))
            
        }
        
    }
    
    func saveShot(_ club: Int, practiceMode: String, randomCardIndex: Int, peakResult: Int, landResult: Int, fatThinResult: Int, heelToeResult: Int){
        // 1
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        // 2
        let entity = NSEntityDescription.entity(forEntityName: "Shot", in: managedContext)
        let shot = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        // 3  
        shot.setValue(club, forKey: "club")
        shot.setValue(practiceMode, forKey: "practiceMode")
        shot.setValue(randomCardIndex, forKey: "randomCardIndex")
        shot.setValue(peakResult, forKey: "peakResult")
        shot.setValue(landResult, forKey: "landResult")
        shot.setValue(fatThinResult, forKey: "fatThinResult")
        shot.setValue(heelToeResult, forKey: "heelToeResult")
        
        // 4
        
        do {
            try managedContext.save()
            
            shotsListCoreData.append(shot)
        } catch let error as NSError {
            print("could not save \(error), \(error.userInfo)")
        }
        
    }
    
}
