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
class continueController: UIViewController,GADBannerViewDelegate,GADInterstitialDelegate {

    @IBOutlet var bannerView: GADBannerView!
    var btnTimer = Timer()
    var adTimer = Timer()
    @IBOutlet var bannerViewBottom: GADBannerView!
    var interstitial:GADInterstitial!
    @IBOutlet weak var btnContinue: UIButton!
    var hud = MBProgressHUD()
    @IBOutlet weak var subView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        subView.isHidden = false
        hud = MBProgressHUD.showAdded(to:subView, animated:true)
        hud.label.text = "Please wait..."
        btnTimer = Timer.scheduledTimer(timeInterval:10, target:self, selector:#selector(continueController.enablebutton), userInfo:nil, repeats:false)
        adTimer = Timer.scheduledTimer(timeInterval:3, target:self, selector:#selector(continueController.adshow), userInfo:nil, repeats:true)
        self.bannerView.delegate = self
        self.bannerView.adUnitID = "ca-app-pub-4544139061122026/8865062395"
        self.bannerView.rootViewController = self;
        self.bannerView.load(GADRequest())
        self.bannerViewBottom.delegate = self
        self.bannerViewBottom.adUnitID = "ca-app-pub-4544139061122026/1341795592"
        self.bannerViewBottom.rootViewController = self;
        self.bannerViewBottom.load(GADRequest())
        createAndLoadInterstitial()
         Constant.index = 5
        NotificationCenter.default.addObserver(self, selector: #selector(continueController.notifyoperation), name:NSNotification.Name(rawValue: "addisplay"), object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
       // print("receive")
    }
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
       // print("fail")
    }

    
    @IBAction func btnContinue(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier:"ViewController")
        self.navigationController?.pushViewController(VC!, animated:true)
        
    }
    func enablebutton(){
        btnTimer.invalidate()
        MBProgressHUD.hideAllHUDs(for:subView, animated:true)
        subView.isHidden = true
    }
    
    func createAndLoadInterstitial(){
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-4544139061122026/2678927998")
        interstitial.load(GADRequest())
    }
    
    func adshow(){
        if (interstitial?.isReady)!{
             adTimer.invalidate()
             self.interstitial?.present(fromRootViewController: self)
        }
        else{
            
        }
    }
    func notifyoperation(){
         adTimer = Timer.scheduledTimer(timeInterval:3, target:self, selector:#selector(continueController.adshow), userInfo:nil, repeats:true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
