//
//  MenuViewController.swift
//  MyDrinkBooking
//
//  Created by VorkYu on 2019/10/2.
//  Copyright © 2019 VorkYu. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var menuTableView: UITableView!
    var menuAllList = [DrinkList]()
    var refreshView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshView.startAnimating()
        getMenuList()
    }
    //取得菜單資料
    func getMenuList() {
        if let url = Bundle.main.url(forResource: "kqTea", withExtension: "txt"), let content = try? String(contentsOf: url) {
            let menuLists = content.components(separatedBy: "\n")
            for menuList in menuLists {
                let array = menuList.components(separatedBy: ",")
                menuAllList.append(DrinkList(drinkName: array[0], drinkPrice: array[1]))
            }
        } else {
            print("error")
        }
        refreshView.stopAnimating()
    }
    
    //新增一個Loading UI
    func setLoading() {
        refreshView = UIActivityIndicatorView(style: .large)
        refreshView.color = .gray
        refreshView.center = self.view.center
        self.view.addSubview(refreshView)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? OrderTableViewController, let row = menuTableView.indexPathForSelectedRow?.row {
            controller.myOrder = menuAllList[row]
        }
    }

}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuAllList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuTableViewCell

        cell.updateMenu(with: menuAllList[indexPath.row])
        return cell
    }
    
}
