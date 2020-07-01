// DatePopupViewController.swift
// MyStuffRental
// Created by manjunath Hindupur on 13/11/18.
// Copyright © 2018 Vaayoo. All rights reserved.

import UIKit
import SwiftMessages

class DatePopupViewController: UIViewController {
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveBtn: UIButton!
    
    var showTimePicker:Bool = false
    var actionName: String?
    
    var selectedFromDate: Date?; var selectedToDate: Date?
    var isFromDateBtnClicked: Bool?; var isToBtnClicked:Bool?
    var productExpiryDate: Date?
    // var rentingMinDate: Date?; var rentingMaxDate: Date?
    //var onSave:((_ data:String) ->())?
    var onSave:((_ data:Date) ->())?
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        //formatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
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
            var maxDate: Date?; var minDate: Date?
            
            titlelabel.text = "Select Time"
            datePicker.datePickerMode = .time
            datePicker.locale = Locale(identifier: "en_GB")
            saveBtn.setTitle("Save Time", for: .normal)
            if selectedClassDate != nil {
                let order = NSCalendar.current.compare(selectedClassDate!, to: Date(), toGranularity: .day)
                
                if order == .orderedAscending {
                    // date 1 is older
                    datePicker.minimumDate = selectedClassDate!
                }
                else if order == .orderedDescending {
                    // date 1 is newer
                }
                else if order == .orderedSame {
                    // same day/hour depending on granularity parameter
                    
                    comps.minute = 30// past dates are not allowed and 30 mintues ahead
                    minDate = calendar.date(byAdding: comps, to: Date())
                    datePicker.minimumDate = minDate
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
                //comps.year = -85//-30 // Person can be max of 100 yrs old (15 + 85)
                //minDate = calendar.date(byAdding: comps, to: Date())
                
                //datePicker.minimumDate = minDate
                // datePicker.maximumDate = maxDate
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

