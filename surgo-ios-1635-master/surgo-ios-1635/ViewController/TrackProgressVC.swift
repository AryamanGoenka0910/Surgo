/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit
import PieCharts
class TrackProgressVC: UIViewController {
    //MARK: @IBoutlet
    @IBOutlet weak var lblFood: UILabel!
    @IBOutlet weak var lblHealth: UILabel!
    @IBOutlet weak var lblMusic: UILabel!
    @IBOutlet weak var vwChart: PieChart!
    //MARK:- UIViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        vwChart.models = [
            PieSliceModel(value: 1.5, color: AppColor.yellowLight),
            PieSliceModel(value: 3, color: AppColor.yellow),
            PieSliceModel(value: 1, color:AppColor.yellowRed),
        ]
     
    }

}
