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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFieldsPublisher()

    }

    private func setupTextFieldsPublisher() {
        addTextFieldPublisher(textField: handicapIndexTextField)
        addTextFieldPublisher(textField: slopeRatingTextField)
        addTextFieldPublisher(textField: courseRatingTextField)
        addTextFieldPublisher(textField: parTextField)
    }

    private func addTextFieldPublisher(textField: UITextField) {
        textField
            .publisher(for: .editingChanged)
            .debounce(for: .milliseconds(1000), scheduler: DispatchQueue.main)
            .sink { [weak self] in
                self?.viewModel.handicapIndexChange(handicapIndex: textField.text ?? "")
            }.store(in: &cancellables)

    }

}
