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
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate,CLLocationManagerDelegate{
    
    var window: UIWindow?
    //多线程
    let queue = DispatchQueue(label: "创建并行队列", attributes: .concurrent)
    //var player:AVPlayer?
    
    //定位
    let locationManager = CLLocationManager()
    var currentLocation:CLLocation!
    var lock = NSLock()
    var addressstring:String = ""
    
    //后台任务
    var backgroundTask:UIBackgroundTaskIdentifier! = nil

    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("不知是否前台")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("不知是否后台")
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print("application")
//        if addressstring.isEmpty{
//            UserDefaults.standard.set("重启应用以获取您的当前位置", forKey: "curaddress")
//            addressstring = String(describing: UserDefaults.standard.string(forKey: "curaddress")!)
//        }
        
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
        //向APNs请求token
        UIApplication.shared.registerForRemoteNotifications()
       
        
        
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
        
        //定位
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //定位精确度（最高）一般有电源接入，比较耗电
        //kCLLocationAccuracyNearestTenMeters;                    //精确到10米
        locationManager.distanceFilter = 50                       //设备移动后获得定位的最小距离（适合用来采集运动的定位）
        locationManager.requestWhenInUseAuthorization()           //弹出用户授权对话框，使用程序期间授权（ios8后)
        //requestAlwaysAuthorization;                             //始终授权
        locationManager.startUpdatingLocation()
        print("开始定位》》》")
        print("application1")
        
        return true
        
        
    }
    //token请求回调
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //打印出获取到的token字符串
        UserDefaults.standard.set(deviceToken.hexString, forKey: "deviceToken")
        print("Get Push token: \(deviceToken.hexString)")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("applicationWillResignActive")
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        //self.player!.play()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        //self.player!.play()
       
        
        //如果已存在后台任务，先将其设为完成
        if self.backgroundTask != nil {
            application.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = UIBackgroundTaskInvalid
        }
        
        //如果要后台运行
        
            //注册后台任务
            self.backgroundTask = application.beginBackgroundTask(expirationHandler: {
                () -> Void in
                //如果没有调用endBackgroundTask，时间耗尽时应用程序将被终止
                application.endBackgroundTask(self.backgroundTask)
                self.backgroundTask = UIBackgroundTaskInvalid
            })
        
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("applicationWillEnterForeground")
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        //self.player!.play()
        //徽章为0
        UserDefaults.standard.set(0, forKey: "badgebadgenumber")
        application.applicationIconBadgeNumber = 0
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("applicationDidBecomeActive")
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //self.player!.play()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("applicationWillTerminate")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        //self.player!.play()
    }
    
    //定位
    //委托传回定位，获取最后一个
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lock.lock()
        currentLocation = locations.last                        //注意：获取集合中最后一个位置（最新的位置）
        print("定位经纬度为：\(currentLocation.coordinate.latitude)")
        //一直发生定位错误输出结果为0：原因是我输出的是currentLocation.altitude(表示高度的)而不是currentLoction.coordinate.latitude（这个才是纬度）
        print(currentLocation.coordinate.longitude)
        lock.unlock()
        reverseGeocode(latitude:currentLocation.coordinate.latitude,longitude: currentLocation.coordinate.longitude)
        
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("定位出错拉！！\(error)")
    }
    
    //地理信息反编码
    func reverseGeocode( latitude:CLLocationDegrees, longitude:CLLocationDegrees){
        let geocoder = CLGeocoder()
        let currentLocation = CLLocation(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeLocation(currentLocation, completionHandler: {
            (placemarks:[CLPlacemark]?, error:Error?) -> Void in
            //强制转成简体中文
            let array = NSArray(object: "zh-hans")
            UserDefaults.standard.set(array, forKey: "AppleLanguages")
            //显示所有信息
            if error != nil {
                //print("错误：\(error.localizedDescription))")
                //self.textView.text = "错误：\(error!.localizedDescription))"
                return
            }
            
            if let p = placemarks?[0]{
                print(p) //输出反编码信息
                var address = ""
                
                if let country = p.country {
                    //address.append("国家：\(country)\n")
                    print("国家：\(country)\n")
                }
                if let administrativeArea = p.administrativeArea {
                    //address.append("省份：\(administrativeArea)\n")
                    print("省份：\(administrativeArea)\n")
                }
                if let subAdministrativeArea = p.subAdministrativeArea {
                    //address.append("其他行政区域信息（自治区等）：\(subAdministrativeArea)\n")
                    print("其他行政区域信息（自治区等）：\(subAdministrativeArea)\n")
                }
                if let locality = p.locality {
                    //address.append("城市：\(locality)\n")
                    address.append(locality)
                }
                if let subLocality = p.subLocality {
                    //address.append("区划：\(subLocality)\n")
                    address.append(subLocality)
                }
                if let thoroughfare = p.thoroughfare {
                    //address.append("街道：\(thoroughfare)\n")
                    address.append(thoroughfare)
                }
                if let subThoroughfare = p.subThoroughfare {
                    //address.append("门牌：\(subThoroughfare)\n")
                    address.append(subThoroughfare)
                }
                if let name = p.name {
                    address.append(name)
                    print("地名：\(name)\n")
                }
                if let isoCountryCode = p.isoCountryCode {
                    //address.append("国家编码：\(isoCountryCode)\n")
                    print("国家编码：\(isoCountryCode)\n")
                }
                if let postalCode = p.postalCode {
                    //address.append("邮编：\(postalCode)\n")
                    print("邮编：\(postalCode)\n")
                }
                if let areasOfInterest = p.areasOfInterest {
                    //address.append("关联的或利益相关的地标：\(areasOfInterest)\n")
                    print("关联的或利益相关的地标：\(areasOfInterest)\n")
                }
                if let ocean = p.ocean {
                    //address.append("海洋：\(ocean)\n")
                    print("海洋：\(ocean)\n")
                }
                if let inlandWater = p.inlandWater {
                    //address.append("水源，湖泊：\(inlandWater)\n")
                    print("水源，湖泊：\(inlandWater)\n")
                }
                
                UserDefaults.standard.set(address, forKey: "curaddress")
                print("地址是\(address)")
            } else {
                print("No placemarks!")
            }
        })
    }
    
    
}

//对Data类型进行扩展
extension Data {
    //将Data转换为String
    var hexString: String {
        return withUnsafeBytes {(bytes: UnsafePointer<UInt8>) -> String in
            let buffer = UnsafeBufferPointer(start: bytes, count: count)
            return buffer.map {String(format: "%02hhx", $0)}.reduce("", { $0 + $1 })
        }
    }
}
