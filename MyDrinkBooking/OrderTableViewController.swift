//
//  OrderTableViewController.swift
//  MyDrinkBooking
//
//  Created by VorkYu on 2019/10/2.
//  Copyright © 2019 VorkYu. All rights reserved.
//

import UIKit

class OrderTableViewController: UITableViewController, UITextFieldDelegate {
    
    var myOrder: DrinkList?
    var editOrder: OrderItem?
    var orgPrice: Int?
    var drinkSize: String?
    var addThing: String?
    var sugarLevel: String?
    var iceLevel: String?
    var refreshView = UIActivityIndicatorView()
    
    @IBOutlet weak var orderImg: UIImageView!
    @IBOutlet weak var orderDrink: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var purchaser: UITextField!
    @IBOutlet weak var sizeSegment: UISegmentedControl!
    @IBOutlet weak var moreSegment: UISegmentedControl!
    @IBOutlet weak var sugarSegment: UISegmentedControl!
    @IBOutlet weak var iceSegment: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //設定TextField的代理人
        purchaser.delegate = self
        //新增一個Loading畫面
        setLoading()
        //一個全新的訂單(從菜單來)
        if let myOrder = myOrder {
            orderImg.image = UIImage(named: "noImg")
            orderDrink.text = myOrder.drinkName
            orderPrice.text = "NT. \(myOrder.drinkPrice)"
            //儲存一開始飲料金額
            orgPrice = Int((orderPrice.text! as NSString).substring(from: 4))
        }
        //一個修改的訂單(從訂購資料來)
        if let editOrder = editOrder {
            setEditOrder(with: editOrder)
        }
    }

    @IBAction func getOrder(_ sender: UIButton) {
        if purchaser.text?.isEmpty == true {
            showAlertMessage(title: "哈囉", message: "請寫上姓名!")
        } else {
            sendOrder()
        }
    }
    
    //準備上傳的訂單資料
    func sendOrder() {
        let orderItem = OrderItem(orderName: purchaser.text!,
                                  orderDrink: orderDrink.text!,
                                  orderSize: drinkSize ?? SizeLevel.sizeL.rawValue,
                                  orderSugar: sugarLevel ?? SugarLevel.normal.rawValue,
                                  orderIce: iceLevel ?? IceLevel.more.rawValue,
                                  moreThing: addThing ?? MoreThing.noThing.rawValue,
                                  orderPrice: (orderPrice.text! as NSString).substring(from: 4),
                                  orderTime: getRealTime())
        
        //若修改訂單不為nil表示為修改訂單
        if editOrder != nil {
            OrderController.shared.update(order: orderItem) { (title, msg) in
                DispatchQueue.main.async {
                    self.refreshView.stopAnimating()
                    self.showAlertMessage(title: title, message: msg) { (action) in
                        if title.contains("成功") {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        } else {
            OrderController.shared.post(order: orderItem) { (title, msg) in
                DispatchQueue.main.async {
                    self.refreshView.stopAnimating()
                    self.showAlertMessage(title: title, message: msg) { (action) in
                        if title.contains("成功") {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
        //Loading畫面啟動
        refreshView.startAnimating()
        
    }
    
    //取得容量、甜度等資訊
    @IBAction func selectSegmented(_ sender: UISegmentedControl) {
        switch sender {
        case sizeSegment:
            if sizeSegment.selectedSegmentIndex == 0 {
                drinkSize = SizeLevel.sizeL.rawValue
            } else {
                drinkSize = SizeLevel.sizeM.rawValue
            }
            
        case sugarSegment:
            switch sugarSegment.selectedSegmentIndex {
            case 0:
                sugarLevel = SugarLevel.normal.rawValue
            case 1:
                sugarLevel = SugarLevel.less.rawValue
            case 2:
                sugarLevel = SugarLevel.half.rawValue
            case 3:
                sugarLevel = SugarLevel.quarter.rawValue
            case 4:
                sugarLevel = SugarLevel.noSuger.rawValue
            default:
                break
            }
            
        case iceSegment:
            switch iceSegment.selectedSegmentIndex {
            case 0:
                iceLevel = IceLevel.more.rawValue
            case 1:
                iceLevel = IceLevel.normal.rawValue
            case 2:
                iceLevel = IceLevel.less.rawValue
            case 3:
                iceLevel = IceLevel.quarter.rawValue
            case 4:
                iceLevel = IceLevel.noIce.rawValue
            case 5:
                iceLevel = IceLevel.hot.rawValue
            default:
                break
            }
            
        case moreSegment:
            switch moreSegment.selectedSegmentIndex {
            case 0:
                addThing = MoreThing.noThing.rawValue
                orderPrice.text = "NT. \(orgPrice!)"
            case 1:
                addThing = MoreThing.grass.rawValue
                orderPrice.text = "NT. \(orgPrice! + 5)"
            case 2:
                addThing = MoreThing.pearl.rawValue
                orderPrice.text = "NT. \(orgPrice! + 10)"
            case 3:
                addThing = MoreThing.coconut.rawValue
                orderPrice.text = "NT. \(orgPrice! + 10)"
            case 4:
                addThing = MoreThing.pudding.rawValue
                orderPrice.text = "NT. \(orgPrice! + 10)"
            case 5:
                addThing = MoreThing.GoldenJelly.rawValue
                orderPrice.text = "NT. \(orgPrice! + 10)"
            case 6:
                addThing = MoreThing.taroBall.rawValue
                orderPrice.text = "NT. \(orgPrice! + 15)"
            default:
                break
            }
        default:
            break
        }
        
    }
    
    //將單筆訂單資訊帶入
    func setEditOrder(with editOrder: OrderItem) {
        orderImg.image = UIImage(named: "noImg")
        orderDrink.text = editOrder.orderDrink
        orderPrice.text = "NT. \(editOrder.orderPrice)"
        orgPrice = Int((orderPrice.text! as NSString).substring(from: 4))
        purchaser.text = editOrder.orderName
        
        for index in 0 ..< sizeSegment.numberOfSegments {
            if sizeSegment.titleForSegment(at: index) == editOrder.orderSize {
                sizeSegment.selectedSegmentIndex = index
                if sizeSegment.selectedSegmentIndex == 0 {
                    drinkSize = SizeLevel.sizeL.rawValue
                } else {
                    drinkSize = SizeLevel.sizeM.rawValue
                }
                break
            }
        }
        
        for index in 0 ..< sugarSegment.numberOfSegments {
            if sugarSegment.titleForSegment(at: index) == editOrder.orderSugar {
                sugarSegment.selectedSegmentIndex = index
                switch sugarSegment.selectedSegmentIndex {
                case 0:
                    sugarLevel = SugarLevel.normal.rawValue
                case 1:
                    sugarLevel = SugarLevel.less.rawValue
                case 2:
                    sugarLevel = SugarLevel.half.rawValue
                case 3:
                    sugarLevel = SugarLevel.quarter.rawValue
                case 4:
                    sugarLevel = SugarLevel.noSuger.rawValue
                default:
                    break
                }
                break
            }
        }
        
        for index in 0 ..< iceSegment.numberOfSegments {
            if iceSegment.titleForSegment(at: index) == editOrder.orderIce {
                iceSegment.selectedSegmentIndex = index
                switch iceSegment.selectedSegmentIndex {
                case 0:
                    iceLevel = IceLevel.more.rawValue
                case 1:
                    iceLevel = IceLevel.normal.rawValue
                case 2:
                    iceLevel = IceLevel.less.rawValue
                case 3:
                    iceLevel = IceLevel.quarter.rawValue
                case 4:
                    iceLevel = IceLevel.noIce.rawValue
                case 5:
                    iceLevel = IceLevel.hot.rawValue
                default:
                    break
                }
                break
            }
        }
        
        for index in 0 ..< moreSegment.numberOfSegments {
            if moreSegment.titleForSegment(at: index) == editOrder.moreThing {
                moreSegment.selectedSegmentIndex = index
                switch moreSegment.selectedSegmentIndex {
                case 0:
                    addThing = MoreThing.noThing.rawValue
                    //扣除加料金額，得到原來金額
                    orgPrice = Int((orderPrice.text! as NSString).substring(from: 4))
                case 1:
                    addThing = MoreThing.grass.rawValue
                    orgPrice = Int((orderPrice.text! as NSString).substring(from: 4))! - 5
                case 2:
                    addThing = MoreThing.pearl.rawValue
                    orgPrice = Int((orderPrice.text! as NSString).substring(from: 4))! - 10
                case 3:
                    addThing = MoreThing.coconut.rawValue
                    orgPrice = Int((orderPrice.text! as NSString).substring(from: 4))! - 10
                case 4:
                    addThing = MoreThing.pudding.rawValue
                    orgPrice = Int((orderPrice.text! as NSString).substring(from: 4))! - 10
                case 5:
                    addThing = MoreThing.GoldenJelly.rawValue
                    orgPrice = Int((orderPrice.text! as NSString).substring(from: 4))! - 10
                case 6:
                    addThing = MoreThing.taroBall.rawValue
                    orgPrice = Int((orderPrice.text! as NSString).substring(from: 4))! - 15
                default:
                    break
                }
                break
            }
        }
    }
    
    //新增一個Loading UI
    func setLoading() {
        refreshView = UIActivityIndicatorView(style: .large)
        refreshView.color = .gray
        refreshView.center = self.tableView.center
        tableView.addSubview(refreshView)
    }
    
    //設定返回鍵關閉鍵盤
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //顯示警示視窗
    func showAlertMessage(title: String, message: String, handler: ((UIAlertAction)-> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確認", style: .default, handler: handler)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //取得訂購時間
    func getRealTime() -> String {
        let time = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let nowTime = formatter.string(from: time)
        return nowTime
    }
    
    // MARK: - Table view data source
    /*
     override func numberOfSections(in tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     return 0
     }
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     // #warning Incomplete implementation, return the number of rows
     return 0
     }
     */
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
