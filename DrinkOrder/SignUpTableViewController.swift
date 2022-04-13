//
//  LogUpTableViewController.swift
//  DrinkOrder
//
//  Created by 蔡尚諺 on 2022/3/23.
//

import UIKit

class SignUpTableViewController: UITableViewController {

    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkPasswordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func textFieldDidEndOnExit(_ sender: Any) {}
    
    @IBAction func clickCreateAccount(_ sender: Any) {
        
        //檢查輸入
        if let error = AccountController.shared.checkPasswordFormat(pattern: "[A-Za-z0-9@.]", password: userNameTextField.text!){

            AccountController.shared.showAlert(title: "警告", message: "帳號錯誤：\(error)") { alert in

                self.present(alert, animated: true, completion: nil)
            }
            return
        }

        if let error = AccountController.shared.checkPasswordFormat(pattern: "[A-Za-z0-9]", password: passwordTextField.text!){

            AccountController.shared.showAlert(title: "警告", message: "密碼錯誤：\(error)") { alert in

                self.present(alert, animated: true, completion: nil)
            }
            
            return
        }

        if passwordTextField.text! != checkPasswordTextField.text! {

            AccountController.shared.showAlert(title: "警告", message: "密碼與確認密碼輸入不同") { alert in

                self.present(alert, animated: true, completion: nil)
            }
            
            return
        }

        if let error = AccountController.shared.checkPasswordFormat(pattern: "", password: firstNameTextField.text!){

            AccountController.shared.showAlert(title: "警告", message: "名字錯誤：\(error)") { alert in

                self.present(alert, animated: true, completion: nil)
            }
        }

        if let error = AccountController.shared.checkPasswordFormat(pattern: "", password: lastNameTextField.text!){

            AccountController.shared.showAlert(title: "警告", message: "姓氏錯誤：\(error)") { alert in

                self.present(alert, animated: true, completion: nil)
            }
        }
        //Call API 建立帳號
        let createUserBody = CreateUserBody(profile: CreateUserBody.Profile(firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, email: userNameTextField.text!, login: userNameTextField.text!), credentials: CreateUserBody.Credentials(password: passwordTextField.text!))
      
        AccountController.shared.createUserwithPassword(createUserBody: createUserBody) { result in
            
            switch result {
            case .success(let result):
                
                DispatchQueue.main.async {
                    AccountController.shared.showAlert(title: "訊息", message: "帳號建立成功!") { alert in
                        self.present(alert, animated: true){
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                
            case .failure(let error):
                
                var message = ""
                    
                switch error {
                case .invalidurl:
                    message = "invalidurl"
                case .invalidJsonFormat:
                    message = "invalidJsonFormat"
                case .invalidResponse:
                    message = "invalidResponse"
                case .requestFailed:
                    message = "requestFailed"
                case .invalidData:
                    message = "invalidData"
                case .other(let otherErrorMessage):
                    message = otherErrorMessage
                }
                
                DispatchQueue.main.async {
                    AccountController.shared.showAlert(title: "警告", message: "帳號建立失敗:\n\(message)") { alert in
                        self.present(alert, animated: true)
                    }
                }
                
            }
            
        }
        
        //收鍵盤
        view.endEditing(true)
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //收鍵盤
        view.endEditing(true)
        //取消選擇
        tableView.deselectRow(at: indexPath, animated: true)
    }

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

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
