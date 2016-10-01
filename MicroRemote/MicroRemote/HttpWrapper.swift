//
//  HttpWrapper.swift
//  MicroRemote
//
//  Created by Reece Boyd on 10/1/16.
//  Copyright © 2016 Jeff Zotz. All rights reserved.
//

import UIKit

class HttpWrapper {
	static let sharedInstance = HttpWrapper()
	
	private var serverUrl = "http://10.140.110.185:8080"
	
	func doCook(upc: String) -> Void {
		let request = NSMutableURLRequest(url: NSURL(string: serverUrl + "/get_cooktime")! as URL)
		let session = URLSession.shared
		request.httpMethod = "POST"
		
		let params = ["upc":upc] as Dictionary<String, String>
		
		request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
		
		let key = KeychainSwift()
		
		if let pass = key.get("password") {
			let dataString = String(data: request.httpBody!, encoding: .utf8)
			let encryptedJSON = AES256CBC.encryptString(dataString!, password: pass)
			let encryptedJSONData = encryptedJSON?.data(using: .utf8)
			request.httpBody = encryptedJSONData
		} else {
			let pass = AES256CBC.generatePassword()
			key.set(pass, forKey: "password")
			let dataString = String(data: request.httpBody!, encoding: .utf8)
			let encryptedJSON = AES256CBC.encryptString(dataString!, password: pass)
			let encryptedJSONData = encryptedJSON?.data(using: .utf8)
			request.httpBody = encryptedJSONData
		}
		
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		
		let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
		})
		task.resume()
	}
	
	func getCookTime(upc: String, completion: ((Bool, String, Int, Int) -> Void)!) -> Void {
		var success = false
		var name = ""
		var cookTime = -1
		var waitTime = -1
		
		let request = NSMutableURLRequest(url: NSURL(string: serverUrl + "/get_cooktime")! as URL)
		let session = URLSession.shared
		request.httpMethod = "POST"
		
		let params = ["upc":upc] as Dictionary<String, String>
		
		request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
		
		let key = KeychainSwift()
		
		if let pass = key.get("password") {
			let dataString = String(data: request.httpBody!, encoding: .utf8)
			let encryptedJSON = AES256CBC.encryptString(dataString!, password: pass)
			let encryptedJSONData = encryptedJSON?.data(using: .utf8)
			request.httpBody = encryptedJSONData
		} else {
			let pass = AES256CBC.generatePassword()
			key.set(pass, forKey: "password")
			let dataString = String(data: request.httpBody!, encoding: .utf8)
			let encryptedJSON = AES256CBC.encryptString(dataString!, password: pass)
			let encryptedJSONData = encryptedJSON?.data(using: .utf8)
			request.httpBody = encryptedJSONData
		}

		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		
		let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
			if let httpResponse = response as? HTTPURLResponse {
				if (httpResponse.statusCode == 200) {
					let responseString = String(data: data!, encoding: .utf8)
					
					// decode the json and put store data into variables
					let data = responseString?.data(using: .utf8)!
					
					let json = try? JSONSerialization.jsonObject(with: data!) as! NSDictionary
					print("Le JSON Derulo: \(json)")
					
					success = true
					
					name = json?["name"] as! String
					cookTime = json?["cook_time"] as! Int
					waitTime = json?["wait_time"] as! Int
        }
        completion(success, name, cookTime, waitTime)
			}
			
		})
		task.resume()
	}
	
	func updateCookTime(upc: String, name: String = "", cookTime: Int = -1, waitTime: Int = -1) {
		let request = NSMutableURLRequest(url: NSURL(string: serverUrl + "/update_cooktime")! as URL)
		let session = URLSession.shared
		request.httpMethod = "POST"
		
		var params: Dictionary<String, String> = [:]
		
		params["upc"] = upc
		
		if (name != "") {
			params["name"] = name
		}
		if (cookTime != -1) {
			params["cook_time"] = String(cookTime)
		}
		if (waitTime != -1) {
			params["wait_time"] = String(waitTime)
		}
		
		request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
		
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		
		let task = session.dataTask(with: request as URLRequest)
		task.resume()
	}

	func printData(success: Bool, name: String, cookTime: Int, waitTime: Int) -> Void {
		print("Success: \(success), Name: \(name), cookTime: \(cookTime), waitTime: \(waitTime)")
	}
	
}
