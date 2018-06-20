//
//  ShotCard.swift
//  PracticePro
//
//  Created by Jason Crouse on 5/29/16.
//  Copyright © 2016 Jason Crouse. All rights reserved.
//

import UIKit

class Shot: NSObject {
    
    static var numberOfShots = 0
    
    // Properties
    var randomCardNumber : Int
    var distance : Int? = nil
    var practiceType : String
    var landResult : Int? = nil
    var peakResult : Int? = nil
    var heelToeResult : Int? = nil
    var fatThinResult : Int? = nil
    
    
    // Initializer
    init(distance: Int?, randomCardNumber: Int, practiceType: String, landResult: Int?, peakResult: Int?, heelToeResult: Int?, fatThinResult: Int?) {
        self.distance = distance
        self.practiceType = practiceType
        self.randomCardNumber = randomCardNumber
        self.landResult = landResult
        self.peakResult = peakResult
        self.heelToeResult = heelToeResult
        self.fatThinResult = fatThinResult
        
        Shot.numberOfShots += 1
    }
}
