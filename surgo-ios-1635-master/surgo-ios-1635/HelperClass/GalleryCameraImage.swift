/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/


import UIKit
import Foundation
import AVFoundation
import CropViewController


protocol PassImageDelegate {
    func passSelectedImgCrop(selectImage: UIImage)
}
var objPassImageDelegate:PassImageDelegate?

class GalleryCameraImage: NSObject,UIImagePickerControllerDelegate, UINavigationControllerDelegate,TOCropViewControllerDelegate {
    
    //MARK:- variable Decleration
    var imagePicker = UIImagePickerController()
    var imageTapped = Int()
    var clickImage = UIImage()
    var controller = UIViewController()
    
    //MARK:- Choose Image Method
    func customActionSheet(_ controler:UIViewController) {
        self.controller = controler
        let myActionSheet = UIAlertController()
        let galleryAction = UIAlertAction(title: AlertMessage.choosePhoto, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openGallary()
        })
        let cameraAction = UIAlertAction(title: AlertMessage.takePhoto, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.checkCameraPermission()
        })
        
        let cancelAction = UIAlertAction(title: AlertMessage.cancel, style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        myActionSheet.addAction(galleryAction)
        myActionSheet.addAction(cameraAction)
        myActionSheet.addAction(cancelAction)
        controller.present(myActionSheet, animated: true, completion: nil)
    }
    
    //MARK:- Open Image Camera
    func checkCameraPermission() {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            DispatchQueue.main.async {
                self.openCamera()
            }
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    DispatchQueue.main.async {
                        self.openCamera()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.presentCameraSettings()
                    }
                }
            })
        }
    }
    
    func presentCameraSettings() {
        let settingAlert = UIAlertController(title: AlertMessage.permit, message: AlertMessage.cameraPermit, preferredStyle: .alert)
        let okAction = UIAlertAction(title:AlertMessage.ok, style: .default, handler: nil)
        settingAlert.addAction(okAction)
        
        let openSetting = UIAlertAction(title:AlertMessage.settings, style:.default, handler:{ (action: UIAlertAction!) in
            let url:URL = URL(string: UIApplication.openSettingsURLString)!
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: {
                    (success) in })
            } else {
                guard UIApplication.shared.openURL(url) else {
                    return
                }
            }
        })
        settingAlert.addAction(openSetting)
        if #available(iOS 13.0, *) {
            let sceneDelegate = UIApplication.shared.connectedScenes
                .first!.delegate as! SceneDelegate
            sceneDelegate.window!.rootViewController?.present(settingAlert, animated: true, completion: nil)
        } else {
            KAppDelegate.window?.rootViewController?.present(settingAlert, animated: true, completion: nil)
        }
    }
    func openCamera(){
        DispatchQueue.main.async {
            if(UIImagePickerController .isSourceTypeAvailable(.camera)) {
                self.imagePicker.sourceType = .camera
                self.imagePicker.delegate = self
                self.imagePicker.allowsEditing = false
                self.controller.present(self.imagePicker, animated: true, completion: nil)
                
            } else {
                let alert = UIAlertController(title: AlertMessage.alert, message: AlertMessage.cameraNotSupported, preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: AlertMessage.ok, style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okAction)
                self.controller.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK:- Open Image Gallery
    func openGallary() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        controller.present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.main.async {
            let objImagePick: UIImage = (info[UIImagePickerController.InfoKey.originalImage] as! UIImage)
            self.setSelectedimage(objImagePick)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Selectedimage
    func setSelectedimage(_ image: UIImage) {
        clickImage = image
        let cropViewController = TOCropViewController(image: clickImage)
        cropViewController.delegate = self
        controller.present(cropViewController, animated: true, completion: nil)
    }
    
    
    //MARK:-CropViewController Delegate
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        objPassImageDelegate?.passSelectedImgCrop(selectImage: image)
        controller.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
