//
//  Common.swift
//  DemoTestChatBot
//
//  Created by IXM on 25/07/20.
//  Copyright © 2020 IXM. All rights reserved.
//

import UIKit
import MobileCoreServices
class Common: NSObject {

    class func currentDateAgg() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let result = formatter.string(from: date)
        print(result)
        return result
    }
    
}
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
