//
//  CourseHandicapViewModel.swift
//  GolfPadTestProblem
//
//  Created by Ruslan Abbasov on 18.11.2022.
//

import Combine

class CourseHandicapViewModel {

//    var playerData = PlayerData()
    let handicapIndexSubject = CurrentValueSubject<Float?, Never>(nil)
    let slopeRatinIndexSubject = CurrentValueSubject<Float?, Never>(nil)
    let courseRatingSubject = CurrentValueSubject<Float?, Never>(nil)
    let parSubject = CurrentValueSubject<Float?, Never>(nil)
    let courseHandicapSubject = PassthroughSubject<Float, Never>()

    private var cancellables = Set<AnyCancellable>()

    init() {
        Publishers.CombineLatest4(handicapIndexSubject, slopeRatinIndexSubject, courseRatingSubject, parSubject)
            .sink { [weak self] (handicap, slope, course, par) in
                guard let self = self,
                      let handicap = handicap,
                      let slope = slope,
                      let course = course,
                      let par = par
                else {
                    return
                }
                let playerData = PlayerData(handicapIndex: handicap,
                                            slopeRating: slope,
                                            courseRate: course,
                                            par: par)
                let courseHandicap = self.countCourseHandicap(playerData: playerData)
                self.courseRatingSubject.send(courseHandicap)

            }.store(in: &cancellables)
    }

    func countCourseHandicap(playerData: PlayerData) -> Float {
        if playerData.handicapIndex != 0 && playerData.slopeRating != 0 {
            return countByFormula(handicapIndex: playerData.handicapIndex,
                                  slopeRating: playerData.slopeRating,
                                  courseRate: playerData.courseRate,
                                  par: playerData.par)
        } else {
            return 0
        }
    }

    func countByFormula(handicapIndex: Float, slopeRating: Float, courseRate: Float, par: Float) -> Float {
        return handicapIndex * (slopeRating / 113) + (courseRate - par)
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

    private func convertStringToFloat(string: String) -> Float {
        guard let number = Float(string) else {
            return 0
        }
        return number
    }

}

struct PlayerData {
    var handicapIndex: Float = 0
    var slopeRating: Float = 0
    var courseRate: Float = 0
    var par: Float = 0
}

enum PlayerDataType {
    case handicapIndex
    case slopeRating
    case courseRate
    case par
}
