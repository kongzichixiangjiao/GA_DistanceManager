//
//  GA_TextField.swift
//  GA_DistanceManager
//
//  Created by houjianan on 16/2/23.
//  Copyright © 2016年 houjianan. All rights reserved.
//

import UIKit

@objc
protocol GA_TextFieldDelegate {
    optional
    func myTextFieldDidBeginEditing(textField: UITextField)
    optional
    func myTextFieldShouldReturn(textField: UITextField)
}

class GA_TextField: UIView, UITextFieldDelegate {
    
    enum PostionType {
        case LEFT, RIGHT, MIDDLE
    }
    var postionType: PostionType = .RIGHT
    
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
        let t = UITextField(frame: CGRectMake(0, 0, w, h))
        self.addSubview(t)
        t.delegate = self
        t.tag = 999
        t.userInteractionEnabled = true
        t.borderStyle = .RoundedRect
        
        t.textRangeFromPosition(UITextRange().start, toPosition: UITextRange().end)
        t.font = UIFont.systemFontOfSize(12)
        let v = UIView(frame: CGRectMake(0, 0, 20, 20))
        v.backgroundColor = UIColor.orangeColor()
        t.inputAccessoryView? = v
        
        let i = UIImage(named: "搜索.jpg")!
        
        let m = UIImageView(image: i)
        m.tag = 888
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
        let m = self.viewWithTag(888) as! UIImageView
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
            let t = self.viewWithTag(999) as! UITextField
            t.placeholder = SpaceStr + "输入关键词，如：咖啡、演出 等"
            break
        case .MIDDLE:
            let t = self.viewWithTag(999) as! UITextField
            t.placeholder = ""
            let h: CGFloat = self.frame.size.height
            let w: CGFloat = self.frame.size.width
            let lW: CGFloat = 50
            let lX =  w / 2 - lW / 2
            let lY: CGFloat = 0
            let l = UILabel(frame: CGRectMake(lX, lY, lW, h))
            t.addSubview(l)
            l.tag = 777
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
    
    func update(type: PostionType) {
        let t = self.viewWithTag(999) as! UITextField
        if self.postionType == type || t.editing {
            return
        }
        self.postionType = type
        switch postionType {
        case .LEFT:
            let l = self.viewWithTag(777) as! UILabel
            l.removeFromSuperview()
            break
        case .MIDDLE:
//            let t = self.viewWithTag(999) as! UITextField
//            t.text = ""
            break
        case .RIGHT:
            break
        }

        reloadTextFieldPlaceholder(type)
        reloadTextFieldGlassPosition(type, afType: type)
    }
    
    func reloadTextFieldGlassPosition(beType: PostionType, afType: PostionType) {
        getParameter { (i, m, w, h, mW, mH, space) -> () in
            var mX: CGFloat = 0
            let mY: CGFloat = h / 2 - mH / 2
            switch beType {
            case .LEFT:
                mX = space
                m.frame = CGRectMake(mX, mY, mW, mH)
                break
            case .MIDDLE:
                let l = self.viewWithTag(777) as! UILabel
                mX = CGRectGetMinX(l.frame) - mW
                m.frame = CGRectMake(mX, mY, mW, mH)
                break
            case .RIGHT:
                mX = w - space - mW
                m.frame = CGRectMake(mX, mY, mW, mH)
                break
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
            let l = self.viewWithTag(777) as! UILabel
            l.hidden = true
            break
        case .RIGHT:

            break
        }
    }
    
    func textFieldShouldReturnUpdate() {
        let t = self.viewWithTag(999) as! UITextField
        t.text = ""
        switch postionType {
        case .LEFT:
            t.placeholder = SpaceStr + "输入关键词，如：咖啡、演出 等"
            break
        case .MIDDLE:
            let l = self.viewWithTag(777) as! UILabel
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
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        //false不做修改
        print(range)
        print(SpaceStr.characters.count)
        print(range.location)
        if range.location == SpaceStr.characters.count - 1 {
            return false
        }
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        print(textField.text)
        return true
    }
    
}
