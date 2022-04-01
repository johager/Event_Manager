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
    }
    
    // MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = nameTextField?.text,
              !name.isEmpty,
              let date = datePicker?.date
        else { return }
        
        if let event = event {
            EventController.shared.update(event, name: name, date: date)
        } else {
            EventController.shared.createEvent(name: name, date: date)
        }
        
        navigationController?.popViewController(animated: true)
    }
}
