//
//  OrderListTableViewCell.swift
//  MyDrinkBooking
//
//  Created by VorkYu on 2019/10/8.
//  Copyright © 2019 VorkYu. All rights reserved.
//

import UIKit

class OrderListTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var drink: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var sugar: UILabel!
    @IBOutlet weak var ice: UILabel!
    @IBOutlet weak var add: UILabel!
    @IBOutlet weak var time: UILabel!
    
    //更新TableViewCell
    func updateOrderList(with order: OrderItem) {
        self.name.text = "訂購人:\(order.orderName)"
        self.drink.text = "飲料:\(order.orderDrink)"
        self.price.text = "NT. \(order.orderPrice)"
        self.size.text = "容量:\(order.orderSize)"
        self.sugar.text = "甜度:\(order.orderSugar)"
        self.ice.text = "冰度:\(order.orderIce)"
        self.add.text = "加料:\(order.moreThing)"
        self.time.text = "訂購時間:\(order.orderTime)"
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
