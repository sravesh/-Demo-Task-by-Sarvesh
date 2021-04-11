//
//  TaskListCell.swift
//  DemoTask
//
//  Created by Sarvesh Gundi on 11/04/21.
//

import UIKit

class TaskListCell: UITableViewCell {

    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Desc: UILabel!
    @IBOutlet weak var lbl_CreatedDate: UILabel!
    @IBOutlet weak var lbl_CreatedTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
