import UIKit

class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var groups: [MatchGroup]? {
        didSet{
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.groupTableView.reloadData()
            }
        }
    }
    var currentGroup: MatchClass?
    var teamToSegue: TournamentTeam?
    
    @IBOutlet weak var groupTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        groupTableView.delegate = self
        groupTableView.dataSource = self
        groups = currentGroup!.matchGroups
            // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("teamCell") as UITableViewCell!
        cell.textLabel?.text = groups![indexPath.row].name
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups!.count
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "groupToTeamView"{
            if let indexPath = self.groupTableView.indexPathForSelectedRow{
                (segue.destinationViewController as! TeamViewController).currentGroup = groups![indexPath.row]
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
