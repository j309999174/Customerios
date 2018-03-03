//
//  ViewController.swift
//  ZZYQRCodeSwift
//
//  Created by jd on 2017/5/22.
//  Copyright © 2017年 zzy. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore
import UserNotifications
import AVFoundation
import MediaPlayer

class ViewController: UIViewController, WKUIDelegate, WKScriptMessageHandler,WKNavigationDelegate{
    var webView: WKWebView!
    var myURL: URL!
    //打开音乐，播放音乐，为了保持后台
    let queue = DispatchQueue(label: "创建并行队列", attributes: .concurrent)
    
    //默认首页
    var passresut: String!="http://47.96.173.116/customer/homepage/123"
    override func loadView() {
        //创建配置
        let webConfiguration = WKWebViewConfiguration()
        //创建用户脚本，负责swift调js
        let userScript = WKUserScript(source: "redHeader()", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        webConfiguration.userContentController.addUserScript(userScript)
        //内容控制，负责js调用swift
        webConfiguration.userContentController.add(self,name: "callbackHandler")
        webConfiguration.userContentController.add(self,name: "iosAlipay")
        webConfiguration.userContentController.add(self,name: "ioscusidsave")
        webConfiguration.userContentController.add(self,name: "ioscountdown")
        //webview加入配置
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.setNavigationBarHidden(true,animated: false)
        //链接改为扫描后的的值
        myURL = URL(string: passresut)
        //let myURL = URL(string: "http://172.114.10.238/customer/homepage/123")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
        //self.musicplay()
        
        
    }
    
    //错误处理
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("发生错误：\(error)")
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        //加载本地html
        let fileURL =  Bundle.main.url(forResource: "htmlerror/error", withExtension: "html" )
        webView.loadFileURL(fileURL!,allowingReadAccessTo:Bundle.main.bundleURL);
        print("发生错误：\(error)")
    }

    //设一个方法，执行多线程
    func musicplay(){
        queue.async {
            print("1 秒后输出")
            //播放器相关
            //var playerItem:AVPlayerItem?
            var player:AVPlayer?
            // Do any additional setup after loading the view, typically from a nib.
            //初始化播放器
            //_ = Bundle.main
            let path = Bundle.main.path(forResource: "silence", ofType: "mp3")
            guard path != nil else { return }
            let asset = AVAsset(url: URL(fileURLWithPath: path!))
            let item = AVPlayerItem(asset: asset)
            player = AVPlayer(playerItem: item)
            //playerLayer = AVPlayerLayer(player: player)
            //playerContainer.layer.addSublayer(playerLayer)
            
            //let url = URL(string: "http://mxd.766.com/sdo/music/data/3/m10.mp3")
            //playerItem = AVPlayerItem(url: url!)
            //player = AVPlayer(playerItem: playerItem!)
            player!.play()
            
            while(true){
                sleep(10)
                player!.seek(to: CMTimeMake(1, 1))
                print("http://47.96.173.116/customerajax/unreadjsoncustomer/\(String(describing: UserDefaults.standard.string(forKey: "cusid")))")
                //获取数据  顾客的消息推送,
                if ((UserDefaults.standard.string(forKey: "cusid")) != nil){
                    let urlmessage:String!="http://47.96.173.116/customerajax/unreadjsoncustomer/\(String(describing: UserDefaults.standard.string(forKey: "cusid")!))"
                    print(urlmessage)
                    let messagenote=Messagenote()
                    messagenote.httpGet(request: URLRequest(url: URL(string: urlmessage)!))
                    
                }
            }
        }
        
    }
    //扫描后传值
    func passresult(pr: String){
        passresut = pr
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //js调用的扫码
        if(message.name == "callbackHandler") {
            print("JavaScript is sending a message \(message.body)")
            AVCaptureSessionManager.checkAuthorizationStatusForCamera(grant: {
                let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scanViewController")
                self.navigationController?.pushViewController(controller, animated: true)
            }){
                let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: { (action) in
                    let url = URL(string: UIApplicationOpenSettingsURLString)
                    UIApplication.shared.openURL(url!)
                })
                let con = UIAlertController(title: "权限未开启", message: "您未开启相机权限，点击确定跳转至系统设置开启", preferredStyle: UIAlertControllerStyle.alert)
                con.addAction(action)
                self.present(con, animated: true, completion: nil)
                
            }
        }
        //js调用的支付宝
        if(message.name == "iosAlipay"){
            print("支付宝支付\(message.body)")
            AlipaySDK.defaultService().payOrder(message.body as! String, fromScheme: "jiangdongiosalipay") { (result) in
                print("支付宝支付结果\(String(describing: result))")
            }
        }
        //js调用储存用户ID
        if(message.name == "ioscusidsave"){
            print("用户ID\(message.body)")
            
            UserDefaults.standard.set(message.body, forKey: "cusid")
            print("储存的用户id\(String(describing: UserDefaults.standard.string(forKey: "cusid")!))")
        }
        //预约倒计时
        if(message.name == "ioscountdown"){
            print("倒计时")
            print("秒数\(message.body)")
            let countdown = message.body as! Int
            let countdownnote = Countdownnote()
            countdownnote.countdown(secondnumber: countdown)
            
            
        }
    }
}
