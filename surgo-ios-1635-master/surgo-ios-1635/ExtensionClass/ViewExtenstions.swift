/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/



import UIKit


extension UIViewController {


    //MARK:- Push/POP methods
    func moveToNext(_ identifier: String,titleStr: String = "",animation: Bool = true) {
        let controller = mainStoryboard.instantiateViewController(withIdentifier: identifier)
        controller.title = titleStr
        self.navigationController?.pushViewController(controller, animated: animation)
    }
    func popToBack(_ animate:Bool = true) {
        self.navigationController?.popViewController(animated: animate)
    }
    //MARK:- Present/Dismiss methods
    func presentWithTitle(_ identifier: String, titleStr: String = "") {

        let controller = mainStoryboard.instantiateViewController(withIdentifier: identifier)
        controller.title = titleStr
        self.present(controller, animated: true)
    }
    func rootWithoutDrawer(_ identifier: String){
        let blankController = mainStoryboard.instantiateViewController(withIdentifier: identifier)
        var homeNavController:UINavigationController = UINavigationController()
        homeNavController = UINavigationController.init(rootViewController: blankController)
        homeNavController.isNavigationBarHidden = true
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                let window:UIWindow =  sd.window!
                window.rootViewController = homeNavController
                window.makeKeyAndVisible()
            }
        } else {
            KAppDelegate.window!.rootViewController = homeNavController
            KAppDelegate.window!.makeKeyAndVisible()
        }
    }

    func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showAlert(_ msg:String, completion:@escaping(_ isYes:Bool) -> Void) {
            DispatchQueue.main.async {
                let controller = UIAlertController(title: AlertMessage.alert, message: msg, preferredStyle: .alert)
                
                let yesAction = UIAlertAction(title: AlertMessage.yes, style: .default) { (action) in
                    completion(true)
                }
                
                let noAction = UIAlertAction(title: AlertMessage.no, style: .default) { (action) in
                    self.dismissController()
                }
              
                controller.addAction(yesAction)
                controller.addAction(noAction)
                self.present(controller, animated: true, completion: nil)
            }
        }
    
    
    func noDataFound(_ tableView : UITableView,msg:String="No Data Found") {
        let noDataLabel: UILabel = UILabel(frame: CGRect(x:0, y:0, width:tableView.bounds.size.width,height: tableView.bounds.size.height))
        noDataLabel.text = msg
        noDataLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        noDataLabel.font = UIFont(name: FontName.medium, size: 17)
        noDataLabel.textAlignment = NSTextAlignment.center
        tableView.backgroundView = noDataLabel
    }
    func noDataFound(_ collectionView : UICollectionView,msg:String="No Data Found") {
          let noDataLabel: UILabel = UILabel(frame: CGRect(x:0, y:0, width:collectionView.bounds.size.width,height: collectionView.bounds.size.height))
          noDataLabel.text = msg
          noDataLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
          noDataLabel.font = UIFont(name: FontName.medium, size: 17)
          noDataLabel.textAlignment = NSTextAlignment.center
          collectionView.backgroundView = noDataLabel
      }
    
    func showAlertWithMultiActions(_ title: String, msg: String, actions: [String], isCancelAction: Bool, completion:@escaping(_ title: String) -> Void) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)

        if isCancelAction {
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (actionCancel) in
                self.dismiss(animated: true, completion: nil)
            }))
        }
        alert.view.backgroundColor = .white
        alert.view.cornerRadius = 5
        for action in actions {
            alert.addAction(UIAlertAction(title: action, style: .default, handler: { (alert) in
                completion(action)
            })
            )}
        self.present(alert, animated: true, completion: nil)
    }
}


extension Notification.Name {
    static let topMenu = NSNotification.Name("topmenu")
}


extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

extension UINavigationController {
    
    func backToViewController(viewController: Any) {
        // iterate to find the type of vc
        for element in viewControllers as Array {
            if "\(type(of: element)).Type" == "\(type(of: viewController))" {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
    
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y:
            locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
extension Int {
    func dateFromMilliseconds(format:String) -> Date {
        let date : NSDate! = NSDate(timeIntervalSince1970:Double(self) / 1000.0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        let timeStamp = dateFormatter.string(from: date as Date)
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return ( formatter.date( from: timeStamp ) )!
    }
}
extension DateFormatter {
    static var sharedDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        // Add your formatter configuration here
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter
    }()
}
