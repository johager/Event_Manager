//
//  EventTableViewCell.swift
//  EventManager
//
//  Created by James Hager on 4/1/22.
//

import UIKit

protocol EventTableViewCellDelegate: AnyObject {
    func toggleIsAttendingForEvent(in cell: EventTableViewCell)
}

// MARK: -

class EventTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var hasAlarmLabel: UILabel!
    @IBOutlet weak var isAttendingButton: UIButton!
    
    // MARK: - Properties
    
    weak var delegate: EventTableViewCellDelegate?
    
    // MARK: - View Methods
    
    func configure(with event: Event, andDelegate delegate: EventTableViewCellDelegate) {
        nameLabel?.text = event.name
        dateLabel?.text = event.date.stringForEventDate
        hasAlarmLabel?.text = event.hasAlarm ? "⏰" : ""
        let image = event.isAttending ? UIImage(systemName: Strings.clockFillImageName) : UIImage(systemName: Strings.clockImageName)
        isAttendingButton.setImage(image, for: .normal)
        self.delegate = delegate
    }

    // MARK: - Actions

    @IBAction func isAttendingButtonTapped(_ sender: UIButton) {
        delegate?.toggleIsAttendingForEvent(in: self)
    }
}
