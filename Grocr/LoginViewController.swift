/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import Firebase

class LoginViewController: UIViewController {
  
  // MARK: Constants
  let loginToList = "LoginToList"
  
  // MARK: Outlets
  @IBOutlet weak var textFieldLoginEmail: UITextField!
  @IBOutlet weak var textFieldLoginPassword: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    FIRAuth.auth()!.addStateDidChangeListener { (auth, user) in
      if user != nil {
        print("User \(user?.email) logged in")
        self.performSegue(withIdentifier: self.loginToList, sender: nil)
      }
    }
  }
  
  // MARK: Actions
  @IBAction func loginDidTouch(_ sender: AnyObject) {
    FIRAuth.auth()!.signIn(withEmail: textFieldLoginEmail.text!,
                           password: textFieldLoginPassword.text!)
  }
  
  @IBAction func signUpDidTouch(_ sender: AnyObject) {
    
    if let email = textFieldLoginEmail.text,
      let password = textFieldLoginPassword.text {
      
      FIRAuth.auth()!.createUser(withEmail: email, password: password, completion: { (user, error) in
        if error == nil {
          // sign in that newly created user
          FIRAuth.auth()!.signIn(withEmail: email,
                                 password: password, completion: nil)
        } else {
          self.showAlert(title: "Error", content: error!.localizedDescription)
        }
      })
    } else {
      self.showAlert(title: "Error", content: "Pls enter email/password")
    }
    
  }
  
}

extension LoginViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == textFieldLoginEmail {
      textFieldLoginPassword.becomeFirstResponder()
    }
    if textField == textFieldLoginPassword {
      textField.resignFirstResponder()
    }
    return true
  }
  
}

extension UIViewController {
  func showAlert(title: String, content: String) {
    let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
}
