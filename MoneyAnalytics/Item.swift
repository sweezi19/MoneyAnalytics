//
//  Item.swift
//  MoneyAnalytics
//
//  Created by Theo Tar on 17/05/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
