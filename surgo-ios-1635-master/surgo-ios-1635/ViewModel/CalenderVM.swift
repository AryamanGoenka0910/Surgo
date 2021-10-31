/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/


import UIKit
import FSCalendar
class CalenderVM: NSObject {
    
    //MARK:- Variables
    
    var arrTaskListModel = [TaskListModel]()
    var selectedDate = Date()
    func getTask(_ date:String, completion:@escaping() -> Void){
        fireStoreRef.collection(firebaseCollectionKeys.task).whereField("uid", isEqualTo: objUserDetails.userId!).whereField("slectedDate", isEqualTo: date).getDocuments { snapshot, error in
            if error != nil {
                Proxy.shared.hideActivityIndicator()
                Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                return 
            }
            guard let snap = snapshot else {
                return
            }
            
            for j in 0..<snap.documents.count {
                fireStoreRef.collection(firebaseCollectionKeys.task).document(snap.documents[j].documentID).getDocument{ (snapData, error) in
                    if error != nil {
                        Proxy.shared.hideActivityIndicator()
                        Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                        return
                    }
                    guard let data = snapData else {
                        return
                    }
                    let objTaskListModel = TaskListModel()
                    objTaskListModel.getData(data.data()!,documentId: data.documentID)
                    self.arrTaskListModel.append(objTaskListModel)
                    self.arrTaskListModel = self.arrTaskListModel.sorted{$0.date < $1.date}
                    completion()
                }
            }
            completion()
        }
    }

}

//MARK:- FSCalendar Delegates and DataSource Methods

extension CalenderVC: FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance{
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        objCalenderVM.arrTaskListModel = []
        objCalenderVM.selectedDate = date
        lblDate.text = date.stringFromFormat("EEEE, dd MMM")
        self.tblVwUserTask.reloadData()
        DispatchQueue.main.async {
            Proxy.shared.showActivityIndicator()
            if Proxy.shared.networkReachable() {
                self.objCalenderVM.getTask(date.stringFromFormat("yyyy-MM-dd")) {
                Proxy.shared.hideActivityIndicator()
                self.tblVwUserTask.reloadData()
            }
        }
        }
    }
  
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentYear = Calendar.current.component(.year, from: calendar.currentPage)
        let currentMonth = Calendar.current.component(.month, from: calendar.currentPage)
        let monthStr = Calendar.current.monthSymbols[currentMonth-1]
        lblMonthYear.text = "\(monthStr) \(currentYear)"
        
    }
    
}
