//
//  ViewController.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/2/8.
//

import UIKit

class UserViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NetWorkController.shared.showAlert(title: "提示", message: "登入成功") { alert in
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func clickHistoryOrder(_ sender: Any) {
        //收鍵盤
        view.endEditing(true)
        
       let orderVC = storyboard?.instantiateViewController(withIdentifier: "\(OrderViewController.self)") as! OrderViewController
        
        navigationController?.pushViewController(orderVC, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //收鍵盤
        view.endEditing(true)
    }
}

