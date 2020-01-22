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
    @Published var content: ContentResponse? {
        didSet {
            isLoading = false
        }
    }
    @Published var image: UIImage = UIImage.init() {
        didSet {
            isLoading = false
        }
    }
    @Published var isLoading = true

    private var contentCancellable: Cancellable? {
        didSet { oldValue?.cancel() }
    }

    private var imageCancellable: Cancellable? {
        didSet { oldValue?.cancel() }
    }

    deinit {
        contentCancellable?.cancel()
        imageCancellable?.cancel()
    }

    init() {
        search()
    }

    func search() {
        let urlComponents = URLComponents(string: "https://api.reelgood.com/roulette?content_kind=movie&free=false&nocache=true&sources=netflix")!
        let request = URLRequest(url: urlComponents.url!)

        contentCancellable = URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: ContentResponse.self, decoder: JSONDecoder())
            .map { $0 }
            .replaceError(with: nil)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] content in
                self?.fetchImage(for: content!)
            })
    }

    func fetchImage(for content: ContentResponse) {
        let url = URL(string: "https://img.reelgood.com/content/movie/\(content.id)/poster-342.jpg")!
        let request = URLRequest(url: url)
        imageCancellable = URLSession.shared.dataTaskPublisher(for: request)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] image in
                self?.content = content
                self?.image = image ?? UIImage(named: "noImage")!
            })
    }
}
