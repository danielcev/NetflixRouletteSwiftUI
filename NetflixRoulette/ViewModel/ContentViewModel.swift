//
//  ContentViewModel.swift
//  NetflixRoulette
//
//  Created by Daniel Plata on 22/01/2020.
//  Copyright © 2020 silverapps. All rights reserved.
//

import SwiftUI
import Combine

final class ContentViewModel: ObservableObject {
    @Published var content: ContentResponse?
    @Published var image: UIImage = UIImage.init() {
        didSet {
            isLoading = false
        }
    }
    @Published var isLoading = true

    private var publishers = [AnyCancellable]()

    private let apiProvider: ContentProvider

    deinit {
        publishers.forEach { $0.cancel() }
    }

    init() {
        apiProvider = ContentApi()
        getRandom()
    }

    func getRandom() {
        apiProvider
            .getRandomContent()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { error in
                print(error)
            }) { response in
                self.content = response
                self.fetchImage(for: response)
            }
            .store(in: &publishers)

    }

    func fetchImage(for content: ContentResponse) {
        apiProvider
            .getImage(id: content.id)
            .map { UIImage(data: $0) }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { error in
                print(error)
            }) { image in
                self.image = image ?? UIImage(named: "noImage")!
            }
            .store(in: &publishers)
    }
}
