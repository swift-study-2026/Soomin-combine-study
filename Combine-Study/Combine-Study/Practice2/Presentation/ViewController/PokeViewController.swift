//
//  PokeViewController.swift
//  Combine-Study
//
//  Created by mandoo on 4/27/26.
//

import UIKit

import Combine
import SnapKit
import Then

class PokeViewController: UIViewController {
    
    let pokeView = PokeView()
    private let viewModel = PokeViewModel()
    private var pokes: [PokeModel] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    
    override func loadView() {
        view = pokeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setDelegate()
        setBind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewWillAppearSubject.send(())
    }
    
    private func setDelegate() {
        pokeView.tableView.delegate = self
        pokeView.tableView.dataSource = self
    }
    
    private func setBind(){
        let input = PokeViewModel.Input (viewWillAppear: viewWillAppearSubject.eraseToAnyPublisher())
        
        let output = viewModel.transform(input: input)
        
        output.pokes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] pokes in
                self?.pokes = pokes
                self?.pokeView.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        output.isLoading
            .receive(on: DispatchQueue.main)
            .sink { isLoading in
                if isLoading {
                    self.pokeView.loadingIndicator.startAnimating()
                    self.pokeView.tableView.alpha = 0.5
                } else {
                    self.pokeView.loadingIndicator.stopAnimating()
                    self.pokeView.tableView.alpha = 1
                }
            }
            .store(in: &cancellables)
        
        output.error
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { error in
                print(error)
            }
            .store(in: &cancellables)
    }
}

extension PokeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension PokeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokeTableViewCell.identifier, for: indexPath) as? PokeTableViewCell else { return UITableViewCell() }
        cell.dataBind(pokes[indexPath.row])
        return cell
    }
}
