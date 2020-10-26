//
//  EventTableViewCell.swift
//  casumoTestTask
//
//  Created by Oleksii Pelekh on 26.10.2020.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var eventIdLabel: UILabel!
    @IBOutlet weak var eventCreatedAtLabel: UILabel!
    @IBOutlet weak var eventTypeColorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
