//
//  CourseHandicapCalcViewController.swift
//  GolfPadTestProblem
//
//  Created by Ruslan Abbasov on 18.11.2022.
//

import UIKit
import Combine

class CourseHandicapCalcViewController: UIViewController, UITextFieldDelegate {

    private var cancellables = Set<AnyCancellable>()
    private var viewModel = CourseHandicapViewModel()

    @IBOutlet private weak var handicapIndexTextField: UITextField!
    @IBOutlet private weak var slopeRatingTextField: UITextField!
    @IBOutlet private weak var courseRatingTextField: UITextField!
    @IBOutlet private weak var parTextField: UITextField!
    @IBOutlet private weak var courseNumberLabel: UILabel!
    @IBOutlet private weak var resultBackgroundView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToCourseHandicapSubject()
        setupTextFieldsTag()
        self.hideKeyboardWhenTappedAround()
        setupCornerRadius(view: resultBackgroundView)
    }

    private func subscribeToCourseHandicapSubject() {
        setupTextFieldsPublisher()
        viewModel.courseHandicapSubject.sink { [weak self] courseHandicap in
            self?.courseNumberLabel.text = courseHandicap
        }.store(in: &cancellables)
    }

    private func setupCornerRadius(view: UIView) {
        view.layer.cornerRadius = view.frame.height / 4
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

    private func setupTextFieldsTag() {
        handicapIndexTextField.delegate = self
        handicapIndexTextField.tag = 0

        slopeRatingTextField.delegate = self
        slopeRatingTextField.tag = 1

        courseRatingTextField.delegate = self
        courseRatingTextField.tag = 2

        parTextField.delegate = self
        parTextField.tag = 3
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }

}
