import UIKit

class HomeViewController: UIViewController {


    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var newsView: UIView!
    @IBOutlet weak var sosialView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var viewShowing = 0;

    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            showNewsTab()
            //  self.callViewChangedToChildController(NewsViewController)
        case 1:
            showInfoTab()
        case 2:
            showSosialTab()
        default: break
//            print("erroe")
        }
    }
    
    func showNewsTab(){
        viewShowing = 0;
        newsView.hidden = false
        infoView.hidden = true
        sosialView.hidden = true
        headerLabel.hidden = true
        //segmentedControl.selectedSegmentIndex = 1
    }
    
    func showInfoTab(){
        viewShowing = 1;
        newsView.hidden = true
        infoView.hidden = false
        sosialView.hidden = true
        headerLabel.hidden = true
        //segmentedControl.selectedSegmentIndex = 2
       
        self.callViewChangedToChildController(InfoViewController)
    }
    
    func showSosialTab(){
        viewShowing = 2;
        newsView.hidden = true
        infoView.hidden = true
        sosialView.hidden = false
        headerLabel.hidden = false
        //segmentedControl.selectedSegmentIndex = 3

        self.callViewChangedToChildController(SosialViewController)
    }
    
    override func viewDidAppear(animated: Bool) {
        switch segmentedControl.selectedSegmentIndex{
//        case 0:
//            self.callViewChangedToChildController(NewsViewController)
        case 1:
            self.callViewChangedToChildController(InfoViewController)
        case 2:
            self.callViewChangedToChildController(SosialViewController)
        default: break
//            print("erroe")
        }
    }
    
    func callViewChangedToChildController<T : SegmentChangeProto>(t : T.Type) {
        self.childViewControllers.forEach({ (child) -> () in
            if let tempController = child as? T {
                tempController.viewChangedTo()
            }
        })
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoView.hidden = true
        newsView.hidden = false
        sosialView.hidden = true
        // Do any additional setup after loading the view.
        activityIndicator.startAnimating()
        newsView.hidden = true

        //Swipes
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            print("Swipe Left")
            if (viewShowing==0){
                showInfoTab()
                segmentedControl.selectedSegmentIndex = 1
            } else if (viewShowing==1){
                showSosialTab()
                segmentedControl.selectedSegmentIndex = 2
            } else if (viewShowing==2){
                print("allerede helt til venstre")
            } else {
                print("nothing")
            }
        }
        
        if (sender.direction == .Right) {
            print("Swipe Right")
            if (viewShowing==0){
                print("allerede helt til hoyre")
            } else if (viewShowing==1){
                showNewsTab()
                segmentedControl.selectedSegmentIndex = 0

            } else if (viewShowing==2){
                showInfoTab()
                segmentedControl.selectedSegmentIndex = 1

            } else {
                print("nothing")
            }
            
        }
    }
}
