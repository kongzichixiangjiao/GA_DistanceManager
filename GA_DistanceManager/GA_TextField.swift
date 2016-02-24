//
//  GA_TextField.swift
//  GA_DistanceManager
//
//  Created by houjianan on 16/2/23.
//  Copyright © 2016年 houjianan. All rights reserved.
//

/*
//初始化
let t = GA_TextField(frame: CGRectMake(20, 100, 300, 30), delegate: self)
t.tag = 111
self.view.addSubview(t)

//改变放大镜位置的方法 hasCancleButton == true 取消按钮显示
t.update(.MIDDLE)
t.update(.LEFT, hasCancleButton: true)

//代理方法
func myTextFieldDidBeginEditing(textField: UITextField)
func myTextFieldShouldBeginEditing(textField: UITextField)
func myTextFieldShouldReturn(text: String)
func cancleButton()
}
*/

import UIKit

@objc
protocol GA_TextFieldDelegate {
    optional
    func myTextFieldDidBeginEditing(textField: UITextField)
    optional
    func myTextFieldShouldBeginEditing(textField: UITextField)
    optional
    func myTextFieldShouldReturn(text: String)
    optional
    func cancleButton()
}

class GA_TextField: UIView, UITextFieldDelegate {
    
    private var t: UITextField!
    private var l: UILabel!
    private var m: UIImageView!
    private var b: UIButton!
    
