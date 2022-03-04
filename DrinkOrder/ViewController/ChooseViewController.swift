//
//  ChooseViewController.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/2/14.
//

import UIKit

class ChooseViewController: UIViewController {
    
    var item: Menu.Records.Fields!
    //數量
    var currentQuantity: Int = 0
    //總金額
    var price: Int = 0

    @IBOutlet weak var quantityLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setChooseTableViewController()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickPlusMinus(_ sender: UIButton) {
        
        //減
        if sender.tag == 0 {
            currentQuantity -= 1
            
            if currentQuantity < 0 {
                currentQuantity = 0
            }
        }
        //加
        else{
            currentQuantity += 1
        }
        
        quantityLabel.text = "\(currentQuantity)"
        
        //計算金額
        countPrice()
    }
    
    @IBAction func clickAddToCart(_ sender: UIButton) {
        
        //檢查是否都有選擇飲料屬性＆數量
        self.children.forEach { viewController in
            
            guard let chooseTableViewController = viewController as? ChooseTableViewController else {
                return }
            
            if let ice = chooseTableViewController.currentIceAttribute,
               let sugar = chooseTableViewController.currentSugarAttribute,
               let size = chooseTableViewController.currentSizeAttribute,
               currentQuantity != 0,
               price != 0
            {
                
                let cartData = Cart(ice: ice, sugar: sugar, size: size, bubble: chooseTableViewController.currentAddBubble ,quantity: currentQuantity,price: price, itemID: item.recordID , itemName: item.itemName)
                
                g_cartData.append(cartData)
                
                setAlert(title: "已新增至購物車")
            }else{
                setAlert(title: "請輸入完整資訊")
            }
            
        }
        
    }
    //計算金額
    func countPrice(){
        //計算金額
        self.children.forEach { viewController in
            var currentPrice = 0
            guard let chooseTableViewController = viewController as? ChooseTableViewController else {
                return }
            //金額先歸零
            chooseTableViewController.priceLabel.text = "\(currentQuantity * currentPrice)"
            
            guard let currentSizeAttribute = chooseTableViewController.currentSizeAttribute else { return }
            
            guard let currentIceAttribute = chooseTableViewController.currentIceAttribute else { return }
            
                switch currentSizeAttribute {
                case .M:
                    //熱飲只有M的價格
                    if currentIceAttribute == .hot {
                        currentPrice = Int(chooseTableViewController.item.hotMPrice ?? 0)
                    }else{
                        currentPrice = Int(chooseTableViewController.item.coldMPrice ?? 0)
                    }
                    
                case .L:
                    currentPrice = Int(chooseTableViewController.item.coldLPrice ?? 0)
                }
            
            if chooseTableViewController.currentAddBubble {
                price = currentQuantity * currentPrice + 5 * currentQuantity
                chooseTableViewController.priceLabel.text = "\(price)"
            }else{
                price = currentQuantity * currentPrice
                chooseTableViewController.priceLabel.text = "\(price)"
            }
            
        }
    }
    
    //跳出alert訊息
    func setAlert(title: String){
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    //初始設定ChooseTableViewController
    func setChooseTableViewController(){
        self.children.forEach { viewController in
            
            guard let chooseTableViewController = viewController as? ChooseTableViewController else {
                return }
            
            chooseTableViewController.item = item
            chooseTableViewController.initialUI()
        }
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
