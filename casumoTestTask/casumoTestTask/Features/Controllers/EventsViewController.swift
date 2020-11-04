//
//  EventsViewController.swift
//  casumoTestTask
//
//  Created by Oleksii Pelekh on 26.10.2020.
//

import UIKit
import RxSwift
import RxCocoa

class EventsViewController: UIViewController, UITableViewDelegate {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchFooter: SearchFooter!
    @IBOutlet private weak var searchFooterBottomConstraint: NSLayoutConstraint!

    private let searchController = UISearchController(searchResultsController: nil)
    private let refreshControl = UIRefreshControl()

    private let disposeBag = DisposeBag()
    private let viewModel = EventViewModel()

    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        viewModel.fetchProductList()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    private func setupUI() {
        setupReactiveBindings()

        setupSearchController()
        setupNotifications()
    }

    private func setupReactiveBindings() {
        setupTableView()
        setupRefreshControl()

        viewModel.filteredEvents
            .bind(to: self.tableView.rx.items(cellIdentifier: Constants.eventTableViewCellIdentifier, cellType: EventTableViewCell.self)) { index, event, cell in
                cell.eventTypeLabel?.text = event.type
                cell.eventIdLabel?.text = event.id
                cell.eventCreatedAtLabel?.text = event.created_at
                cell.eventTypeColorView.backgroundColor = UIColor.colorForEventType(eventType: event.type)}
            .disposed(by: disposeBag)

    }

    private func setupTableView() {
        tableView.register(UINib(nibName: Constants.eventTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: Constants.eventTableViewCellIdentifier)
        tableView.addSubview(refreshControl)

        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        tableView.rx
            .modelSelected(Event.self)
            .subscribe(onNext: { [weak self] event in
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let detailViewController = storyBoard.instantiateViewController(withIdentifier: Constants.detailViewControllerIdentifier) as! DetailViewController
                        detailViewController.event = event
                        self?.navigationController?.pushViewController(detailViewController, animated: true)})
            .disposed(by: disposeBag)
    }

    private func setupRefreshControl() {
        refreshControl.rx
            .controlEvent(UIControl.Event.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.fetchProductList()
                self?.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
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

    private func setupNotifications() {
        let notificationCenter = NotificationCenter.default

        notificationCenter.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification,
                                       object: nil, queue: .main) { (notification) in
            self.handleKeyboardState(notification: notification) }
        notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                       object: nil, queue: .main) { (notification) in
            self.handleKeyboardState(notification: notification) }
    }

    private func filterTableViewContentForSearchText(_ searchText: String,
                                                     eventType: Event.EventType? = nil) {
        let filteredEvents = viewModel.events.value.filter { (event: Event) -> Bool in
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

        searchFooter.setIsFilteringToShow(filteredItemCount: filteredEvents.count, of: viewModel.events.value.count)
        viewModel.filteredEvents.accept(filteredEvents)
    }

    private func handleKeyboardState(notification: Notification) {
        guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
            searchFooterBottomConstraint.constant = 0
            view.layoutIfNeeded()

            return
        }

        guard let info = notification.userInfo,
              let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardHeight = keyboardFrame.cgRectValue.size.height - self.view.safeAreaInsets.bottom

        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.searchFooterBottomConstraint.constant = keyboardHeight
            self.view.layoutIfNeeded()
        })
    }
}

extension EventsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let eventType = Event.EventType(rawValue: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
        filterTableViewContentForSearchText(searchBar.text ?? "", eventType: eventType)
    }
}

extension EventsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let eventType = Event.EventType(rawValue: searchBar.scopeButtonTitles?[selectedScope] ?? "")
        filterTableViewContentForSearchText(searchBar.text ?? "", eventType: eventType)
    }
}

private extension EventsViewController {
    struct Constants {
        static let detailViewControllerIdentifier = "DetailViewController"
        static let eventTableViewCellIdentifier = "EventTableViewCell"
        static let searchBarPlaceholderText = "Search Events (by id)"
    }
}
