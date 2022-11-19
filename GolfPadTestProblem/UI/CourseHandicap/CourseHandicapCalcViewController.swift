//
//  CourseHandicapCalcViewController.swift
//  GolfPadTestProblem
//
//  Created by Ruslan Abbasov on 18.11.2022.
//

import UIKit
import Combine

class CourseHandicapCalcViewController: UIViewController {

    private var cancellables = Set<AnyCancellable>()
    private var viewModel = CourseHandicapViewModel()

    @IBOutlet private weak var handicapIndexTextField: UITextField!
    @IBOutlet private weak var slopeRatingTextField: UITextField!
    @IBOutlet private weak var courseRatingTextField: UITextField!
    @IBOutlet private weak var parTextField: UITextField!
    @IBOutlet private weak var courseNumberLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFieldsPublisher()
        viewModel.courseHandicapSubject.sink { [weak self] courseHandicap in
            self?.courseNumberLabel.text = courseHandicap
        }.store(in: &cancellables)

    }

    private func setupTextFieldsPublisher() {
        addTextFieldPublisher(textField: handicapIndexTextField, dataType: .handicapIndex)
        addTextFieldPublisher(textField: slopeRatingTextField, dataType: .slopeRating)
        addTextFieldPublisher(textField: courseRatingTextField, dataType: .courseRate)
        addTextFieldPublisher(textField: parTextField, dataType: .par)
    }

    private func addTextFieldPublisher(textField: UITextField, dataType: PlayerDataType) {
        textField
            .publisher(for: .editingChanged)
            .debounce(for: .milliseconds(1000), scheduler: DispatchQueue.main)
            .sink { [weak self] in
                self?.viewModel.playerDataChange(numberString: textField.text, dataType: dataType)
            }.store(in: &cancellables)

    }

}
