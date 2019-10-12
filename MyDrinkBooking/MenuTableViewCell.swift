//
//  MenuTableViewCell.swift
//  MyDrinkBooking
//
//  Created by VorkYu on 2019/10/2.
//  Copyright © 2019 VorkYu. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuName: UILabel!
    @IBOutlet weak var menuPrice: UILabel!
    //更新TableViewCell
    func updateMenu(with menu: DrinkList) {
        self.menuImage.image = UIImage(named: "noImg")
        self.menuName.text = menu.drinkName
        self.menuPrice.text = "NT. \(menu.drinkPrice)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
