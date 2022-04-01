//
//  EventDetailViewController.swift
//  EventManager
//
//  Created by James Hager on 4/1/22.
//

import UIKit

class EventDetailViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var alarmAtEventSwitch: UISwitch!
    @IBOutlet weak var alarm1HourSwitch: UISwitch!
    @IBOutlet weak var alarm1DaySwitch: UISwitch!
    @IBOutlet weak var alarm1WeekSwitch: UISwitch!
    
    
    // MARK: - Properties
    
    var event: Event?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    // MARK: - View Methods
    
    func updateViews() {
        guard let event = event else {
            title = "Create New Event"
            return
        }

        title = "Event Details"
        
        nameTextField?.text = event.name
        datePicker?.date = event.date
        
        alarmAtEventSwitch?.isOn = event.alarmAtEvent
        alarm1HourSwitch?.isOn = event.alarm1Hour
        alarm1DaySwitch?.isOn = event.alarm1Day
        alarm1WeekSwitch?.isOn = event.alarm1Week
    }
    
    // MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = nameTextField?.text,
              !name.isEmpty,
              let date = datePicker?.date,
              let alarm1Day = alarm1DaySwitch?.isOn,
              let alarm1Hour = alarm1HourSwitch?.isOn,
              let alarm1Week = alarm1WeekSwitch?.isOn,
              let alarmAtEvent = alarmAtEventSwitch?.isOn
        else { return }
        
        if let event = event {
            EventController.shared.update(event, name: name, date: date, alarm1Day: alarm1Day, alarm1Hour: alarm1Hour, alarm1Week: alarm1Week, alarmAtEvent: alarmAtEvent)
        } else {
            EventController.shared.createEvent(name: name, date: date, alarm1Day: alarm1Day, alarm1Hour: alarm1Hour, alarm1Week: alarm1Week, alarmAtEvent: alarmAtEvent)
        }
        
        navigationController?.popViewController(animated: true)
    }
}
