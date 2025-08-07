//
//  CardCollectionViewCell.swift
//  StoreApp
//
//  Created by Giri on 4/18/25.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseView.layer.cornerRadius = adapted(dimensionSize: 12)
        title.font = InterFont.interRegular(size: 16)
        price.font = InterFont.interBold(size: 16)
    }

}
