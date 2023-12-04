//
//  ConversationCell.swift
//  ChatAi
//
//  Created by wangfeng on 2023/11/16.
//

import UIKit

class ConversationCell: UITableViewCell,RegisterCellFromNib {

    @IBOutlet weak var chatAvatarImageV: UIImageView!
    @IBOutlet weak var chatNameLab: UILabel!
    @IBOutlet weak var chatMsgLab: UILabel!
    @IBOutlet weak var chatTimeLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
