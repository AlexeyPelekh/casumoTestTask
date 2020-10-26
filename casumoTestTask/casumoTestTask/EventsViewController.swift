//
//  EventsViewController.swift
//  casumoTestTask
//
//  Created by Oleksii Pelekh on 26.10.2020.
//

import UIKit

class EventsViewController: UIViewController, UITableViewDelegate {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchFooter: SearchFooter!
    @IBOutlet private weak var searchFooterBottomConstraint: NSLayoutConstraint!

    private let networkManager = NetworkManager()
    private let searchController = UISearchController(searchResultsController: nil)

    private var events: [Event] = []
    private var filteredEvents: [Event] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(nibName: "EventTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "EventTableViewCell")

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Events"
        navigationItem.searchController = searchController
        definesPresentationContext = true

        networkManager.request(url: "https://api.github.com/events?per_page=100", completion: { response in
            switch response {
            case .success(let data):
                if let events = try? JSONDecoder().decode([Event].self, from: data) {
                    self.events = events
                    self.tableView.reloadData()
                }

            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

                self.present(alert, animated: true)
            }
        })

        searchController.searchBar.scopeButtonTitles = Event.EventType.allCases.map { $0.rawValue }
        searchController.searchBar.delegate = self

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification,
                                       object: nil, queue: .main) { (notification) in
            self.handleKeyboard(notification: notification) }
        notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                       object: nil, queue: .main) { (notification) in
            self.handleKeyboard(notification: notification) }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "DetailViewController",
            let indexPath = tableView.indexPathForSelectedRow,
            let detailViewController = segue.destination as? DetailViewController
        else {
            return
        }

        let event: Event?
        if isFiltering {
            event = filteredEvents[indexPath.row]
        } else {
            event = events[indexPath.row]
        }
        detailViewController.event = event
    }

    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }

    func filterContentForSearchText(_ searchText: String,
                                    eventType: Event.EventType? = nil) {
//        filteredEvents = events.filter { (event: Event) -> Bool in
//            let doesCategoryMatch = eventType == .all || event.type == eventType
//
//            if isSearchBarEmpty {
//                return doesCategoryMatch
//            } else {
//                return doesCategoryMatch && String(event.id ?? "").contains(searchText.lowercased())
//            }
//        }

        tableView.reloadData()
    }

    func handleKeyboard(notification: Notification) {
        guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
            searchFooterBottomConstraint.constant = 0
            view.layoutIfNeeded()
            return
        }

        guard
            let info = notification.userInfo,
            let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
            return
        }

        let keyboardHeight = keyboardFrame.cgRectValue.size.height
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.searchFooterBottomConstraint.constant = keyboardHeight
            self.view.layoutIfNeeded()
        })
    }

}

extension EventsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            searchFooter.setIsFilteringToShow(filteredItemCount:
                                                filteredEvents.count, of: events.count)
            return filteredEvents.count
        }

        searchFooter.setNotFiltering()

        return events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as! EventTableViewCell
        let event: Event
        if isFiltering {
            event = filteredEvents[indexPath.row]
        } else {
            event = events[indexPath.row]
        }

        cell.eventTypeLabel?.text = event.type
        cell.eventIdLabel?.text = event.id
        cell.eventCreatedAtLabel?.text = event.created_at

        switch event.type {
        case Event.EventType.all.rawValue:
            cell.eventTypeColorView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        case Event.EventType.pushEvent.rawValue:
            cell.eventTypeColorView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        case Event.EventType.pullRequestEvent.rawValue:
            cell.eventTypeColorView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        case Event.EventType.createEvent.rawValue:
            cell.eventTypeColorView.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        case Event.EventType.other.rawValue:
            cell.eventTypeColorView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        default:
            cell.eventTypeColorView.backgroundColor = #colorLiteral(red: 0.2244646549, green: 0.9471392035, blue: 1, alpha: 1)
        }

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegue(withIdentifier: "DetailViewController", sender: indexPath)
    }
}

extension EventsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let eventType = Event.EventType(rawValue:
                                            searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
        filterContentForSearchText(searchBar.text!, eventType: eventType)
    }
}

extension EventsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let eventType = Event.EventType(rawValue:
                                            searchBar.scopeButtonTitles![selectedScope])
        filterContentForSearchText(searchBar.text!, eventType: eventType)
    }
}
