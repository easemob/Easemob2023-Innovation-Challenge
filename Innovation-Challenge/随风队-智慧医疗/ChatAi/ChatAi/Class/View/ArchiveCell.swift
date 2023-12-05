//
//  ArchiveCell.swift
//  ChatAi
//
//  Created by wangfeng on 2023/11/24.
//

import UIKit

class ArchiveCell: UITableViewCell,RegisterCellFromNib {

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
