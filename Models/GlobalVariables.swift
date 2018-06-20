//
//  GlobalVariables.swift
//  PracticePro
//
//  Created by Jason Crouse on 6/5/16.
//  Copyright © 2016 Jason Crouse. All rights reserved.
//

import UIKit
import CoreData

struct GlobalVariables {
    struct practiceModes {
        static let putting = "putting"
        static let finesse = "short game"
        static let wedges = "wedges"
        static let approach = "approach"
        static let driving = "driving"
    }
    struct ShotCards {
        
        // finesse
        static let fairwayHigh = "Fairway SG Card High"
        static let fairwayMed = "Fairway SG Card Med"
        static let fairwayLow = "Fairway SG Card Low"
        static let roughHigh = "Rough SG Card High"
        static let roughMed = "Rough SG Card Med"
        static let roughLow = "Rough SG Card Low"
        static let bunker = "Bunker SG Card"

    }
    
}
struct PuttCards {
    static let putt1 = "Putting 1"
    static let putt2 = "Putting 2"
    static let putt3 = "Putting 3"
    static let putt4 = "Putting 4"
    static let putt5 = "Putting 5"
    static let putt6 = "Putting 6"
    static let putt7 = "Putting 7"
    static let putt8 = "Putting 8"
    static let putt9 = "Putting 9"
    static let putt10 = "Putting 10"
    static let putt11 = "Putting 11"
    static let putt12 = "Putting 12"
    
}

var shotsListCoreData = [NSManagedObject]()

let clubs = ["1w", "3w", "3i", "4i", "5i", "6i", "7i", "8i", "9i", "pw", "gw", "sw", "lw"]


// Global Methods


