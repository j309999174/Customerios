//
//  Countdownnote.swift
//  ZZYQRCodeSwift
//
//  Created by 江东 on 2017/12/7.
//  Copyright © 2017年 zzy. All rights reserved.
//

import Foundation
import UserNotifications

class Countdownnote{
    let queue = DispatchQueue(label: "创建并行队列", attributes: .concurrent)
    var x = 0
    func countdown(secondnumber:Int){
        print("开始啦")
        self.x = secondnumber
        var boolean = true
        queue.async {
        
            while(boolean){
            print("时间是\(secondnumber)")
            sleep(1)
            
            self.x = self.x - 1
             print("xianzai时间是\(self.x)")
                if(self.x == 7200){
                    let content = UNMutableNotificationContent()
                    content.title = "您有一条预约提示"
                    content.body = "亲，距离您的预约还有2小时"
                    //徽章数
                    let badgenumber = UserDefaults.standard.integer(forKey: "badgebadgenumber")+1 as NSNumber
                    UserDefaults.standard.set(badgenumber, forKey: "badgebadgenumber")
                    content.badge = badgenumber
                    content.sound = UNNotificationSound.default()
                    //json["lastword"]! as! String
                    
                    //设置通知触发器
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
                    
                    //设置请求标识符
                    let requestIdentifier = "倒计时2小时"
                    //判断identifier是否存在
                    var ifsend = 0
                    UNUserNotificationCenter.current().getDeliveredNotifications{(notifications) in
                        for notification in notifications{
                            if(notification.request.identifier == requestIdentifier){
                                print("已存在")
                                ifsend = 1
                            }
                        }
                        if(ifsend == 0){
                            //设置一个通知请求
                            let request = UNNotificationRequest(identifier: requestIdentifier,
                                                                content: content, trigger: trigger)
                            
                            //将通知请求添加到发送中心
                            UNUserNotificationCenter.current().add(request) { error in
                                if error == nil {
                                    print("Time Interval Notification scheduled: \(requestIdentifier)")
                                }
                            }
                        }
                    }
                }
                if(self.x == 3600){
                    let content = UNMutableNotificationContent()
                    content.title = "您有一条预约提示"
                    content.body = "亲，距离您的预约还有1小时"
                    //徽章数
                    let badgenumber = UserDefaults.standard.integer(forKey: "badgebadgenumber")+1 as NSNumber
                    UserDefaults.standard.set(badgenumber, forKey: "badgebadgenumber")
                    content.badge = badgenumber
                    content.sound = UNNotificationSound.default()
                    //json["lastword"]! as! String
                    
                    //设置通知触发器
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
                    
                    //设置请求标识符
                    let requestIdentifier = "倒计时1小时"
                    //判断identifier是否存在
                    var ifsend = 0
                    UNUserNotificationCenter.current().getDeliveredNotifications{(notifications) in
                        for notification in notifications{
                            if(notification.request.identifier == requestIdentifier){
                                print("已存在")
                                ifsend = 1
                            }
                        }
                        if(ifsend == 0){
                            //设置一个通知请求
                            let request = UNNotificationRequest(identifier: requestIdentifier,
                                                                content: content, trigger: trigger)
                            
                            //将通知请求添加到发送中心
                            UNUserNotificationCenter.current().add(request) { error in
                                if error == nil {
                                    print("Time Interval Notification scheduled: \(requestIdentifier)")
                                }
                            }
                        }
                    }
                }
                if(self.x == 900){
                    let content = UNMutableNotificationContent()
                    content.title = "您有一条预约提示"
                    content.body = "亲，距离您的预约还有15分钟"
                    //徽章数
                    let badgenumber = UserDefaults.standard.integer(forKey: "badgebadgenumber")+1 as NSNumber
                    UserDefaults.standard.set(badgenumber, forKey: "badgebadgenumber")
                    content.badge = badgenumber
                    content.sound = UNNotificationSound.default()
                    //json["lastword"]! as! String
                    
                    //设置通知触发器
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
                    
                    //设置请求标识符
                    let requestIdentifier = "倒计时15分钟"
                    //判断identifier是否存在
                    var ifsend = 0
                    UNUserNotificationCenter.current().getDeliveredNotifications{(notifications) in
                        for notification in notifications{
                            if(notification.request.identifier == requestIdentifier){
                                print("已存在")
                                ifsend = 1
                            }
                        }
                        if(ifsend == 0){
                            //设置一个通知请求
                            let request = UNNotificationRequest(identifier: requestIdentifier,
                                                                content: content, trigger: trigger)
                            
                            //将通知请求添加到发送中心
                            UNUserNotificationCenter.current().add(request) { error in
                                if error == nil {
                                    print("Time Interval Notification scheduled: \(requestIdentifier)")
                                }
                            }
                        }
                    }
                }
                if(self.x<900){
                    boolean = false
                }
            }
        }
    }
}
