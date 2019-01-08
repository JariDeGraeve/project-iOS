//
//  ItemTableViewCell.swift
//  LosTrouvee
//
//  Created by Jari De Graeve on 28/11/2018.
//  Copyright © 2018 Jari De Graeve. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateAddedLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with item: Item) {
        var df = Item.timeAddedDateFormatter
        titleLabel.text = item.title
        dateAddedLabel.text = df.string(from: item.timeAdded)
        categoryLabel.text = item.category.rawValue.uppercased()
        descriptionLabel.text = item.description
        df = Item.timeStampDateFormatter
        timestampLabel.text = df.string(from: item.timestamp)
        //apparte functie maken om place te formatten
        placeLabel.text =  item.place.city
        
    }

}
