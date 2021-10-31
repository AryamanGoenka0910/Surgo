/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/
import UIKit

class EditTaskVM: NSObject {
    var timePickerTask = UIDatePicker()
    var btnSelected = -1
    var arrTaskList = ["Add New Sub Task Title"]
    var objTaskListModel = TaskListModel()
    var arrTaskSubTitle = NSMutableArray()
    func updateTask(_ req:AddTaskRequest,completion:@escaping() -> Void){
        let param = [
            "title":req.title ?? "",
            "taskTime":Proxy.shared.dateConvertDay(date: req.time ?? "", dateFormat: "hh:mm a", getFormat: "HH:mm:ss"),
            "subTitles":req.arrSubTitle ?? [],
            "slectedDate":self.objTaskListModel.selectedDate!,
            "date":Date(),
            "uid":objUserDetails.userId  ?? "",
            "state":TaskState.new.rawValue
        ] as [String:Any]
        fireStoreRef.collection(firebaseCollectionKeys.task).document(self.objTaskListModel.taskId ?? "").updateData(param) { error in
            if error != nil {
                Proxy.shared.showActivityIndicator()
                Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
            }
            completion()
        }
    }
    func completeTask(_ completion:@escaping() -> Void){
        let param = [
            "title":objTaskListModel.title ?? "",
            "taskTime":objTaskListModel.taskTime! ,  //Proxy.shared.dateConvertDay(date: objTaskListModel.taskTime ?? "", dateFormat: "hh:mm a", getFormat: "HH:mm:ss"),
            "subTitles":arrTaskSubTitle ,
            "slectedDate":self.objTaskListModel.selectedDate!,
            "date":Date(),
            "uid":objUserDetails.userId  ?? "",
            "state":TaskState.completed.rawValue
        ] as [String:Any]
        fireStoreRef.collection(firebaseCollectionKeys.task).document(self.objTaskListModel.taskId ?? "").updateData(param) { error in
            if error != nil {
                Proxy.shared.showActivityIndicator()
                Proxy.shared.displayStatusCodeAlert(error!.localizedDescription)
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
extension EditTaskVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objEditTaskVM.arrTaskSubTitle.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddSubTaskTVC.className) as! AddSubTaskTVC
        cell.txtFldSubTask.text = self.objEditTaskVM.arrTaskSubTitle[indexPath.row] as? String ?? ""
        //  cell.txtFldSubTask.delegate = self
        cell.txtFldSubTask.tag = indexPath.row
        cell.btnDelete.isHidden = indexPath.row == .zero
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(removeTask), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    @objc func removeTask(_ sender:UIButton){
        self.objEditTaskVM.arrTaskSubTitle.removeObject(at: sender.tag)
        self.tblVwEditTask.reloadData()
        self.cnstHeightTblVw.constant = CGFloat(self.objEditTaskVM.arrTaskSubTitle.count * 80)
    }
}

//MARK:- Text Filed Delegate Methods
//extension EditTaskVC: UITextFieldDelegate{
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == txtFldTime{
//            if textField.text == "" {
//                let date = Date()
//                let dateStr = Proxy.shared.timeConvertTimeToString(date: date)
//                txtFldTime.text = dateStr
//            }
//        }
//    }
//}
