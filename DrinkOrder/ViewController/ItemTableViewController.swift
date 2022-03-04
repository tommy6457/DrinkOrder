//
//  ItemTableViewController.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/2/9.
//

import UIKit

class ItemTableViewController: UITableViewController {
    
    var currentMenu: [Menu.Records]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currentMenu?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ItemTableViewCell.self)", for: indexPath) as! ItemTableViewCell
        
        guard let item = currentMenu?[indexPath.row].fields else { return cell }
        
        //填標籤
        cell.itemNameLabel.text = item.itemName
        cell.descriptionTextView.text = item.description
        cell.originLabel.text = item.origin
        cell.hotMPriceLabel.text = "\(Int(item.hotMPrice ?? 0))"
        cell.coldMPriceLabel.text = "\(Int(item.coldMPrice ?? 0))"
        cell.coldLPriceLabel.text = "\(Int(item.coldLPrice ?? 0))"
        
        //推薦冰塊甜度
        var iceString = ""
        var sugarString = ""
        let onlyString = "僅"
        
        for label in item.ice {
            
            if iceString.isEmpty {
                
                if item.fixIce == true {
                    iceString = "\"" + onlyString + label + "\""
                }else{
                    iceString = label
                }
                
            }else{
                iceString = iceString + "/" + label
            }
            
        }
        
        for label in item.sugar {
            
            if sugarString.isEmpty {
                
                if item.fixSugar == true {
                    sugarString = "\"" + onlyString + label + "\""
                }else{
                    sugarString = label
                }
                
            }else{
                sugarString = sugarString + "/" + label
            }
            
        }
        
        cell.iceLabel.text = iceString
        cell.sugarLabel.text = sugarString
        
        //熱飲元件顯示
        if item.hot == nil {
            cell.hotStackView.isHidden = true
        }else{
            cell.hotStackView.isHidden = false
        }
        
        //冷飲元件顯示
        if item.size.contains("M") == false{
            cell.coldMStackView.isHidden = true
        }else{
            cell.coldMStackView.isHidden = false
        }
        
        if item.size.contains("L") == false{
            cell.coldLStackView.isHidden = true
        }else{
            cell.coldLStackView.isHidden = false
        }
        
        //莊園限定
        if item.limited == nil {
            cell.limitedLabel.isHidden = true
            cell.backgroundColor = UIColor(named: "JohnBlue")

        }else{
            cell.limitedLabel.isHidden = false
            cell.backgroundColor = UIColor(named: "JohnDeepBlue")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chooseViewController = storyboard?.instantiateViewController(withIdentifier: "\(ChooseViewController.self)") as! ChooseViewController
        
        guard let item = currentMenu?[indexPath.row].fields else {
            return }
        
        chooseViewController.item = item

        navigationController?.pushViewController(chooseViewController, animated: true)
        
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
