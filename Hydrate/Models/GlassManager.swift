//
//  GlassManager.swift
//  Hydrate
//
//  Created by Soumil Datta on 5/24/20.
//  Copyright © 2020 Soumil Datta. All rights reserved.
//

import Foundation
import Firebase

struct GlassManager {
    // use singleton
    static var sharedInstance = GlassManager()
    let db = Firestore.firestore()
    
    var currentGoal: Float = 8
    let glassSizes: [String] = ["4", "6", "8", "9", "10", "12", "14", "16"]
}
