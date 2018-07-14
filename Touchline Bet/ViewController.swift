//
//  ViewController.swift
//  tableDemo
//
//  Created by Nikunj on 3/15/17.
//  Copyright © 2017 Nikunj. All rights reserved.
//

import UIKit
import GoogleMobileAds
import MBProgressHUD
import ESPullToRefresh

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GADBannerViewDelegate,GADInterstitialDelegate,UITextViewDelegate,SKStoreProductViewControllerDelegate {
    
    
    @IBOutlet weak var imgRefresh: UIImageView!
    @IBOutlet weak var btnRefresh: UIButton!
    @IBOutlet weak var lblYes: UILabel!
    
    @IBOutlet weak var img_high: UIImageView!
    @IBOutlet weak var img_bet: UIImageView!
    @IBOutlet weak var img_today: UIImageView!
    @IBOutlet weak var img_yes: UIImageView!
    @IBOutlet weak var lblToday: UILabel!
    
    @IBOutlet weak var lblHigh: UILabel!
    
    @IBOutlet weak var lblBet: UILabel!
    
    @IBOutlet weak var betWebview: UIWebView!
    @IBOutlet weak var betView: UIView!
    @IBOutlet weak var btnBetslip: UIButton!
    static var firstPopup: Bool = false
    @IBOutlet weak var btnHighOdd: UIButton!
    static var firstTimePopup: Bool = false
    var buttonDisplay : Bool = false
    var buttonDisplay1 : Bool = false
    var responseArr : NSArray? = nil
    var yesresponseArr : NSArray? = nil
    var headerCount = Int()
    var rowCount = Int()
    var sect = Int()
    var jsonArr = NSArray()
    var defDay = Int()
    var interstitial:GADInterstitial!
    var justTimer = Timer()
    var btnSelect = Bool()
    var gesture = UITapGestureRecognizer()
    var hud = MBProgressHUD()
    static var tmpAd = Bool()
    var tab:Int = 0
    var isTomorrow:Bool = true
    var isBet:Bool = true
    var isOdd:Bool = true
    var adIndex:Int = 0
    var refreshControl: UIRefreshControl!
    var refreshControl1: UIRefreshControl!
    var addRefreshPool:Bool = false
    var currentRow:Int = 0
    @IBOutlet weak var menuView: UIView!
  
        @IBOutlet weak var OddBanner: GADBannerView!
    @IBOutlet weak var txtOddView: UITextView!
    @IBOutlet weak var OddView: UIView!
    @IBOutlet weak var betweb: UIScrollView!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var menuviewwidthCons: NSLayoutConstraint!
    @IBOutlet weak var refreshLead: NSLayoutConstraint!
    
    @IBOutlet weak var tochlead: NSLayoutConstraint!
    
    @IBOutlet weak var menulead: NSLayoutConstraint!
    
    @IBOutlet weak var thnxLead: NSLayoutConstraint!
    @IBOutlet weak var btnTodday: UIButton!
    @IBOutlet weak var btnYesterday: UIButton!
    @IBOutlet var bannerView: GADBannerView!
    @IBOutlet var TBL: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIScreen.main.bounds.size.width == 414{
            menuviewwidthCons.constant = 220
        }
        else if UIScreen.main.bounds.size.width == 320{
            menuviewwidthCons.constant = 170
        }
        imgRefresh.isHidden = true
        btnRefresh.isUserInteractionEnabled = false
        ViewController.tmpAd = false
        TBL.register(UINib(nibName:"tblCell", bundle:nil), forCellReuseIdentifier:"newCell")
        TBL.separatorStyle = .none
        TBL.estimatedRowHeight = 205
        TBL.rowHeight = UITableViewAutomaticDimension
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.clear
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(ViewController.refresh), for: UIControlEvents.valueChanged)
        TBL.addSubview(refreshControl)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        
        let swipeRight1 = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight1.direction = UISwipeGestureRecognizerDirection.left
        let swipeRight2 = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight2.direction = UISwipeGestureRecognizerDirection.right
        self.txtView.addGestureRecognizer(swipeRight2)
        let swipeRight3 = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight3.direction = UISwipeGestureRecognizerDirection.left
        self.txtOddView.addGestureRecognizer(swipeRight3)
        
        let swipeRight4 = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight4.direction = UISwipeGestureRecognizerDirection.right
        self.txtOddView.addGestureRecognizer(swipeRight4)
        let swipeRight5 = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight5.direction = UISwipeGestureRecognizerDirection.left
        self.betView.addGestureRecognizer(swipeRight5)
        
        self.OddView.addGestureRecognizer(swipeRight1)
        self.OddView.addGestureRecognizer(swipeRight)
        self.TBL.addGestureRecognizer(swipeRight3)
        self.TBL.addGestureRecognizer(swipeRight4)
        self.bannerView.delegate = self
        self.bannerView.adUnitID = "ca-app-pub-4544139061122026/1341795592"
        self.bannerView.rootViewController = self;
        self.bannerView.load(GADRequest())
        self.OddBanner.delegate = self
        self.OddBanner.adUnitID = "ca-app-pub-4544139061122026/1341795592"
        self.OddBanner.rootViewController = self;
        self.OddBanner.load(GADRequest())
        btnBetslip.layer.cornerRadius = 6
        btnHighOdd.layer.cornerRadius = 6
        btnBetslip.layer.borderWidth = 2.5
        btnHighOdd.layer.borderWidth = 2.5
        btnBetslip.layer.borderColor = UIColor.white.cgColor
        btnHighOdd.layer.borderColor = UIColor.white.cgColor
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.secondNotifyOperation), name:NSNotification.Name(rawValue: "secondaddisplay"), object: nil)
        DispatchQueue.main.async {
            self.lblYes.isHidden = true
            self.lblBet.isHidden = true
            self.lblHigh.isHidden = true
            self.betView.isHidden = true
            self.OddView.isHidden = true
            self.btnYesterday.titleLabel?.textColor = UIColor.black
        }
        justTimer = Timer.scheduledTimer(timeInterval:1, target:self, selector:#selector(ViewController.showadd), userInfo:nil, repeats:true)
        callTodayWebservice()
        createAndLoadInterstitial()
        
       // callaboutService()
    }
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                if tab == 3 {

                    imgRefresh.isHidden = false
                    btnRefresh.isUserInteractionEnabled = true
                    betView.isHidden = true
                    OddView.isHidden = false
                    tab = 2
                    
                    DispatchQueue.main.async {
                        self.lblYes.isHidden = true
                        self.lblBet.isHidden = true
                        self.lblHigh.isHidden = false
                        self.lblToday.isHidden = true
                        self.img_bet.image = #imageLiteral(resourceName: "bet_black")
                        self.img_yes.image = #imageLiteral(resourceName: "yes_black")
                        self.img_high.image = #imageLiteral(resourceName: "high_red")
                        self.img_today.image = #imageLiteral(resourceName: "today_black")
                    }
                    
                    if isOdd {
                        isOdd = false
                        let alert = UIAlertController(title: "Touchline Bet", message: "Click refresh button above", preferredStyle: UIAlertControllerStyle.alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        }))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        
                    }
                    
                } else if tab == 2 {
                    betView.isHidden = true
                    OddView.isHidden = true
                    tab = 0

                    
                    DispatchQueue.main.async {
                        self.imgRefresh.isHidden = true
                        self.btnRefresh.isUserInteractionEnabled = false
                        self.lblYes.isHidden = true
                        self.lblBet.isHidden = true
                        self.lblHigh.isHidden = true
                        self.lblToday.isHidden = false
                        self.img_bet.image = #imageLiteral(resourceName: "bet_black")
                        self.img_yes.image = #imageLiteral(resourceName: "yes_black")
                        self.img_high.image = #imageLiteral(resourceName: "high_black")
                        self.img_today.image = #imageLiteral(resourceName: "today_red")
                    }
                    
                    TBL.setContentOffset(CGPoint(x: 0, y: 0), animated:false)
                    //        DispatchQueue.main.async {
                    //            self.btnTodday.titleLabel?.textColor = UIColor.white
                    //            self.btnYesterday.titleLabel?.textColor = UIColor.black
                    //           self.hud = MBProgressHUD.showAdded(to:self.view, animated:true)
                    //           self.hud.label.text = "Fetching data. Please wait..."
                    //        }
                    //        slideryes.isHidden = true
                    //        sliderToday.isHidden = false
                    if responseArr?.count != nil {
                        headerCount = (responseArr?.count)!
                        DispatchQueue.main.async {
                            self.TBL.reloadData()
                        }
                    } else {
                        callTodayWebservice()
                    }
                    
                } else if tab == 0  {
                    imgRefresh.isHidden = true
                    btnRefresh.isUserInteractionEnabled = false
                justTimer.invalidate()
                betView.isHidden = true
                OddView.isHidden = true
                tab = 1
                    

                DispatchQueue.main.async {
                    self.lblYes.isHidden = false
                    self.lblBet.isHidden = true
                    self.lblHigh.isHidden = true
                    self.lblToday.isHidden = true
                    self.img_bet.image = #imageLiteral(resourceName: "bet_black")
                    self.img_yes.image = #imageLiteral(resourceName: "yes_red")
                    self.img_high.image = #imageLiteral(resourceName: "high_black")
                    self.img_today.image = #imageLiteral(resourceName: "today_black")
                }
                //        if addRefreshPool {
                //            addRefreshPool = false
                //            refreshControl1.removeFromSuperview()
                //            refreshControl = UIRefreshControl()
                //            refreshControl.tintColor = UIColor.clear
                //            refreshControl.attributedTitle = NSAttributedString(string: "")
                //            refreshControl.addTarget(self, action: #selector(ViewController.refresh), for: UIControlEvents.valueChanged)
                //            TBL.addSubview(refreshControl)
                //        }
                if isTomorrow {
                    headerCount = 0
                    self.isTomorrow = false
                    DispatchQueue.main.async {
                        self.TBL.setContentOffset(CGPoint(x: 0, y: 0), animated:false)
                        self.TBL.reloadData()
                        self.btnYesterday.titleLabel?.textColor = UIColor.white
                        self.btnTodday.titleLabel?.textColor = UIColor.black
                        
                    }
                    
                    let alert = UIAlertController(title: "Touchline Bet", message: "Pull down to refresh", preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    }))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                } else {
                    DispatchQueue.main.async {
                        if self.yesresponseArr != nil {

                            self.headerCount = (self.yesresponseArr?.count)!
                            self.TBL.setContentOffset(CGPoint(x: 0, y: 0), animated:false)
                            self.TBL.reloadData()
                        } else {
                            self.headerCount = 0
                            self.TBL.setContentOffset(CGPoint(x: 0, y: 0), animated:false)
                            self.TBL.reloadData()
                        }
                        
                    }
                }
            }
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                if tab == 0 {

                    tab = 2
                    DispatchQueue.main.async {
                        self.imgRefresh.isHidden = false
                        self.btnRefresh.isUserInteractionEnabled = true
                        self.betView.isHidden = true
                        self.OddView.isHidden = false
                        self.lblYes.isHidden = true
                        self.lblBet.isHidden = true
                        self.lblHigh.isHidden = false
                        self.lblToday.isHidden = true
                        self.img_bet.image = #imageLiteral(resourceName: "bet_black")
                        self.img_yes.image = #imageLiteral(resourceName: "yes_black")
                        self.img_high.image = #imageLiteral(resourceName: "high_red")
                        self.img_today.image = #imageLiteral(resourceName: "today_black")
                    }
                    
                    if isOdd {
                        isOdd = false
                        let alert = UIAlertController(title: "Touchline Bet", message: "Click refresh button above", preferredStyle: UIAlertControllerStyle.alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        }))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        
                    }

                } else if tab == 1 {

                    betView.isHidden = true
                    OddView.isHidden = true
                    tab = 0
                    imgRefresh.isHidden = true
                    btnRefresh.isUserInteractionEnabled = false
                    DispatchQueue.main.async {
                        self.lblYes.isHidden = true
                        self.lblBet.isHidden = true
                        self.lblHigh.isHidden = true
                        self.lblToday.isHidden = false
                        self.img_bet.image = #imageLiteral(resourceName: "bet_black")
                        self.img_yes.image = #imageLiteral(resourceName: "yes_black")
                        self.img_high.image = #imageLiteral(resourceName: "high_black")
                        self.img_today.image = #imageLiteral(resourceName: "today_red")
                    }
                    
                    TBL.setContentOffset(CGPoint(x: 0, y: 0), animated:false)
                    //        DispatchQueue.main.async {
                    //            self.btnTodday.titleLabel?.textColor = UIColor.white
                    //            self.btnYesterday.titleLabel?.textColor = UIColor.black
                    //           self.hud = MBProgressHUD.showAdded(to:self.view, animated:true)
                    //           self.hud.label.text = "Fetching data. Please wait..."
                    //        }
                    //        slideryes.isHidden = true
                    //        sliderToday.isHidden = false
                    if responseArr?.count != nil {
                        headerCount = (responseArr?.count)!
                        DispatchQueue.main.async {
                            self.TBL.reloadData()
                        }
                    } else {
                        callTodayWebservice()
                    }

                } else if tab == 2 {

                    imgRefresh.isHidden = false
                    btnRefresh.isUserInteractionEnabled = true
                    betView.isHidden = false
                    OddView.isHidden = true
                    tab = 3
                    DispatchQueue.main.async {
                        self.lblYes.isHidden = true
                        self.lblBet.isHidden = false
                        self.lblHigh.isHidden = true
                        self.lblToday.isHidden = true
                        self.img_bet.image = #imageLiteral(resourceName: "bet_red")
                        self.img_yes.image = #imageLiteral(resourceName: "yes_black")
                        self.img_high.image = #imageLiteral(resourceName: "high_black")
                        self.img_today.image = #imageLiteral(resourceName: "today_black")
                    }
                    
                    if isBet {
                        isBet = false
                        let alert = UIAlertController(title: "Touchline Bet", message: "Click refresh button above to view (Ad will be displayed", preferredStyle: UIAlertControllerStyle.alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        }))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        
                    }

                }
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
//        self.txtOddView.es_addPullToRefresh {
//            self.txtOddView.es_header?.stop()
//            if self.tab == 2 {
//                let alert = UIAlertController(title: "Touchline Bet", message: "Our tips are FREE - View Ad to see High Odd Picks?", preferredStyle: UIAlertControllerStyle.alert)
//                
//                // add an action (button)
//                alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { action in
//                }))
//                alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
//                    self.justTimer = Timer.scheduledTimer(timeInterval:1, target:self, selector:#selector(ViewController.showadd), userInfo:nil, repeats:true)
//                    self.callHighoddService()
//                    self.createAndLoadInterstitial()
//                }))
//                
//                
//                self.present(alert, animated: true, completion: nil)
//                
//            }
//        }
//        self.txtView.es_addPullToRefresh {
//            self.txtView.es_header?.stop()
//            if self.tab == 3 {
//                let alert = UIAlertController(title: "Touchline Bet", message: "Our tips are FREE - View Ad to see Betslips?", preferredStyle: UIAlertControllerStyle.alert)
//                
//                // add an action (button)
//                alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { action in
//                }))
//                alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
//                    self.justTimer = Timer.scheduledTimer(timeInterval:1, target:self, selector:#selector(ViewController.showadd), userInfo:nil, repeats:true)
//                    self.callBetService()
//                    self.createAndLoadInterstitial()
//                }))
//                
//                
//                self.present(alert, animated: true, completion: nil)
//                
//            }
        }

