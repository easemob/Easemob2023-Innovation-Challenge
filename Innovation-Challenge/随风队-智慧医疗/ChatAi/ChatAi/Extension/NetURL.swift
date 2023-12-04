//
//  NetURL.swift
//  ChildrenEducation
//
//  Created by wangfeng on 2020/1/7.
//  Copyright © 2020 wangfeng. All rights reserved.
//

import UIKit


let key = "Bearer sk-1415560ebad54a42acc8b8adb832a76c"

let BASE_IP = "xiaofeng.ac.cn:28000"
//let BASE_IP = "192.168.31.71:8000"


/// 服务器地址
let BASE_URL = "http://\(BASE_IP)/"

///获取用户信息
let kUrlUser = BASE_URL+"user/"
///添加用户信息
let kUrlUserAdd = BASE_URL+"user/add"
///获取用户病例记录
let kUrlRecord = BASE_URL+"record/"
///添加用户病例记录
let kUrlRecordAdd = BASE_URL+"record/add"
///获取全部医生信息
let kUrlDoctor = BASE_URL+"user/doctor"
///医生推荐
//let kUrlDoctorRecommend = BASE_URL+"doctor/recommend"
