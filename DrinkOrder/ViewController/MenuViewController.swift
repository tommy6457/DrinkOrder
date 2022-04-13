//
//  MenuViewController.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/2/8.
//

import UIKit

class MenuViewController: UIViewController {
    
    /*當前頁面*/
    var currentPage = 0
    
    /*飲料品項ContainerView*/
    @IBOutlet weak var itemContainerView: UIView!
    
    /* JSON 檔案*/
    var drinkTypes: DrinkType?
    var menu: Menu?
    
    /*MenuButtons*/
    @IBOutlet weak var buttonsStackView: UIStackView!
    
    /*Loading View*/
    var loadingVC: LoadingViewController!
    
    /*底線*/
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var underlineViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var underlineViewCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var underlineViewTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //標題
        self.title = "MENU"
        //Loading
        loadingVC = storyboard?.instantiateViewController(withIdentifier: "\(LoadingViewController.self)") as! LoadingViewController
        
        navigationController?.pushViewController(loadingVC, animated: false)
        
        //抓飲料類別資料
        NetWorkController.shared.fetchDrinkType(urlString: "\(NetWorkController.getDrinkTypeURL)") { result in
            //根據結果判斷
            switch result {
            case .success(let drinkTypes):
                
                self.drinkTypes = drinkTypes
                
                DispatchQueue.main.async {
                    
                    for (index,records) in drinkTypes.records.enumerated() {
                        //設定MenuButton
                        self.setMenuButton(index: index, records: records)
                    }
                    
                    //設定底線&同步頁面資訊
                    self.setUnderLineView(index: self.currentPage)
                    //抓menu所有資料
                    NetWorkController.shared.fetchMenu(urlString: "\(NetWorkController.getMenuURL)") { result in
                        //根據結果判斷
                        switch result {
                        case .success(let menu):
                            
                            self.menu = menu
                            
                            DispatchQueue.main.async {
                                self.setItemTableViewController(currentpage: self.currentPage)
                                self.navigationController?.popViewController(animated: false)
                                
                            }
                            
                        case.failure(let error):
                            var errorMessage = ""
                            switch error {
                            case .invalidurl:
                                errorMessage = "invalidurl"
                                
                            case .invalidJsonFormat:
                                errorMessage = "invalidJsonFormat"
                            case .invalidData:
                                errorMessage = "invalidData"
                            case .requestFailed:
                                errorMessage = "requestFailed"
                            case .invalidResponse:
                                errorMessage = "invalidResponse"
                            case .other:
                                errorMessage = "other"
                            }
                            
                            
                            NetWorkController.shared.showAlert(title: "警告", message: "資料抓取錯誤：\(errorMessage)") { alert in
                                DispatchQueue.main.async {
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
                
                
            case.failure(let error):
                
                var errorMessage = ""
                
                switch error {
                case .invalidurl:
                    errorMessage = "invalidurl"
                    
                case .invalidJsonFormat:
                    errorMessage = "invalidJsonFormat"
                case .invalidData:
                    errorMessage = "invalidData"
                case .requestFailed:
                    errorMessage = "requestFailed"
                case .invalidResponse:
                    errorMessage = "invalidResponse"
                case .other:
                    errorMessage = "other"
                }
                DispatchQueue.main.async {
                    NetWorkController.shared.showAlert(title: "警告", message: "資料抓取錯誤：\(errorMessage)") { alert in
                        
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
    //點擊MenuButton對應method
    @objc func clickMenu(sender: UIButton){
        currentPage = sender.tag
        setUnderLineView(index: sender.tag)
        setItemTableViewController(currentpage: sender.tag)
    }
    //根據設定檔新增Button
    func setMenuButton(index: Int, records: DrinkType.Records){
        
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: records.fields.typeName, attributes: [.foregroundColor: UIColor(named: "AccentColor")!, .font: UIFont(name: "Songti TC", size: 15)!]), for: .normal)
        button.tag = index
        button.addTarget(self, action: #selector(self.clickMenu), for: .touchUpInside)
        //stackView要使用addArrangedSubview
        buttonsStackView.addArrangedSubview(button)
        
    }
    //根據Button調整底線位置
    func setUnderLineView(index: Int){
        
        let button = buttonsStackView.arrangedSubviews[index]
        
        underlineView.isHidden = false
        underlineViewWidthConstraint.isActive = false
        underlineViewCenterXConstraint.isActive = false
        underlineViewTopConstraint.isActive = false
        
        underlineViewWidthConstraint = underlineView.widthAnchor.constraint(equalTo: button.widthAnchor)
        
        underlineViewCenterXConstraint = underlineView.centerXAnchor.constraint(equalTo: button.centerXAnchor)
        
        underlineViewTopConstraint = underlineView.topAnchor.constraint(equalTo: button.bottomAnchor)
        
        underlineViewWidthConstraint.isActive = true
        underlineViewCenterXConstraint.isActive = true
        underlineViewTopConstraint.isActive = true
        
        UIViewPropertyAnimator.init(duration: 0.3, curve: .easeInOut) {
            self.view.layoutIfNeeded()
        }.startAnimation()
        
    }
    
    //更新ItemTableViewController的值
    func setItemTableViewController(currentpage: Int){
        
        self.children.forEach { viewController in
            
            guard let itemTableViewController = viewController as? ItemTableViewController else { return }
            
            guard let itemMenu = getItemMenu(from: currentPage) else { return }
            
            //給item值
            itemTableViewController.currentMenu = itemMenu
            //更新tableview
            itemTableViewController.tableView.reloadData()
            //向右滑入cell動畫
            itemTableViewController.tableView.reloadSections(IndexSet(integer: 0), with: .right)
            
            //換頁要滑到最上面
            itemTableViewController.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }
    }
    
    //根據飲料分類取得相對應的品項
    func getItemMenu(from currentPage: Int) -> [Menu.Records]? {
        
        let records = menu?.records.filter({ result in
            return result.fields.type == drinkTypes?.records[currentPage].fields.typeID
        })
        
        return records
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
