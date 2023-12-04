//
//  ChatTextCell.swift
//  ChatAi
//
//  Created by wangfeng on 2023/11/16.
//

import UIKit

class ChatTextCell: UITableViewCell,RegisterCellFromNib {

//    var handleDoubleBlock:(()->(Void))?
    @IBOutlet weak var loadingImageV: UIImageView!

    @IBOutlet weak var contentLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
//        doubleTapGesture.numberOfTapsRequired = 2
//        self.addGestureRecognizer(doubleTapGesture)

    }
//    @objc func handleDoubleTap(_ gestureRecognizer: UITapGestureRecognizer) {
//        if gestureRecognizer.state == .ended {
//            handleDoubleBlock?()
//        }
//    }

    func updateStatus(isSucceed:Bool) {
        if !isSucceed {
            loadingImageV.isHidden = false
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z") // 让其在z轴旋转
            rotationAnimation.toValue = NSNumber(value: .pi * 2.0) // 旋转角度
            rotationAnimation.duration = 1 // 旋转周期
            rotationAnimation.isCumulative = true // 旋转累加角度
            rotationAnimation.repeatCount = 100000 // 旋转次数
            loadingImageV.layer.add(rotationAnimation, forKey: "rotationAnimation")
        }else{
            loadingImageV.layer.removeAllAnimations()
            loadingImageV.isHidden = true
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
