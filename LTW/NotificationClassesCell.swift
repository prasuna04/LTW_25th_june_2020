//
//  NotificationClassesCell.swift
//  LTW
//
//  Created by vaayoo on 01/07/20.
//  Copyright © 2020 vaayoo. All rights reserved.
//

import UIKit

class NotificationClassesCell: UITableViewCell {
    

    @IBOutlet weak var classTitle : UILabel!
    @IBOutlet weak var grades : UILabel!
    @IBOutlet weak var timings : UILabel!
    @IBOutlet weak var subject : UILabel!
    @IBOutlet weak var joinButton : UIButton!
    @IBOutlet weak var whiteboardButton : UIButton!
    @IBOutlet weak var subscribeUnsubscribeButton : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
