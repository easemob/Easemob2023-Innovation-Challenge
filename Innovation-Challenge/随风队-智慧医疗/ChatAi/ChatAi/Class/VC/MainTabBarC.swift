//
//  MainTabBarC.swift
//  ChildrenEducation
//
//  Created by wangfeng on 2019/12/22.
//  Copyright © 2019 wangfeng. All rights reserved.
//

import UIKit

class MainTabBarC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        let nav1 = UINavigationController(rootViewController: ConversationVC())
        let nav2 = UINavigationController(rootViewController: ConsultVC())
        let nav3 = UINavigationController(rootViewController: MineVC())

        viewControllers = [nav1,nav2,nav3]
        let tabbarArray = [["title":"消息", "imageName":"", "selectImage":""],
                           ["title":"咨询", "imageName":"", "selectImage":""],
                           ["title":"我的", "imageName":"", "selectImage":""]];

        var i = 0
        for item in tabBar.items ?? [] {
            item.title = tabbarArray[i]["title"]
            item.image = UIImage(named: tabbarArray[i]["imageName"]!)
            item.selectedImage = UIImage(named: tabbarArray[i]["selectImage"]!)
            i += 1
        }
 
    }
    

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

    }


}

extension MainTabBarC: UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}


