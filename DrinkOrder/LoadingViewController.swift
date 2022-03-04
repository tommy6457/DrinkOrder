//
//  LoadingViewController.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/3/3.
//

import UIKit

class LoadingViewController: UIViewController {
    
    //判斷是否取消讀取
    var cancel = false {
        willSet{
            if newValue == true{
                self.navigationController?.popViewController(animated: false)
            }
        }
    }
    
    @IBOutlet weak var loadingView: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    override func viewDidLayoutSubviews() {super.viewDidLayoutSubviews()
        loadingView.layer.cornerRadius = loadingView.bounds.width / 10
    }
    
    
    @IBAction func clickCancel(_ sender: Any) {
        
        cancel = true
        
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
