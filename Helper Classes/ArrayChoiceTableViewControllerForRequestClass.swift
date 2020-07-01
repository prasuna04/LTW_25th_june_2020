//  ArrayChoiceTableViewControllerForRequestClass.swift
//  LTW
//  Created by Ranjeet Raushan on 24/02/20.
//  Copyright © 2020 vaayoo. All rights reserved.

import UIKit

class ArrayChoiceTableViewControllerForRequestClass<Element> : UITableViewController {
    
    typealias SelectionHandler = (Element) -> Void
    typealias LabelProvider = (Element) -> String
    
    private let values : [Element]
    private let labels : LabelProvider
    private let onSelect : SelectionHandler?
    
    init(_ values : [Element], labels : @escaping LabelProvider = String.init(describing:), onSelect : SelectionHandler? = nil) {
        self.values = values
        self.onSelect = onSelect
        self.labels = labels
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.selectionStyle = .none /* Added By Ranjeet on 24th Feb 2020 */
        cell.imageView?.image = UIImage(named: "radio") /* Added By Ranjeet on 24th Feb 2020 */
        cell.separatorInset = UIEdgeInsets.zero
        cell.textLabel?.text = labels(values[indexPath.row])
        cell.textLabel?.textColor = UIColor.init(hex: "2DA9EC")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true)
        onSelect?(values[indexPath.row])
          let cell = tableView.cellForRow(at: indexPath as IndexPath) /* Added By Ranjeet on 24th Feb 2020 */
          cell?.imageView?.image = UIImage(named: "radio_selected") /* Added By Ranjeet on 24th Feb 2020 */
    }
  
}
