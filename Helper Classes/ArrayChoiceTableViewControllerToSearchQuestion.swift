//  ArrayChoiceTableViewControllerToSearchQuestion.swift
//  LTW
//  Created by manjunath Hindupur on 13/08/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import Foundation
import UIKit
import SwiftyJSON

class ArrayChoiceTableViewControllerToSearchQuestion<Element, Element2> : UITableViewController, UIPopoverPresentationControllerDelegate { /* Added Element2 By Chandra on 22nd Jan 2020 */
/* Added UIPopoverPresentationControllerDelegate here  By Veeresh on 25th Feb 2020  */
    
    typealias SelectionHandler = (Element) -> Void
    typealias LabelProvider = (Element) -> String
    
    var values : [Element]
    var searchString: String! /* Added By Chandra on 22nd Jan 2020 - starts  here */  //code for highlighting search text.

    private let labels : LabelProvider
    private let onSelect : SelectionHandler?
    
    init(_ values : [Element],searchString:Element2,labels : @escaping LabelProvider = String.init(describing:), onSelect : SelectionHandler? = nil) { /* Added By Chandra on 22nd Jan 2020 - starts  here */
        self.values = values
        self.searchString = searchString as? String /* Added By Chandra on 22nd Jan 2020 - starts  here */
        self.onSelect = onSelect
        self.labels = labels
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /* Added By Veeresh on 25th Feb 2020 - starts here */
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
/* Added By Veeresh on 25th Feb 2020 - ends  here */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let dictJSON  = values[indexPath.row] as! JSON
        let labelString = dictJSON["Questions"].stringValue
        
           /* Commented By Chandra on 22nd Jan 2020 - starts  here */
        //        cell.separatorInset = UIEdgeInsets.zero
        //        cell.textLabel?.attributedText = getAttributedString(htmlString: labelString)
        //        // cell.textLabel?.attributedText = try? NSAttributedString(htmlString: "ABCd", font: UIFont.systemFont(ofSize: 100, weight: .thin))
        //        //labels(values[indexPath.row])
        //        cell.textLabel?.textColor = UIColor.init(hex: "2DA9EC")
           /* Commented By Chandra on 22nd Jan 2020 - ends  here */
       
        /* Added By Chandra on 22nd Jan 2020 - starts  here */
        //code for highlighting search text..
        let attributed = NSMutableAttributedString(string: labelString)
        let splitString = searchString.split(separator: " ")
        for searchSubString in splitString{
            do{
                let regex = try! NSRegularExpression(pattern: String(searchSubString),options: .caseInsensitive)
                for match in regex.matches(in: labelString, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: labelString.count)) as [NSTextCheckingResult] {
                    attributed.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.init(hex: "2DA9EC"), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)], range: match.range)
                    
                }
                
            }
            
        }
        //End of highlighting search text...
        cell.textLabel?.attributedText = attributed
        cell.separatorInset = UIEdgeInsets.zero
         /* Added By Chandra on 22nd Jan 2020 - ends  here */
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        let dictJSON  = values[indexPath.row] as! JSON
        //        let labelString = dictJSON["Questions"].stringValue
        
        self.dismiss(animated: true)
        // onSelect?(labelString)
        onSelect?(values[indexPath.row])
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    
}
