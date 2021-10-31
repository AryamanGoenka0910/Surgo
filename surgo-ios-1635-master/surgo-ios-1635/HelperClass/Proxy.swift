/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit
import CoreLocation
import NVActivityIndicatorView
import SDWebImage
import Alamofire
import AVKit


let KAppDelegate = UIApplication.shared.delegate as! AppDelegate
class Proxy {
    static var shared: Proxy {
        return Proxy()
    }
    private init(){}
    
    func accessNil() -> String {
        if let accessToken = UserDefaults.standard.object(forKey:accessToken) as? String {
            return accessToken
        } else {
            return ""
        }
    }
    
    func getLatitude() -> String {
        if UserDefaults.standard.object(forKey: "lat") != nil {
            let currentLat =  UserDefaults.standard.object(forKey: "lat") as! String
            return currentLat
        }
        return ""
    }
    
    func getLongitude() -> String {
        if UserDefaults.standard.object(forKey: "long") != nil {
            let currentLong =  UserDefaults.standard.object(forKey: "long") as! String
            return currentLong
        }
        return ""
    }
    
    func buyPlan() -> String {
        if UserDefaults.standard.object(forKey: "buyPlan") != nil {
            let plan = UserDefaults.standard.object(forKey: "buyPlan") as! String
            return plan
        }
        return ""
    }
    
    func getCurrentAddress() -> String {
        if UserDefaults.standard.object(forKey: "address") != nil {
            let currentLong =  UserDefaults.standard.object(forKey: "address") as! String
            return currentLong
        }
        return ""
    }
    func getRememberVal() -> (String,String) {
        var email = ""
        var password = ""
        if let emailVal = UserDefaults.standard.object(forKey: "email") as? String {
            email = emailVal
        }
        if let passwordVal = UserDefaults.standard.object(forKey: "password") as? String {
            password = passwordVal
        }
        return (email,password)
    }
    
    func deviceToken() -> String {
        var deviceTokken =  ""
        if UserDefaults.standard.object(forKey: "device_token") == nil {
            deviceTokken = "00000000055"
        } else {
            deviceTokken = UserDefaults.standard.object(forKey: "device_token")! as! String
        }
        return deviceTokken
    }
    
    func registerNib(_ tblView: UITableView, identifierCell:String){
        let nib = UINib(nibName: identifierCell, bundle: nil)
        tblView.register(nib, forCellReuseIdentifier: identifierCell)
    }
    func registerCollViewNib(_ collView: UICollectionView, identifierCell:String){
        let nib = UINib(nibName: identifierCell, bundle: nil)
        collView.register(nib, forCellWithReuseIdentifier: identifierCell)
    }
    func statusBarColor(scrrenColor: String){
        UIApplication.shared.statusBarStyle = scrrenColor == "Black" ? .lightContent : .default
    }
    
    //    func clearChache(){
    //        SDImageCache.shared.clearMemory()
    //        SDImageCache.shared.clearDisk()
    //    }
    
