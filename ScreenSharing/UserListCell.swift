//  UserListCell.swift
//  LTW
//  Created by Vaayoo USA on 12/11/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
//import QuickbloxWebRTC

class UserListCell: UITableViewCell {

    //MARK: - IBOutlets
      @IBOutlet weak var nameLabel: UILabel!
      @IBOutlet weak var muteButton: UIButton!

    var didPressMuteButton: ((_ isMuted: Bool) -> Void)?
    var name = "" {
           didSet {
               nameLabel.text = name
               muteButton.isHidden = name.isEmpty
           }
       }
    
       let unmutedImage = UIImage(named: "ic-qm-videocall-dynamic-off")!
       let mutedImage = UIImage(named: "ic-qm-videocall-dynamic-on")!
    
//    var connectionState: QBRTCConnectionState = .connecting {
//        didSet {
//            muteButton.isHidden = !(connectionState == .connected)
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        muteButton.setImage(unmutedImage, for: .normal)
        muteButton.setImage(mutedImage, for: .selected)
        muteButton.isHidden = true
        muteButton.isSelected = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: - Actions
      @IBAction func didPressMuteButton(_ sender: UIButton) {
          sender.isSelected = !sender.isSelected
          didPressMuteButton?(sender.isSelected)
      }
    
}
