//
//  CustomGraphView.swift
//  Reporting
//
//  Created by tom on 12.01.17.
//  Copyright © 2017 tom. All rights reserved.
//

import UIKit
import Charts

class CustomGraphView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    public func stringForValue(_ value: Double, axis: Charts.AxisBase?) -> String
    {
        return "My X Axis Label Str";  // Return you label string, from an array perhaps.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
