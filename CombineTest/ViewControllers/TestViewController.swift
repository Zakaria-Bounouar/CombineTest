//
//  TestViewController.swift
//  CombineTest
//
//  Created by Zakaria Bounouar on 2020-08-12.
//  Copyright © 2020 Zakaria Bounouar. All rights reserved.
//

import UIKit
import Combine

protocol TestViewControllerDelegate: class {
    func increaseCount()
    func decreaseCount()
    func changeColor(to color: UIColor)
}

class TestViewController: UIViewController, Observer {

    @IBOutlet weak var countTitleLabel: UILabel!
    @IBOutlet weak var countValueLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var nextPageButton: UIButton!
    @IBOutlet weak var actionButtonsStackView: UIStackView!
    @IBOutlet weak var gridContainer: UIStackView!
    
    private var enableActions: Bool
    private var navigationEnabled: Bool
    weak var delegate: TestViewControllerDelegate?
    
    var cancellable: AnyCancellable?
    
    private var colors: [UIColor] = [.blue,
                                     .red,
                                     .cyan,
                                     .yellow,
                                     .green,
                                     .magenta,
                                     .orange,
                                     .purple,
                                     .brown,
                                     .black]
    
    private var countModel: CountModel {
        didSet {
            DispatchQueue.main.async {
                guard let valueLabel = self.countValueLabel else { return }
                valueLabel.text = "\(self.countModel.count)"
                valueLabel.backgroundColor = self.countModel.color
            }
        }
    }
    
    init(countModel: CountModel,
         enableActions: Bool,
         navigationEnabled: Bool,
         delegate: TestViewControllerDelegate?) {
        self.countModel = countModel
        self.enableActions = enableActions
        self.navigationEnabled = navigationEnabled
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.cancellable?.cancel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButtonsStackView.isHidden = !enableActions
        nextPageButton.isHidden = !navigationEnabled
        countValueLabel.text = "\(countModel.count)"
        countValueLabel.backgroundColor = countModel.color
        gridContainer.isHidden = !enableActions
        if enableActions {
            generateGrid(numberOfRows: 3, numberOfColumns: 3)
        }
    }
    
    func generateGrid(numberOfRows: Int, numberOfColumns: Int) {
        for row in 0..<numberOfRows {
            let rowContainer = UIStackView()
            rowContainer.axis = .horizontal
            gridContainer.addArrangedSubview(rowContainer)
            for column in 0..<numberOfColumns {
                let colorView = ColorSelectorView()
                let colorIndex = ((numberOfColumns * row) + column) % colors.count
                colorView.configure(withColor: colors[colorIndex], delegate: self)
                rowContainer.addArrangedSubview(colorView)
                colorView.widthAnchor
                    .constraint(equalTo: gridContainer.widthAnchor, multiplier: 1.0 / CGFloat(numberOfColumns))
                    .isActive = true
                colorView.heightAnchor
                    .constraint(equalTo: gridContainer.heightAnchor, multiplier: 1.0 / CGFloat(numberOfRows))
                    .isActive = true
            }
        }
    }
    
    // MARK: - Observer method
    
    func update(forStatus status: ObservableCountStatus) {
        switch status {
        case .didLoad(let countModel):
            self.countModel = countModel
        default:
            break
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func minusButtonTapped(_ sender: Any) {
        delegate?.decreaseCount()
    }
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        delegate?.increaseCount()
    }
    
    @IBAction func nextPageButtonTapped(_ sender: Any) {
        // Nothing to do here for now
    }
}

extension TestViewController: ColorSelectorViewDelegate {
    func colorSelectorView(_ colorSelectorView: ColorSelectorView, didSelectColor color: UIColor) {
        delegate?.changeColor(to: color)
    }
}
