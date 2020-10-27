//
//  DetailViewController.swift
//  casumoTestTask
//
//  Created by Oleksii Pelekh on 26.10.2020.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var eventIdLabel: UILabel!
    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var eventCreatedAtLabel: UILabel!
    @IBOutlet weak var eventDetailInfoTextField: UITextView!
    @IBOutlet weak var accessoryView: UIView!
    
    var event: Event? {
        didSet {
            configureView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }

    func configureView() {
        if let event = event,
           let eventIdLabel = eventIdLabel,
           let eventTypeLabel = eventTypeLabel,
           let eventCreatedAtLabel = eventCreatedAtLabel,
           let eventDetailInfoTextField = eventDetailInfoTextField {
            eventIdLabel.text = event.id
            eventTypeLabel.text = event.type
            eventCreatedAtLabel.text = event.created_at
            eventDetailInfoTextField.text = textForTheDetailView(eventDescription: String(describing: event))
            accessoryView.backgroundColor = UIColor.colorForEventType(eventType: event.type)
        }
    }

    private func textForTheDetailView(eventDescription: String) -> String {
        // TODO: - should be replaced with an adequate solution
        return eventDescription.replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: "), ", with: "\n - ").replacingOccurrences(of: ", ", with: "\n - ").replacingOccurrences(of: "Event(", with: " - ").replacingOccurrences(of: "casumoTestTask.Repo(", with: "").replacingOccurrences(of: "casumoTestTask.Actor(", with: "").replacingOccurrences(of: "casumoTestTask.Payload(", with: "").replacingOccurrences(of: "))", with: "")
    }
}
