//
//  PullRequest.swift
//  casumoTestTask
//
//  Created by Oleksii Pelekh on 25.10.2020.
//

import Foundation

struct PullRequest: Decodable {
    let url: String?
    let id: Int?
    let node_id: String?
    let html_url: String?
    let diff_url: String?
    let patch_url: String?
    let issue_url: String?
    let number: Int?
    let state: String?
    let locked: Bool?
    let title: String?
    let user: User?
    let body: String?
    let created_at: String?
    let updated_at: String?
    let closed_at: String?
    let merged_at: String?
    let merge_commit_sha: String?
    let assignee: String?
    let assignees: [String]?
    let requested_reviewers: [String]?
    let requested_teams: [String]?
    let labels: [Label]?
    let milestone: String?
    let draft: Bool?
    let commits_url: String?
    let review_comments_url: String?
    let review_comment_url: String?
    let comments_url: String?
    let statuses_url: String?
    let head: Head?
    let base: Base?
    let author_association: String?
    let active_lock_reason: String?
    let merged: Bool?
    let mergeable: Bool?
    let rebaseable: Bool?
    let mergeable_state: String?
    let merged_by: MergedBy?
    let comments: Int?
    let review_comments: Int?
    let maintainer_can_modify: Bool?
    let commits: Int?
    let additions: Int?
    let deletions: Int?
    let changed_files: Int?
    let href: String?
}
