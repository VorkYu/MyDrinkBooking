//
//  ShowOrderTableViewController.swift
//  MyDrinkBooking
//
//  Created by VorkYu on 2019/10/3.
//  Copyright © 2019 VorkYu. All rights reserved.
//

import UIKit

class ShowOrderTableViewController: UITableViewController {
    
    @IBOutlet weak var totalCount: UILabel!
    var orderList = [OrderItem]()
    var LoadingView = UIActivityIndicatorView()
    //下拉更新時顯示字樣
    override func viewDidAppear(_ animated: Bool) {
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "更新中...")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLoading()
        LoadingView.startAnimating()
        //取得試算表資料
        OrderController.shared.getAllData { (orderList) in
            if let orderList = orderList {
                var sum: Int = 0
                self.orderList = orderList
                self.orderList.reverse()
                for index in 0 ..< orderList.count {
                    sum = sum + Int(orderList[index].orderPrice)!
                }
                DispatchQueue.main.async {
                    self.totalCount.text = "總杯數:\(orderList.count), 總金額:\(sum)元"
                    self.tableView.reloadData()
                    self.LoadingView.stopAnimating()
                }
            }
        }
        //新增下拉式更新功能
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    //新增Loading UI
    func setLoading() {
        LoadingView = UIActivityIndicatorView(style: .large)
        LoadingView.color = .gray
        LoadingView.center = self.tableView.center
        tableView.addSubview(LoadingView)
    }
    //設定TableCell背景顏色
    func colorForIndex(index: Int) -> UIColor {
        let itemCount = orderList.count - 1
        let color = (CGFloat(index) / CGFloat(itemCount)) * 0.7
        return UIColor(red: 0.0, green: 0.7, blue: color, alpha: 0.3)
    }
    //下拉式更新時觸發的行為
    @objc func handleRefresh() {
        OrderController.shared.getAllData { (orderList) in
            if let orderList = orderList {
                var sum: Int = 0
                self.orderList = orderList
                self.orderList.reverse()
                for index in 0 ..< orderList.count {
                    sum = sum + Int(orderList[index].orderPrice)!
                }
                DispatchQueue.main.async {
                    self.totalCount.text = "總杯數:\(orderList.count), 總金額:\(sum)元"
                    self.tableView.reloadData()
                }
            }
        }
        tableView.refreshControl?.endRefreshing()
    }
    //顯示警示視窗
    func showAlertMessage(title: String, message: String, handler: ((UIAlertAction)-> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確認", style: .default, handler: handler)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orderList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderListCell", for: indexPath) as! OrderListTableViewCell
        
        cell.updateOrderList(with: orderList[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = colorForIndex(index: indexPath.row)
    }
    //新增右側按鈕
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal, title: "修改") { (action, view, completionHandler) in
            let editController = self.storyboard?.instantiateViewController(identifier: "editView") as! OrderTableViewController
            editController.editOrder = self.orderList[indexPath.row]
            self.show(editController, sender: self)
            completionHandler(true)
        }
        
        let delAction = UIContextualAction(style: .destructive, title: "刪除") { (action, view, completionHandler) in
            self.LoadingView.startAnimating()
            OrderController.shared.delete(order: self.orderList[indexPath.row]) { (title, msg) in
                DispatchQueue.main.async {
                    self.showAlertMessage(title: title, message: msg)
                    self.handleRefresh()
                    self.LoadingView.stopAnimating()
                }
                
            }
            completionHandler(true)
        }
        
        //        let configuration = UISwipeActionsConfiguration(actions: [delAction, editAction])
        //        configuration.performsFirstActionWithFullSwipe = false
        
        return UISwipeActionsConfiguration(actions: [delAction, editAction])
    }
    
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
