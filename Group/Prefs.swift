//
//  Prefs.swift
//  Snowonder
//
//  Created by Augus on 22/10/2017.
//  Copyright © 2017 Karetski. All rights reserved.
//

import Foundation

private let userDefaults = UserDefaults(suiteName: "J4Z2NCTR3S.com.iAugus.Snowonder")!

struct Prefs {

    static var sortByStringSize: Bool {
        set {
            userDefaults.set(newValue, forKey: "kSortByStringSize")
        }
        get {
            return userDefaults.bool(forKey: "kSortByStringSize")
        }
    }
}
