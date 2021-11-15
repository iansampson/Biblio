//
//  ProvisionActivity.swift
//  
//
//  Created by Ian Sampson on 2021-11-15.
//

struct ProvisionActivity {
    let place: String?
    let agent: Agent?
    let date: String?
    // TODO: Add ETDF scheme
}

extension ProvisionActivity {
    init?(expanding provisionActivity: [Link]?, in document: Document) throws {
        let provisionActivity = try document.expand(provisionActivity,
                                                into: LinkedData.ProvisionActivity.self)
            .lazy
            .compactMap { activity -> ProvisionActivity? in
                let place = try document.expand(activity.places, into: Node.self)
                    .first?.labels?.first?.value
                let agent = try Agent(expanding: activity.agents, in: document)
                let date = activity.dates?.first?.value
                return ProvisionActivity(place: place, agent: agent, date: date)
            }
            .sorted { (first, second) in
                first.agent != nil && second.agent == nil
            }
            .first
        // TODO: Find a better way to select which provision activity to use (or use both)
        
        if let provisionActivity = provisionActivity {
            self = provisionActivity
        } else {
            return nil
        }
    }
}
