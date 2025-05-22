//
//  RaceHorseCellViewModel.swift
//  IMT-iOS
//
//  Created on 02/04/2024.
//
    

import Foundation

class RaceHorseCellViewModel: HorseAndJockeyCellViewModel {
    private(set) var racehorse: OshiUma
    
    init(racehorse: OshiUma) {
        self.racehorse = racehorse
        super.init()
        self.setup()
    }
    
    private func setup() {
        self.title = racehorse.bna
        self.sex = "\(J01SEXCOD(rawValue: racehorse.sexcod)?.text() ?? "")\(racehorse.age)"
        if racehorse.shusso == "TRUE" {
            self.badge.append((text: "Racing", color: .lapisLazuli))
            }

            if racehorse.hoboku == "TRUE" {
                self.badge.append((text: "On Pasture", color: .quickSilver))
            }

            if racehorse.rahmaskbn == "1" {
                self.badge.append((text: "Removed", color: .darkCharcoal))
            }

    }
}
