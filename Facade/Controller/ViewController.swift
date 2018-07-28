//
//  ViewController.swift
//  Facade
//
//  Created by Bapusaheb Patil on July 14,2018.
//  Copyright © 2018 Bapusaheb Patil. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var creationFrame: UIView!
    @IBOutlet weak var creationImageView: UIImageView!
    
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var colorsContainer: UIView!
    
    var creation = Creation.init()
    var localImages = [UIImage].init()
    let defaults = UserDefaults.standard
    var colorSwatches = [ColorSwatch].init()
    
    let colorUserDefaultsKey = "ColorIndex"
    var savedColorSwatchIndex: Int {
        get {
            let savedIndex = defaults.value(forKey: colorUserDefaultsKey)
            if savedIndex == nil {
                defaults.set(colorSwatches.count - 1, forKey: colorUserDefaultsKey)
            }
            return defaults.integer(forKey: colorUserDefaultsKey)
        }
        set {
            if newValue >= 0 && newValue < colorSwatches.count {
                defaults.set(newValue, forKey: colorUserDefaultsKey)
            }
        }
    }
    
    @IBAction func startOver(_ sender: Any) {
        //print("Starting over")
        creation.reset(colorSwatch: colorSwatches[savedColorSwatchIndex])
        creationImageView.image = creation.image
        creationFrame.backgroundColor = creation.colorSwatch.color
        colorLabel.text = creation.colorSwatch.caption
        displayImagePickingOptions()
    }
    
    @IBAction func applyColor(_ sender: UIButton) {
        //print("Applying color")
        if let index = colorsContainer.subviews.index(of: sender) {
            creation.colorSwatch = colorSwatches[index]
            creationFrame.backgroundColor = creation.colorSwatch.color
            colorLabel.text = creation.colorSwatch.caption
            
            // Save selected color in UserDefaults
            savedColorSwatchIndex = index
        }
    }
    
    @IBAction func share(_ sender: Any) {
        //print("Sharing")
        if let index = colorSwatches.index(where: {$0.caption == creation.colorSwatch.caption}) {
            savedColorSwatchIndex = index
        }
    }
    
    @objc func pickImage(_ sender: UITapGestureRecognizer) {
        //print("Picking image")
        creation.reset(colorSwatch: colorSwatches[savedColorSwatchIndex])
        creationImageView.image = creation.image
        creationFrame.backgroundColor = creation.colorSwatch.color
        colorLabel.text = creation.colorSwatch.caption
        displayImagePickingOptions()
    }
    
    @objc func moveImageView(_ sender: UIPanGestureRecognizer) {
        print("moving")
    }
    
    @objc func rotateImageView(_ sender: UIRotationGestureRecognizer) {
        print("rotating")
    }
    
    @objc func scaleImageView(_ sender: UIPinchGestureRecognizer) {
        print("scaling")
    }
    
    func displayImagePickingOptions() {
        let alertController = UIAlertController(title: "Choose image", message: nil, preferredStyle: .actionSheet)
        
        // create camera action
        let cameraAction = UIAlertAction(title: "Take photo", style: .default) { (action) in
            self.displayCamera()
        }
        
        // add camera action to alert controller
        alertController.addAction(cameraAction)
        
        // create library action
        let libraryAction = UIAlertAction(title: "Library pick", style: .default) { (action) in
            self.displayLibrary()
        }
        
        // add library action to alert controller
        alertController.addAction(libraryAction)
        
        // create random action
        let randomAction = UIAlertAction(title: "Random", style: .default) { (action) in
            self.pickRandom()
        }
        
        // add random action to alert controller
        alertController.addAction(randomAction)
        
        // create cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // add cancel action to alert controller
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true) {
            // code to execute after the controller finished presenting
        }
    }
    
    func displayCamera() {
        let sourceType = UIImagePickerControllerSourceType.camera
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            
            let noPermissionMessage = "Looks like FrameIT have access to your camera:( Please use Setting app on your device to permit FrameIT accessing your camera"
            
            switch status {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                    if granted {
                        self.presentImagePicker(sourceType: sourceType)
                    } else {
                        self.troubleAlert(message: noPermissionMessage)
                    }
                })
            case .authorized:
                self.presentImagePicker(sourceType: sourceType)
            case .denied, .restricted:
                self.troubleAlert(message: noPermissionMessage)
            }
        }
        else {
            troubleAlert(message: "Sincere apologies, it looks like we can't access your camera at this time")
        }
    }
    
    func displayLibrary() {
        let sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let status = PHPhotoLibrary.authorizationStatus()
            let noPermissionMessage = "Looks like FrameIT have access to your photos:( Please use Setting app on your device to permit FrameIT accessing your library"
            
            switch status {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                    if newStatus == .authorized {
                        self.presentImagePicker(sourceType: sourceType)
                    } else {
                        self.troubleAlert(message: noPermissionMessage)
                    }
                })
            case .authorized:
                self.presentImagePicker(sourceType: sourceType)
            case .denied, .restricted:
                self.troubleAlert(message: noPermissionMessage)
            }
        }
        else {
            troubleAlert(message: "Sincere apologies, it looks like we can't access your photo library at this time")
        }
    }
    
    func presentImagePicker(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let newImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        processPicked(image: newImage)
    }
    
    func troubleAlert(message: String?) {
        let alertController = UIAlertController(title: "Oops...", message:message , preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Got it", style: .cancel)
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
    
    func pickRandom() {
        processPicked(image: randomImage())
    }
    
    func randomImage() -> UIImage? {
        
        let currentImage = creation.image
        
        if localImages.count > 0 {
            while true {
                let randomIndex = Int(arc4random_uniform(UInt32(localImages.count)))
                let newImage = localImages[randomIndex]
                if newImage != currentImage {
                    return newImage
                }
            }
        }
        return nil
    }
    
    func collectLocalImageSet() {
        localImages.removeAll()
        let imageNames = ["Splash.png"]
        
        for name in imageNames {
            if let image = UIImage.init(named: name) {
                localImages.append(image)
            }
        }
    }
    
    func collectColors() {
        colorSwatches = [
            ColorSwatch.init(caption: "Ocean", color: UIColor.init(red: 44/255, green: 151/255, blue: 222/255, alpha: 1)),
            ColorSwatch.init(caption: "Shamrock", color: UIColor.init(red: 28/255, green: 188/255, blue: 100/255, alpha: 1)),
            ColorSwatch.init(caption: "Candy", color: UIColor.init(red: 221/255, green: 51/255, blue: 27/255, alpha: 1)),
            ColorSwatch.init(caption: "Violet", color: UIColor.init(red: 136/255, green: 20/255, blue: 221/255, alpha: 1)),
            ColorSwatch.init(caption: "Sunshine", color: UIColor.init(red: 242/255, green: 197/255, blue: 0/255, alpha: 1))
        ]
        if colorSwatches.count == colorsContainer.subviews.count {
            for i in 0 ..< colorSwatches.count {
                colorsContainer.subviews[i].backgroundColor = colorSwatches[i].color
            }
        }
    }
    
    func processPicked(image: UIImage?) {
        if let newImage = image {
            creation.image = newImage
            creationImageView.image = creation.image
        }
    }
    
    func configure() {
        // Adding gestures
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moveImageView(_:)))
        panGestureRecognizer.delegate = self
        creationImageView.addGestureRecognizer(panGestureRecognizer)
        
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotateImageView(_:)))
        rotationGestureRecognizer.delegate = self
        creationImageView.addGestureRecognizer(rotationGestureRecognizer)
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(scaleImageView(_:)))
        pinchGestureRecognizer.delegate = self
        creationImageView.addGestureRecognizer(pinchGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pickImage(_:)))
        tapGestureRecognizer.delegate = self
        creationImageView.addGestureRecognizer(tapGestureRecognizer)
        
        //collect images
        collectLocalImageSet()
        
        //collect colors
        collectColors()
        
        //set creation data object
        creation.colorSwatch = colorSwatches[savedColorSwatchIndex]
        
        // apply creation data to the views
        creationImageView.image = creation.image
        creationFrame.backgroundColor = creation.colorSwatch.color
        colorLabel.text = creation.colorSwatch.caption
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        configure()
    }
    
}
