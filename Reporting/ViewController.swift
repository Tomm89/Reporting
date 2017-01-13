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

    var dateArray: [String] = []
    var productArray: [Product] = []
    
    var newArray: [Product] = []
    
    var rootRef: FIRDatabaseReference!
    //var items: [String] = ["Hodnocení 1", "Hodnocení 2", "Hodnocení 3"]
    let textCellIdentifier = "tablecell"
    
        var days = [String]()

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
        datePickerView.addTarget(self, action: #selector(ViewController.timePickerValueChanged), for: UIControlEvents.valueChanged)
        
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
    
    
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var rattingTable: UITableView!
    @IBOutlet weak var textTest: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRApp.configure()
        rootRef = FIRDatabase.database().reference()
        rattingTable.delegate = self
        
        days = ["PO","UT","ST","ČT","PA","SO","NE"]
        let dollars = [1453.0,2352,5431,1442,5451,6486,1173,5678,9234,1345,9411,2212]
    
        
        setChartData(days: days, values: dollars)

        
        rootRef.observe(.value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            for item in value! {
                    
                self.productArray.append(Product(ratting: item.value as! String, timeStamp:item.key as! String))
                
                for x in self.productArray {
                    let time = Double(x.getTimeStamp())
                    
                    self.dateArray.append(String(describing: Date(timeIntervalSince1970: (time!/1000))))
                   
                    var date = String(describing: Date(timeIntervalSince1970: (time!/1000)))
                    let range = date.index(date.endIndex, offsetBy: -15)..<date.endIndex
                    date.removeSubrange(range)
                    self.rattingTable.reloadData()
                }
            }
         })
    }
    
    
    func setChartData(days : [String], values: [Double]) {

        
        var yVals1 : [ChartDataEntry] = []
        
        for i in 0 ..< days.count {
            yVals1.append(ChartDataEntry(x: Double(i), y: values[i]))

        }
        
        // 2 - create a data set with our array
        let set1: LineChartDataSet = LineChartDataSet(values: yVals1, label: "Hodnocení")
        //let lineChartData = LineChartData(xVals: days, dataSet: LineChartDataSet)
        lineChart.animate(xAxisDuration: 2.0)
        set1.axisDependency = .left // Line will correlate with left axis values
        set1.setColor(UIColor.red.withAlphaComponent(0.5)) // our line's opacity is 50%
        set1.setCircleColor(UIColor.red) // our circle will be dark red
        set1.lineWidth = 2.0
        set1.circleRadius = 6.0 // the radius of the node circle
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor.red
        set1.highlightColor = UIColor.white
        set1.drawCircleHoleEnabled = true
        
        //3 - create an array to store our LineChartDataSets
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        
        //4 - pass our months in for our x-axis label value along with our dataSets
        let data: LineChartData = LineChartData(dataSets: dataSets)
        data.setValueTextColor(UIColor.black)
        
        //5 - finally set our data
        self.lineChart.data = data
        lineChart.notifyDataSetChanged()
        
        
    }
    
    func pickRattingForChart (date: Double) {
        
        //let timestamp = NSDate().timeIntervalSince1970
        //print(timestamp)
        
        let datePlus = date + 24*3600
        
        for x in self.productArray {

            
            if let timeUn = Double(x.getTimeStamp()) {
                if timeUn/1000 > date && timeUn/1000 < datePlus {
                    self.dateArray.append(String(describing: Date(timeIntervalSince1970: (timeUn/1000))))
                    
                }
            }
        }
        
    }

    
    func datePickerValueChanged(sender:UIDatePicker) {
    let  date = sender.date.timeIntervalSince1970
        pickRattingForChart(date: date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        textField.text = dateFormatter.string(from: sender.date)
        
    }
    
    func timePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
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

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getDayOfWeek(_ today: String)->Int {
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.dateFormat = "HH mm"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath as IndexPath)

        let time = Double(productArray[indexPath.row].timeStamp!)
        cell.textLabel?.text = productArray[indexPath.row].ratting
        cell.detailTextLabel?.text =  String(describing: Date(timeIntervalSince1970: (time!/1000)))

        
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

