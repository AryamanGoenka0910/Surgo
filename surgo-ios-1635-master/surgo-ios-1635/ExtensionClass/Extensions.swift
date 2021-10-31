/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/


import UIKit
import WebKit
extension NSObject {
    
    class var className: String {
        return String(describing: self)
    }
}

extension Date {
    
    // MARK: - Format dates
    func stringFromFormat(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.calendar = Calendar.autoupdatingCurrent
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}


extension UITextField {
    
    // Adding gray view as leftside of UITextField
        @IBInspectable var addLeftView: Bool {
            get {
                return false
            } set {
                if newValue {
                    let left: UIView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 30.0, height: self.frame.size.height))
                    left.backgroundColor = UIColor.gray
                    leftViewMode = .always
                    
                    
                }
            }
        }
        @IBInspectable var leftSide:UIImage {
            get {
                return UIImage()
            } set {
                let outerView = UIView(frame: CGRect(x: 0, y: 0, width: 30+10, height: self.frame.size.height))
                let left: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0.0, width: 30, height: self.frame.size.height))
                left.image = newValue
                outerView.addSubview(left)
                left.contentMode = .center
                leftViewMode = .always
                self.leftView = outerView
            }
        }
        
        @IBInspectable var rightSide:UIImage {
            get {
                return UIImage()
            } set {
                let right: UIImageView = UIImageView(frame: CGRect(x: self.frame.size.width , y: 0.0, width: 10, height: self.frame.size.height))
                right.image = newValue
                right.contentMode = .center
                rightViewMode = .always
                self.rightView = right
            }
        }
    
    var isBlank : Bool {
        return (self.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!
    }
    
    var trimmedValue : String {
        return (self.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
    }
    
        func rightImage(image:UIImage,imgW:Int,imgH:Int)  {
            self.rightViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imgW, height: imgH))
            imageView.image = image
            self.rightView = imageView
        }
        func leftImageAndPlaceHolder(image:UIImage,imgW:Int,imgH:Int,txtString: String)  {
            self.leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x:100, y: 0, width: imgW, height: imgH))
            imageView.contentMode = .center
            imageView.clipsToBounds = true
            imageView.image = image
            self.leftView = imageView
            self.layer.cornerRadius = self.frame.size.height/2
            self.attributedPlaceholder = NSAttributedString(string: txtString, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        }
    
    func bottomBorder() {
        let border = CALayer()
        let width  = CGFloat(1.0)
        border.borderColor = (UIColor.lightGray).cgColor
        border.borderWidth = width
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: 1)
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    class func connectAllTxtFieldFields(txtfields:[UITextField]) -> Void {
        guard let last = txtfields.last else {
            return
        }
        for i in 0 ..< txtfields.count - 1 {
            txtfields[i].returnKeyType = .next
            txtfields[i].addTarget(txtfields[i+1], action: #selector(UIResponder.becomeFirstResponder), for: .editingDidEndOnExit)
            //txtfields[i].textColor = UIColor.white
            
        }
        last.returnKeyType = last.returnKeyType == .search ? .search : .done
        last.addTarget(last, action: #selector(UIResponder.resignFirstResponder), for: .editingDidEndOnExit)
    }
    func goToNextTextFeild(nextTextFeild:UITextField){
        resignFirstResponder()
    }
    
}

extension UIView {
    func blink() {
        self.alpha = 0.0;
        UIView.animate(withDuration: 0.8, //Time duration you want,
            delay: 0.0,
            options: [.curveEaseInOut, .autoreverse, .repeat],
            animations: { [weak self] in self?.alpha = 1.0 },
            completion: { [weak self] _ in self?.alpha = 0.0 })
    }
    func animateToSenderPostion(_ sender: UIControl) {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .beginFromCurrentState , animations: {
            self.frame.origin.x = sender.frame.minX
            self.layoutIfNeeded()
        }, completion: nil)
    }
}
extension String {
    var isValidName : Bool {
        let emailRegEx = "^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$"
        let range = self.range(of: emailRegEx, options:.regularExpression)
        return range != nil ? true : false
    }
    var isValidEmail : Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    var isBlank : Bool {
        return (self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
}

extension UITextView {
    func bottomBorder() {
        let border = CALayer()
        let width  = CGFloat(1.0)
        border.borderColor = (UIColor.lightGray).cgColor
        border.borderWidth = width
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height:1)
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
extension UIView {
    func showAnimations(_ completion: ((Bool) -> Swift.Void)? = nil) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.layoutIfNeeded()
            self.layoutSubviews()
        }, completion: completion)
    }
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.frame, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func setBorderColor(_ borderColor: UIColor) {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = 2.0
    }
    @IBInspectable
    var roundedTopCorners: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.cornerRadius = newValue
            if #available(iOS 11.0, *) {
                layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            } else {
                // Fallback on earlier versions
            }
        }
    }
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 5)
            layer.shadowOpacity = 0.4
            layer.shadowRadius = newValue
            layer.cornerRadius = shadowRadius
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
}

