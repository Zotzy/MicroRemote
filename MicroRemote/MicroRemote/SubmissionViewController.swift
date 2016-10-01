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

  @IBAction func didSubmit(_ sender: AnyObject) {
    NSLog(itemName.text!)
    NSLog(cookMin.text!)
    NSLog(cookSec.text!)
    NSLog(waitMin.text!)
    NSLog(waitSec.text!)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
  
}
