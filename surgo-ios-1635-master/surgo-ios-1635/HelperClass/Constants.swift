/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/


import UIKit
import FirebaseFirestore

enum AppInfo {
    static let mode = "development"
    static let appName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
    static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    static let userAgent = "\(mode)/\(appName)/\(version)"
}

enum DeviceInfo{
    static let deviceType = "2"
    static let deviceName = UIDevice.current.name
   // static let deviceToken = Proxy.shared.deviceToken()
    
}
enum FontName{
    static let appFont = "Montserrat-Regular"
    static let medium = "Montserrat"
    static let regularSize = UIFont(name: appFont, size: 15)
    static let mediumSize = UIFont(name: appFont, size: 17)
}
var mainStoryboard: UIStoryboard {
    return UIStoryboard(name: "Main", bundle: nil)
}


enum AlertState {
    case success
    case warning
    case info
    case `default`
    case error
}
enum ApiImgUrl {
    static let imgUrl = "https://tracolasia.com" //live url
}
enum AppColor {
    static let color = #colorLiteral(red: 0.4039215686, green: 0.768627451, blue: 0.8784313725, alpha: 1)
    static let yellow = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
    static let yellowLight = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
    static let yellowRed = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
}
struct ApiResponse {
    var jsonData: Data?
    var data: NSDictionary?
    var message: String?
}


enum PagesConstant:Int{
    case terms = 1, aboutUs,faq
    var termsConditonType: String {
        switch self {
        case .terms:
            return "Terms & Conditions"
        case .aboutUs:
            return "About Us"
        case .faq:
            return "FAQs"
        }
    }
}




var accessToken : String {"acces-token"}
var profileImagesPath : String {"profile_Photos"}
var postImagesPath : String {"post_Pics"}

enum firebaseCollectionKeys {
    static let users = "Users"
    static let goals = "Goals"
    static let passions = "Passions"
    static let subPassions = "SubPassions"
    static let friendRequests = "FriendRequests"
    static let userDetail = "userDetail"
    static let friends = "Friends"
    static let post = "Posts"
    static let task = "Task"
}
enum ProfileSteps :Int {
    case singup = 1, userDetail, goals, passion, subPassion
}
var fireStoreRef : Firestore { Firestore.firestore()}
enum TaskState : Int {
    case new,completed
}
