/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit
import FSCalendar
class AddTaskVM: NSObject {
    
    //MARK:- Varaible
    var arrTaskSubTitle = NSMutableArray()
    var timePickerTask = UIDatePicker()
    var date = String()
    
    func createTask(_ req:AddTaskRequest,completion:@escaping() -> Void){
        let param = [
            "title":req.title ?? "",
            "taskTime":Proxy.shared.dateConvertDay(date: req.time ?? "", dateFormat: "hh:mm a", getFormat: "HH:mm:ss"),
            "subTitles":req.arrSubTitle ?? [],
            "slectedDate":req.date ?? "",
            "date":Date(),
            "uid":objUserDetails.userId  ?? "",
            "state":TaskState.new.rawValue
        ] as [String:Any]
           fireStoreRef.collection(firebaseCollectionKeys.task).document().setData(param) { error in
               if error != nil {
                   Proxy.shared.showActivityIndicator()
                   Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
               }
               completion()
           }
       }
    func deleteTask(_ taskId:String, completion:@escaping() -> Void){
        fireStoreRef.collection(firebaseCollectionKeys.task).document(taskId).delete { error in
            if error != nil {
                Proxy.shared.hideActivityIndicator()
                Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
                return
            }
            completion()
        }
    }
    
    func validData(_ req:AddTaskRequest) -> Bool{
        if req.title!.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.taskTitle)
            return false
        } else if req.time!.isBlank {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.taskTime)
            return false
        } else if req.arrSubTitle?.count == .zero {
            Proxy.shared.displayStatusCodeAlert(AlertMessage.subtitle)
            return false
        } else {
            var isEmpty = false
            for i in 0..<req.arrSubTitle!.count {
                if req.arrSubTitle![i] as! String == "" {
                    isEmpty = true
                    break
                }
            }
            if isEmpty {
                Proxy.shared.displayStatusCodeAlert(AlertMessage.emptyField)
            }
            return !isEmpty
        }
    }
}
extension AddTaskVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.objAddTaskVM.arrTaskSubTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddSubTaskTVC.className) as! AddSubTaskTVC
        cell.txtFldSubTask.text = self.objAddTaskVM.arrTaskSubTitle[indexPath.row] as? String ?? ""
        cell.txtFldSubTask.tag = indexPath.row
        cell.btnDelete.isHidden = indexPath.row == .zero && self.objAddTaskVM.arrTaskSubTitle.count == 1
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    @objc func deleteAction(_ sender:UIButton){
        self.view.endEditing(true)
        self.objAddTaskVM.arrTaskSubTitle.removeObject(at: sender.tag)
        self.tblVwAddTask.reloadData()
        self.cnstHeightTblVw.constant = CGFloat(self.objAddTaskVM.arrTaskSubTitle.count * 80)
    }
    func tableView(_ tableView: UITableView,leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if self.objAddTaskVM.arrTaskSubTitle.count != 1 {
        let closeAction = UIContextualAction(style: .normal, title: TitleMessage.delete, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.objAddTaskVM.arrTaskSubTitle.removeObject(at: indexPath.row)
            self.tblVwAddTask.reloadData()
            self.cnstHeightTblVw.constant = CGFloat(self.objAddTaskVM.arrTaskSubTitle.count * 80)
            success(true)
        })
        closeAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [closeAction])
    }
        return UISwipeActionsConfiguration(actions: [])
    }
}

//MARK:- FSCalendar Delegates and DataSource Methods

extension AddTaskVC: FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        objAddTaskVM.date =  date.stringFromFormat("yyyy-MM-dd")
        lblTaskHeader.text = date.stringFromFormat("EEEE, dd MMM")
    }
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}
