//
//  ChartStringFormatter.swift
//  
//
//  Created by tom on 12.01.17.
//
//

import UIKit

class ChartStringFormatter: NSObject {
    
    var nameValues: [String]! =  ["A", "B", "C", "D"]
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return String(describing: nameValues[Int(value)])
    }

}
