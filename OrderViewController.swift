//
//  OrderViewController.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/2/28.
//

import UIKit

class OrderViewController: UIViewController {
    /*Loading View*/
    var loadingVC: LoadingViewController!
    /*EmptyView*/
    @IBOutlet weak var emptyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Loading
        loadingVC = storyboard?.instantiateViewController(withIdentifier: "\(LoadingViewController.self)") as! LoadingViewController
        
        navigationController?.pushViewController(self.loadingVC, animated: false)
        
        setOrderTableViewController()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emptyView.layer.cornerRadius = emptyView.bounds.width / 10
    }
    
    func setOrderTableViewController(){
        
        
        children.forEach { controller in
            
            guard let OrderTVC = controller as? OrderTableViewController else { return  }
            
            NetWorkController.shared.fetchOrderHeader(urlString: NetWorkController.getOrderHeaderURL, where: (field: "userName", value: g_headerInfo.userName)) { result in
                
                switch result {
                case .success(let orderHeader):
                    OrderTVC.orderHeader = orderHeader
                    DispatchQueue.main.async {
                        
                        OrderTVC.tableView.reloadData()
                        
                        self.navigationController?.popViewController(animated: false)
                        
                        if orderHeader.records.isEmpty {
                            self.emptyView.isHidden = false
                        }else{
                            self.emptyView.isHidden = true
                        }
                        
                    }
                case .failure:
                    
                    DispatchQueue.main.async {
                        NetWorkController.shared.showAlert(title: "訊息", message: "訂單讀取失敗") { alert in
                            self.present(alert, animated: true){
                                DispatchQueue.main.async {
                                    self.navigationController?.popViewController(animated: false)
                                    self.navigationController?.popViewController(animated: false)
                                }
                            }
                            
                        }
                    }
                }
            }
            
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
