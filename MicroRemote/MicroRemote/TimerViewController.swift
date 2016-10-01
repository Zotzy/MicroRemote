//
//  TimerViewController.swift
//  MicroRemote
//
//  Created by Jeff Zotz on 10/1/16.
//  Copyright © 2016 Jeff Zotz. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
  
  @IBOutlet weak var currentState: UILabel!
  @IBOutlet weak var timerLabel: UILabel!
  
  
  var cookTime = 90
  var waitTime = 20
  
  var timer = Timer()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
		
		
		
		
		var httpWrapper = HttpWrapper.sharedInstance
		
		//		getCookTime(upc: "54321", completion: printData)
		
		//		updateCookTime(upc: "54321", name: "noodles", cookTime: 90, waitTime: 90)
		
		httpWrapper.getCookTime(upc: "54321", completion: httpWrapper.printData)
		
		httpWrapper.updateCookTime(upc: "54321", name: "noodles", cookTime: 90, waitTime: 90)
		
		
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @IBAction func startCooking(_ sender: AnyObject) {
    currentState.text! = "Cooking..."
    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
  }
  
  func tick() {
    if (currentState.text! == "Cooking..."){
      if (cookTime >= 0) {
        let seconds = cookTime % 60
        let minutes = (cookTime - seconds) / 60
        timerLabel.text! = String(format: "%2d:%.2d", arguments: [minutes, seconds])
        cookTime = cookTime - 1
      } else {
        currentState.text! = "Waiting..."
      }
    } else if (currentState.text! == "Waiting...") {
      if (waitTime >= 0) {
        let seconds = waitTime % 60
        let minutes = (waitTime - seconds) / 60
        timerLabel.text! = String(format: "%2d:%.2d", arguments: [minutes, seconds])
        waitTime = waitTime - 1
      } else {
        currentState.text! = "Done!"
      }
    }
  }
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */

}
