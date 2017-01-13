//
//  MyTableViewCell.swift
//  Reporting
//
//  Created by tom on 13.01.17.
//  Copyright © 2017 tom. All rights reserved.
//

import UIKit
import Charts

class MyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    var days: Array<String>?
    var ratting: Array<Float>?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
