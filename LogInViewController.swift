//
//  LogInViewController.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/2/23.
//

import UIKit

class LogInViewController: UIViewController {
   
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var signUPButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func textFieldDidEndOnExit(_ sender: Any) {}
    
    @IBAction func clickLogIn(_ sender: Any) {
        
        //檢查帳號是否為空
        if userNameTextField.text!.isEmpty {
            //alert
            NetWorkController.shared.showAlert(title: "警告", message: "請輸入使用者名稱") { alert in
                self.present(alert, animated: true, completion: nil)
            }
            
            return
        }
        
        //檢查帳號是否為空
        if passwordTextField.text!.isEmpty {
            //alert
            NetWorkController.shared.showAlert(title: "警告", message: "請輸入密碼") { alert in
                self.present(alert, animated: true, completion: nil)
            }
            
            return
        }
        
        //登入
        var errorMessage = ""
        AccountController.shared.userLogin(userName: userNameTextField.text!, password: passwordTextField.text!) { result in
            
            DispatchQueue.main.sync {
                switch result {
                case .failure(let error):

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
                    case .other(let otherMessage):
                        errorMessage = otherMessage
                    }
                    
                    g_headerInfo.userName = nil
                    NetWorkController.shared.showAlert(title: "警告", message: "請檢查帳號密碼\n\(errorMessage)") { alert in
                        self.present(alert, animated: true, completion: nil)
                    }

                case .success(let loginResponse):
                    
                    if loginResponse.status == "SUCCESS" {
                        
//                        NetWorkController.shared.showAlert(title: "提示", message: "登入成功") { alert in
//                            self.present(alert, animated: true)
//                        }
                        
                        //收鍵盤
                        self.userNameTextField.resignFirstResponder()
                        self.passwordTextField.resignFirstResponder()
                        
                        //keep userName
                        g_headerInfo.userName = self.userNameTextField.text
                        
                        //去下一頁
                        if let userVC = self.storyboard?.instantiateViewController(withIdentifier: "\(UserViewController.self)"){
                            
                            
                            self.navigationController?.pushViewController(userVC, animated: true)
                            
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
