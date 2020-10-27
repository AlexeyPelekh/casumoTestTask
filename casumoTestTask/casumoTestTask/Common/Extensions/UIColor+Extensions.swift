//
//  UIColor+Extensions.swift
//  casumoTestTask
//
//  Created by Oleksii Pelekh on 27.10.2020.
//

import Foundation

import UIKit

extension UIColor {
    static func colorForEventType(eventType: String?) -> UIColor {
        switch eventType {
        case Event.EventType.pushEvent.rawValue:
            return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        case Event.EventType.pullRequestEvent.rawValue:
            return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        case Event.EventType.createEvent.rawValue:
            return #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        case Event.EventType.pushEvent.rawValue:
            return #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        case Event.EventType.pullRequestEvent.rawValue:
            return #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        case Event.EventType.createEvent.rawValue:
            return #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        case Event.EventType.publicEvent.rawValue:
            return #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        case Event.EventType.deleteEvent.rawValue:
            return #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        case Event.EventType.issueCommentEvent.rawValue:
            return #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        case Event.EventType.watchEvent.rawValue:
            return #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        case Event.EventType.forkEvent.rawValue:
            return #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        case Event.EventType.issuesEvent.rawValue:
            return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        case Event.EventType.pullRequestReviewCommentEvent.rawValue:
            return #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)
        case Event.EventType.pullRequestReviewEvent.rawValue:
            return #colorLiteral(red: 1, green: 0.3892855048, blue: 0.7500491738, alpha: 1)
        case Event.EventType.commitCommentEvent.rawValue:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        default:
            return #colorLiteral(red: 0.2244646549, green: 0.9471392035, blue: 1, alpha: 1)
        }
    }
}
