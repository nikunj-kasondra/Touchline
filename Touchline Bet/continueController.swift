//
//  continueController.swift
//  tableDemo
//
//  Created by Nikunj on 3/16/17.
//  Copyright © 2017 Nikunj. All rights reserved.
//

import UIKit
import GoogleMobileAds
import MBProgressHUD
class continueController: UIViewController,GADBannerViewDelegate,GADInterstitialDelegate,UIWebViewDelegate {

    
    
   // @IBOutlet var bannerView: GADBannerView!
    
   
    
    //@IBOutlet weak var gifView: UIView!
    @IBOutlet weak var webView: UIWebView!
    var btnTimer = Timer()
    //var adTimer = Timer()
    @IBOutlet var bannerViewBottom: GADBannerView!
    var interstitial:GADInterstitial!
    @IBOutlet weak var btnContinue: UIButton!
    var hud = MBProgressHUD()
    @IBOutlet weak var subView: UIView!
    var loadIndex:Int = 0
    var timeIndex:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        btnContinue.isHidden = true
        subView.isHidden = false
        hud = MBProgressHUD.showAdded(to:subView, animated:true)
        hud.label.text = "Please wait..."
        btnTimer = Timer.scheduledTimer(timeInterval:7, target:self, selector:#selector(continueController.enablebutton), userInfo:nil, repeats:false)
       // adTimer = Timer.scheduledTimer(timeInterval:3, target:self, selector:#selector(continueController.adshow), userInfo:nil, repeats:true)
        self.bannerViewBottom.delegate = self
        self.bannerViewBottom.adUnitID = "ca-app-pub-4544139061122026/8865062395"
        self.bannerViewBottom.rootViewController = self
        self.bannerViewBottom.load(GADRequest())
        //downloadedFrom(url:URL(string:"https://refbanners.website/I?tag=d_38845m_2584c_&site=38845&ad=2584")!)
        if UIScreen.main.bounds.size.height == 568 {
            let htmlCode = "<iframe scrolling='no' frameBorder='0' style='margin-left:7px;margin-top:0px; border:0px;border-style:none;border-style:none;' width='250' height='250' src='https://refbanners.website/I?tag=d_38845m_2584c_&site=38845&ad=2584' ></iframe>"
            webView.loadHTMLString(htmlCode, baseURL: nil)
        } else if UIScreen.main.bounds.size.height == 667 {
            let htmlCode = "<iframe scrolling='no' frameBorder='0' style='margin-left:35px;margin-top:0px; border:0px;border-style:none;border-style:none;' width='250' height='250' src='https://refbanners.website/I?tag=d_38845m_2584c_&site=38845&ad=2584' ></iframe>"
            webView.loadHTMLString(htmlCode, baseURL: nil)
        } else {
            let htmlCode = "<iframe scrolling='no' frameBorder='0' style='margin-left:50px;margin-top:0px; border:0px;border-style:none;border-style:none;' width='250' height='250' src='https://refbanners.website/I?tag=d_38845m_2584c_&site=38845&ad=2584' ></iframe>"
            webView.loadHTMLString(htmlCode, baseURL: nil)
        }
        
        
//        webView.loadRequest(URLRequest(url:URL(string:"https://refbanners.website/I?tag=d_38845m_2584c_&site=38845&ad=2584")!))
//        self.bannerViewBottom.delegate = self
//        self.bannerViewBottom.adUnitID = "ca-app-pub-4544139061122026/1341795592"
//        self.bannerViewBottom.rootViewController = self;
//        self.bannerViewBottom.load(GADRequest())
       // createAndLoadInterstitial()
         Constant.index = 5
        NotificationCenter.default.addObserver(self, selector: #selector(continueController.notifyoperation), name:NSNotification.Name(rawValue: "addisplay"), object: nil)
//        let tmpImg = UIImage.gif(name: "728x90")
//        let imageView = UIImageView.init(frame:CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:64))
//            imageView.image = tmpImg
//        self.gifView.addSubview(imageView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        if loadIndex == 1 && timeIndex == 1{
            DispatchQueue.main.async {
                self.btnTimer.invalidate()
                self.btnContinue.isHidden = false
                MBProgressHUD.hideAllHUDs(for:self.subView, animated:true)
                self.subView.isHidden = true
            }
           
        }
        loadIndex = 1
       // print("receive")
    }
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
       // print("fail")
        if loadIndex == 1 && timeIndex == 1{
            DispatchQueue.main.async {
                self.btnTimer.invalidate()
                self.btnContinue.isHidden = false
                MBProgressHUD.hideAllHUDs(for:self.subView, animated:true)
                self.subView.isHidden = true
            }
           
        }
        loadIndex = 1
    }

    
    @IBAction func btnContinue(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier:"ViewController")
        self.navigationController?.pushViewController(VC!, animated:true)
        
    }
    func enablebutton(){
        timeIndex = 1
        if loadIndex == 1 {
            DispatchQueue.main.async {
                self.btnContinue.isHidden = false
                self.btnTimer.invalidate()
                MBProgressHUD.hideAllHUDs(for:self.subView, animated:true)
                self.subView.isHidden = true
            }
            
        }
        
    }
    
    func createAndLoadInterstitial(){
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-4544139061122026/2678927998")
        interstitial.load(GADRequest())
    }
    
    func adshow(){
//        if (interstitial?.isReady)!{
//             adTimer.invalidate()
//             self.interstitial?.present(fromRootViewController: self)
//        }
//        else{
//            
//        }
    }
    func notifyoperation(){
//         adTimer = Timer.scheduledTimer(timeInterval:3, target:self, selector:#selector(continueController.adshow), userInfo:nil, repeats:true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnGif(_ sender: Any) {
        UIApplication.shared.openURL(URL(string:"https://1xzry.top/?tag=d_38845m_2584c_")!)
    }
    
    @IBAction func gifAction(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier:"webController")
        self.navigationController?.pushViewController(VC!, animated:true)
    }
    func downloadedFrom(url:URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            let httpURLResponse = response as? HTTPURLResponse
            if httpURLResponse?.statusCode == 200{
                let image = UIImage(data: data!)
                DispatchQueue.main.async {
                  //  self.bannerImg.image = image
                }
            }
            }.resume()
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == .linkClicked{
            UIApplication.shared.openURL(request.url!)
            return false
        }
        return true
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if loadIndex == 1 && timeIndex == 1 {
            DispatchQueue.main.async {
                self.btnTimer.invalidate()
                self.btnContinue.isHidden = false
                MBProgressHUD.hideAllHUDs(for:self.subView, animated:true)
                self.subView.isHidden = true
            }
            
        }
        loadIndex = 1
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        if loadIndex == 1 && timeIndex == 1{
            DispatchQueue.main.async {
                self.btnTimer.invalidate()
                self.btnContinue.isHidden = false
                MBProgressHUD.hideAllHUDs(for:self.subView, animated:true)
                self.subView.isHidden = true
            }
            
        }
        loadIndex = 1

    }
}
