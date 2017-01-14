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
    var newDays = Array(repeating:[Product](),count:7)
    var newChart = Array(repeating: Array(repeating:Int(),count:4),count:7)
    var productArray: [Product] = []

    var newArray: [Product] = []
    
    var rootRef: FIRDatabaseReference!
    let textCellIdentifier = "tablecell"
    var date: Double!
    
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
    
       
        
        setChartData(date: days, values: dollars)

        
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
    
    
    func setChartData(date : [String], values: [Double]) {
        for root in 0...6 {
            for child in 0..<newDays[root].count {
                let x = Int(newDays[root][child].ratting!)
                
                newChart[root][x!] = newChart[root][x!] + 1
                
                
            }
        }
        
        var yVals1 : [ChartDataEntry] = []
        
        for i in 0 ..< days.count {
            yVals1.append(ChartDataEntry(x: Double(i), y: Double(newChart[i][0])))

        }
        
        // 2 - create a data set with our array
        let set1: LineChartDataSet = LineChartDataSet(values: yVals1, label: "Hodnocení")
        //let lineChartData = LineChartData(xVals: days, dataSet: LineChartDataSet)
        lineChart.animate(xAxisDuration: 2.0)
        set1.axisDependency = .left // Line will correlate with left axis values
        set1.setColor(UIColor.red.withAlphaComponent(0.5)) // our line's opacity is 50%
        set1.setCircleColor(UIColor.red) // our circle will be dark red
        set1.lineWidth = 4.0
        set1.circleRadius = 6.0 // the radius of the node circle
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor.red
        set1.highlightColor = UIColor.white
        set1.drawCircleHoleEnabled = true
        
        var yVals2 : [ChartDataEntry] = []
        for i in 0 ..< days.count {
            yVals2.append(ChartDataEntry(x: Double(i), y: Double(newChart[i][1])))
            
        }
        //3 - create an array to store our LineChartDataSets
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
       
        let set2: LineChartDataSet = LineChartDataSet(values: yVals2, label: "Hodnocení2")
        //let lineChartData = LineChartData(xVals: days, dataSet: LineChartDataSet)
        lineChart.animate(xAxisDuration: 2.0)
        set2.axisDependency = .left // Line will correlate with left axis values
        set2.setColor(UIColor.blue.withAlphaComponent(0.5)) // our line's opacity is 50%
        set2.setCircleColor(UIColor.blue) // our circle will be dark red
        set2.lineWidth = 4.0
        set2.circleRadius = 6.0 // the radius of the node circle
        set2.fillAlpha = 65 / 255.0
        set2.fillColor = UIColor.blue
        set2.highlightColor = UIColor.white
        set2.drawCircleHoleEnabled = true
        
        dataSets.append(set2)
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
       
       // let datePlus = date + 3*24*3600
       // let dateMinus = date - 3*24*3600
        for x in self.productArray {

            
            if let timeUn = Double(x.getTimeStamp()) {
             //   if timeUn/1000 > dateMinus && timeUn/1000 < datePlus {
               //     self.dateArray.append(String(describing: Date(timeIntervalSince1970: (timeUn/1000))))
                
               // }
                var plus:Double
                var minus:Double
                for index in 0...6 {
                    plus = Double((index - 4)*24*3600)
                    minus = Double((index - 3)*24*3600)
                    if timeUn/1000 > date+plus && timeUn/1000 < date+minus {
                        newDays[index].append(x)
                        
                    }
                }
                
                days = ["PO","UT","ST","ČT","PA","SO","NE"]
                let dollars = [1453.0,2352,5431,1442,5451,6486,1173,5678,9234,1345,9411,2212]
                
                setChartData(date: days, values: dollars)
                

                /*
                if timeUn/1000 > date-4*24*3600 && timeUn/1000 < date-3*24*3600 {
                    newDays[0].append(x)
                    
                }
                if timeUn/1000 > date-3*24*3600 && timeUn/1000 < date-2*24*3600 {
                    newDays[1].append(x)
                    
                }
                
                if timeUn/1000 > date-2*24*3600 && timeUn/1000 < date-1*24*3600 {
                   newDays[2].append(x)
                
                }
                
                if timeUn/1000 > date-1*24*3600 && timeUn/1000 < date {
                    newDays[3].append(x)
                    
                }
                
                if timeUn/1000 > date && timeUn/1000 < date + 1*24*3600 {
                    newDays[4].append(x)
                    
                }
                
                if timeUn/1000 > date + 1*24*3600 && timeUn/1000 < date+2*24*3600 {
                    newDays[5].append(x)
                    
                }
                
                if timeUn/1000 > date+2*24*3600 && timeUn/1000 < date+3*24*3600 {
                    newDays[6].append(x)
                    
                }
                
                if timeUn/1000 > date+3*24*3600 && timeUn/1000 < date+4*24*3600 {
                    newDays[6].append(x)
                    
                } */
            }
        }
    }

    
    func datePickerValueChanged(sender:UIDatePicker) {
    date = sender.date.timeIntervalSince1970
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        textField.text = dateFormatter.string(from: sender.date)
        
        for index in 0...6 {
            self.newDays[index].removeAll()
        }
        
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
        self.dateArray.removeAll()
        pickRattingForChart(date: date)
        textField.resignFirstResponder()
        textField2.resignFirstResponder()
        self.rattingTable.reloadData()
        
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
            newDays[3].remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newDays[3].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath as IndexPath)

        let time = Double(newDays[3][indexPath.row].timeStamp!)
        cell.textLabel?.text = newDays[3][indexPath.row].ratting
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

