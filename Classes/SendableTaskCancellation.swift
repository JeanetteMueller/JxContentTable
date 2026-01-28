//
//  SendableTaskCancellation.swift
//  JxContentTable
//
//  Created by Jeanette Müller on 25.10.25.
//  Copyright © 2025 Jeanette Müller. All rights reserved.
//

import Foundation

public protocol SendableTaskCancellation: AnyObject, Sendable {
    @MainActor var asyncTasks: [Task<Void, Never>] { get set }
}

public extension SendableTaskCancellation {
    @discardableResult @MainActor
    func cancellationTask(
        _ action: @escaping @MainActor @Sendable () async -> Void
    ) -> Task<Void, Never> {
        let task = Task.detached {
            await action()
        }
        asyncTasks.append(task)

        return task
    }

    func cancelTasks() {
        MainActor.assumeIsolated {
            asyncTasks.forEach { $0.cancel() }
            asyncTasks = []
        }
    }
}
