//
//  betController.swift
//  tableDemo
//
//  Created by Rujal on 3/23/17.
//  Copyright © 2017 Nikunj. All rights reserved.
//

import UIKit
import GoogleMobileAds
import MBProgressHUD
class betController: UIViewController,GADBannerViewDelegate {
    var hud = MBProgressHUD()
    
    @IBOutlet weak var bannerView: GADBannerView!
    var gesture = UITapGestureRecognizer()
    @IBOutlet weak var menuviewwidthCons: NSLayoutConstraint!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var txtView: UITextView!
    var btnSelect = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        btnSelect = false
        menuView.isHidden = true
        self.bannerView.delegate = self
        self.bannerView.adUnitID = "ca-app-pub-4544139061122026/1341795592"
        self.bannerView.rootViewController = self;
        self.bannerView.load(GADRequest())
        callBetService()
    }
    
    
    @IBAction func btnRefresh(_ sender: Any) {
        btnSelect = false
        menuView.removeGestureRecognizer(gesture)
        UIView.animate(withDuration:0.1, animations: {
            self.menuView.isHidden = true
        })
        callBetService()

    }
    @IBAction func btnBack(_ sender: Any) {
        btnSelect = false
        ViewController.firstTimePopup = true
        menuView.removeGestureRecognizer(gesture)
        UIView.animate(withDuration:0.1, animations: {
            self.menuView.isHidden = true
        })
        self.navigationController?.popViewController(animated:true)
    }
   
    func callBetService(){
        hud = MBProgressHUD.showAdded(to:self.view, animated:true)
        hud.label.text = "Fetching data. Please wait..."
        var request = URLRequest(url:URL(string:"http://touchlinebet.com/feedsv4/betslip.txt")!)
        request.httpMethod = "Get"
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        URLSession.shared.dataTask(with:request) { (data,response,error) in
            let resStr = String(data: data!, encoding: .utf8)
            let attrStr = try! NSAttributedString(
                data: (resStr?.data(using: String.Encoding.unicode, allowLossyConversion: true)!)!,
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            
            DispatchQueue.main.async {
                self.txtView.attributedText = attrStr
                MBProgressHUD.hideAllHUDs(for:self.view, animated:true)
            }
            
            }.resume()
    }
    override func viewWillDisappear(_ animated: Bool) {
        ViewController.tmpAd = false
    }
    
    @IBAction func btnMenu(_ sender: Any) {
        if btnSelect{
            btnSelect = false
            menuView.removeGestureRecognizer(gesture)
            UIView.animate(withDuration:0.1, animations: {
                self.menuView.isHidden = true
            })
        }
        else{
            btnSelect = true
            gesture = UITapGestureRecognizer.init(target:self, action:#selector(ViewController.hideView))
            menuView.addGestureRecognizer(gesture)
            UIView.animate(withDuration:0.1, animations: {
                self.menuView.isHidden = false
            })
        }

    }
    func hideView(Gesture:UITapGestureRecognizer){
        btnSelect = false
        menuView.removeGestureRecognizer(gesture)
        UIView.animate(withDuration:0.1, animations: {
            self.menuView.isHidden = true
        })
    }
}