//        if !ViewController.tmpAd{
//            ViewController.tmpAd = false
//            justTimer = Timer.scheduledTimer(timeInterval:1, target:self, selector:#selector(ViewController.showadd), userInfo:nil, repeats:true)
//            if !ViewController.firstTimePopup{
//                createAndLoadInterstitial()
//            }
//            else{
//                ViewController.firstTimePopup = false
//            }
//            // Do any additional setup after loading the view, typically from a nib.
//            sliderToday.isHidden = false
//            defDay = 0
//            slideryes.isHidden = true
//            headerCount = 0
//            rowCount = 0
//            callTodayWebservice()
//            Constant.index = 10
//            btnSelect = false
//
//        }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tab == 0 {
            if responseArr != nil {
                return (responseArr?.count)!
            } else {
                return 0
            }
        } else {
            if yesresponseArr != nil {
                return (yesresponseArr?.count)!
            } else {
                return 0
            }
        }
        return headerCount
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // print("rowcounting")
        if tab == 0 {
            if responseArr != nil{
                return ((responseArr?.object(at:section) as! NSDictionary).value(forKey:"matches")as! NSArray).count
            }
            else{
                return 0
                
            }

        } else {
            if yesresponseArr != nil{
                return ((yesresponseArr?.object(at:section) as! NSDictionary).value(forKey:"matches")as! NSArray).count
            }
            else{
                return 0
                
            }
        }
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tab == 0 {
            let cell : tblCell = tableView.dequeueReusableCell(withIdentifier:"newCell") as! tblCell
            // print("cell call")
//            var rowNumber = indexPath.row
//            for i in 0..<indexPath.section {
//                rowNumber += self.TBL.numberOfRows(inSection: i)
//            }
//            print(rowNumber)
            //currentRow = sumSections + indexPath.row
            var sumSections: Int = 0
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeRight.direction = UISwipeGestureRecognizerDirection.right
            cell.addGestureRecognizer(swipeRight)
            let swipeRight1 = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeRight.direction = UISwipeGestureRecognizerDirection.left
            cell.addGestureRecognizer(swipeRight1)
            for i in 0..<indexPath.section {
                var rowsInSection: Int = TBL.numberOfRows(inSection: i)
                sumSections += rowsInSection
            }
            currentRow = sumSections + indexPath.row + 1
            if currentRow % 3 == 0 && currentRow > 2{
                adIndex = 0
                cell.adsHeight.constant = 44
                cell.bannerView.delegate = self
                cell.bannerView.adUnitID = "ca-app-pub-4544139061122026/2818528799"
                cell.bannerView.rootViewController = self;
                cell.bannerView.load(GADRequest())
            } else {
                cell.adsHeight.constant = 0
            }
            cell.lblHomeTeam.text = ((((responseArr?.object(at:indexPath.section) as! NSDictionary).value(forKey:"matches")as! NSArray).value(forKey:"hometeam") as! NSArray).object(at:indexPath.row) as? String)
            cell.lblAwayTeam.text = ((((responseArr?.object(at:indexPath.section) as! NSDictionary).value(forKey:"matches")as! NSArray).value(forKey:"awayteam") as! NSArray).object(at:indexPath.row) as? String)
            
            
            cell.lblScroeHome.text = ((((responseArr?.object(at:indexPath.section) as! NSDictionary).value(forKey:"matches")as! NSArray).value(forKey:"homescore") as! NSArray).object(at:indexPath.row) as? String)
            
            
            cell.lblScoreAway.text = ((((responseArr?.object(at:indexPath.section) as! NSDictionary).value(forKey:"matches")as! NSArray).value(forKey:"awayscore") as! NSArray).object(at:indexPath.row) as? String)
            
            

            
            cell.lblTip.text = String("TIP: ") + String((((responseArr?.object(at:indexPath.section) as! NSDictionary).value(forKey:"matches")as! NSArray).value(forKey:"tiptext") as! NSArray).object(at:indexPath.row) as! String)
            
            
            cell.lblOdd.text = String("ODD: ") + String((((responseArr?.object(at:indexPath.section) as! NSDictionary).value(forKey:"matches")as! NSArray).value(forKey:"oddtext") as! NSArray).object(at:indexPath.row) as! String)
            
            
            cell.lblTime.text = ((((responseArr?.object(at:indexPath.section) as! NSDictionary).value(forKey:"matches")as! NSArray).value(forKey:"matchtime") as! NSArray).object(at:indexPath.row) as! String)
            
            
            if ((((responseArr?.object(at:indexPath.section) as! NSDictionary).value(forKey:"matches")as! NSArray).value(forKey:"betstate") as! NSArray).object(at:indexPath.row) as! String) == ""{
                cell.img.image = UIImage(named:"pause")
            }
            else if ((((responseArr?.object(at:indexPath.section) as! NSDictionary).value(forKey:"matches")as! NSArray).value(forKey:"betstate") as! NSArray).object(at:indexPath.row) as! String) == "1"{
                cell.img.image = UIImage(named:"right")
            }
            else{
                cell.img.image = UIImage(named:"cross")
            }
            if indexPath.row == 0 && indexPath.section == 0{
                cell.lblDate.text = ((responseArr?.value(forKey:"date") as! NSArray).object(at:indexPath.row) as? String)
                cell.dateWidth.constant = 54
            } else {
                cell.lblDate.text = ""
                cell.dateWidth.constant = 0
            }
            
            cell.lblClub.text = ((responseArr?.value(forKey:"country") as! NSArray).object(at:indexPath.section) as? String)
            cell.lblStatus.text = String(" - ") + String(((responseArr?.value(forKey:"name") as! NSArray).object(at:indexPath.section)as! String))
            cell.flagImg.imageURL = URL(string:((responseArr?.value(forKey:"image_url") as! NSArray).object(at:indexPath.section)as! String))
            return cell

        } else {
            let cell : tblCell = tableView.dequeueReusableCell(withIdentifier:"newCell") as! tblCell
            var sumSections: Int = 0
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeRight.direction = UISwipeGestureRecognizerDirection.right
            cell.addGestureRecognizer(swipeRight)
            let swipeRight1 = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeRight.direction = UISwipeGestureRecognizerDirection.left
            for i in 0..<indexPath.section {
                var rowsInSection: Int = TBL.numberOfRows(inSection: i)
                sumSections += rowsInSection
            }
            currentRow = sumSections + indexPath.row + 1
            if currentRow % 3 == 0 && currentRow > 2{
                adIndex = 0
                cell.adsHeight.constant = 44
                cell.bannerView.delegate = self
                cell.bannerView.adUnitID = "ca-app-pub-4544139061122026/2818528799"
                cell.bannerView.rootViewController = self;
                cell.bannerView.load(GADRequest())
            } else {
                cell.adsHeight.constant = 0
            }
            if yesresponseArr?.count != 0 {
                cell.lblHomeTeam.text = ((((yesresponseArr?.object(at:indexPath.section) as! NSDictionary).value(forKey:"matches")as! NSArray).value(forKey:"hometeam") as! NSArray).object(at:indexPath.row) as? String)
                cell.lblAwayTeam.text = ((((yesresponseArr?.object(at:indexPath.section) as! NSDictionary).value(forKey:"matches")as! NSArray).value(forKey:"awayteam") as! NSArray).object(at:indexPath.row) as? String)
                cell.lblScroeHome.text = ((((yesresponseArr?.object(at:indexPath.section) as! NSDictionary).value(forKey:"matches")as! NSArray).value(forKey:"homescore") as! NSArray).object(at:indexPath.row) as? String)
                
                
                cell.lblScoreAway.text = ((((yesresponseArr?.object(at:indexPath.section) as! NSDictionary).value(forKey:"matches")as! NSArray).value(forKey:"awayscore") as! NSArray).object(at:indexPath.row) as? String)
                
                
                
                
                cell.lblTip.text = String("TIP: ") + String((((yesresponseArr?.object(at:indexPath.section) as! NSDictionary).value(forKey:"matches")as! NSArray).value(forKey:"tiptext") as! NSArray).object(at:indexPath.row) as! String)
                
                
                cell.lblOdd.text = String("ODD: ") + String((((yesresponseArr?.object(at:indexPath.section) as! NSDictionary).value(forKey:"matches")as! NSArray).value(forKey:"oddtext") as! NSArray).object(at:indexPath.row) as! String)
                
                
                cell.lblTime.text = ((((yesresponseArr?.object(at:indexPath.section) as! NSDictionary).value(forKey:"matches")as! NSArray).value(forKey:"matchtime") as! NSArray).object(at:indexPath.row) as! String)
                
                
                if ((((yesresponseArr?.object(at:indexPath.section) as! NSDictionary).value(forKey:"matches")as! NSArray).value(forKey:"betstate") as! NSArray).object(at:indexPath.row) as! String) == ""{
                    cell.img.image = UIImage(named:"pause")
                }
                else if ((((yesresponseArr?.object(at:indexPath.section) as! NSDictionary).value(forKey:"matches")as! NSArray).value(forKey:"betstate") as! NSArray).object(at:indexPath.row) as! String) == "1"{
                    cell.img.image = UIImage(named:"right")
                }
                else{
                    cell.img.image = UIImage(named:"cross")
                }
                if indexPath.row == 0 && indexPath.section == 0 {
                    cell.lblDate.text = ((yesresponseArr?.value(forKey:"date") as! NSArray).object(at:indexPath.row) as? String)
                    cell.dateWidth.constant = 54
                } else {
                    cell.lblDate.text = ""
                    cell.dateWidth.constant = 0
                }
                
                cell.lblClub.text = ((yesresponseArr?.value(forKey:"country") as! NSArray).object(at:indexPath.section) as? String)
                cell.lblStatus.text = String(" - ") + String(((yesresponseArr?.value(forKey:"name") as! NSArray).object(at:indexPath.section)as! String))
                cell.flagImg.imageURL = URL(string:((yesresponseArr?.value(forKey:"image_url") as! NSArray).object(at:indexPath.section)as! String))
            }

            return cell
            
        }
     }
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("receive")
    }
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
       // print("fail")
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "newHeader") as! headerCell!
//        //print("headercall")
//        
//        rowCount = ((responseArr?.object(at:section) as! NSDictionary).value(forKey:"matches")as! NSArray).count
//        sect = section
//        jsonArr = ((responseArr?.object(at:section) as! NSDictionary).value(forKey:"matches")as! NSArray)
//       // print(rowCount)
//         if UIScreen.main.bounds.size.width == 375{
//            if section == 0{
//                header?.clubCons.constant = 170
//                header?.stateCons.constant = 130
//            }
//            else{
//                header?.clubCons.constant = 170
//                header?.stateCons.constant = 170
//            }
//            
//            
//        }
//        else if UIScreen.main.bounds.size.width == 414{
//            if section == 0{
//                header?.clubCons.constant = 210
//                header?.stateCons.constant = 170
//            }
//            else{
//                header?.clubCons.constant = 210
//                header?.stateCons.constant = 200
//            }
//
//        }
//        else{
//            if section == 0{
//                header?.clubCons.constant = 140
//                header?.stateCons.constant = 100
//            }
//            else{
//                header?.clubCons.constant = 150
//                header?.stateCons.constant = 150
//            }
//        }
//        return header!.contentView
//    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    func callTodayWebservice(){
        hud = MBProgressHUD.showAdded(to:self.view, animated:true)
        hud.label.text = "Fetching data. Please wait..."
        let url = URL(string:"http://www.touchlinebet.com/feedsv4/data.json")!
        let request = NSMutableURLRequest(url: url)
        request.cachePolicy = .reloadIgnoringCacheData
        request.httpMethod = "GET"
        URLCache.shared.removeAllCachedResponses()
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            self.refreshControl.endRefreshing()
            if error != nil {
                DispatchQueue.main.async {
                    self.TBL.reloadData()
                    MBProgressHUD.hideAllHUDs(for:self.view, animated:true)
                    let alert = UIAlertView.init(title:"Touchline Bet", message:"Please check your internet connection. Try again..", delegate:self, cancelButtonTitle:"Ok")
                    alert.show()
                }
                return
        }
                do {
                    
                    if let response = try JSONSerialization.jsonObject(with: data!, options: []) as? NSArray {
                        DispatchQueue.main.async {
                            MBProgressHUD.hideAllHUDs(for:self.view, animated:true)
                        }
                        self.headerCount = (response.value(forKey:"country") as AnyObject).count!
                       // print(response)
                        self.responseArr = response
                       // print(self.responseArr)
                        DispatchQueue.main.async {
                            self.TBL.reloadData()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.TBL.reloadData()
                             MBProgressHUD.hideAllHUDs(for:self.view, animated:true)
                            let alert = UIAlertView.init(title:"Touchline Bet", message:"Please check your internet connection. Try again..", delegate:self, cancelButtonTitle:"Ok")
                            alert.show()
                        }
                       
                    }
                    
                }
                catch {
                    let responseString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                    DispatchQueue.main.async {
                        self.TBL.reloadData()
                         MBProgressHUD.hideAllHUDs(for:self.view, animated:true)
                        let alert = UIAlertView.init(title:"Touchline Bet", message:"Please check your internet connection. Try again..", delegate:self, cancelButtonTitle:"Ok")
                        alert.show()
                    }
                    //print("responseString = \(responseString)")
                    
                }
           
        }
        task.resume()
    }
    
    @IBAction func btnToday(_ sender: Any) {
        //defDay = 0
//        if addRefreshPool {
//            addRefreshPool = false
//            refreshControl1.removeFromSuperview()
//            refreshControl = UIRefreshControl()
//            refreshControl.tintColor = UIColor.clear
//            refreshControl.attributedTitle = NSAttributedString(string: "")
//            refreshControl.addTarget(self, action: #selector(ViewController.refresh), for: UIControlEvents.valueChanged)
//            TBL.addSubview(refreshControl)
//        }
        imgRefresh.isHidden = true
        btnRefresh.isUserInteractionEnabled = false
         betView.isHidden = true
        OddView.isHidden = true
        tab = 0
        DispatchQueue.main.async {
            self.lblYes.isHidden = true
            self.lblBet.isHidden = true
            self.lblHigh.isHidden = true
            self.lblToday.isHidden = false
            self.img_bet.image = #imageLiteral(resourceName: "bet_black")
            self.img_yes.image = #imageLiteral(resourceName: "yes_black")
            self.img_high.image = #imageLiteral(resourceName: "high_black")
            self.img_today.image = #imageLiteral(resourceName: "today_red")
        }

        TBL.setContentOffset(CGPoint(x: 0, y: 0), animated:false)
//        DispatchQueue.main.async {
//            self.btnTodday.titleLabel?.textColor = UIColor.white
//            self.btnYesterday.titleLabel?.textColor = UIColor.black
//           self.hud = MBProgressHUD.showAdded(to:self.view, animated:true)
//           self.hud.label.text = "Fetching data. Please wait..."
//        }
//        slideryes.isHidden = true
//        sliderToday.isHidden = false
        if responseArr?.count != nil {
            headerCount = (responseArr?.count)!
            DispatchQueue.main.async {
                self.TBL.reloadData()
            }
        } else {
            callTodayWebservice()
        }

    }
    func callTommorowWebservice(){
       hud = MBProgressHUD.showAdded(to:self.view, animated:true)
        hud.label.text = "Fetching data. Please wait..."
        let url = URL(string:"http://www.touchlinebet.com/feedsv4/old.json")!
        print(url)
        URLCache.shared.removeAllCachedResponses()
        let request = NSMutableURLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            self.refreshControl.endRefreshing()
            if error != nil {
                DispatchQueue.main.async {
                    self.TBL.reloadData()
                    MBProgressHUD.hideAllHUDs(for:self.view, animated:true)
                    let alert = UIAlertView.init(title:"Touchline Bet", message:"Please check your internet connection. Try again..", delegate:self, cancelButtonTitle:"Ok")
                    alert.show()
                }
                return
            }

                do {
                    
                    if let response = try JSONSerialization.jsonObject(with: data!, options: []) as? NSArray {
                        DispatchQueue.main.async {
                            MBProgressHUD.hideAllHUDs(for:self.view, animated:true)
                        }
                        self.headerCount = (response.value(forKey:"country") as AnyObject).count!
                        self.isTomorrow = false
                        self.yesresponseArr = response
                       // print(self.responseArr)
                        DispatchQueue.main.async {
                            self.TBL.reloadData()
                        }
                    } else {
                        DispatchQueue.main.async {
                            
                            self.TBL.reloadData()
                            MBProgressHUD.hideAllHUDs(for:self.view, animated:true)
                            let alert = UIAlertView.init(title:"Touchline Bet", message:"Please check your internet connection. Try again..", delegate:self, cancelButtonTitle:"Ok")
                            alert.show()
                        }
                        
                    }
                    
                }
                catch {
                    let responseString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                    DispatchQueue.main.async {
                        self.TBL.reloadData()
                         MBProgressHUD.hideAllHUDs(for:self.view, animated:true)
                        let alert = UIAlertView.init(title:"Touchline Bet", message:"Please check your internet connection. Try again..", delegate:self, cancelButtonTitle:"Ok")
                        alert.show()
                    }
                    //print("responseString = \(responseString)")
                }
            }
        task.resume()
    }
    @IBAction func btnYesterday(_ sender: Any) {
        imgRefresh.isHidden = true
        btnRefresh.isUserInteractionEnabled = false
        justTimer.invalidate()
         betView.isHidden = true
        OddView.isHidden = true
        tab = 1
        DispatchQueue.main.async {
            self.lblYes.isHidden = false
            self.lblBet.isHidden = true
            self.lblHigh.isHidden = true
            self.lblToday.isHidden = true
            self.img_bet.image = #imageLiteral(resourceName: "bet_black")
            self.img_yes.image = #imageLiteral(resourceName: "yes_red")
            self.img_high.image = #imageLiteral(resourceName: "high_black")
            self.img_today.image = #imageLiteral(resourceName: "today_black")
        }
//        if addRefreshPool {
//            addRefreshPool = false
//            refreshControl1.removeFromSuperview()
//            refreshControl = UIRefreshControl()
//            refreshControl.tintColor = UIColor.clear
//            refreshControl.attributedTitle = NSAttributedString(string: "")
//            refreshControl.addTarget(self, action: #selector(ViewController.refresh), for: UIControlEvents.valueChanged)
//            TBL.addSubview(refreshControl)
//        }
        if isTomorrow {
            headerCount = 0
            self.isTomorrow = false

            DispatchQueue.main.async {
                self.TBL.setContentOffset(CGPoint(x: 0, y: 0), animated:false)
                self.TBL.reloadData()
                self.btnYesterday.titleLabel?.textColor = UIColor.white
                self.btnTodday.titleLabel?.textColor = UIColor.black
                
            }
           
            let alert = UIAlertController(title: "Touchline Bet", message: "Pull down to refresh", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            }))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        } else {
            DispatchQueue.main.async {
                if self.yesresponseArr == nil {
                    self.headerCount = 0
                    self.TBL.setContentOffset(CGPoint(x: 0, y: 0), animated:false)
                    self.TBL.reloadData()
                } else {
                    self.headerCount = (self.yesresponseArr?.count)!
                    self.TBL.setContentOffset(CGPoint(x: 0, y: 0), animated:false)
                    self.TBL.reloadData()
                }
                
            }
        }
    }
    
    @IBAction func btnRefresh(_ sender: Any) {
        
//        justTimer = Timer.scheduledTimer(timeInterval:1, target:self, selector:#selector(ViewController.showadd), userInfo:nil, repeats:true)
//        if defDay == 0{
//            createAndLoadInterstitial()
//            callTodayWebservice()
//        }
//        else{
//            createAndLoadInterstitial()
//            callTommorowWebservice()
//        }
    }
    func createAndLoadInterstitial(){
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-4544139061122026/4155661199")
        interstitial.load(GADRequest())
    }
    func showadd(){
       // print("Adv")
        if interstitial.isReady{
            ViewController.tmpAd = true
            justTimer.invalidate()
          //  print("invalidateTimer")
            interstitial.delegate = self
            self.interstitial?.present(fromRootViewController: self)
        }
    }
    func secondNotifyOperation(){
        createAndLoadInterstitial()
         justTimer = Timer.scheduledTimer(timeInterval:1, target:self, selector:#selector(ViewController.showadd), userInfo:nil, repeats:true)
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
    
    @IBAction func btnExit(_ sender: Any) {
        exit(0)
    }
    func callaboutService(){
        MBProgressHUD.showAdded(to:self.view, animated:true)
        
        let url = URL(string:"http://www.touchlinebet.com/privacy-policy/")!
        print(url)
        let request = NSMutableURLRequest(url: url)
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    MBProgressHUD.hideAllHUDs(for:self.view, animated:true)
                    let alert = UIAlertView.init(title:"Touchline Bet", message:"Please check your internet connection. Try again..", delegate:self, cancelButtonTitle:"Ok")
                    alert.show()
                }
                return
            }
            
            do {
                
                if let response = try JSONSerialization.jsonObject(with: data!, options: []) as? NSArray {
                    DispatchQueue.main.async {
                        MBProgressHUD.hideAllHUDs(for:self.view, animated:true)
                    }
                    self.headerCount = (response.value(forKey:"country") as AnyObject).count!
                   // self.responseArr = response
                    print(response)
                } else {
                    DispatchQueue.main.async {
                        MBProgressHUD.hideAllHUDs(for:self.view, animated:true)
                        let alert = UIAlertView.init(title:"Touchline Bet", message:"Please check your internet connection. Try again..", delegate:self, cancelButtonTitle:"Ok")
                        alert.show()
                    }
                    
                }
                
            }
            catch {
                let responseString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                DispatchQueue.main.async {
                    MBProgressHUD.hideAllHUDs(for:self.view, animated:true)
                    let alert = UIAlertView.init(title:"Touchline Bet", message:"Please check your internet connection. Try again..", delegate:self, cancelButtonTitle:"Ok")
                    alert.show()
                }
                //print("responseString = \(responseString)")
            }
        }
        task.resume()
    }
    
    @IBAction func btnAbout(_ sender: Any) {
        btnSelect = false
        menuView.removeGestureRecognizer(gesture)
        UIView.animate(withDuration:0.1, animations: {
            self.menuView.isHidden = true
        })
        let about = Bundle.main.loadNibNamed("policyVIew", owner:self, options:nil)?.first as! aboutView
        UIView.animate(withDuration:0.1) { 
            self.view.addSubview(about)
        }
    }

    
    
    @IBAction func btnHighOdds(_ sender: Any) {

        betView.isHidden = true
        OddView.isHidden = false
        tab = 2
        imgRefresh.isHidden = false
        btnRefresh.isUserInteractionEnabled = true

        DispatchQueue.main.async {
            self.lblYes.isHidden = true
            self.lblBet.isHidden = true
            self.lblHigh.isHidden = false
            self.lblToday.isHidden = true
            self.img_bet.image = #imageLiteral(resourceName: "bet_black")
            self.img_yes.image = #imageLiteral(resourceName: "yes_black")
            self.img_high.image = #imageLiteral(resourceName: "high_red")
            self.img_today.image = #imageLiteral(resourceName: "today_black")
        }

        if isOdd {
            isOdd = false
            let alert = UIAlertController(title: "Touchline Bet", message: "Click refresh button above", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            }))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        } else {
            
        }
    }
    
    

    @IBAction func btnBetslip(_ sender: Any) {

            betView.isHidden = false
            OddView.isHidden = true
            tab = 3
        imgRefresh.isHidden = false
        btnRefresh.isUserInteractionEnabled = true

        DispatchQueue.main.async {
            self.lblYes.isHidden = true
            self.lblBet.isHidden = false
            self.lblHigh.isHidden = true
            self.lblToday.isHidden = true
            self.img_bet.image = #imageLiteral(resourceName: "bet_red")
            self.img_yes.image = #imageLiteral(resourceName: "yes_black")
            self.img_high.image = #imageLiteral(resourceName: "high_black")
            self.img_today.image = #imageLiteral(resourceName: "today_black")
        }
 
        if isBet {
            isBet = false
            let alert = UIAlertController(title: "Touchline Bet", message: "Click refresh button above", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            }))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        } else {
            //callBetService()
        }
    }
    
    @IBAction func btnMenuThnx(_ sender: Any) {
        btnSelect = false
        menuView.removeGestureRecognizer(gesture)
        UIView.animate(withDuration:0.1, animations: {
            self.menuView.isHidden = true
            UIApplication.shared.openURL(URL(string:"https://www.paypal.me/touchlinebet")!)
        })
    }
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        justTimer.invalidate()
        //            buttonDisplay = false
