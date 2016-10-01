//
//  SubmissionViewController.swift
//  MicroRemote
//
//  Created by Jeff Zotz on 10/1/16.
//  Copyright © 2016 Jeff Zotz. All rights reserved.
//

import UIKit

class SubmissionViewController: UIViewController, UITextFieldDelegate {
  @IBOutlet weak var itemName: UITextField!
  @IBOutlet weak var cookMin: UITextField!
  @IBOutlet weak var cookSec: UITextField!
  @IBOutlet weak var waitMin: UITextField!
  @IBOutlet weak var waitSec: UITextField!
  
  let httpWrapper = HttpWrapper.sharedInstance
  
  var upc = ""
  var success = false
  var name = ""
  var cookTime = -1
  var waitTime = -1

  @IBAction func didSubmit(_ sender: AnyObject) {
    /*
    NSLog(String(describing: Int(upc)))
    NSLog(String(describing: Int(itemName.text!)))
    print(String(describing: Int(cookMin.text!)))
    NSLog(String(describing: Int(cookSec.text!)))
    NSLog(String(describing: Int(waitMin.text!)))
    NSLog(String(describing: Int(waitSec.text!)))
    */
    
    let httpWrapper = HttpWrapper.sharedInstance
    
    self.name = itemName.text!
    
    if Int(cookMin.text!) != nil {
      self.cookTime = Int(cookMin.text!)!*60
    } else {
      self.cookTime = 0
    }
    
    if Int(cookSec.text!) != nil {
      self.cookTime += Int(cookSec.text!)!
    }
    
    if Int(waitMin.text!) != nil {
      self.waitTime = Int(waitMin.text!)!*60
    } else {
      self.waitTime = 0
    }
    
    if Int(waitSec.text!) != nil {
      self.waitTime += Int(waitSec.text!)!
    }
    
    print("UPC: \(upc), Success: \(success), Name: \(name), cookTime: \(cookTime), waitTime: \(waitTime)")
    
    httpWrapper.updateCookTime(upc: self.upc, name: self.name, cookTime: self.cookTime, waitTime: self.waitTime)
    self.performSegue(withIdentifier: "cook", sender: self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SubmissionViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */

  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let maxLength = 2
    let currentString: NSString = textField.text! as NSString
    let newString: NSString =
      currentString.replacingCharacters(in: range, with: string) as NSString
    return newString.length <= maxLength
  }
  
  func dismissKeyboard() {
    //Causes the view (or one of its embedded text fields) to resign the first responder status.
    view.endEditing(true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if (segue.identifier == "cook") {
      // pass data
      let destVC = segue.destination as! TimerViewController
      destVC.upc = self.upc
      destVC.success = self.success
      destVC.name = self.name
      destVC.cookTime = self.cookTime
      destVC.waitTime = self.waitTime
    }
    
  }
  
}
