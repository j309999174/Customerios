//
//  AppDelegate.swift
//  ZZYQRCodeSwift
//
//  Created by jd on 2017/5/22.
//  Copyright © 2017年 zzy. All rights reserved.
//

import UIKit
import UserNotifications
import AVFoundation
import MediaPlayer
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, CLLocationManagerDelegate{
    
    var window: UIWindow?
    //多线程
    let queue = DispatchQueue(label: "创建并行队列", attributes: .concurrent)
    //var player:AVPlayer?
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("不知是否前台")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("不知是否后台")
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UserDefaults.standard.set(0, forKey: "unreadnumber")
        //徽章为0
        UserDefaults.standard.set(0, forKey: "badgebadgenumber")
        application.applicationIconBadgeNumber = 0
        //微信注册id
        WXApi.registerApp("wxc7ff179d403b7a51", enableMTA: false)
        //请求通知权限
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                (accepted, error) in
                if !accepted {
                    print("用户不允许消息通知。")
                }
        }
        // 注册后台播放
//        let session = AVAudioSession.sharedInstance()
//        do {
//            try session.setActive(true)
//            try session.setCategory(AVAudioSessionCategoryPlayback)
//        } catch {
//            print(error)
//        }
        
        queue.async {
            //播放
//            let path = Bundle.main.path(forResource: "silence", ofType: "mp3")
//            guard path != nil else { return }
//            let asset = AVAsset(url: URL(fileURLWithPath: path!))
//            let item = AVPlayerItem(asset: asset)
//            self.player = AVPlayer(playerItem: item)
//            self.player!.play()
            print("1 秒后输出")
            while(true){
                sleep(8)
                //定位
                //                self.locationManager.delegate = self
                //                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                //                self.locationManager.distanceFilter = 50
                //                self.locationManager.requestWhenInUseAuthorization()
                //                self.locationManager.startUpdatingLocation()
                //                print("开始定位》》》")
                
                //播放
                //self.player!.seek(to: CMTimeMake(1, 1))
                print("https://www.oushelun.cn/customerajax/unreadjsoncustomer/\(String(describing: UserDefaults.standard.string(forKey: "cusid")))")
                //获取数据  顾客的消息推送,
                
                if ((UserDefaults.standard.string(forKey: "cusid")) != nil){
                    let urlmessage:String!="https://www.oushelun.cn/customerajax/unreadjsoncustomer/\(String(describing: UserDefaults.standard.string(forKey: "cusid")!))"
                    print(urlmessage)
                    let messagenote=Messagenote()
                    messagenote.httpGet(request: URLRequest(url: URL(string: urlmessage)!))
                    //获取数据  通知的推送
                    let notificationfunction=Notificationfunction()
                    notificationfunction.httpGet(request: URLRequest(url: URL(string: "https://www.oushelun.cn/customerajax/notificationjson/123")!))
                    
                }
            }
        }
        return true
        
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        //self.player!.play()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        //self.player!.play()
        //获取数据  通知的推送
        let notificationfunction=Notificationfunction()
        notificationfunction.httpGet(request: URLRequest(url: URL(string: "https://www.oushelun.cn/customerajax/notificationjson/123")!))
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        //self.player!.play()
        //徽章为0
        UserDefaults.standard.set(0, forKey: "badgebadgenumber")
        application.applicationIconBadgeNumber = 0
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //self.player!.play()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        //self.player!.play()
    }
    //定位
    //    //委托传回定位，获取最后一个
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        lock.lock()
    //        currentLocation = locations.last                        //注意：获取集合中最后一个位置（最新的位置）
    //        print("定位经纬度为：\(currentLocation.coordinate.latitude)")
    //        //一直发生定位错误输出结果为0：原因是我输出的是currentLocation.altitude(表示高度的)而不是currentLoction.coordinate.latitude（这个才是纬度）
    //        print(currentLocation.coordinate.longitude)
    //        lock.unlock()
    //
    //    }
    //    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    //        print("定位出错拉！！\(error)")
    //    }
    
}

