//
//  CartViewController.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/2/17.
//

import UIKit

class CartViewController: UIViewController {
    //取貨時間alert
    let alertController = UIAlertController(title: "請選擇取貨時間", message: "注意：取貨時間至少為一小時後", preferredStyle: .alert)
    
    //總金額
    var total = 0
    
    //表頭
    var orderHeader = OrderHeader(records: [OrderHeader.Records]())
    
    //每秒更新alert的時間
    //    var timer: Timer?
    
    /*Loading View*/
    var loadingVC: LoadingViewController!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //title
        title = "購物車"
        //設定送出訂單要跳出的alert
        setAlertController()
        //總金額label
        setTotalPrice()
        //Loading
        loadingVC = storyboard?.instantiateViewController(withIdentifier: "\(LoadingViewController.self)") as! LoadingViewController
    }
    
    func setTotalPrice(){
        //歸零
        total = 0
        //總金額
        if !g_cartData.isEmpty {
            total = g_cartData.reduce(0){
                $0 + $1.price }
        }
        //填標籤
        totalPriceLabel.text = "\(total)"
    }
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(animated)
    //        if timer != nil {
    //            timer?.invalidate()
    //            timer = nil
    //        }
    //    }
    
    //初始化alert設定
    func setAlertController(){
        //datePicker
        let datePicker = UIDatePicker()
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(datePickerEditingChanged), for: .valueChanged)
        
        //alertController加TextField
        alertController.addTextField { textField in
            textField.inputView = datePicker
            textField.text = NetWorkController.shared.getOrderHeaderDateTime(date: datePicker.date)
            textField.addTarget(self, action: #selector(self.textfieldEditingChanged), for: .editingChanged)
        }
        
        let action_Ok = UIAlertAction(title: "OK", style: .default) { action in
            //keep取貨時間
            g_headerInfo.date = NetWorkController.shared.getOrderHeaderDateTime(date: datePicker.date)
            //儲存資料到AirTable
            self.saveDataToAirTable()
        }
        
        let action_Cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        action_Ok.isEnabled = false
        
        alertController.addAction(action_Ok)
        alertController.addAction(action_Cancel)
        alertController.view.tintColor = .systemBlue
        
    }
    
    //判斷所選擇時間是否符合規格
    //    func checkDateTime(date: Date, alert: UIAlertController){
    //
    //        if let textFields = alertController.textFields?.first,
    //           let datePicker = textFields.inputView as? UIDatePicker,
    //           let action = alertController.actions.first{
    //
    //            //只能點未來一小時的
    //            if datePicker.date > Date().addingTimeInterval(60 * 60){
    //                action.isEnabled = true
    //            }else{
    //                action.isEnabled = false
    //            }
    //
    //        }
    //
    //    }
    
    //設定每分鐘更新alert中的textFields、datePicker時間
    //    func setCheckTimer(){
    //        if timer == nil {
    //            timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateAlert), userInfo: nil, repeats: true)
    //        }
    //    }
    
    //更新Alert裡面的textFields、datePicker
    func updateAlert(){
        
        if let textFields = alertController.textFields?.first,
           let datePicker = textFields.inputView as? UIDatePicker,
           let action = alertController.actions.first{
            
            textFields.text = getOneHourLaterDateTime().dateString
            datePicker.minimumDate = getOneHourLaterDateTime().date
            datePicker.setDate(getOneHourLaterDateTime().date, animated: true)
            action.isEnabled = true
            
        }
        
    }
    
    //取得一小時後的時間以及字串
    func getOneHourLaterDateTime() -> (dateString: String , date: Date){
        
        let date = Date().addingTimeInterval(60 * 60)
        let string = NetWorkController.shared.getOrderHeaderDateTime(date: date)
        
        return (string,date)
    }
    
    
    //點擊送出
    @IBAction func clickSend(_ sender: UIBarButtonItem){
        //檢查購物車是否為空
        if g_cartData.isEmpty {
            
            NetWorkController.shared.showAlert(title: "警告", message: "購物車無資料") { alert in
                self.present(alert, animated: true, completion: nil)
            }
            
            return
        }
        
        //更新alertController中textFields、datePicker時間
        updateAlert()
        //顯示alert
        present(alertController, animated: true, completion: nil)
        
    }
    
    //textfield值改變會觸發
    @objc func textfieldEditingChanged(sender: UITextField){
        guard let datePicker = alertController.textFields?.first?.inputView as? UIDatePicker else { return }
        
        sender.text = NetWorkController.shared.getOrderHeaderDateTime(date: datePicker.date)
        
    }
    
    //datePicker值改變會觸發
    @objc func datePickerEditingChanged(sender: UIDatePicker){
        
        if let textField = alertController.textFields?[0] ,
           let action = alertController.actions.first{
            
            textField.text = NetWorkController.shared.getOrderHeaderDateTime(date: sender.date)
            
            //只能點未來一小時的
            if sender.date > Date().addingTimeInterval(60 * 60){
                action.isEnabled = true
            }else{
                action.isEnabled = false
            }
        }
    }
    
    //存資料到AirTable
    func saveDataToAirTable(){
        
        /*===================組表頭===================*/
        orderHeader = OrderHeader(records: [OrderHeader.Records]())
        
        var orderNumber = NetWorkController.shared.getOrderHeaderDate(date: Date())
        
        NetWorkController.shared.fetchOrderHeader(urlString: NetWorkController.getOrderHeaderURL, where: (field: "orderNumber", value: orderNumber)) { result in
            
            switch result{
                
            case.failure:
                orderNumber += "000001"
                
            case.success(var result):
                
                //倒序
                result.records.sort { records1, records2 in
                    return records2.fields.orderNumber < records1.fields.orderNumber
                }
                //判斷result是否為空陣列
                if !result.records.isEmpty{
                    let num = result.records.first!.fields.orderNumber
                    let startIndex = num.index(num.startIndex, offsetBy: 8)
                    
                    //endIndex是最後一個字的下一個
                    let string = num[startIndex..<num.endIndex]
                    var number = Int(string)!
                    //號碼+1
                    number += 1
                    //轉文字合併字串
                    orderNumber += NetWorkController.shared.getFrontZero(count: 6, value: number)
                    
                }else{
                    
                    orderNumber += "000001"
                    
                }
            }
            
            if let date = g_headerInfo.date,
               let phone = g_headerInfo.phone,
               let userName = g_headerInfo.userName,
               let consigneeName = g_headerInfo.consigneeName{
                
                let field = OrderHeader.Records.Fields(orderNumber: orderNumber, userName: userName, date: date, phone: phone, consigneeName: consigneeName, status: Status.send.statusText, totalPrice: self.total)
                
                let records = OrderHeader.Records(fields: field)
                
                self.orderHeader.records.append(records)
                /*===================上傳表頭===================*/
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(self.loadingVC, animated: false)
                }
                
                
                NetWorkController.shared.postOrderHeader(urlString: NetWorkController.orderHeaderURL, orderHeader: self.orderHeader) { result in
                    
                    switch result{
                        
                    case .failure(let error):
                        
                        var errorMessage = ""
                        
                        switch error{
                        case .invalidData:
                            errorMessage = "invalidData"
                        case .invalidJsonFormat:
                            errorMessage = "invalidJsonFormat"
                        case .invalidResponse:
                            errorMessage = "invalidResponse"
                        case .invalidurl:
                            errorMessage = "invalidurl"
                        case .requestFailed:
                            errorMessage = "requestFailed"
                        }
                        
                        DispatchQueue.main.async {
                            NetWorkController.shared.showAlert(title: "警告", message: "訂單建立失敗" + errorMessage) { alert in
                                
                                self.present(alert, animated: true) {
                                    
                                    DispatchQueue.main.async {
                                        self.navigationController?.popViewController(animated: false)
                                    }
                                }
                            }
                        }
                        
                    case .success(let orderHeader):
                        /*===================組表身===================*/
                        
                        let orderItem = self.combineorderItem(orderHeaderID: (orderHeader.records.first!.id)!)
                        
                        /*===================上傳表身===================*/
                        NetWorkController.shared.postOrderItem(urlString: NetWorkController.orderItemURL, orderItem: orderItem) { result in
                            
                            switch result {
                            case .failure(let error):
                                print("失敗")
                                
                                switch error{
                                case .requestFailed:
                                    print("requestFailed")
                                case .invalidurl:
                                    print("invalidurl")
                                case .invalidResponse:
                                    print("invalidResponse")
                                case .invalidJsonFormat:
                                    print("invalidJsonFormat")
                                case .invalidData:
                                    print("invalidData")
                                }
                                
                            case .success(let orderItem):
                                    
                                    DispatchQueue.main.async {
                                        //刪除購物車資料
                                        self.removeCartTable()
                                        
                                        NetWorkController.shared.showAlert(title: "通知", message: "訂單建立成功") { alert in
                                            
                                            self.present(alert, animated: true) {
                                                
                                                DispatchQueue.main.async {
                                                    self.navigationController?.popViewController(animated: false)
                                                }
                                                
                                            }
                                        }
                                    }
                            }
                        }
                    }
                }
                
            }
            
        }
    }
    //組orderItem
    func combineorderItem(orderHeaderID: String) -> OrderItem{
        
        var orderItem = OrderItem.init(records: [OrderItem.Records]())
        
        var itemNumber = 0
        
        for cart in g_cartData {
            
            itemNumber += 1
            
            let itemNumberString = NetWorkController.shared.getFrontZero(count: 3, value: itemNumber)
            
            let fields = OrderItem.Records.Fields(orderItemNumber: itemNumberString, orderNumber: [orderHeaderID],itemID: [cart.itemID], ice: cart.ice.rawValue, sugar: cart.sugar.rawValue, quantity: cart.quantity,bubble: cart.bubble == true ? cart.bubble:nil , subPrice: cart.price)
            
            let record = OrderItem.Records(fields: fields)
            
            orderItem.records.append(record)
        }
        
        return orderItem
    }
    
    func removeCartTable(){
        
        guard let cartTVC = children.first as? CartTableViewController else { return }
        
        //移除購物車資料
        g_cartData.removeAll()
        //刷新table
        cartTVC.tableView.reloadData()
        //更新總金額
        setTotalPrice()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