    func getStringValue(_ value: Any) -> String{
        var finalVal = ""
        if let  idVal   = value as? Int{
            finalVal = "\(idVal)"
        } else if let  idVal   = value as? Double{
            finalVal = "\(idVal)"
        } else if let  idVal   = value as? Float{
            finalVal = "\(idVal)"
        } else  if let idVal = value as? String{
            finalVal = idVal
        }
        return finalVal
    }
    func getElapsedInterval(_ toDate: Date, fromDate: Date) -> String {
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: fromDate, to: toDate)
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year ago" :
                "\(year)" + " " + "years"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month ago" :
                "\(month)" + " " + "months"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day ago" :
                "\(day)" + " " + "days ago"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour)" + " " + "hour ago" :
                "\(hour)" + " " + "hours ago"
        } else if let min = interval.minute, min > 0 {
            return min == 1 ? "\(min)" + " " + "minute ago" :
                "\(min)" + " " + "mins ago"
        } else {
            return "a moment ago"
        }
    }
    func getIntegerValue(_ value: Any) -> Int{
        var finalVal = Int()
        finalVal = 0
        if let  idVal = value as? Int{
            finalVal = idVal
        } else if let  idVal   = value as? Double{
            finalVal = Int(idVal)
        } else  if let idVal = value as? String{
            if idVal != ""{
                finalVal = Int(Double(idVal)!)
            }else{
                finalVal = 0
            }
        }
        return finalVal
    }
    
    //MARK: - HANDLE ACTIVITY
        func showActivityIndicator() {
            DispatchQueue.main.async {
                let activityData = ActivityData(size: CGSize(width: 80, height: 80), type: .ballSpinFadeLoader, color: #colorLiteral(red: 1, green: 0.4509803922, blue: 0.3254901961, alpha: 0.5))
                NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData,nil)
            }
        }
        func hideActivityIndicator()  {
            DispatchQueue.main.async {
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    
            }
        }
    
    //MARK:- Check Valid Email Method
    func isValidEmail(_ testStr:String) -> Bool  {
        let emailRegEx = "^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$"
        return (testStr.range(of: emailRegEx, options:.regularExpression) != nil)
    }
    
    //MARK:- Check Valid Full Name
    func isValidName(_ testStr:String) -> Bool {
        //testStr.count > 0,
        guard testStr.count < 18 else { return false }
        let predicateTest = NSPredicate(format: "SELF MATCHES %@", "^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$")
        return predicateTest.evaluate(with: testStr)
    }
    func isValidPhone(_ phone: String) -> Bool {
        guard phone.count < 15 else { return false }
            let phoneTest = NSPredicate(format: "SELF MATCHES %@","^[0-9+]{0,1}+[0-9]{5,16}$" )
            return phoneTest.evaluate(with: phone)
        }
    func isValidTime(_ time: String) -> Bool {
            let phoneTest = NSPredicate(format: "SELF MATCHES %@","1582-10-31T01:01:01Z" )
            return phoneTest.evaluate(with: time)
        }
    
    
    func networkReachable() -> Bool {
        var isNetworkAvailable = true
        if NetworkReachabilityManager.default!.isReachable {
             isNetworkAvailable = true
        } else {
            isNetworkAvailable = false
            self.hideActivityIndicator()
            self.openSettingApp()
        }
        return isNetworkAvailable
    }
    
    //MARK:- Display Toast
        func displayStatusCodeAlert(_ userMessage: String) {
            if #available(iOS 13.0, *) {
                let scene = UIApplication.shared.connectedScenes.first
                if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                    let window:UIWindow =  sd.window!
                    window.rootViewController?.view.makeToast(message: userMessage,
                                                              duration: TimeInterval(2.0),
                                                              position: .center,
                                                              title: "",
                                                              
                                                              backgroundColor: .black,
                                                              titleColor: .white,
                                                              messageColor: .white,
                                                              font: nil)
                    window.makeKeyAndVisible()
                }
            } else {
                KAppDelegate.window?.rootViewController?.view.makeToast(message: userMessage,
                                                                        duration: TimeInterval(2.0),
                                                                        position: .center,
                                                                        title: "",
                                                                        backgroundColor: .black,
                                                                        titleColor: .white,
                                                                        messageColor: .white,
                                                                        font: nil)
                KAppDelegate.window?.makeKeyAndVisible()
            }
        }
    
    func expiryDateCheckMethod(expiryDate: String)->Bool  {
        let dateInFormat = DateFormatter()
        dateInFormat.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateInFormat.dateFormat = "yyyy-MM-dd"
        let expiryDate = dateInFormat.date(from: expiryDate)
        if Date().compare(expiryDate!) == .orderedDescending {
            //  Proxy.shared.displayDateCheckAlert()
            return false
        }
        return true
        
    }
    func dateConvertDay(date : String,dateFormat:String,getFormat:String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale(identifier: "en_US_POSIX")
        var selectedDate = Date()
        if date != ""{
            selectedDate = formatter.date(from: date)!
        }
        formatter.dateFormat = getFormat
        let outputTime = formatter.string(from: selectedDate)
        return outputTime
    }
    
    func convertImageFromString(str:String) -> UIImage {
        if !UIApplication.shared.canOpenURL(URL(string:  str)!) {
            return #imageLiteral(resourceName: "ic_image")
        } else {
            let imageData = NSData.init(contentsOf: URL(string:  str)!)!
            let str64 = imageData.base64EncodedData(options: .lineLength64Characters)
            let data = NSData(base64Encoded: str64 , options: .ignoreUnknownCharacters)!
            let dataImage = UIImage(data: data as Data)!
            return dataImage
        }
    }
    
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy MMM dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    func displayDateCheckAlert(){
        let alertController = UIAlertController(title: TitleMessage.demoExpired, message:  TitleMessage.contactWithTeam, preferredStyle: .alert)
        let cancelBtnAction = UIAlertAction(title: TitleMessage.ok, style: .destructive) { (action) in}
        alertController.addAction(cancelBtnAction)
      //  KAppDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func openSettingApp() {
        let settingAlert = UIAlertController(title: TitleMessage.connectionProblem, message: TitleMessage.internetConnection, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: TitleMessage.cancel, style: UIAlertAction.Style.default, handler: nil)
        settingAlert.addAction(okAction)
        let openSetting = UIAlertAction(title:TitleMessage.settings, style:UIAlertAction.Style.default, handler:{ (action: UIAlertAction!) in
            let url:URL = URL(string: UIApplication.openSettingsURLString)!
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: {
                    (success) in })
            } else {
                guard UIApplication.shared.openURL(url) else {
                    //Proxy.shared.displayStatusCodeAlert(AlertMessage.pleaseReviewYourNetworkSettings)
                    return
                }
            }
        })
        settingAlert.addAction(openSetting)
        UIApplication.shared.keyWindow?.rootViewController?.present(settingAlert, animated: true, completion: nil)
    }
    
    func createAttributedString(fullString: String, fullStringColor: UIColor, subString: String, subStringColor: UIColor) -> NSMutableAttributedString
    {
        let range = (fullString as NSString).range(of: subString)
        let attributedString = NSMutableAttributedString(string:fullString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: fullStringColor, range: NSRange(location: 0, length: fullString.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: subStringColor, range: range)
        return attributedString
    }
    
    func serializationString(arr : NSMutableArray) -> String {
        var feedbackResponse = NSString()
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: arr, options: JSONSerialization.WritingOptions.prettyPrinted)
            feedbackResponse = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)!
        }catch let error as NSError{
            //Proxy.shared.displayStatusCodeAlert(error.localizedDescription)
        }
        return feedbackResponse as String
    }
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        return nil
    }
    
    func stringToDate(_ dateStr:String,dateFormat:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from:dateStr)!
        return date
    }
    func timeConvertTimeToString(date : Date) -> String {
        
           let formatter = DateFormatter()
           formatter.dateFormat = "hh:mm a"
           let outputDate  = formatter.string(from: date)
           return outputDate
       }
    
            
    func dateConvertDateToString(date : Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let outputDate  = formatter.string(from: date)
        return outputDate
    }
    //MARK:- Change Date format
    func changeDateFormat(_ dateStr: String, oldFormat:String, dateFormat:String) -> String{
        if dateStr != ""{
            let dateFormattr = DateFormatter()
            dateFormattr.dateFormat = oldFormat
            let date1 = dateFormattr.date(from: dateStr)
            let dateFormattr1 = DateFormatter()
            dateFormattr1.dateFormat = dateFormat
            var dateNew = String()
            if date1 != nil {
                dateNew = dateFormattr1.string(from: (date1!))
            } else {
                dateNew = dateFormattr1.string(from: (Date()))
            }
            return dateNew
        } else {
            return ""
        }
    }
   
    
}
