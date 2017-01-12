//
//  BarChartFormatter.swift
//  
//
//  Created by tom on 12.01.17.
//
//

import Foundation
import UIKit
import Charts

@objc(LineChartFormatter)
public class LineChartFormatter: NSObject, IAxisValueFormatter
{
    var days: [String]! = ["PO", "UT", "ST", "CT", "PA", "SO", "NE"]
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String
    {
        return days[Int(value)]
    }   
}
