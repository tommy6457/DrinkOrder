//
//  ItemTableViewCell.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/2/10.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var hotMPriceLabel: UILabel!
    @IBOutlet weak var coldLPriceLabel: UILabel!
    @IBOutlet weak var coldMPriceLabel: UILabel!
    @IBOutlet weak var coldMStackView: UIStackView!
    @IBOutlet weak var coldLStackView: UIStackView!
    @IBOutlet weak var hotStackView: UIStackView!
    @IBOutlet weak var iceSymbolLabel: UILabel!
    @IBOutlet weak var hotSymbolLabel: UILabel!
    @IBOutlet weak var iceLabel: UILabel!
    @IBOutlet weak var sugarLabel: UILabel!
    
    @IBOutlet weak var limitedLabel: UILabel!
    let selectedView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iceSymbolLabel.layer.cornerRadius = iceSymbolLabel.bounds.width / 2
        hotSymbolLabel.layer.cornerRadius = hotSymbolLabel.bounds.width / 2
        //選擇cell的背景顏色
        selectedView.backgroundColor = UIColor(named: "SelJohnBlue")
        self.selectedBackgroundView = selectedView
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
