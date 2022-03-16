//
//  OrderTableViewController.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/3/1.
//

import UIKit

class OrderTableViewController: UITableViewController {
    
    var orderHeader: OrderHeader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orderHeader?.records.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(OrderTableViewCell.self)", for: indexPath) as! OrderTableViewCell
        
        if let record = orderHeader?.records[indexPath.row] {
            
            cell.consigneeNameLabel.text = record.fields.consigneeName
            cell.dateLabel.text = record.fields.date
            cell.orderNumberLabel.text = record.fields.orderNumber
            cell.phoneLabel.text = record.fields.phone
            cell.totalPriceLabel.text = "$ \(record.fields.totalPrice)"
            cell.statusLabel.text = record.fields.status
            
            switch record.fields.status {
            case "完成訂單":
                cell.statusLabel.textColor = UIColor.systemGreen
            case "取消訂單":
                cell.statusLabel.textColor = UIColor.systemRed
            case "已送出":
                cell.statusLabel.textColor = UIColor.systemOrange
            case "確認訂單":
                cell.statusLabel.textColor = UIColor.systemCyan
            default:
                cell.statusLabel.textColor = UIColor(named: "AccentColor")
            }
        }
        
        //改底色
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(named: "JohnBlue")?.withAlphaComponent(0.9)
        }else{
            cell.backgroundColor = UIColor(named: "JohnDeepBlue")?.withAlphaComponent(0.9)
        }
        
        return cell
    }
    
    //右邊按鈕
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard var record = orderHeader?.records[indexPath.row] else { return nil }
        
        //完成訂單不能更改
        if record.fields.status == Status.complete.statusText { return nil }
        
        //取消訂單不能更改
        if record.fields.status == Status.cancel.statusText { return nil }
        
        let cancel = UIContextualAction(style: .normal, title: "取消") { action, view, bool in
            //叫出 LoadingView
            self.pushToLoadingView()
            //狀態改為取消
            record.fields.status = Status.cancel.statusText
            
            let orderHeaderTemp = OrderHeader(records: [record])
            
            NetWorkController.shared.patchOrderHeader(urlString: NetWorkController.orderHeaderURL, orderHeader: orderHeaderTemp) { result in
                
                switch result {
                case .failure:
                    
                    DispatchQueue.main.async {
                        NetWorkController.shared.showAlert(title: "訊息", message: "訂單取消失敗") { alert in
                            self.present(alert, animated: true){
                                DispatchQueue.main.async {
                                    self.navigationController?.popViewController(animated: false)
                                }
                            }

                        }
                    }
                    
                case .success(let orderHeaderResult):
                    self.orderHeader!.records[indexPath.row] = orderHeaderResult.records.first!
                    //更新資料
                    DispatchQueue.main.async {
                        tableView.reloadData()
                        
                        NetWorkController.shared.showAlert(title: "訊息", message: "訂單取消成功") { alert in
                            self.present(alert, animated: true){
                                DispatchQueue.main.async {
                                    self.navigationController?.popViewController(animated: false)
                                }
                            }

                        }
                    }
                }
                
            }
            
            bool(true)
        }
        
        let edit = UIContextualAction(style: .normal, title: "更改") { action, view, bool in
            
            //-------- alert controller start--------
            let alert = UIAlertController(title: "修改訂單資訊", message: "僅以下資訊提供調整", preferredStyle: .alert)
            
            alert.addTextField { textField in
                textField.placeholder = "取貨人名稱"
            }
            
            alert.addTextField { textField in
                textField.placeholder = "聯絡電話"
                textField.keyboardType = .phonePad
                
            }
            
            let okAction = UIAlertAction(title: "OK", style: .default) { action in
                //兩個都是空的
                if let consigneeName = alert.textFields?[0].text,
                   consigneeName.isEmpty,
                   let phone = alert.textFields?[1].text,
                    phone.isEmpty{
                    
                    NetWorkController.shared.showAlert(title: "警告", message: "無修改內容") { alert in
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    return
                }
                //填值
                if let consigneeName = alert.textFields?[0].text,
                   !consigneeName.isEmpty{
                    
                    record.fields.consigneeName = consigneeName
                }
                
                if let phone = alert.textFields?[1].text,
                   !phone.isEmpty{
                    record.fields.phone = phone
                }
                
                //叫出 LoadingView
                self.pushToLoadingView()
                
                let orderHeaderTemp = OrderHeader(records: [record])
                //修改雲端資料
                NetWorkController.shared.patchOrderHeader(urlString: NetWorkController.orderHeaderURL, orderHeader: orderHeaderTemp) { result in
                    
                    switch result {
                    case .failure:
                        
                        DispatchQueue.main.async {
                            NetWorkController.shared.showAlert(title: "訊息", message: "修改失敗") { alert in
                                self.present(alert, animated: true){
                                    DispatchQueue.main.async {
                                        self.navigationController?.popViewController(animated: false)
                                    }
                                }

                            }
                        }
                        
                        
                    case .success(let orderHeader):
                        
                        self.orderHeader?.records[indexPath.row] = orderHeader.records.first!
                        
                        DispatchQueue.main.async {
                            //更新資料
                            tableView.reloadData()
                            
                            NetWorkController.shared.showAlert(title: "訊息", message: "修改成功") { alert in
                                self.present(alert, animated: true){
                                    DispatchQueue.main.async {
                                        self.navigationController?.popViewController(animated: false)
                                    }
                                }

                            }
                        }
                    }
                }
                
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            //-------- alert controller end--------
            
            bool(true)
        }
        
        edit.backgroundColor = .systemOrange
        
        let config = UISwipeActionsConfiguration(actions: [edit,cancel])
        
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
    
    //左邊按鈕
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let record = orderHeader?.records[indexPath.row] else { return nil }
        
        //完成訂單不能更改
        if record.fields.status == Status.complete.statusText { return nil }
        
        //取消訂單不能更改
        if record.fields.status == Status.cancel.statusText { return nil }
        
        let delete = UIContextualAction(style: .normal, title: "刪除") { action, view, bool in
            //叫出 LoadingView
            self.pushToLoadingView()
            
            NetWorkController.shared.deleteOrderHeader(urlString: NetWorkController.orderHeaderURL, id: record.id!) { result in
                
                switch result {
                    
                case .failure:
                    
                    DispatchQueue.main.async {
                        NetWorkController.shared.showAlert(title: "訊息", message: "刪除失敗") { alert in
                            self.present(alert, animated: true){
                                DispatchQueue.main.async {
                                    self.navigationController?.popViewController(animated: false)
                                }
                            }
                        }
                    }
                    
                case .success:
                    
                    self.orderHeader?.records.remove(at: indexPath.row)
                    
                    DispatchQueue.main.async {
                        
                        self.tableView.deleteRows(at: [indexPath], with: .left)
                        self.tableView.reloadData()
                        
                    }
                    
                    //刪除表身
                    NetWorkController.shared.deleteOrderItem(urlString: NetWorkController.orderItemURL, records: record) { result in
                        
                        switch result {
                        case .failure(let error):
                            switch error {
                            case .invalidData:
                                print("invalidData")
                            case .invalidJsonFormat:
                                print("invalidJsonFormat")
                            case .invalidurl:
                                print("invalidurl")
                            case .invalidResponse:
                                print("invalidResponse")
                            case .requestFailed:
                                print("requestFailed")
                            }
                        case .success:
                            
                            DispatchQueue.main.async {
                                NetWorkController.shared.showAlert(title: "通知", message: "已刪除該筆訂單") { alert in
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                            
                        }
                    }
                    //從loading頁面返回
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: false)
                    }
                }
                
            }
            
            bool(true)
            
        }
        
        delete.backgroundColor = .systemRed
        
        let config = UISwipeActionsConfiguration(actions: [delete])
        
        config.performsFirstActionWithFullSwipe = false
        
        return config
        
    }
    
    //點擊row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        guard let record = orderHeader?.records[indexPath.row] else { return }
        
        NetWorkController.shared.fetchOrderItem(urlString: NetWorkController.getOrderItemURL, where: (field: "orderNumberString", value: record.fields.orderNumber)) {result in
            
            switch result {
            case .failure(let error):
                switch error {
                case .invalidData:
                    print("invalidData")
                case .invalidJsonFormat:
                    print("invalidJsonFormat")
                case .invalidurl:
                    print("invalidurl")
                case .invalidResponse:
                    print("invalidResponse")
                case .requestFailed:
                    print("requestFailed")
                }
            case .success(let orderItem):
                print("orderItem\(orderItem)")
            }
            
        }
    }
    
    func pushToLoadingView(){
        
        guard let orderVC = parent as? OrderViewController else { return }
        
        guard let loadingVC = orderVC.loadingVC else { return }
        
        self.navigationController?.pushViewController(loadingVC, animated: false)
        
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
