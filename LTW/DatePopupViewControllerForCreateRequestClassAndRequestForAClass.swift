// DatePopupViewControllerForCreateRequestClassAndRequestForAClass.swift
//  LTW
//  Created by Ranjeet Raushan on 17/03/20.
//  Copyright © 2020 vaayoo. All rights reserved.

import Foundation
import UIKit
import SwiftMessages

class DatePopupViewControllerForCreateRequestClassAndRequestForAClass: UIViewController {
    
    
   
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveBtn: UIButton!
    
    var showTimePicker:Bool = false
    var actionName: String?
    var toTimeSelected : Bool = false
    
    var selectedFromDate: Date?; var selectedToDate: Date?
    var isFromDateBtnClicked: Bool?; var isToBtnClicked:Bool?
    var productExpiryDate: Date?
    var onSave:((_ data:Date) ->())?
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: datePicker.date)
    }
    var formattedTime: String {
        get {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: datePicker.date)
        }
    }
    var selectedClassDate: Date?
    override func viewDidLoad() {
        super.viewDidLoad()
        if showTimePicker {
            let calendar = Calendar(identifier: .gregorian)
            var comps = DateComponents()
            var maxDate: Date?; var minDate: Date?;var currentDate: Date?
            titlelabel.text = "Select Time"
            datePicker.datePickerMode = .time
            datePicker.locale = Locale(identifier: "en_GB")
            saveBtn.setTitle("Save Time", for: .normal)
            if selectedClassDate != nil {
                /*Added by yasodha on 16th April 2020 - starts here */
                //For automatic to time selection 45 min
                
      /*******************************Commented by yasodha on 24/4/2020********************************/
                
//                 comps.minute = 0
//                 minDate = calendar.date(byAdding: comps, to:selectedClassDate!)
//                 datePicker.minimumDate = minDate
//                 if toTimeSelected == true{
//                     comps.minute = 45 // past dates are not allowed and 5 mintues ahead
//                     toTimeSelected = false
//                 }
//                 currentDate = calendar.date(byAdding: comps, to:selectedClassDate!)
//                 datePicker.date = currentDate!
//
    /*********************************Commented by yasodha on 24/4/2020**************************************/
              

                let order = NSCalendar.current.compare(selectedClassDate!, to: Date(), toGranularity: .day)
                let distanceBetweenDates: TimeInterval? = selectedClassDate!.timeIntervalSince(Date())


                let minBetweenDates = Int((distanceBetweenDates! / 60 ))//minsInAnHour
                  
              //  let order = NSCalendar.current.compare(selectedClassDate!, to: Date(), toGranularity: .day)

                if order == .orderedAscending {
                    // date 1 is older
                    datePicker.minimumDate = selectedClassDate!
                }
                else if order == .orderedDescending {
                    // date 1 is newer
                    /*Added by yasodha on 24/4/2020 starts here */
                    comps.minute = 5 // past dates are not allowed and 5 mintues ahead
                    datePicker.minimumDate = minDate
                    if toTimeSelected == true{
                    comps.minute = 45 // past dates are not allowed and 5 mintues ahead
                    toTimeSelected = false
                    }

                    if minBetweenDates < 0 {//Current time is Grater than selected time
                    minDate = calendar.date(byAdding: comps, to:Date())
                    currentDate = calendar.date(byAdding: comps, to:Date())
                    }else{
                    minDate = calendar.date(byAdding: comps, to:selectedClassDate!)
                    currentDate = calendar.date(byAdding: comps, to:selectedClassDate!)
                    }
                    //minDate = calendar.date(byAdding: comps, to:selectedClassDate!)
                    //currentDate = calendar.date(byAdding: comps, to:selectedClassDate!)
                    datePicker.date = currentDate!
                    /*Added by yasodha 24/4/2020 ends here */
                    
                }
                else if order == .orderedSame {
                    
                  // same day/hour depending on granularity parameter

                    // comps.minute = 5 // past dates are not allowed and 5 mintues ahead
                    // minDate = calendar.date(byAdding: comps, to: Date())
                    // datePicker.minimumDate = minDate

                    /*Added by yasodha on 24/4/2020 starts here */
                    comps.minute = 5 // past dates are not allowed and 5 mintues ahead
                    datePicker.minimumDate = selectedClassDate
                    if toTimeSelected == true{
                    comps.minute = 45 // past dates are not allowed and 5 mintues ahead
                    toTimeSelected = false
                    }

                    if minBetweenDates < 0 {//Current time is Grater than selected time
                    minDate = calendar.date(byAdding: comps, to:Date())
                    currentDate = calendar.date(byAdding: comps, to:Date())
                    }else{
                    minDate = calendar.date(byAdding: comps, to:selectedClassDate!)
                    currentDate = calendar.date(byAdding: comps, to:selectedClassDate!)
                    }
                    //minDate = calendar.date(byAdding: comps, to:selectedClassDate!)
                    //currentDate = calendar.date(byAdding: comps, to:selectedClassDate!)
                    datePicker.date = currentDate!
                    /*Added by yasodha 24/4/2020 ends here */
                    
               }
                
           }
            
        }else{
            let calendar = Calendar(identifier: .gregorian)
            var comps = DateComponents()
            var maxDate: Date?; var minDate: Date?
            if actionName == "AddingProductDate" {
                if isFromDateBtnClicked! {
                    if selectedToDate == nil {
                        comps.year = 0// past dates are not allowed
                        minDate = calendar.date(byAdding: comps, to: Date())
                        datePicker.minimumDate = minDate
                        
                        comps.year = 50// Upto 50 yrs in future
                        maxDate = calendar.date(byAdding: comps, to: Date())
                        datePicker.maximumDate = maxDate
                    } else {
                        
                        comps.year = 0// past dates are not allowed
                        minDate = calendar.date(byAdding: comps, to: Date())
                        datePicker.minimumDate = minDate
                        
                        comps.day = -1
                        maxDate = calendar.date(byAdding: comps, to: selectedToDate!)
                        datePicker.maximumDate = maxDate
                    }
                    if selectedFromDate != nil {
                        datePicker.setDate(selectedFromDate!, animated: true)
                    }
                    
                }else if isToBtnClicked! {
                    
                    if selectedFromDate == nil {
                        comps.year = 0// past dates are not allowed
                        minDate = calendar.date(byAdding: comps, to: Date())
                        datePicker.minimumDate = minDate
                        
                        comps.year = 50// Upto 50 yrs in future
                        maxDate = calendar.date(byAdding: comps, to: Date())
                        datePicker.maximumDate = maxDate
                        
                    } else {
                        // datePicker.minimumDate = selectedFromDate
                        comps.day = +1// past dates are not allowed
                        minDate = calendar.date(byAdding: comps, to: selectedFromDate!)
                        datePicker.minimumDate = minDate
                        
                        
                        comps.year = 50// Upto 50 yrs in future // can be restricted based on selected from date
                        maxDate = calendar.date(byAdding: comps, to: Date())
                        datePicker.maximumDate = maxDate
                    }
                    
                    if selectedToDate != nil {
                        datePicker.setDate(selectedToDate!, animated: true)
                    }
                    
                }
            } else if actionName == "dateOfBirth" {
                comps.year = -16//30 // Person must be atlest 15 yr old
                maxDate = calendar.date(byAdding: comps, to: Date())
                datePicker.setDate(maxDate!, animated: true)
            }
            else if actionName == "rentingProduct" {
                if isFromDateBtnClicked! {
                    if selectedToDate == nil {
                        comps.year = 0// past dates are not allowed
                        minDate = calendar.date(byAdding: comps, to: Date())
                        datePicker.minimumDate = minDate
                        
                        comps.day = -1// 1 day before the expiry date
                        maxDate = calendar.date(byAdding: comps, to: productExpiryDate!)
                        datePicker.maximumDate = maxDate
                    } else {
                        
                        comps.year = 0// past dates are not allowed
                        minDate = calendar.date(byAdding: comps, to: Date())
                        datePicker.minimumDate = minDate
                        
                        comps.day = -1
                        maxDate = calendar.date(byAdding: comps, to: selectedToDate!)
                        datePicker.maximumDate = maxDate
                    }
                    if selectedFromDate != nil {
                        datePicker.setDate(selectedFromDate!, animated: true)
                    }
                    
                }else if isToBtnClicked! {
                    
                    if selectedFromDate == nil {
                        comps.year = 0// past dates are not allowed
                        minDate = calendar.date(byAdding: comps, to: Date())
                        datePicker.minimumDate = minDate
                        
                        // comps.year = 50// Upto 50 yrs in future
                        // maxDate = calendar.date(byAdding: comps, to: Date())
                        datePicker.maximumDate = productExpiryDate
                        
                    } else {
                        // datePicker.minimumDate = selectedFromDate
                        comps.day = +1// past dates are not allowed
                        minDate = calendar.date(byAdding: comps, to: selectedFromDate!)
                        datePicker.minimumDate = minDate
                        
                        
                        // comps.year = 50// Upto 50 yrs in future
                        // maxDate = calendar.date(byAdding: comps, to: Date())
                        datePicker.maximumDate = productExpiryDate
                    }
                    
                    if selectedToDate != nil {
                        datePicker.setDate(selectedToDate!, animated: true)
                    }
                    
                }
                
            }else if actionName == "testStartDate" {
                comps.year = 0// past dates are not allowed
                minDate = calendar.date(byAdding: comps, to: Date())
                datePicker.minimumDate = minDate
                
                comps.year = 10// Upto 50 yrs in future
                maxDate = calendar.date(byAdding: comps, to: Date())
                datePicker.maximumDate = maxDate
                
            }
            
        }
        
    }

    @IBAction func onSaveBtnClick(_ sender: Any) {
        if showTimePicker {
            onSave?(datePicker.date)
            dismiss(animated: true, completion: nil)
        }else {
            //onSave?(formattedDate)
            print("Selected Date = \(datePicker.date)")
            onSave?(datePicker.date)
            dismiss(animated: true)
        }
    }
    @IBAction func onCloseBtnClick(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dismiss(animated: true)
    }
}

