//
//  Event.swift
//  casumoTestTask
//
//  Created by Oleksii Pelekh on 25.10.2020.
//

import Foundation

struct Event: Decodable {
    let id: String?
    let type: EventType?
    let actor: Actor?
    let repo: Repo?
    let payload: Payload?
    let isPublic: Bool?
    let created_at: String?

    enum EventType: Decodable {
        case all
        case pushEvent
        case pullRequestEvent
        case createEvent
        case other
    }
}

extension Event.EventType: CaseIterable { }

extension Event.EventType: RawRepresentable {
    typealias RawValue = String

    init?(rawValue: RawValue) {
        switch rawValue {
        case "All": self = .all
        case "PushEvent": self = .pushEvent
        case "PullRequestEvent": self = .pullRequestEvent
        case "CreateEvent": self = .createEvent
        case "Other": self = .other

        default: return nil
        }
    }

    var rawValue: RawValue {
        switch self {
        case .all: return "All"
        case .pushEvent: return "PushEvent"
        case .pullRequestEvent: return "PullRequestEvent"
        case .createEvent: return "CreateEvent"
        case .other: return "Other"
        }
    }
}
