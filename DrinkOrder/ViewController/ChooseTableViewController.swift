//
//  ChooseTableViewController.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/2/14.
//

import UIKit

class ChooseTableViewController: UITableViewController {
    //飲料屬性設定檔
    var item: Menu.Records.Fields!
    
    //飲料當前屬性
    var currentIceAttribute: Ice?       //冰塊
    var currentSugarAttribute: Sugar?   //甜度
    var currentSizeAttribute: Size?   //尺寸
    var currentAddBubble = false        //珍珠
    var currentPrice = 0                //金額
    
    //文字Label
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var priceLabel: UILabel!
    
    //Button選項
    @IBOutlet var sugarCheckButtons: [UIButton]!
    @IBOutlet var iceCheckButtons: [UIButton]!
    @IBOutlet var sizeCheckButtons: [UIButton]!
    @IBOutlet var bubbleCheckButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    //初始UI畫面
    func initialUI(){
        
        guard let item = item else { return }
        
        itemNameLabel.text = item.itemName
        descriptionTextView.text = item.description
        //冰塊判斷不能點擊
        if item.fixIce == true,
           let ice = Ice(rawValue: item.ice.first!){
            setButtonsDisable(tag: ice.getIndex(), buttons: iceCheckButtons, equal: false)
        }
        //熱飲判斷不能點擊
        if item.hot == false || item.hot == nil {
            setButtonsDisable(tag: Ice.hot.getIndex(), buttons: iceCheckButtons, equal: true)
        }
        //甜度判斷不能點擊
        if item.fixSugar == true,
           let sugar = Sugar(rawValue: item.sugar.first!){
            setButtonsDisable(tag: sugar.getIndex(),buttons: sugarCheckButtons, equal: false)
        }
        
        //尺寸判斷不能點擊
        if item.fixSize == true, let size = Size(rawValue: item.size.first!){
            
            setButtonsDisable(tag: size.getIndex(),buttons: sizeCheckButtons, equal: false)
        }
        
        //珍珠判斷不能加
        if item.addBubble == nil || item.addBubble == false {
            setButtonsDisable(tag: 0,buttons: bubbleCheckButtons, equal: true)
        }
        
    }
    //設定button disable
    func setButtonsDisable(tag: Int, buttons: [UIButton], equal: Bool){
        //指定tag的button不可被點擊
        if equal {
            for button in buttons where button.tag == tag{
                
                button.setImage(UIImage(systemName: "checkmark.circle.trianglebadge.exclamationmark"), for: .normal)
                button.isEnabled = false
                
            }
        //指定tag以外的button不可被點擊
        }else{
            for button in buttons where button.tag != tag{
                
                button.setImage(UIImage(systemName: "checkmark.circle.trianglebadge.exclamationmark"), for: .normal)
                button.isEnabled = false
                
            }
            
        }
    }
    //設定button enable
    func setButtonsEnable(tag: Int, buttons: [UIButton]){
        //指定tag的button可被點擊
            for button in buttons where button.tag == tag{
                
                button.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
                button.isEnabled = true
                
            }
    }
    //單選button動作
    func radioButtonAction(tag: Int, buttons: [UIButton]){
        //disabled以外的button才要做更改
        for button in buttons where button.state != .disabled {
            
            if button.tag == tag {
                button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            }else{
                button.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            }
            
        }
        
    }
    
    //點擊冰塊button
    @IBAction func clickIceButton(_ sender: UIButton) {
        radioButtonAction(tag: sender.tag, buttons: iceCheckButtons)
        currentIceAttribute = Ice.getIce(int: sender.tag)
        //熱飲的話不能選擇L尺寸
        if sender.tag == 4 {
            setButtonsEnable(tag: 0, buttons: sizeCheckButtons)
            setButtonsDisable(tag: 1,buttons: sizeCheckButtons, equal: true)
            currentSizeAttribute = nil
        }else{
            //如果選擇熱飲以外的，讓尺寸L可以被選擇
            for button in sizeCheckButtons where button.tag == 1{
                if !button.isEnabled {
                    setButtonsEnable(tag: 1, buttons: sizeCheckButtons)
                }
            }
        }
        
        let chooseViewController = parent as! ChooseViewController
        chooseViewController.countPrice()
    }
    
    //點擊甜度button
    @IBAction func clickSugarButton(_ sender: UIButton) {
        radioButtonAction(tag: sender.tag, buttons: sugarCheckButtons)
        currentSugarAttribute = Sugar.getSugar(int: sender.tag)
        let chooseViewController = parent as! ChooseViewController
        chooseViewController.countPrice()
    }
    
    //點擊尺寸button
    @IBAction func clickSizeButton(_ sender: UIButton) {
        radioButtonAction(tag: sender.tag, buttons: sizeCheckButtons)
        currentSizeAttribute = Size.getSize(int: sender.tag)
        let chooseViewController = parent as! ChooseViewController
        chooseViewController.countPrice()
    }
    
    @IBAction func clickBubbleButton(_ sender: UIButton) {
        
        currentAddBubble.toggle()
        //加珍珠：將圖示填滿
        if currentAddBubble {
            radioButtonAction(tag: sender.tag, buttons: bubbleCheckButtons)
        //不加珍珠：隨便指定一個沒有設定的tag，就可以改變為非填滿的圖示
        }else{
            radioButtonAction(tag: 100, buttons: bubbleCheckButtons)
        }
        
        let chooseViewController = parent as! ChooseViewController
        chooseViewController.countPrice()
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
