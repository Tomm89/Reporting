//
//  File.swift
//  Reporting
//
//  Created by tom on 08.01.17.
//  Copyright © 2017 tom. All rights reserved.
//

import Foundation

class Product {
    
    var timeStamp: String?
    var ratting: String?
    
    init(ratting:String, timeStamp:String){
        
        self.ratting = ratting
        self.timeStamp = timeStamp
    }
    
    func getTimeStamp() -> String{
        return self.timeStamp!
        
    }
}
