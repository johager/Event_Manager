//
//  EventListViewController.swift
//  EventManager
//
//  Created by James Hager on 4/1/22.
//

import UIKit

class EventListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Strings.showEventDetails,
              let indexPath = tableView.indexPathForSelectedRow,
              let destination = segue.destination as? EventDetailViewController
        else { return }
        destination.event = EventController.shared.events[indexPath.row]
    }
}

// MARK: - UITableViewDataSource

extension EventListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventController.shared.events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Strings.eventCell, for: indexPath) as? EventTableViewCell
        else { return UITableViewCell() }
        
        cell.configure(with: EventController.shared.events[indexPath.row], andDelegate: self)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        EventController.shared.deleteEvent(atIndex: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

// MARK: -

extension EventListViewController: EventTableViewCellDelegate {
    
    func toggleIsAttendingForEvent(in cell: EventTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        EventController.shared.toggleIsAttendingForEvent(atIndex: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
