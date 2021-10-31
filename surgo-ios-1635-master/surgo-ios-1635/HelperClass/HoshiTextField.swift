/**
* Aryaman Goenka
* All Rights Reserved.
* Proprietary and confidential :  All information contained remains
* the property of Surgo LLC.
* Unauthorized copying of this file, via any medium is strictly prohibited.
*/

import UIKit

/**
 An HoshiTextField is a subclass of the TextFieldEffects object, is a control that displays an UITextField with a customizable visual effect around the lower edge of the control.
 */
@IBDesignable open class HoshiTextField: TextFieldEffects {
    /**
     The color of the border when it has no content.
     
     This property applies a color to the lower edge of the control. The default value for this property is a clear color.
     */
    @IBInspectable dynamic open var borderInactiveColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    
    /**
     The color of the border when it has content.
     
     This property applies a color to the lower edge of the control. The default value for this property is a clear color.
     */
    @IBInspectable dynamic open var borderActiveColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    
    /**
     The color of the placeholder text.
     
     This property applies a color to the complete placeholder string. The default value for this property is a black color.
     */
    @IBInspectable dynamic open var placeholderColor: UIColor = .black {
        didSet {
            updatePlaceholder()
        }
    }
    
    /**
     The scale of the placeholder font.
     
     This property determines the size of the placeholder label relative to the font size of the text field.
     */
    @IBInspectable dynamic open var placeholderFontScale: CGFloat = 0.65 {
        didSet {
            updatePlaceholder()
        }
    }
    
    override open var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    override open var bounds: CGRect {
        didSet {
            updateBorder()
            updatePlaceholder()
        }
    }
    /// Adding gray view as leftside of UITextField
    @IBInspectable override var addLeftView: Bool {
        get {
            return false
        } set {
            if newValue {
                let left: UIView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: self.frame.size.height))
                left.backgroundColor = UIColor.gray
                leftViewMode = .always
                
                
            }
        }
    }
    @IBInspectable override var leftSide:UIImage {
        get {
            return UIImage()
        } set {
            let outerView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.size.height))
            let left: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0.0, width: 15, height: self.frame.size.height))
            left.image = newValue
            outerView.addSubview(left)
            left.contentMode = .center
            leftViewMode = .always
            self.leftView = outerView
        }
    }
    
    @IBInspectable override var rightSide:UIImage {
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
    private let borderThickness: (active: CGFloat, inactive: CGFloat) = (active: 1, inactive: 0.5)
    private let placeholderInsets = CGPoint(x: 0, y: 8)
    private let textFieldInsets = CGPoint(x: 0, y: 8)
    private let inactiveBorderLayer = CALayer()
    private let activeBorderLayer = CALayer()    
    private var activePlaceholderPoint: CGPoint = CGPoint.zero
    
    // MARK: - TextFieldEffects
    
    override open func drawViewsForRect(_ rect: CGRect) {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: rect.size.width, height: rect.size.height))
        
        placeholderLabel.frame = frame.insetBy(dx: placeholderInsets.x, dy: placeholderInsets.y)
        placeholderLabel.font = placeholderFontFromFont(font!)
        
        updateBorder()
        updatePlaceholder()
        
        layer.addSublayer(inactiveBorderLayer)
        layer.addSublayer(activeBorderLayer)
        addSubview(placeholderLabel)
    }
    
    override open func animateViewsForTextEntry() {
        if text!.isEmpty {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .beginFromCurrentState, animations: ({
                self.placeholderLabel.frame.origin = CGPoint(x: 10, y: self.placeholderLabel.frame.origin.y)
                self.placeholderLabel.alpha = 0
            }), completion: { _ in
                self.animationCompletionHandler?(.textEntry)
            })
        }
        
        layoutPlaceholderInTextRect()
        placeholderLabel.frame.origin = activePlaceholderPoint
        
        UIView.animate(withDuration: 0.4, animations: {
            self.placeholderLabel.alpha = 1.0
        })
        
        activeBorderLayer.frame = rectForBorder(borderThickness.active, isFilled: true)
    }
    
    override open func animateViewsForTextDisplay() {
        if let text = text, text.isEmpty {
            UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: .beginFromCurrentState, animations: ({
                self.layoutPlaceholderInTextRect()
                self.placeholderLabel.alpha = 1
            }), completion: { _ in
                self.animationCompletionHandler?(.textDisplay)
            })
            
            activeBorderLayer.frame = self.rectForBorder(self.borderThickness.active, isFilled: false)
            inactiveBorderLayer.frame = self.rectForBorder(self.borderThickness.inactive, isFilled: true)
            
        }
    }
    
    // MARK: - Private
    
    private func updateBorder() {
        inactiveBorderLayer.frame = rectForBorder(borderThickness.inactive, isFilled: !isFirstResponder)
        inactiveBorderLayer.backgroundColor = borderInactiveColor?.cgColor
        
        activeBorderLayer.frame = rectForBorder(borderThickness.active, isFilled: isFirstResponder)
        activeBorderLayer.backgroundColor = borderActiveColor?.cgColor
    }
    
    private func updatePlaceholder() {
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.sizeToFit()
        layoutPlaceholderInTextRect()
        
        if isFirstResponder || text!.isNotEmpty {
            animateViewsForTextEntry()
        }
    }
    
    private func placeholderFontFromFont(_ font: UIFont) -> UIFont! {
        let smallerFont = UIFont(descriptor: font.fontDescriptor, size: font.pointSize * placeholderFontScale)
        return smallerFont
    }
    
    private func rectForBorder(_ thickness: CGFloat, isFilled: Bool) -> CGRect {
        if isFilled {
            return CGRect(origin: CGPoint(x: 0, y: frame.height-thickness), size: CGSize(width: frame.width, height: thickness))
        } else {
            return CGRect(origin: CGPoint(x: 0, y: frame.height-thickness), size: CGSize(width: 0, height: thickness))
        }
    }
    
    private func layoutPlaceholderInTextRect() {        
        let textRect = self.textRect(forBounds: bounds)
        var originX = textRect.origin.x
        switch self.textAlignment {
        case .center:
            originX += textRect.size.width/2 - placeholderLabel.bounds.width/2
        case .right:
            originX += textRect.size.width - placeholderLabel.bounds.width
        default:
            break
        }
        placeholderLabel.frame = CGRect(x: originX, y: textRect.height/2 - 10,
                                        width: placeholderLabel.bounds.width, height: placeholderLabel.bounds.height)
        activePlaceholderPoint = CGPoint(x: placeholderLabel.frame.origin.x, y: placeholderLabel.frame.origin.y - placeholderLabel.frame.size.height - placeholderInsets.y)
        
    }
    
    // MARK: - Overrides
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: textFieldInsets.x + 30, dy: textFieldInsets.y)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: textFieldInsets.x + 30, dy: textFieldInsets.y)
    }
    
}
