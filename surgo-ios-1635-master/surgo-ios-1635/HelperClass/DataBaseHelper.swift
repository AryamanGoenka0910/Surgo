/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
class DataBaseHelper: NSObject {
    static var shared = DataBaseHelper()
    func UploadImage(userImage: UIImage, path: String, completion: @escaping (String) -> ()) {
        let storage = Storage.storage().reference()
        let uid = Auth.auth().currentUser!.uid
        guard let imageData = userImage.jpegData(compressionQuality: 0.3)
        else {return}
        storage.child(path).child(uid).putData(imageData, metadata: nil) { (_, err) in
            if err != nil {
                completion("")
                return
            }
            storage.child(path).child(uid).downloadURL{ (url, err) in
                if err != nil {
                    completion("")
                    return
                }
                completion("\(url!)")
            }
        }
    }
    
    func getDocument(_ firebaseKey:String,uid:String,completion:@escaping([String:Any]) -> Void){
        fireStoreRef.collection(firebaseKey).document(uid).getDocument { snapShot, error in
            if error != nil {
                Proxy.shared.hideActivityIndicator()
                Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                return
            }
            if let dict = snapShot!.data(){
                completion(dict)
            }
        }
    }
    
    func getCollectionData(_ firebaseKey:String,completion:@escaping(_ arr:QuerySnapshot) -> Void){
        fireStoreRef.collection(firebaseKey).getDocuments { snapShot, error in
            if error != nil {
                Proxy.shared.hideActivityIndicator()
                Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                return
            }
            if let arrList = snapShot{
                completion(arrList)
            }
        }
    }
    
    func getSubPassions(_ firebaseKey:String,collectionKey:String,selectedpassion:String, completion:@escaping(_ arr:NSArray) -> Void){
       // self.fireStoreRef.collection(firebaseKey).document(selectedpassion).collection(collectionKey).getDocuments { snapShot, error in
        fireStoreRef.collection(firebaseKey).document(selectedpassion).getDocument { snapShot, error in
            if error != nil {
                Proxy.shared.hideActivityIndicator()
                Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                return
            }
            if let dictDetail = snapShot?.data(){
                if let arrList = dictDetail["subPassions"] as? NSArray {
                    completion(arrList)
                } else {
                    completion([])
                }
            }
        }
    }
    func logoutUser(_ completion:@escaping() -> Void) {
        if (Auth.auth().currentUser) != nil {
            do {
                try Auth.auth().signOut()
                objUserDetails = UserDetails()
                UserDefaults.standard.set("", forKey: accessToken)
                UserDefaults.standard.synchronize()
                Proxy.shared.hideActivityIndicator()
                completion()
            } catch let signOutError as NSError {
                Proxy.shared.hideActivityIndicator()
                Proxy.shared.displayStatusCodeAlert("\(signOutError.localizedDescription)")
            }
        }
    }
    
    func getAllUsers(_ completion:@escaping(_ arr:QuerySnapshot) -> Void){
        fireStoreRef.collection(firebaseCollectionKeys.users).getDocuments { snapShot, error in
            if error != nil {
                Proxy.shared.hideActivityIndicator()
                Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                return
            }
            if let arrList = snapShot {
                completion(arrList)
            }
        }
    }
}
