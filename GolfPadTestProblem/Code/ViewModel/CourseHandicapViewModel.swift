//
//  CourseHandicapViewModel.swift
//  GolfPadTestProblem
//
//  Created by Ruslan Abbasov on 18.11.2022.
//

import Combine

class CourseHandicapViewModel {

    private let handicapIndexSubject = PassthroughSubject<Float, Never>()
    private let slopeRatinIndexSubject = PassthroughSubject<Float, Never>()
    private let courseRatingSubject = PassthroughSubject<Float, Never>()
    private let parSubject = PassthroughSubject<Float, Never>()
    private var cancellables = Set<AnyCancellable>()

    public let courseHandicapSubject = PassthroughSubject<String, Never>()

    init() {
        Publishers.CombineLatest4(handicapIndexSubject,
                                  slopeRatinIndexSubject,
                                  courseRatingSubject,
                                  parSubject)
            .sink { [weak self] (handicap, slope, course, par) in
                self?.sendCourseHandicap(handicapIndex: handicap,
                                         slopeRating: slope,
                                         courseRate: course,
                                         par: par)
            }.store(in: &cancellables)
    }

    public func playerDataChange(numberString: String?, dataType: PlayerDataType) {
        guard let floatNumber = Float(numberString!) else {
            return
        }
        switch dataType {
        case .handicapIndex:
            handicapIndexSubject.send(floatNumber)
        case .slopeRating:
            slopeRatinIndexSubject.send(floatNumber)
        case .courseRate:
            courseRatingSubject.send(floatNumber)
        case .par:
            parSubject.send(floatNumber)
        }
    }

    private func sendCourseHandicap(handicapIndex: Float, slopeRating: Float, courseRate: Float, par: Float) {

        guard
            let courseHandicap = self.getCourseHandicap(handicapIndex: handicapIndex,
                                                          slopeRating: slopeRating,
                                                          courseRate: courseRate,
                                                          par: par)
        else {
            return
        }

        self.courseHandicapSubject.send(courseHandicap)
    }

    private func getCourseHandicap(handicapIndex: Float, slopeRating: Float, courseRate: Float, par: Float) -> String? {

        let courseHandicap = self.countCourseHandicap(handicapIndex: handicapIndex,
                                                      slopeRating: slopeRating,
                                                      courseRate: courseRate,
                                                      par: par)
        if courseHandicap > 0 {
            let courseHandicapRound = courseHandicap.rounded(toPlaces: 1)
            let courseHandicapRoundString = String(courseHandicapRound)
            return courseHandicapRoundString
        } else {
            return nil
        }
    }

}

extension CourseHandicapViewModel {
    private func countByFormula(handicapIndex: Float, slopeRating: Float, courseRate: Float, par: Float) -> Float {
        return handicapIndex * (slopeRating / 113) + (courseRate - par)
    }

    private func convertStringToFloat(string: String) -> Float {
        guard let number = Float(string) else {
            return 0
        }
        return number
    }

    private func countCourseHandicap(handicapIndex: Float, slopeRating: Float, courseRate: Float, par: Float) -> Float {
        if  slopeRating != 0 {
            return countByFormula(handicapIndex: handicapIndex,
                                  slopeRating: slopeRating,
                                  courseRate: courseRate,
                                  par: par)
        } else {
            return 0
        }
    }
}

enum PlayerDataType {
    case handicapIndex
    case slopeRating
    case courseRate
    case par
}
