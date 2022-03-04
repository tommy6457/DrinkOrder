//
//  CartTableViewController.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/2/18.
//

import UIKit

class CartTableViewController: UITableViewController {

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
        return g_cartData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(CartTableViewCell.self)", for: indexPath) as! CartTableViewCell
        let cartData = g_cartData[indexPath.row]
        
        cell.itemNameLabel.text = cartData.itemName
        cell.iceLabel.text = cartData.ice.rawValue
        cell.sugarLabel.text = cartData.sugar.rawValue
        cell.quantityLabel.text = "\(cartData.quantity!)"
        cell.priceLabel.text = "\(cartData.price!)"
        cell.sizeLabel.text = "\(cartData.size.rawValue)"
        
        if cartData.bubble {
            cell.bubbleLabel.isHidden = false
        }else{
            cell.bubbleLabel.isHidden = true
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "刪除") { action, view , bool in
            //刪除資料
            g_cartData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.reloadData()
            bool(true)
            
            NetWorkController.shared.showAlert(title: "通知", message: "已刪除該筆資料") { alert in
                self.present(alert, animated: true, completion: nil)
            }
            
            //更新總金額
            if let cartVC = self.parent as? CartViewController{
                cartVC.setTotalPrice()
            }
        }
        
        delete.backgroundColor = .systemRed
        
        let config = UISwipeActionsConfiguration(actions: [delete])
        
        config.performsFirstActionWithFullSwipe = false
        
        return config
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
