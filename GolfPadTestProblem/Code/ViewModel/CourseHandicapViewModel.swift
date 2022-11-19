//
//  CourseHandicapViewModel.swift
//  GolfPadTestProblem
//
//  Created by Ruslan Abbasov on 18.11.2022.
//

import Combine

struct CourseHandicapViewModel {

    var playerData = PlayerData()
    let handicapIndexSubject = CurrentValueSubject<Float, Never>(0)
    let slopeRatinIndexSubject = CurrentValueSubject<Float, Never>(0)
    let courseRatingSubject = CurrentValueSubject<Float, Never>(0)
    let parSubject = CurrentValueSubject<Float, Never>(0)

    private var cancellables = Set<AnyCancellable>()

    func countCourseHandiCap(playerData: PlayerData) -> Float {
        return playerData.handicapIndex * (playerData.slopeRating / 113) + (playerData.courseRate - playerData.par)
    }

    public func handicapIndexChange(handicapIndex: String) {
        let handicapIndexNumber = convertStringToFloat(string: handicapIndex)
        handicapIndexSubject.send(handicapIndexNumber)
    }

    public func slopeRatingChange(slopeRating: String) {
        let slopeRatingNumber = convertStringToFloat(string: slopeRating)
        slopeRatinIndexSubject.send(slopeRatingNumber)
    }

    public func courseRatingChange(courseRating: String) {
        let courseRatingNumber = convertStringToFloat(string: courseRating)
        courseRatingSubject.send(courseRatingNumber)
    }

    public func parChange(par: String) {
        let parNumber = convertStringToFloat(string: par)
        courseRatingSubject.send(parNumber)
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
