//
//  LogInViewController.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/2/23.
//

import UIKit

class LogInViewController: UIViewController {

    
    @IBOutlet weak var userNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if userNameTextField.text!.isEmpty {
            //alert
            NetWorkController.shared.showAlert(title: "警告", message: "請輸入使用者名稱") { alert in
                self.present(alert, animated: true, completion: nil)
            }
            
            return false
        }
        //keep 使用者名稱
        g_headerInfo.userName = userNameTextField.text
        
        return true
    }
    
    @IBAction func textFieldDidEndOnExit(_ sender: Any) {}
    
    @IBSegueAction func toUserPage(_ coder: NSCoder) -> UserViewController? {
        
        userNameTextField.resignFirstResponder()
        
        return UserViewController(userName: userNameTextField.text, coder: coder)
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
