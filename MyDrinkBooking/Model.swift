//
//  Model.swift
//  MyDrinkBooking
//
//  Created by VorkYu on 2019/10/2.
//  Copyright © 2019 VorkYu. All rights reserved.
//

import Foundation
import UIKit

struct DrinkList {
    var drinkName: String
    var drinkPrice: String
}

struct OrderItem: Codable {
    var orderName: String
    var orderDrink: String
    var orderSize: String
    var orderSugar: String
    var orderIce: String
    var moreThing: String
    var orderPrice: String
    var orderTime: String
    
}

struct OrderData: Encodable {
    var data: OrderItem
}

enum SizeLevel: String {
    case sizeL = "L", sizeM = "M"
}

enum MoreThing: String {
    case noThing = "無",grass = "仙草", pearl = "珍珠", coconut = "椰果", pudding = "布丁", GoldenJelly = "愛玉", taroBall = "小芋圓"
}

enum SugarLevel: String {
case normal = "正常", less = "七分", half = "半糖", quarter = "微糖", noSuger = "無糖"
}

enum IceLevel: String {
case more = "多冰", normal = "正常", less = "少冰", quarter = "微冰", noIce = "去冰", hot = "熱飲"
}
