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
import DatePickerDialog


class ViewController: UIViewController, ChartViewDelegate, UITableViewDataSource, UITableViewDelegate {


    var productArray: [Product] = []
    var rootRef: FIRDatabaseReference!
    //var items: [String] = ["Hodnocení 1", "Hodnocení 2", "Hodnocení 3"]
    let textCellIdentifier = "tablecell"
    
    var days: [String]!
    

    @IBOutlet weak var textField: UITextField!
    
    @IBAction func textFieldEditing(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(ViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    @IBOutlet weak var textField2: UITextField!
    
    @IBAction func textFieldEditing2(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.time
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(ViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField2.inputAccessoryView = toolBar
    }
    
    
    //@IBOutlet weak var LineChart: LineChartView!
    @IBOutlet weak var rattingTable: UITableView!
    @IBOutlet weak var textTest: UITextView!
    @IBOutlet weak var barChartView: BarChartView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRApp.configure()
        rootRef = FIRDatabase.database().reference()
        rattingTable.delegate = self
        
        days = ["PO","UT","ST","ČT","PA","SO","NE"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
     /*   self.LineChart.legend.enabled = false
        self.LineChart.delegate = self
        self.LineChart.chartDescription?.text = ""
        self.LineChart.xAxis.labelPosition =  XAxis.LabelPosition.bottom       // 3
        self.LineChart.chartDescription?.textColor = UIColor.black
        self.LineChart.gridBackgroundColor = UIColor.darkGray
        self.LineChart.noDataText = "No Data"
        setChartData(dataPoints: days, values: unitsSold)  */
        
        setChart(dataPoints: days, values: unitsSold)

        
        
        rootRef.observe(.value, with: { (snapshot) in
            let newItems: [Product] = []
            
            let value = snapshot.value as? NSDictionary
            for item in value! {
                
                self.productArray.append(Product(ratting: item.value as! String, timeStamp:item.key as! String))
                
            }
            
            for x in self.productArray {
                let time = Double(x.getTimeStamp())
                
                
                var Timestamp: TimeInterval {
                    return NSDate().timeIntervalSince1970 * 1000
                    
                }
                
                var date = String(describing: Date())
                let range = date.index(date.endIndex, offsetBy: -15)..<date.endIndex
                date.removeSubrange(range)
                self.productArray = newItems
                self.rattingTable.reloadData()
                
            }
            
         })
        
        rattingTable.allowsMultipleSelectionDuringEditing = false
        
        
        
      /*  self.rootRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            
            let value = snapshot.value as? NSDictionary
            for item in value! {
                
                self.productArray.append(Product(ratting: item.value as! String, timeStamp:item.key as! String))
                
            }
            
           for x in self.productArray {
                let time = Double(x.getTimeStamp())
            
            
            var Timestamp: TimeInterval {
                return NSDate().timeIntervalSince1970 * 1000
                
            }
                
                //var date = String(describing: Date(timeIntervalSince1970: (time!/1000)))
                var date = String(describing: Date())
                let range = date.index(date.endIndex, offsetBy: -15)..<date.endIndex
                date.removeSubrange(range)
                self.textTest.text = self.textTest.text! + String(self.getDayOfWeek(date))
            }
            
        })  */
        
    }
    
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        barChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = Array()
        var counter = 0.0
        
        for i in 0..<dataPoints.count {
            counter += 1.0
            let dataEntry = BarChartDataEntry(x: values[i], y: counter)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Time")
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        barChartView.data = chartData
        
    }

    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        textField.text = dateFormatter.string(from: sender.date)
        
    }
    
    func timePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        textField2.text = dateFormatter.string(from: sender.date)
        
    }
    
    func doneClick() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        textField.resignFirstResponder()
        textField2.resignFirstResponder()
    }
    
    func cancelClick() {
        textField.resignFirstResponder()
        textField2.resignFirstResponder()
    }

    
  /*  func setChartData(dataPoints: [String], values: [Double]) {
        // 1 - creating an array of data entries
        let dollars1:[Double] = [1,2,3,4,3,2,1]
        var yVals1 = [ChartDataEntry]()
        for i in 0..<dataPoints.count {
            yVals1.append(ChartDataEntry(x: dollars1[i], y: Double(i)))
        }
        
        // 2 - create a data set with our array
        let set1 = LineChartDataSet(values: yVals1, label: "First Set")
        set1.axisDependency = .left // Line will correlate with left axis values
        set1.setColor(UIColor.red) // our line's opacity is 50%
        set1.setCircleColor(UIColor.cyan) // our circle will be dark red
        
        set1.lineWidth = 2.0
        set1.circleRadius = 6.0 // the radius of the node circle
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor.cyan
        set1.highlightColor = UIColor.black
        set1.drawCircleHoleEnabled = true
        
        //3 - create an array to store our LineChartDataSets
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        
        //4 - pass our months in for our x-axis label value along with our dataSets
        let data: LineChartData = LineChartData(dataSets: dataSets)
        data.setValueTextColor(UIColor.white)
        self.LineChart.data = data
    }  */

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getDayOfWeek(_ today: String)->Int {
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.date(from: today)
        let myCalendar = Calendar(identifier: .gregorian)
        var weekDay = myCalendar.component(.weekday, from: todayDate!)
        if(weekDay == 1){ weekDay = 7}
        else {weekDay = weekDay-1}
        return weekDay
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            productArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath as IndexPath)
        
        //let row = productArray[indexPath.row]
        cell.textLabel?.text = productArray[indexPath.row].ratting
        
        return cell
    }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let row = indexPath.row
        print(productArray[row])
    }
    
    
    @IBAction func Exit(_ sender: Any) {
        exit(0)
    }
    
    
}