//        if buttonDisplay{
//            justTimer.invalidate()
//            buttonDisplay = false
//            let VC = self.storyboard?.instantiateViewController(withIdentifier:"highController")
//            self.navigationController?.pushViewController(VC!, animated:true)
//        }
//        else if buttonDisplay1{
//            justTimer.invalidate()
//            buttonDisplay1 = false
//            let VC = self.storyboard?.instantiateViewController(withIdentifier:"betController")
//            self.navigationController?.pushViewController(VC!, animated:true)
//        }
//        print("interstitialDidDismissScreen")
    }
    func refresh() {
        justTimer = Timer.scheduledTimer(timeInterval:1, target:self, selector:#selector(ViewController.showadd), userInfo:nil, repeats:true)
        if tab == 0 {
            callTodayWebservice()
            createAndLoadInterstitial()
        } else if tab == 1 {
            callTommorowWebservice()
            createAndLoadInterstitial()
        }
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
                self.txtView.backgroundColor = UIColor.init(red: 93/255.0, green: 99/255.0, blue: 103/255.0, alpha: 1.0)
                self.txtView.attributedText = attrStr
                MBProgressHUD.hideAllHUDs(for:self.view, animated:true)
            }
            
            }.resume()
    }
    func callHighoddService(){
        hud = MBProgressHUD.showAdded(to:self.view, animated:true)
        hud.label.text = "Fetching data. Please wait..."
        var request = URLRequest(url:URL(string:"http://touchlinebet.com/feedsv4/highodds.txt")!)
        request.httpMethod = "Get"
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        URLSession.shared.dataTask(with:request) { (data,response,error) in
            var resStr = ""
            if data != nil {
                resStr = String(data: data!, encoding: .utf8)!
            }
            
            let attrStr = try! NSAttributedString(
                data: (resStr.data(using: String.Encoding.unicode, allowLossyConversion: true)!),
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            
            DispatchQueue.main.async {
                self.txtOddView.backgroundColor = UIColor.init(red: 93/255.0, green: 99/255.0, blue: 103/255.0, alpha: 1.0)
                self.txtOddView.attributedText = attrStr
                MBProgressHUD.hideAllHUDs(for:self.view, animated:true)
            }
            
            }.resume()
    }
    
    
    @IBAction func btnStarClickeds(_ sender: Any) {
        let urlStr = "https://itunes.apple.com/app/id1219166150"
        UIApplication.shared.openURL(URL(string: urlStr)!)
        
    }
    
    func openStoreProductWithiTunesItemIdentifier(identifier: String) {
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        
        let parameters = [ SKStoreProductParameterITunesItemIdentifier : identifier]
        storeViewController.loadProduct(withParameters: parameters) { [weak self] (loaded, error) -> Void in
            if loaded {
                // Parent class of self is UIViewContorller
                self?.present(storeViewController, animated: true, completion: nil)
            }
        }
    }
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnRefreshClicked(_ sender: Any) {
        createAndLoadInterstitial()
        justTimer = Timer.scheduledTimer(timeInterval:1, target:self, selector:#selector(ViewController.showadd), userInfo:nil, repeats:true)
        if tab == 2 {
            callHighoddService()
        } else if tab == 3 {
            callBetService()
        }
    }
}

