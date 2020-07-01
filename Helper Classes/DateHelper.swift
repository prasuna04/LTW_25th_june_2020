//  DateHelper.swift
//  LTW
//  Created by Ranjeet Raushan on 04/06/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import Foundation

class DateHelper: NSObject {
static func localToUTC(date:String, fromFormat: String, toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
      //  dateFormatter.date /* Don't delete this line , might reuse */
        let dt = dateFormatter.date(from: date)
        dateFormatter.dateFormat = toFormat
        return dateFormatter.string(from: dt!)
    }
    static func formattDate(date: Date,toFormatt: String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = toFormatt
        return formatter.string(from: date)
    }
    
    static func localToUTC(date: Date,toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = NSCalendar.current
        //dateFormatter.timeZone = TimeZone.current
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // Don't delete this line , this is just for understanding purpose for future reference
        dateFormatter.dateFormat = toFormat
        return dateFormatter.string(from: date)
    }
    static func  getDateObj(from dateString: String, fromFormat: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        //dateFormatter.date /*  Don't delete this line , might reuse  */
        let dateObject = dateFormatter.date(from: dateString)
        return dateObject!
    }
}



// Convert UTC time to local of received data
func UTCToLocal(str: String) -> Date?{
    let dateF = DateFormatter()
    dateF.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    dateF.timeZone = TimeZone(abbreviation: "UTC")
    if let dat = dateF.date(from: str){
        dateF.timeZone = TimeZone.current
        return dat
    }
    return nil
}
// To get time differnce from current date to notifcation date
extension Date {
        func getElapsedInterval() -> String {
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " year ago":
                "\(year)"  + " years ago"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " month ago":
                "\(month)" + " months ago"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " day ago":
                "\(day)" + " days ago"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour)" + " hour ago":
                "\(hour)" + " hours ago"
        } else if let minute = interval.minute, minute > 0 {
            return minute == 1 ? "\(minute)" + " minute ago":
                "\(minute)" + " minutes ago"
        } else if let second = interval.second, second > 0 {
            return second == 1 ? "\(second)" + " second ago" :
                "\(second)" + " seconds ago"
        } else {
            return "moment ago"
        }
    }
    /* Added By Prasuna on 11th April 2020 - starts here */
    func secondsFromBeginningOfTheDay() -> TimeInterval {
        let calendar = Calendar.current
        // omitting fractions of seconds for simplicity
        let dateComponents = calendar.dateComponents([.hour, .minute, .second], from: self)

        let dateSeconds = dateComponents.hour! * 3600 + dateComponents.minute! * 60 + dateComponents.second!

        return TimeInterval(dateSeconds)
    }

    // Interval between two times of the day in seconds
    func timeOfDayInterval(toDate date: Date) -> TimeInterval {
        let date1Seconds = self.secondsFromBeginningOfTheDay()
        let date2Seconds = date.secondsFromBeginningOfTheDay()
        return date2Seconds - date1Seconds
    }
     /* Added By Prasuna on 11th April 2020 - ends here */
}
/* Future Reference:
https://stackoverflow.com/questions/42803349/swift-3-0-convert-server-utc-time-to-local-time-and-vice-versa  - [ Swift : Convert server UTC time to local time and vice-versa ]
*/
