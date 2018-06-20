//
//  PracticeType.swift
//  PracticePro
//
//  Created by Jason Crouse on 9/11/16.
//  Copyright © 2016 Jason Crouse. All rights reserved.
//

import UIKit

struct PracticeType {
    
    struct putting {
        static let possibleShotCardArray = [PuttCards.putt1, PuttCards.putt2, PuttCards.putt3, PuttCards.putt4, PuttCards.putt5, PuttCards.putt6, PuttCards.putt7, PuttCards.putt8, PuttCards.putt9, PuttCards.putt10, PuttCards.putt11, PuttCards.putt12]
    }
    struct finesse {
        static let possibleShotCardArray = [GlobalVariables.ShotCards.bunker, GlobalVariables.ShotCards.fairwayHigh, GlobalVariables.ShotCards.fairwayLow, GlobalVariables.ShotCards.fairwayMed, GlobalVariables.ShotCards.roughLow, GlobalVariables.ShotCards.roughMed, GlobalVariables.ShotCards.roughHigh]
    }
    struct wedges {
        static let possibleShotCardArray = ["High Draw Card", "High Fade Card", "Low Draw Card", "Low Fade Card"]
    }
    struct approach {
        static let possibleShotCardArray = ["High Draw Card", "High Fade Card", "Low Draw Card", "Low Fade Card"]
    }
    struct driving {
        static let possibleShotCardArray = ["High Draw Card", "High Fade Card", "Low Draw Card", "Low Fade Card"]
    }


}