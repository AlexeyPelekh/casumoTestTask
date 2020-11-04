//
//  EventViewModel.swift
//  casumoTestTask
//
//  Created by Oleksii Pelekh on 01.11.2020.
//

import Foundation
import RxSwift
import RxCocoa

class EventViewModel {
    private let networkManager = NetworkManager()

    var events = BehaviorRelay(value: [Event]())
    var filteredEvents = BehaviorRelay(value: [Event]())

    func fetchProductList() {
        networkManager.request { response in
            switch response {
            case .success(let data):
                if let events = try? JSONDecoder().decode([Event].self, from: data) {
                    self.events.accept(events)
                    self.filteredEvents.accept(events)
                }

            case .failure(let error):
                print(error)
            }
        }
    }
}
