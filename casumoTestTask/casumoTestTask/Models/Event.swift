//
//  Event.swift
//  casumoTestTask
//
//  Created by Oleksii Pelekh on 25.10.2020.
//

import Foundation

struct Event: Decodable {
    let id: String?
    let type: String?
    let actor: Actor?
    let repo: Repo?
    let payload: Payload?
    let isPublic: Bool?
    let created_at: String?

    enum EventType: String, Decodable {
        case all
        case pushEvent
        case pullRequestEvent
        case createEvent
        case publicEvent
        case deleteEvent
        case issueCommentEvent
        case watchEvent
        case forkEvent
        case issuesEvent
        case pullRequestReviewCommentEvent
        case pullRequestReviewEvent
        case commitCommentEvent
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
        case "PublicEvent": self = .publicEvent
        case "DeleteEvent": self = .deleteEvent
        case "IssueCommentEvent": self = .issueCommentEvent
        case "WatchEvent": self = .watchEvent
        case "ForkEvent": self = .forkEvent
        case "IssuesEvent": self = .issuesEvent
        case "PullRequestReviewCommentEvent": self = .pullRequestReviewCommentEvent
        case "PullRequestReviewEvent": self = .pullRequestReviewEvent
        case "CommitCommentEvent": self = .commitCommentEvent
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
        case .publicEvent: return "PublicEvent"
        case .deleteEvent: return "DeleteEvent"
        case .issueCommentEvent: return "IssueCommentEvent"
        case .watchEvent: return "WatchEvent"
        case .forkEvent: return "ForkEvent"
        case .issuesEvent: return "IssuesEvent"
        case .pullRequestReviewCommentEvent: return "PullRequestReviewCommentEvent"
        case .pullRequestReviewEvent: return "PullRequestReviewEvent"
        case .commitCommentEvent: return "CommitCommentEvent"
        case .other: return "Other"
        }
    }
}
