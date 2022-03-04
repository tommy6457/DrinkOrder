//
//  ViewController.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/2/8.
//

import UIKit

class UserViewController: UIViewController {
    
    internal init?(userName: String? = nil, coder: NSCoder) {
        super.init(coder: coder)
        self.userName = userName
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var userName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

