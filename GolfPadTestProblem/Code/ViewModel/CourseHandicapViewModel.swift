//
//  CourseHandicapViewModel.swift
//  GolfPadTestProblem
//
//  Created by Ruslan Abbasov on 18.11.2022.
//

import Combine

struct CourseHandicapViewModel {

    var playerData = PlayerData()
    let mySubject = PassthroughSubject<Float, Never>()

    func countCourseHandiCap(playerData: PlayerData) -> Float{
        return playerData.handicapIndex * (playerData.slopeRating / 113) + (playerData.courseRate - playerData.par)
    }
}

struct PlayerData {
    var handicapIndex: Float = 0
    var slopeRating: Float = 0
    var courseRate: Float = 0
    var par: Float = 0
}