    enum PostionType {
        case LEFT, RIGHT, MIDDLE
    }
    var postionType: PostionType = .RIGHT
    var hasCancleButton: Bool = false
    var delegate: GA_TextFieldDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.userInteractionEnabled = true
        self.backgroundColor = UIColor.clearColor()
    }
    
    convenience init(frame: CGRect, type: PostionType = .MIDDLE, delegate: GA_TextFieldDelegate) {
        self.init(frame: frame)
        self.postionType = type
        self.delegate = delegate
        addGestureRecognizer()
        buildView(frame, type: type)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: "tap")
        self.addGestureRecognizer(tap)
    }
    
    func tap() {
        print("2")
    }
    
    func buildView(frame: CGRect, type: PostionType) {
        let _ = frame.origin.x
        let _ = frame.origin.y
        let w = frame.size.width
        let h = frame.size.height
        t = UITextField(frame: CGRectMake(0, 0, w, h))
        self.addSubview(t)
        t.delegate = self
        t.userInteractionEnabled = true
        t.borderStyle = .RoundedRect
        t.textRangeFromPosition(UITextRange().start, toPosition: UITextRange().end)
        t.font = UIFont.systemFontOfSize(12)
        
        let v = UIView(frame: CGRectMake(0, 0, 20, 20))
        v.backgroundColor = UIColor.orangeColor()
        t.inputAccessoryView? = v
        
        let i = UIImage(named: "搜索.jpg")!
        
        m = UIImageView(image: i)
        t.addSubview(m)
        
        reloadTextFieldPlaceholder(type)
        reloadTextFieldGlassPosition(type, afType: .MIDDLE)
    }
    
    lazy var SpaceStr: String = {
        switch self.postionType {
        case .LEFT:
            return "      "
        case .MIDDLE:
            return "      "
        case .RIGHT:
            return "      "
        }
    }()
    
    func getParameter(handler: (i: UIImage, m: UIImageView,w: CGFloat, h: CGFloat, mW: CGFloat, mH: CGFloat, space: CGFloat) -> ()) {
        let i = UIImage(named: "搜索.jpg")!
        let h = self.frame.size.height
        let w = self.frame.size.width
        let mW = i.size.width / 2
        let mH = i.size.height / 2
        let space: CGFloat = 10
        
        handler(i: i, m: m, w: w, h: h, mW: mW, mH: mH, space: space)
    }
    
    func reloadTextFieldPlaceholder(type: PostionType) {
        switch type {
        case .LEFT:
            t.placeholder = SpaceStr + "输入关键词，如：咖啡、演出 等"
            break
        case .MIDDLE:
            t.placeholder = ""
            let h: CGFloat = self.frame.size.height
            let w: CGFloat = self.frame.size.width
            let lW: CGFloat = 50
            let lX =  w / 2 - lW / 2
            let lY: CGFloat = 0
            l = UILabel(frame: CGRectMake(lX, lY, lW, h))
            t.addSubview(l)
            l.text = "本地搜索"
            l.textAlignment = .Left
            l.backgroundColor = UIColor.clearColor()
            l.font = UIFont.systemFontOfSize(12)
            l.textColor = UIColor.lightGrayColor()
            break
        case .RIGHT:
            break
        }
    }
    
    func update(type: PostionType, hasCancleButton: Bool = false) {
        if self.postionType == type || t.editing {
            return
        }
        self.postionType = type
        switch postionType {
        case .LEFT:
            l.removeFromSuperview()
            break
        case .MIDDLE:
            break
        case .RIGHT:
            break
        }
        
        if hasCancleButton {
            bRemoveFromSuperview()
            self.hasCancleButton = hasCancleButton
            let x: CGFloat = 0
            let y: CGFloat = 0
            let w: CGFloat = 65
            let h: CGFloat = self.frame.size.height
            b = UIButton(frame: CGRectMake(x, y, w, h))
            self.addSubview(b)
            b.tag = 222
            b.setTitle("取消搜索", forState: .Normal)
            b.setTitleColor(UIColor.blackColor(), forState: .Normal)
            b.titleLabel?.font = UIFont.systemFontOfSize(11)
            b.backgroundColor = UIColor.lightGrayColor()
            b.addTarget(self, action: "bAction:", forControlEvents: .TouchUpInside)
            
            let tX = w + 5
            let tY: CGFloat = 0
            let tW = self.frame.width - w
            let tH = self.frame.height
            t.frame = CGRectMake(tX, tY, tW, tH)
        }
        
        reloadTextFieldPlaceholder(type)
        reloadTextFieldGlassPosition(type, afType: type, hasCancleButton: hasCancleButton)
    }
    func bRemoveFromSuperview() {
        if b != nil {
            b.removeFromSuperview()
            b = nil
        }
    }
    
    func bAction(sender: UIButton) {
        if t.editing {
            return
        }
        
        bRemoveFromSuperview()
        
        let w = frame.size.width
        let h = frame.size.height
        t.frame = CGRectMake(0, 0, w, h)
        
        switch postionType {
        case .LEFT:
            break
        case .MIDDLE:
            l.removeFromSuperview()
            break
        case .RIGHT:
            break
        }
        
        self.hasCancleButton = false
        
        reloadTextFieldPlaceholder(postionType)
        reloadTextFieldGlassPosition(postionType, afType: postionType, hasCancleButton: hasCancleButton)
        
        delegate.cancleButton!()
    }
    
    func reloadTextFieldGlassPosition(beType: PostionType, afType: PostionType, hasCancleButton: Bool = false) {
        getParameter {
            [weak self] i, m, w, h, mW, mH, space in
            if let weakSelf = self {
                var mX: CGFloat = 0
                
                let mY: CGFloat = h / 2 - mH / 2
                switch beType {
                case .LEFT:
                    mX = space
                    m.frame = CGRectMake(mX, mY, mW, mH)
                    break
                case .MIDDLE:
                    let h: CGFloat = weakSelf.t.frame.size.height
                    let w: CGFloat = weakSelf.t.frame.size.width
                    let lW: CGFloat = 50
                    let lX =  w / 2 - lW / 2
                    let lY: CGFloat = 0
                    if weakSelf.hasCancleButton {
                        weakSelf.l.frame = CGRectMake(lX, lY, lW, h)
                    }
                    mX = CGRectGetMinX(weakSelf.l.frame) - mW
                    m.frame = CGRectMake(mX, mY, mW, mH)
                    
                    break
                case .RIGHT:
                    mX = w - space - mW
                    m.frame = CGRectMake(mX, mY, mW, mH)
                    break
                }
            }
        }
    }
    
    func textFieldDidBeginEditingUpdate() {
        getParameter { (i, m, w, h, mW, mH, space) -> () in
            var mX: CGFloat = 0
            let mY: CGFloat = h / 2 - mH / 2
            mX = space
            m.frame = CGRectMake(mX, mY, mW, mH)
        }
        
        switch postionType {
        case .LEFT:
            break
        case .MIDDLE:
            l.hidden = true
            break
        case .RIGHT:
            break
        }
    }
    
    func textFieldShouldReturnUpdate() {
        t.text = ""
        switch postionType {
        case .LEFT:
            t.placeholder = SpaceStr + "输入关键词，如：咖啡、演出 等"
            break
        case .MIDDLE:
            l.hidden = false
            reloadTextFieldGlassPosition(postionType, afType: .MIDDLE)
            break
        case .RIGHT:
            break
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = textField.text == SpaceStr ? SpaceStr : SpaceStr + textField.text!
        
        textFieldDidBeginEditingUpdate()
        
        delegate.myTextFieldDidBeginEditing!(textField)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textFieldShouldReturnUpdate()
        let tStr = textField.text!
        if tStr != SpaceStr {
            textField.resignFirstResponder()
            return true
        }
        let startIndex = tStr.startIndex.advancedBy(SpaceStr.characters.count)
        let endIndex = tStr.endIndex.advancedBy(0)
        
        let range = Range<String.Index>(start: startIndex, end: endIndex)
        print(tStr.substringWithRange(range))
        print(tStr)
        
        let text: String = tStr.substringWithRange(range)
        delegate.myTextFieldShouldReturn!(text)
        
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        //false不做修改
//        print(range)
//        print(SpaceStr.characters.count)
//        print(range.location)
        if range.location == SpaceStr.characters.count - 1 {
            return false
        }
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
//        print(textField.text)
        delegate.myTextFieldShouldBeginEditing!(textField)
        return true
    }
    
}