extension UIImageView {
    func addBlurEffect()
    {
        if #available(iOS 10.0, *) {
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
            
            self.addSubview(blurEffectView)
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
        
    }
}


extension UIDatePicker {
    func set18YearValidation() {
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = -18
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        components.year = -150
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        self.minimumDate = minDate
        self.maximumDate = maxDate
    }
}
extension Int {
    static func convertAny(obj: Any) -> Int {
        if let num = obj as? NSNumber {
            return num.intValue
        }
        if let numStr = obj as? String,
            let val = Int(numStr) {
            return val
        }
        return 0
    }
}

extension Date {
    
    func getElapsedInterval() -> String {
        
        let interval = Calendar.current.dateComponents([.year, .month, .day], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year ago" :
                "\(year)" + " " + "years ago"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month ago" :
                "\(month)" + " " + "months ago"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day ago" :
                "\(day)" + " " + "days ago"
        } else {
            return "a moment ago"
            
        }
        
    }
    
    func dateToString(_ format:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
@IBDesignable
open class GradientView: UIView {
    @IBInspectable
    public var startColor: UIColor = #colorLiteral(red: 0.9490196078, green: 0.6470588235, blue: 0.5333333333, alpha: 1){
        didSet {
            gradientLayer.colors = [startColor.cgColor,endColor.cgColor]
            
        }
    }
    @IBInspectable
    public var endColor: UIColor = #colorLiteral(red: 0.9294117647, green: 0.4666666667, blue: 0.4980392157, alpha: 1) {
        didSet {
            gradientLayer.colors = [startColor.cgColor,endColor.cgColor]
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var gradientCornerRadius: CGFloat {
        get {
            return gradientLayer.cornerRadius
        }        set {
            gradientLayer.cornerRadius = newValue
        }
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.transform = CATransform3DMakeRotation(.pi / 2, 0, 0, 1)
        gradientLayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
        return gradientLayer
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
extension UIView {
    
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
}
extension UILabel {
    
    
    class func textWidth(font: UIFont, text: String) -> CGFloat {
        let myText = text as NSString
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(labelSize.width)
    }
}

extension UITextView {
    var isBlankTextView : Bool {
        return (self.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!
    }
}
extension UIView {
    
    func animateButtonDown() {
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .curveEaseIn], animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: nil)
    }
    
    func animateButtonUp() {
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .curveEaseOut], animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    
}
class Slider: UISlider {
    
    @IBInspectable var thumbImage: UIImage?
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let thumbImage = thumbImage {
            self.setThumbImage(thumbImage, for: .normal)
        }
    }
}
extension UIImage {
    class func imageWithView(_ view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0)
        defer { UIGraphicsEndImageContext() }
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}
extension UIColor {
    convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
        var cString:String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt64 = 10066329
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt64(&rgbValue)
        }
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
    
    var removeHtmlTags: String {
        let removehtmlTags  = self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return removehtmlTags.replacingOccurrences(of: "&[^;]+;", with: "", options: .regularExpression, range: nil)
    }
}
extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension UIViewController {
    
    func deleteAlert(_ message: String, completion:@escaping(_ success:Bool) -> Void)  {
        let alertController = UIAlertController(title: TitleMessage.alert, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: TitleMessage.yes, style: .default) {
            UIAlertAction in
            completion(true)
        }
        alertController.view.cornerRadius = 5
        alertController.view.backgroundColor = .white
        let cancelAction = UIAlertAction(title: TitleMessage.no, style: .destructive, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
extension WKWebView {
    func loadHTMLStringWithMagic(content:String,baseURL:URL?){
        let headerString = """
        <link rel="stylesheet" type="text/css" href="https://fonts.googleapis.com/css2?family=Lato&display=swap">
        <span style="font-family: 'Lato'; font-weight: Lato; font-size: 50; color: drakGray">\(content)</span>
        """
        loadHTMLString(headerString, baseURL: baseURL)
    }
}
@IBDesignable
open class GradientButton: UIButton {
    @IBInspectable
    public var endColor: UIColor = #colorLiteral(red: 0.9568627451, green: 0.7215686275, blue: 0.5764705882, alpha: 1) {
        didSet {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
            setNeedsDisplay()
        }
    }
    @IBInspectable
        public var startColor: UIColor = #colorLiteral(red: 0.9254901961, green: 0.4431372549, blue: 0.5294117647, alpha: 1){
        didSet {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var gradientCornerRadius: CGFloat {
        get {
            return gradientLayer.cornerRadius
        }        set {
            //gradientLayer.cornerRadius = 25
            gradientLayer.cornerRadius = self.frame.size.height / 2
            
        }
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.transform = CATransform3DMakeRotation(.pi / 2, 0, 0, 1)
        gradientLayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
        return gradientLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
extension String {
    func stringToDate(_ fromat:String)-> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromat
        let date = dateFormatter.date(from:self)!
        return date
    }
}
