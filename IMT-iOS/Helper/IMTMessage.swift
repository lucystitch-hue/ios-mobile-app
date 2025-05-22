//
//  IMTMessage.swift
//  IMT-iOS
//
//  Created by dev on 14/06/2023.
//

import Foundation

enum IMTErrorMessage: String {
    case mailInvalid = "The email address format is invalid."
    case mailEmpty = "Please enter your email address."
    case mailIsNotASCII = "The email address contains full-width characters."
    case mailContainsSpace = "The email address contains whitespace."
    case yearOfBirthDayEmpty = "Please select your birth year."
    case monthOfBirthDayEmpty = "Please select your birth month."
    case dayOfBirthDayEmpty = "Please select your birth day."
    case sexEmpty = "Please select your gender."
    case postCodeInvalid = "The entered postal code does not exist."
    case horseRacingYearEmpty = "Please select the year you became interested in horse racing."
    case jobEmpty = "Please select your occupation."
    case passwordEmpty = "Please enter your password."
    case passwordInvalid = "Passwords do not match."
    case passwordDifferent = "The password and confirmation password do not match."
    case passwordIncorrect = "The password format is incorrect."
    case passwordFormatIncorrect = "The password is incorrect."
    case emptyNumber = "This field is required."
    case missingNumber = "The entered information is invalid."
    case cantSkipLoggin = "You cannot skip login because no account is registered."
    case emailJInvalid = "Please enter a valid email address."
    case passwordJInvalid = "Password cannot be left blank."
    case activeVotingInvalid = "Only one active pattern is allowed."
    case permissionPhotoLibary = "Access to the photo library was denied. Please update your settings in the Settings app."
    case singleCharacterHorseSearch = "Please enter at least 2 characters for the horse name."
    case singleCharacterJockeySearch = "Please enter at least 2 characters for the jockey name."
    case anythingOtherThanFullWidthKatakanaOrHiragana = "Please use full-width Katakana or Hiragana."
    case thereWasNoCorrespondingData = "No matching data was found."

}
