//
//  UIView+Extension.swift
//  ChildrenEducation
//
//  Created by wangfeng on 2020/1/5.
//  Copyright © 2020 wangfeng. All rights reserved.
//

import UIKit

extension UIView{
    ///圆角
    @IBInspectable var cornerRadius:CGFloat{
        get {
            return layer.cornerRadius
        } set {
            layer.masksToBounds = (newValue > 0)
            layer.cornerRadius = newValue
        }
    }
    ///边线宽度
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        } set {
            layer.borderWidth = newValue
        }
    }
    ///边线颜色
    @IBInspectable var borderColor: UIColor {
        get {
            return layer.borderUIColor
        } set {
            layer.borderColor = newValue.cgColor
        }
    }
    }
    ///设置边线颜色
    extension CALayer {
    var borderUIColor: UIColor {
        get {
            return UIColor(cgColor: self.borderColor!)
        } set {
            self.borderColor = newValue.cgColor
        }
    }
}
