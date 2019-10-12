//
//  OrderController.swift
//  MyDrinkBooking
//
//  Created by VorkYu on 2019/10/3.
//  Copyright © 2019 VorkYu. All rights reserved.
//

import Foundation
import UIKit

//sheetdb API
class OrderController {
    
    static let shared = OrderController()
    static let sheetDBAPI = "https://sheetdb.io/api/v1/vmoco9br8w9vj"
    //取得試算表上所有資料
    func getAllData(completion: @escaping ([OrderItem]?) -> Void) {
        if let url = URL(string: OrderController.sheetDBAPI) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        let orderList = try JSONDecoder().decode([OrderItem].self, from: data)
                        completion(orderList)
                    } catch {
                        print(error)
                        completion(nil)
                    }
                }
            }
            task.resume()
        } else{
            completion(nil)
        }
        
    }
    //上傳資料
    func post(order: OrderItem, completion: @escaping (String, String) -> Void) {
        var urlRequest = URLRequest(url: URL(string: OrderController.sheetDBAPI)!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let orderData = OrderData(data: order)
        let jsonEncoder = JSONEncoder()
        if let data = try? jsonEncoder.encode(orderData) {
            let task = URLSession.shared.uploadTask(with: urlRequest, from: data) { (data, response, error)in
                let decoder = JSONDecoder()
                if let data = data, let dic = try? decoder.decode([String: Int].self, from: data), dic["created"] == 1 {
                    completion("訂購成功", "準備喝飲料")
                } else {
                    completion("訂購失敗", "請重新訂購")
                }
            }
            task.resume()
        } else {
            completion("訂購失敗", "請重新訂購")
        }
    }
    //刪除資訊
    func delete(order: OrderItem, completion: @escaping (String, String) -> Void) {
        if let urlAPI = "\(OrderController.sheetDBAPI)/orderName/\(order.orderName)/".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlAPI) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "DELETE"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let orderData = OrderData(data: order)
            let jsonEncoder = JSONEncoder()
            if let data = try? jsonEncoder.encode(orderData) {
                let task = URLSession.shared.uploadTask(with: urlRequest, from: data) { (data, response, error)in
                    let decoder = JSONDecoder()
                    if let data = data, let dic = try? decoder.decode([String: Int].self, from: data), dic["deleted"] == 1 {
                        completion("刪除成功", "期待你下次訂")
                    } else {
                        completion("刪除失敗", "老天就是要你喝！")
                    }
                }
                task.resume()
            } else {
                completion("刪除失敗", "老天就是要你喝！")
            }
        }
    }
    //更新資訊
    func update(order: OrderItem, completion: @escaping (String, String) -> Void) {
        if let urlAPI = "\(OrderController.sheetDBAPI)/orderName/\(order.orderName)/".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlAPI) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "PUT"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let orderData = OrderData(data: order)
            let jsonEncoder = JSONEncoder()
            if let data = try? jsonEncoder.encode(orderData) {
                let task = URLSession.shared.uploadTask(with: urlRequest, from: data) { (data, response, error)in
                    let decoder = JSONDecoder()
                    if let data = data, let dic = try? decoder.decode([String: Int].self, from: data), dic["updated"] == 1 {
                        completion("修改成功", "準備喝飲料")
                    } else {
                        completion("修改失敗", "麻煩再改一次")
                    }
                }
                task.resume()
            } else {
                completion("修改失敗", "麻煩再改一次")
            }
        }
    }
}
