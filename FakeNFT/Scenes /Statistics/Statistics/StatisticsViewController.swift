//
//  StatisticsViewController.swift
//  FakeNFT
//
//  Created by Vladimir Vinakheras on 12.07.2024.
//

import Foundation
import UIKit
import SnapKit

protocol StatisticsViewProtocol: AnyObject {

}

final class StatisticsViewController: UIViewController {

    var presenter: StatisticsPresenterProtocol?
    let cellReuseIdentifier = "tableViewCellIdentifier"

    private var customNavBar = StatisticsCustomNavBar()
    private var ratingTableView: UITableView?

    private var users = ["Peter", "Jjn"]

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "FakeWhite")
        initializeUI()
    }

    private func initializeUI() {
        prepareRatingTable()
        setupUI()
        activatingConstraints()

        }

    private func setupUI() {
        guard let ratingTableView = ratingTableView else {return}
        for subView in [customNavBar, ratingTableView ] {
            view.addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
    }

private func activatingConstraints() {
    customNavBar.snp.makeConstraints { maker in
        maker.top.equalTo(view.safeAreaLayoutGuide)
        maker.leading.equalToSuperview()
        maker.trailing.equalToSuperview()
        maker.height.equalTo(42)
    }
}

    private func prepareRatingTable() {
        ratingTableView = UITableView()
        ratingTableView?.layer.cornerRadius = 16
        ratingTableView?.clipsToBounds = true
        ratingTableView?.dataSource = self
        ratingTableView?.delegate = self
        ratingTableView?.register(StatisticsTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
}

// MARK: - StatisticsViewProtocol
extension StatisticsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier,
                                                       for: indexPath) as? StatisticsTableViewCell else {return StatisticsTableViewCell()}

    return cell}
}

extension StatisticsViewController: StatisticsViewProtocol {

}
