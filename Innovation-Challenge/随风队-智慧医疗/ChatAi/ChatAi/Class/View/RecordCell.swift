//
//  RecordCell.swift
//  ChatAi
//
//  Created by wangfeng on 2023/11/30.
//

import UIKit

class RecordCell: UITableViewCell,RegisterCellFromNib {

    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var contentLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
