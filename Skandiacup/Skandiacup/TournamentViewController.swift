//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import UIKit

class TournamentViewController: UIViewController{
    @IBOutlet weak var teamsView: UIView!
    @IBOutlet weak var groupsView: UIView!

    
     func switchTable(index: Int) {
        switch index {
        case 0:
            teamsView.hidden = false
            groupsView.hidden = true
        case 1:
            teamsView.hidden = true
            groupsView.hidden = false
        default:
            break;
        }
    }

   override func viewDidLoad() {
        super.viewDidLoad()
        teamsView.hidden = false
        groupsView.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}