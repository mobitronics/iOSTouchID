//
//  ViewController.swift
//  TouchIDDemo_Swift
//
//  Created by Pranay on 26/07/16.
//  Copyright © 2016 mobitronics. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
  
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!

  var context = LAContext()
  
  let defaultUsername = "Username"
  let defaultPassword = "Password"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Add TapGesture to View to hide the Keyboard
    let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureRecognizer(tapGestureRecognizer:)))
    self.view.addGestureRecognizer(tapGesture)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  //MARK: Tap Gesture Method
  /*
   Tap Gesture Recognizer method to recignize the tap and hide keyboard
   */
  func tapGestureRecognizer(tapGestureRecognizer: UITapGestureRecognizer) {
    usernameTextField.resignFirstResponder()
    passwordTextField.resignFirstResponder()
  }

  //MARK: Action Methods
  /*
   Login button action method
   */
  @IBAction func loginButtonAction(_ sender: AnyObject) {
    if (usernameTextField.text == "" || passwordTextField.text == "") {
      //Show alert for empty username/password
      showAlertMessage(message: "username/password is empty!")
    } else if (usernameTextField.text != defaultUsername || passwordTextField.text != defaultPassword) {
      //Show alert for wrong username or password
      showAlertMessage(message: "username/password is not correct!")
    } else {
      usernameTextField.resignFirstResponder()
      passwordTextField.resignFirstResponder()
      //Show success alert
      showAlertMessage(message: "Logged in successfully!")
    }
  }
  
  /*
   Touch ID buton Action
   */
  @IBAction func touchIDButtonAction(_ sender:AnyObject) {

    if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error:nil) {

      context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                             localizedReason: "Logging in with Touch ID",
                             reply: { (success : Bool, error : NSError? ) -> Void in
                              
                              DispatchQueue.main.async {
                                if success {
                                  //Show success alert message
                                  self.showAlertMessage(message: "Logged in with Touch ID")
                                }
                                
                                if error != nil {
                                  
                                  switch(error!.code) {
                                  case LAError.authenticationFailed.rawValue:
                                    self.showAlertMessage(message: "There was a problem verifying your identity.")
                                    break;
                                  case LAError.userCancel.rawValue:
                                    self.showAlertMessage(message: "You pressed cancel.")
                                    break;
                                  case LAError.userFallback.rawValue:
                                    self.showAlertMessage(message: "You pressed password.")
                                    break;
                                  default:
                                    self.showAlertMessage(message: "Touch ID may not be configured")
                                    break;
                                  }
                                }
                              }
                              
      })
    } else {
      self.showAlertMessage(message: "Touch ID not available")
    }
  }
  
  //MARK: Other Methods
  /*
   Show alert message
   */
  func showAlertMessage(message: String) {
    let alert = UIAlertController.init(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
}

