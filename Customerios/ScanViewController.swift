//
//  ScanViewController.swift
//  ZZYQRCodeSwift
//
//  Created by 张泽宇 on 2017/5/24.
//  Copyright © 2017年 zzy. All rights reserved.
//

import UIKit

class ScanViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var sessionManager:AVCaptureSessionManager?
    var link: CADisplayLink?
    var torchState = false
    
    @IBOutlet weak var scanTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //显示导航
        self.navigationController?.setNavigationBarHidden(false,animated: false)
        link = CADisplayLink(target: self, selector: #selector(scan))
        
        sessionManager = AVCaptureSessionManager(captureType: .AVCaptureTypeBoth, scanRect: CGRect.null, success: { (result) in
            if let r = result {
                self .showResult(result: r) 
                let rootpage = ViewController()
                rootpage.passresult(pr: r)
                self.navigationController?.pushViewController(rootpage,animated: true)
            }
        })
        sessionManager?.showPreViewLayerIn(view: view)
        sessionManager?.isPlaySound = true
        
        let item = UIBarButtonItem(title: "相册", style: .plain, target: self, action: #selector(openPhotoLib))
        navigationItem.rightBarButtonItem = item
    }
    
    override func viewWillAppear(_ animated: Bool) {
        link?.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
        sessionManager?.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        link?.remove(from: RunLoop.main, forMode: RunLoopMode.commonModes)
        sessionManager?.stop()
    }
    
    @objc func scan() {
        scanTop.constant -= 1;
        if (scanTop.constant <= -170) {
            scanTop.constant = 170;
        }
    }
    
    @IBAction func changeState(_ sender: UIButton) {
        torchState = !torchState
        let str = torchState ? "关闭闪光灯" : "开启闪光灯"
        sessionManager?.turnTorch(state: torchState)
        sender.setTitle(str, for: .normal)
    }
    
    
    func showResult(result: String) {
        //let alert = UIAlertView(title: "扫描结果", message: result, delegate: nil, cancelButtonTitle: "确定")
        //alert .show()
        
    }
    
    @objc func openPhotoLib() {
        AVCaptureSessionManager.checkAuthorizationStatusForPhotoLibrary(grant: { 
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }) { 
            let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: { (action) in
                let url = URL(string: UIApplicationOpenSettingsURLString)
                let options = [UIApplicationOpenURLOptionUniversalLinksOnly : true]
                UIApplication.shared.open(url!, options: options, completionHandler: nil)
                //UIApplication.shared.openURL(url!)
            })
            let con = UIAlertController(title: "权限未开启",
                                        message: "您未开启相册权限，点击确定跳转至系统设置开启",
                                        preferredStyle: UIAlertControllerStyle.alert)
            con.addAction(action)
            self.present(con, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        sessionManager?.start()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true) { 
            self.sessionManager?.start()
            self.sessionManager?.scanPhoto(image: info["UIImagePickerControllerOriginalImage"] as! UIImage, success: { (str) in
                if let result = str {
                    self.showResult(result: result)
                    let rootpage = ViewController()
                    rootpage.passresult(pr: result)
                    self.navigationController?.pushViewController(rootpage,animated: true)
                }else {
                    self.showResult(result: "未识别到二维码")
                }
            })
            
        }
    }


}
