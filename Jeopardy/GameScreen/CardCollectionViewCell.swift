//
//  CardCollectionViewCell.swift
//  Jeopardy
//
//  This class handles the custom cells in the UICollectionView
//
//  Created by Prathyusha Pillari on 7/24/18.
//  Edited by Prathyusha Pillari on 7/27/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    // label for the category text
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        // sets a default label for teh category
        categoryLabel.text = "Default"
        categoryLabel.textColor = UIColor.white
    }
}
