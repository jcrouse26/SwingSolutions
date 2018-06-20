//
//  StatsViewController.swift
//  PracticePro
//
//  Created by Jason Crouse on 5/22/16.
//  Copyright © 2016 Jason Crouse. All rights reserved.
//

import UIKit
import CoreData



class StatsViewController: UIViewController {
    
    // Declare view objects
    @IBOutlet weak var peakResultsAvgSlider: UISlider!
    @IBOutlet weak var landResultsAvgSlider: UISlider!
    
    @IBOutlet weak var wideLeft: UILabel!
    @IBOutlet weak var left: UILabel!
    @IBOutlet weak var target: UILabel!
    @IBOutlet weak var right: UILabel!
    @IBOutlet weak var wideRight: UILabel!
    
    @IBOutlet weak var fadesLabel: UILabel!
    @IBOutlet weak var straightLabel: UILabel!
    @IBOutlet weak var drawsLabel: UILabel!
    
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Variables for averages
    var shotCount = 0
    var landCount = 0
    var peakCount = 0
    
    // curves
    var absCurve = 0
    var trueCurve = 0
    
    // curves - count
    var drawsCount = 0
    var fadesCount = 0
    
    // results - land count
    var straightCount = 0
    var wideLeftCount = 0
    var leftCount = 0
    var targetCount = 0
    var rightCount = 0
    var wideRightCount = 0
    
    var landResult = 0
    var peakResult = 0
    
    
    // Function to turn button press into displaying only relevant data
    // do the same as the view will appear
    
    func resetCounters() {
        drawsCount = 0
        straightCount = 0
        fadesCount = 0
        shotCount = 0
        
        // Results Buckets
        wideLeftCount = 0
        leftCount = 0
        targetCount = 0
        rightCount = 0
        wideRightCount = 0
        
        // Peak/Land Counts
        peakCount = 0
        targetCount = 0
        landCount = 0
    }
    
    func bucketLandResult(landResult: Int) {
        
        if landResult < -60 {
            wideLeftCount += 1
        } else if landResult < -20 {
            leftCount += 1
        } else if landResult < 21 {
            targetCount += 1
        } else if landResult < 61 {
            rightCount += 1
        } else if landResult <= 100 {
            wideRightCount += 1
        }
        
    }
    
    func convertToPercentage(count: Int, total: Int) -> String {
        return String(count*100/total) + "%"
    }
    
    func setLabelsForLandResults(count: Int) {
        
        wideLeft.text = convertToPercentage(count: wideLeftCount, total: count)
        left.text = convertToPercentage(count: leftCount, total: count)
        target.text = convertToPercentage(count: targetCount, total: count)
        right.text = convertToPercentage(count: rightCount, total: count)
        wideRight.text = convertToPercentage(count: wideRightCount, total: count)
    }
    
    func classifyAndCountShotShape(peakResult:Int, landResult:Int) {
        if peakResult > landResult {
            drawsCount += 1
        } else if landResult > peakResult {
            fadesCount += 1
        } else if landResult == peakResult {
            straightCount += 1
        }
    }
    
    func setSliders(count: Int) {
        
        peakResultsAvgSlider.value = Float(peakCount/count)
        landResultsAvgSlider.value = Float(landCount/count)
        
    }
    
