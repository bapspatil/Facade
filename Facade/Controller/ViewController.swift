//
//  ViewController.swift
//  Facade
//
//  Created by Bapusaheb Patil on July 14,2018.
//  Copyright © 2018 Bapusaheb Patil. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var creationFrame: UIView!
    @IBOutlet weak var creationImageView: UIImageView!
    @IBOutlet weak var startOverButton: UIButton!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var colorsContainer: UIView!
    @IBOutlet weak var shareButton: UIButton!
    
    var creation = Creation.init()
    
    @IBAction func startOver(_ sender: Any) {
    }
    
    @IBAction func applyColor(_ sender: UIButton) {
    }
    
    @IBAction func share(_ sender: Any) {
        displayImagePicking()
    }
    
    func displayImagePicking() {
        let alertController = UIAlertController(title: "Pick image", message: "Choose an image to decorate", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Take a photo", style: .default) { (action) in
            // Launch camera
        }
        let libraryAction = UIAlertAction(title: "Pick from Gallery", style: .default) { (action) in
            self.displayLibrary()
        }
        let randomAction = UIAlertAction(title: "Random pic", style: .default) { (action) in
            // Pick random image
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // Cancel
        }
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(randomAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true) {
            // Code to execute after AlertController is shown
        }
    }
    
    func displayLibrary() {
        let sourceType = UIImagePickerControllerSourceType.photoLibrary
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization( { (newStatus) in
                    if newStatus == .authorized {
                        self.presentImagePicker(sourceType)
                    } else {
                        self.troubleAlert("Looks like you ain't letting us access your library.")
                    }
                })
            case .authorized:
                self.presentImagePicker(sourceType)
            case .denied, .restricted:
                self.troubleAlert("Looks like you ain't letting us access your library. Go to Settings and let us take a peek, please.")
            }
        } else {
            self.troubleAlert("We're not able to take a peek at your library.")
        }
    }
    
    func presentImagePicker(_ srcType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = srcType
        present(imagePicker, animated: true, completion: nil)
    }
    
    func troubleAlert(_ text: String) {
        let alertController = UIAlertController(title: "Whoopsy-daisy!", message: text, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Gotcha!", style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

