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
            eventDetailInfoTextField.text = String(describing: event)
        }
    }
}
