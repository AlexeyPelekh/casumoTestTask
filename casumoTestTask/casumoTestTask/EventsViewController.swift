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

    private let searchController = UISearchController(searchResultsController: nil)
    private let refreshControl = UIRefreshControl()

    private let networkManager = NetworkManager()
    private var events: [Event] = []
    private var filteredEvents: [Event] = []

    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupRefreshControl()
        setupSearchController()
        setupNotifications()
        getEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constants.detailViewControllerSegueIdentifier,
            let indexPath = tableView.indexPathForSelectedRow,
            let detailViewController = segue.destination as? DetailViewController
        else { return }

        let event: Event?

        if isFiltering {
            event = filteredEvents[indexPath.row]
        } else {
            event = events[indexPath.row]
        }

        detailViewController.event = event
    }

    @objc private func refresh(_ sender: AnyObject) {
        getEvents()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(nibName: Constants.eventTableViewCellIdentifier, bundle: Bundle.main), forCellReuseIdentifier: Constants.eventTableViewCellIdentifier)
    }

    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.searchBarPlaceholderText
        searchController.searchBar.scopeButtonTitles = [Event.EventType.all.rawValue,
                                                        Event.EventType.pushEvent.rawValue,
                                                        Event.EventType.pullRequestEvent.rawValue,
                                                        Event.EventType.createEvent.rawValue,
                                                        Event.EventType.other.rawValue]
        searchController.searchBar.delegate = self

        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func getEvents() {
        networkManager.request { response in
            switch response {
            case .success(let data):
                self.refreshControl.endRefreshing()
                if let events = try? JSONDecoder().decode([Event].self, from: data) {
                    self.events = events
                    self.tableView.reloadData()
                }

            case .failure(let error):
                let alert = UIAlertController(title: Constants.alertErrorTitle, message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: Constants.alertActionTitle, style: .default, handler: nil))

                self.present(alert, animated: true)
            }
        }
    }

    private func setupNotifications() {
        let notificationCenter = NotificationCenter.default

        notificationCenter.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification,
                                       object: nil, queue: .main) { (notification) in
            self.handleKeyboard(notification: notification) }

        notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                       object: nil, queue: .main) { (notification) in
            self.handleKeyboard(notification: notification) }
    }

    private func filterContentForSearchText(_ searchText: String,
                                            eventType: Event.EventType? = nil) {
        filteredEvents = events.filter { (event: Event) -> Bool in
            let doesCategoryMatch = eventType == .all || event.type == eventType?.rawValue ||
                (eventType == .other && event.type != Event.EventType.pushEvent.rawValue && event.type != Event.EventType.pullRequestEvent.rawValue && event.type != Event.EventType.createEvent.rawValue)

            if isSearchBarEmpty {
                return doesCategoryMatch
            } else if event.type == Event.EventType.other.rawValue {
                return doesCategoryMatch && String(event.id ?? "").contains(searchText.lowercased())
            } else {
                return doesCategoryMatch && String(event.id ?? "").contains(searchText.lowercased())
            }
        }

        tableView.reloadData()
    }

    private func handleKeyboard(notification: Notification) {
        guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
            searchFooterBottomConstraint.constant = 0
            view.layoutIfNeeded()

            return
        }

        guard let info = notification.userInfo,
              let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

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
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredEvents.count, of: events.count)

            return filteredEvents.count
        }

        searchFooter.setNotFiltering()

        return events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.eventTableViewCellIdentifier, for: indexPath) as! EventTableViewCell
        let event: Event

        if isFiltering {
            event = filteredEvents[indexPath.row]
        } else {
            event = events[indexPath.row]
        }

        cell.eventTypeLabel?.text = event.type
        cell.eventIdLabel?.text = event.id
        cell.eventCreatedAtLabel?.text = event.created_at
        cell.eventTypeColorView.backgroundColor = UIColor.colorForEventType(eventType: event.type)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.detailViewControllerSegueIdentifier, sender: indexPath)
    }
}

extension EventsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let eventType = Event.EventType(rawValue: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
        filterContentForSearchText(searchBar.text!, eventType: eventType)
    }
}

extension EventsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let eventType = Event.EventType(rawValue: searchBar.scopeButtonTitles![selectedScope])
        filterContentForSearchText(searchBar.text!, eventType: eventType)
    }
}

private extension EventsViewController {
    struct Constants {
        static let detailViewControllerSegueIdentifier = "DetailViewController"
        static let eventTableViewCellIdentifier = "EventTableViewCell"
        static let alertErrorTitle = "Error"
        static let alertActionTitle = "Ok"
        static let searchBarPlaceholderText = "Search Events (by id)"
    }
}
