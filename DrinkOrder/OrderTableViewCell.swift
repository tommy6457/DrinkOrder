//
//  OrderTableViewCell.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/3/1.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var consigneeNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
