//
//  DescriptionViewController.swift
//  StoreApp
//
//  Created by Giri on 4/19/25.
//

import UIKit
import SDWebImage

class DescriptionViewController: UIViewController {

    
    @IBOutlet weak var cardBtn: UIButton!
    @IBOutlet weak var desImg: UIImageView!
    @IBOutlet weak var catLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var desLbl: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var rateLbl: UILabel!
    
    var data: Datalist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setData()
        
    }
    private func setupUI() {
        catLbl.textColor = .lightGray
        desLbl.textColor = .lightGray
        catLbl.font = InterFont.interRegular(size: 16)
        titleLbl.font = InterFont.interBold(size: 24)
        desLbl.font = InterFont.interRegular(size: 16)
        price.font = InterFont.interSemiBold(size: 22)
        titleLbl.font = InterFont.interSemiBold(size: 22)
        cardBtn.layer.cornerRadius = adapted(dimensionSize: 15)
        cardBtn.titleLabel?.font =  InterFont.interBold(size: 16)
    }
    
    private func setData() {
        desImg.sd_setImage(with: URL(string: data?.image ?? ""), placeholderImage: UIImage(named: "blur"))
        catLbl.text = data?.category
        titleLbl.text = data?.title
        rateLbl.text = "\(data?.rating?.rate ?? 0.0) / \(data?.rating?.count ?? 0)"
        price.text = "$\(data?.price ?? 0.0)"
        desLbl.text = data?.description
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func cardAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
