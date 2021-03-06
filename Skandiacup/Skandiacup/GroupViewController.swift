//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import UIKit

class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var groups: [MatchGroup]? {
        didSet{
            groups = groups?.filter{
                $0.isPlayoff == false
            }
            groups?.sortInPlace{($0.name < $1.name)}
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("teamCell") as UITableViewCell!
        if let group = groups?[indexPath.row]{
            if let name = group.name{
                cell.textLabel?.text = "\(SharingManager.locale.teamCellGroup) \(name)"
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups!.count
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "groupToTeamView"{
            if let indexPath = self.groupTableView.indexPathForSelectedRow{
                (segue.destinationViewController as! TeamViewController).currentGroup = groups![indexPath.row]
                (segue.destinationViewController as! TeamViewController).currentMatchClass = currentGroup
            }
        }
    }
}