    func addToCountsAndBucketResults() {
        peakCount += peakResult
        landCount += landResult
        bucketLandResult(landResult: landResult)
    }
    func addToCounts(peakResult: Int, landResult: Int) {
        peakCount += peakResult
        landCount += landResult
    }
    
    
    func coreDataLoad() {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shot")
        
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            shotsListCoreData = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    @IBAction func fadesButton(_ sender: Any) {
        
        resetCounters()
        coreDataLoad()
        
        for Shot in shotsListCoreData {
            peakResult = Shot.value(forKey: "peakResult") as! Int
            landResult = Shot.value(forKey: "landResult") as! Int
            
            // Determine if it's a fade
            if peakResult < landResult {
                fadesCount += 1
                addToCountsAndBucketResults()
            }
        }
        if fadesCount > 0 {
            setLabelsForLandResults(count: fadesCount)
            setSliders(count: fadesCount)
        }
        
    }
    
    
    @IBAction func drawsButton(_ sender: Any) {
        resetCounters()
        coreDataLoad()
        
        for Shot in shotsListCoreData {
            peakResult = Shot.value(forKey: "peakResult") as! Int
            landResult = Shot.value(forKey: "landResult") as! Int
            
            // Determine if it's a draw
            if peakResult > landResult {
                drawsCount += 1
                addToCountsAndBucketResults()
            }
        }
        if drawsCount > 0 {
            setSliders(count:drawsCount)
            setLabelsForLandResults(count:drawsCount)
        }
        
    }
    
    func displayResultsForClub(clubNumbers: [Int]) {
        resetCounters()
        coreDataLoad()
        
        for Shot in shotsListCoreData {
            peakResult = Shot.value(forKey: "peakResult") as! Int
            landResult = Shot.value(forKey: "landResult") as! Int
            let club = Shot.value(forKey: "club") as! Int
            
            if clubNumbers.contains(club) {
                shotCount += 1
                classifyAndCountShotShape(peakResult: peakResult, landResult: landResult)
                bucketLandResult(landResult: landResult)
                addToCounts(peakResult: peakResult, landResult: landResult)
            }
        }
        
        if shotCount != 0 {
            setSliders(count: shotCount)
            setLabelsForLandResults(count: shotCount)
            setLabelsForCurveResults(count: shotCount)
        }
    }
    @IBOutlet weak var driverButtonLabel: UIButton!
    @IBOutlet weak var threeWoodButtonLabel: UIButton!
    @IBOutlet weak var longIronsButtonLabel: UIButton!
    @IBOutlet weak var midIronsButtonLabel: UIButton!
    @IBOutlet weak var shortIronsButtonLabel: UIButton!
    
    
    
    func setBackgroundColorForButtons() {
        driverButtonLabel.backgroundColor = UIColor.gray
        threeWoodButtonLabel.backgroundColor = UIColor.clear
        longIronsButtonLabel.backgroundColor = UIColor.clear
        midIronsButtonLabel.backgroundColor = UIColor.clear
        shortIronsButtonLabel.backgroundColor = UIColor.clear
    }
    
    @IBAction func driverButton(_ sender: Any) {
        displayResultsForClub(clubNumbers: [0])
    }
    
    @IBAction func woodButton(_ sender: Any) {
        displayResultsForClub(clubNumbers: [1])
    }
    
    @IBAction func longIronsButton(_ sender: Any) {
        displayResultsForClub(clubNumbers: [2,3,4])
    }
    
    @IBAction func midIronsButton(_ sender: Any) {
        displayResultsForClub(clubNumbers: [5,6,7])
    }

    @IBAction func shortIronsButton(_ sender: Any) {
        displayResultsForClub(clubNumbers: [8,9,10,11])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetCounters()
        coreDataLoad()
        
        for Shot in shotsListCoreData {
            peakResult = Shot.value(forKey: "peakResult") as! Int
            landResult = Shot.value(forKey: "landResult") as! Int
            
            peakCount += peakResult
            landCount += landResult
            
            classifyAndCountShotShape(peakResult: peakResult, landResult: landResult)
          
            bucketLandResult(landResult: landResult)
            setSliders(count: shotsListCoreData.count)
            setLabelsForLandResults(count: shotsListCoreData.count)
            setLabelsForCurveResults(count: shotsListCoreData.count)
        
        }
        
    }
    
    func setLabelsForCurveResults(count: Int) {
        
        fadesLabel.text = convertToPercentage(count: fadesCount, total: count)
        straightLabel.text = convertToPercentage(count: straightCount, total: count)
        drawsLabel.text = convertToPercentage(count: drawsCount, total: count)
    }
}
