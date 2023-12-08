//
//  CustomCell.swift
//  ChatAi
//
//  Created by wangfeng on 2023/12/8.
//

import UIKit

class CustomCell: UITableViewCell,RegisterCellFromNib {

    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var content: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
