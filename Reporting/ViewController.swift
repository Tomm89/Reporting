//
//  ViewController.swift
//  Reporting
//
//  Created by tom on 06.01.17.
//  Copyright © 2017 tom. All rights reserved.
//

import UIKit
import Firebase
import Charts

class ViewController: UIViewController, ChartViewDelegate, UITableViewDataSource, UITableViewDelegate {


    var productArray = [Product]()
    var rootRef: FIRDatabaseReference!
    var items: [String] = ["We", "Heart", "Swift"]
    let textCellIdentifier = "tablecell"
    
    @IBOutlet weak var LineChart: LineChartView!
    var textTest = UILabel()
    
    @IBOutlet weak var rattingTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // FIRApp.configure()
       // rootRef = FIRDatabase.database().reference()
        
        self.LineChart.legend.enabled = false
        self.LineChart.delegate = self
        self.LineChart.descriptionText = ""
        self.LineChart.xAxis.labelPosition =  XAxis.LabelPosition.bottom       // 3
        self.LineChart.descriptionTextColor = UIColor.black
        self.LineChart.gridBackgroundColor = UIColor.darkGray
        self.LineChart.noDataText = "No Data"
        setChartData()
        // Do any additional setup after loading the view, typically from a nib.
      /*  self.rootRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            for var item in value! {
                
                self.productArray.append(Product(ratting: item.value as! String, timeStamp:item.key as! String))
                
            }
            
            for x in self.productArray {
                let time = Double(x.getTimeStamp())
                
                var date = String(describing: Date(timeIntervalSince1970: (time!/1000)))
                let range = date.index(date.endIndex, offsetBy: -15)..<date.endIndex
                date.removeSubrange(range)
                self.textTest.text = self.textTest.text! + String(self.getDayOfWeek(date))
                
            }
        }) */

    }
    
    func setChartData() {
        // 1 - creating an array of data entries
        let dollars1:[Double] = [1,2,3,4,3,2,1]
        let days:[String] = ["PO","UT","ST","ČT","PA","SO","NE"]
        var yVals1 = [ChartDataEntry]()
        for i in 0 ..< 7 {
            yVals1.append(ChartDataEntry(x: dollars1[i], y: Double(i)))
        }
        
        // 2 - create a data set with our array
        let set1 = LineChartDataSet(values: yVals1, label: "First Set")
        set1.axisDependency = .left // Line will correlate with left axis values
        set1.setColor(UIColor.red) // our line's opacity is 50%
        set1.setCircleColor(UIColor.cyan) // our circle will be dark red
        
        //set1.lineWidth = 2.0
        //set1.circleRadius = 6.0 // the radius of the node circle
        //set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor.cyan
        set1.highlightColor = UIColor.black
        set1.drawCircleHoleEnabled = true
        
        //3 - create an array to store our LineChartDataSets
        var dataSets = [LineChartDataSet]()
        dataSets.append(set1)
        
        //4 - pass our months in for our x-axis label value along with our dataSets
       // let data: LineChartData = LineChartData(xVals: days,dataSets: dataSets)
        let data: LineChartData = LineChartData(dataSets: dataSets)
        
        data.setValueTextColor(UIColor.black)
        self.LineChart.data = data
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getDayOfWeek(_ today: String)->Int {
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.date(from: today)!
        let myCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let myComponents = myCalendar.dateComponents([.day, .month], from: todayDate)
        var weekDay = myComponents.weekday
        if(weekDay == 1){ weekDay = 7}
        else {weekDay = weekDay!-1}
        return weekDay!
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath as IndexPath)
        //let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: IndexPath())
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath as IndexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = items[row]
        
        return cell
    }
    

}

