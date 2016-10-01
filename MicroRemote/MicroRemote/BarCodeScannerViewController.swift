//
//  BarCodeScannerViewController.swift
//  MicroRemote
//
//  Created by Jeff Zotz on 10/1/16.
//  Copyright © 2016 Jeff Zotz. All rights reserved.
//

import UIKit
import AVFoundation

class BarCodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate
{
  /// Helper property and not directly used. The camera layer's bounds will be set to this.
  @IBOutlet weak var cameraView: UIView!
  /// Will show the type of metadata being displayed.
  @IBOutlet weak var lblDataType: UILabel!
  /// Will show the information from the capture metadata.
  @IBOutlet weak var lblDataInfo: UILabel!
  
  //MARK: Properties
  /// Runs the capture session.
  let captureSession = AVCaptureSession()
  /// The device used as input for the capture session.
  var captureDevice:AVCaptureDevice?
  /// The UI layer to display the feed from the input source, in our case, the camera.
  var captureLayer:AVCaptureVideoPreviewLayer?
  
  //MARK: View lifecycle
  override func viewDidLoad()
  {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool)
  {
    super.viewDidAppear(animated)
    
    
    
    self.setupCaptureSession()
  }
  
  //MARK: Session Startup
  /**
   Begins the capture session.
   */
  private func setupCaptureSession()
  {
    self.captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    //let setupError:NSError?
    
    do {
      let deviceInput = try AVCaptureDeviceInput.init(device: captureDevice) as AVCaptureDeviceInput
    
      //Add the input feed to the session and start it
      self.captureSession.addInput(deviceInput)
      self.setupPreviewLayer(completion: {
        self.captureSession.startRunning()
        self.addMetaDataCaptureOutToSession()
      })
    } catch {
      self.showError(error: "Error setting up device input")
    }
  }
  
  /**
   Handles setting up the UI to show the camera feed.
   
   :param: completion Completion handler to invoke if setting up the feed was successful.
   */
  private func setupPreviewLayer(completion:() -> ())
  {
    self.captureLayer = AVCaptureVideoPreviewLayer(session: self.captureSession) as AVCaptureVideoPreviewLayer
    
    if let capLayer = self.captureLayer
    {
      capLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
      capLayer.frame = self.cameraView.frame
      self.view.layer.addSublayer(capLayer)
      completion()
    } else {
      self.showError(error: "An error occured beginning video capture.")
    }
  }
  
  //MARK: Metadata capture
  /**
   Handles identifying what kind of data output we want from the session, in our case, metadata and the available types of metadata.
   */
  private func addMetaDataCaptureOutToSession()
  {
    let metadata = AVCaptureMetadataOutput()
    self.captureSession.addOutput(metadata)
    metadata.metadataObjectTypes = metadata.availableMetadataObjectTypes
    metadata.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
  }
  
  //MARK: Delegate Methods
  func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
    //for metaData in metadataObjects
    //{
      //let decodedData:AVMetadataMachineReadableCodeObject = metaData as! AVMetadataMachineReadableCodeObject
  
      //self.lblDataInfo.text = decodedData.stringValue
      //self.lblDataType.text = decodedData.type
      
    if let metadataObject = metadataObjects.first {
      let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
      
      AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
      //found(code: readableObject.stringValue);
      self.lblDataInfo.text = readableObject.stringValue
      self.lblDataType.text = readableObject.type
      NSLog(readableObject.stringValue)
      NSLog(readableObject.type)

    }
    
    self.captureSession.stopRunning()
    self.captureLayer?.removeFromSuperlayer()
    self.captureLayer = nil
    //}
  }
  
  //MARK: Utility Functions
  /**
   Shows any error that may occur via an alert view.
   
   :param: error The error message.
   */
  private func showError(error:String)
  {
    let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
    let dismiss:UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler:{(alert:UIAlertAction!) in
      alertController.dismiss(animated: true, completion: nil)
    })
    alertController.addAction(dismiss)
    self.present(alertController, animated: true, completion: nil)
  }
  
}