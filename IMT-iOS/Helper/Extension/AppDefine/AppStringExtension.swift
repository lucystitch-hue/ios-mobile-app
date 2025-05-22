//
//  AppStringExtension.swift
//  IMT-iOS
//
//  Created by dev on 07/03/2023.
//


import Foundation

//MARK: AppDefine
extension String {
    class tab {
        static let home = "Home"
        static let race = "Training & Races"
        static let onlineVoting = "Betting"
        static let live = "Live Races"
        static let menu = "App Settings"
    }
    
    class term {
        static let term = "The full text of the Terms of Use will be inserted here. The full text of the Terms of Use will be inserted here. The full text of the Terms of Use will be inserted here. The full text of the Terms of Use will be inserted here. The full text of the Terms of Use will be inserted here. The full text of the Terms of Use will be inserted here. The full text of the Terms of Use will be inserted here. The full text of the Terms of Use will be inserted here. The full text of the Terms of Use will be inserted here. It will be displayed in a scrollable format."
        static let rangeTitle = "IMT App Terms of Use"
        static let rangeDate = "June 1, 2023"
    }
    
    class myPersonal {
        static let myPersonalRegister = "Please enter your primary number.\nIf you wish to switch, please register multiple numbers below,\nthen switch from My Page before use."
        static let titleBtnSub = "Link with another subscriber number"
        static let lbColorSub = "(8-digit number specified by IMT)"
        static let lbColorPArs = "(4-digit number specified by IMT)"
        static let lbColorPin = "(4-digit number set by the customer)"
        static let titleIsRequired = "This field is required"
        static let titleIsIncorrect = "The entered information is incorrect"
        static let placeholderIPatIdRegister = "8-digit number specified by IMT"
        static let placeholderIPatParRegister = "4-digit number specified by IMT"
        static let placeholderIPatPassRegister = "4-digit number set by the customer"
        static let placeholderIPatIdUpdate = "99999999"
        static let placeholderIPatPassUpdate = "****"
        static let placeholderIPatParsUpdate = "9999"
        static let titleBtnNew = "Register"
        static let titleBtnEdit = "Update"
        static let placeholderUMACACardNumber = "12-digit number on the back of UMACA card"
        static let placeholderUMACABirthday = "8-digit number registered with UMACA"
        static let placeholderUMACAPinCode = "4-digit number registered with UMACA"
    }
    
    class loginScreen {
        static let titleLoginWithEmail = "Log in with Email"
        static let line = "Log in with LINE"
        static let yahoo = "Log in with Yahoo!"
        static let google = "Log in with Google"
        static let facebook = "Log in with Facebook"
        static let twitter = "Log in with Twitter"
        static let apple = "Log in with Apple"
        static let sentVerfiCode = "Please check the email sent to your address\nand enter the verification code."
        static let changeEmail = "Please check your registered email\nand enter the received verification code."
        static let titleGuide = """
        It may take a few minutes to receive the email.
        If you do not receive the verification code, the following may be the cause:

        (1) Emails from “@IMT.go.jp” are being blocked
        (2) Incorrectly entered email address
        (3) The email was filtered into your spam folder

        If (1), please update your email settings to allow emails from “@IMT.go.jp”.
        """
        static let titleDesChangePass = "A verification code will be sent\nto change your password"
        static let titlechangeEmail = "A verification code will be sent\nto change your email address"
        
    }
    
    class registerScreen {
        static let titleLoginWithEmail = "Register with Email"
        static let line = "Register with LINE"
        static let yahoo = "Register with Yahoo!"
        static let google = "Register with Google"
        static let facebook = "Register with Facebook"
        static let twitter = "Register with Twitter"
        static let apple = "Register with Apple"
        static let passwordError = "The password does not meet the password policy for the following reason: [You cannot reuse your current password]"
    }
    
    class menuRegisterInfor {
        static let titleFirstLastName = "Full Name (Last & First)*"
        static let titleName = "Name (Furigana)*"
        static let titleDateOfBrithday = "Date of Birth*"
        static let titleMailAdress = "Email Address*"
        static let titleMailAdressConfir = "Email Address (Confirmation)*"
        static let titlePassword = "Password*"
        static let titlePostCode = "Postal Code*"
        static let titleGender = "Gender*"
        static let titleProfession = "Occupation*"
        static let titleHorseRacingYear = "Year Started Horse Racing*"
    }
    
    class error {
        static let networkNotConnect = "Communication failed. Please try again in an area with a better signal."
        static let permissionCamera = "Camera permission is required."
    }
    
    class guide {
        static let next = "Next"
        static let complete = "Done"
    }
    
    class date {
        static let secondsBefore = "A few seconds ago"
        static let minutesBefore = "minutes ago"
        static let hoursBefore = "hours ago"
        static let daysBefore = "days ago"

    }
    
    class placeholder {
        static let select = "Select Option"
        static let year = "Year"
        static let month = "Month"
        static let day = "Day"
        static let yearChange = "**** Year"
        static let monthChange = "** Month"
        static let dayChange = "** Day"
        static let selectGender = "Select Gender"
        static let selectProfession = "Select Occupation"
        static let selectHorseRacingYear = "Select Year Started"
        static let selectCategory = "None"
        static let selectDeviceUsing = "-"
        static let selectOperatingSystem = "-"

    }
    
    class TitleScreen {
        static let deleteApp = "Delete App Registration (Unsubscribe)"
        static let termApp = "Terms of Use"
        static let listNotificationScreen = "IMT Notifications List"
        static let login = "Login"
        static let register = "New Registration"
        static let resetPassword = "Forgot Password"
        static let reset = "Reset Password"
        static let changeEmail = "Confirm / Change Email Address"
        static let changePassword = "Change Password"
        static let updatePerson = "Enter Registration Information (1/3)"
        static let changeRegistration = "Change Registration Information"
        static let comfir = "Confirm / Change Registration Information"
        static let subcriberNumber = "Check / Change Online Betting Link Information"
        static let privacyPolicy = "Privacy Policy"
        static let termsOfService = "Terms of Service"
        static let clubCooperation = "Club IMT-Net Link Registration"
        static let voteRegister = "Register Online Betting Link Information"
        static let voteEdit = "Edit Online Betting Link Information"
        static let notification = "Notification Settings\nPlease use the “Change” button at the bottom after making changes."
        static let notificationSub = "To change, toggle ON/OFF,\n\nthen press the “Change” button at the bottom of the screen."
        static let listQuestions = "Survey"
        static let signUpEmail = "New Registration"
        static let inquiryImprovementRequest = "Contact Us"
        static let detailNotification = "IMT Notification Details"
        static let biometricAuthentication = "Biometric Authentication"
        static let biometricManagement = "Security Settings (Biometric Authentication)"
        static let resultUpdateEmailSuccess = "New Email Address Verified"
        static let resultUpdateEmailFailure = "Error"
        static let umacaSmartCollaboration = "UMACA Smart Collaboration"
        static let umacaTicket = "UMACA Smart Collaboration Info Check / Change"
        static let umacaTicketUpdate = "UMACA Smart Collaboration Info Change"
        static let preferredDisplay = "Preferred Venue Display Settings Check / Change"
        static let infoMenu = "Information Menu"
        static let raceHorseSearch = "Racehorse Search"
        static let jockeySearch = "Jockey Search"

    }
    
    class ListQuestionString {
        static let title = "Please tell us about your experience\nusing the IMT app"
        static let content = """
        Thank you very much for using the IMT app.

        To provide a better app, we would like to hear about your usage and feedback.

        Please take a simple survey that takes about 3 minutes to complete.
        """
        static let answerDeadline = "Response deadline: April 30, 2024, 11:59 PM"

    }
    
    class InquiryImprovementRequestString {
        static let title = "Please enter any inquiries requiring individual responses\n\nor problem reports."
        static let describe = """
        * After submitting the form, an automatic confirmation email will be sent.
        If you do not receive the confirmation email, please check for:
        - Incorrect email address
        - Spam/junk mail folder
        - Email rejection settings for emails sent from a PC (especially on mobile phones)

        * Depending on the content of your inquiry, we may not be able to respond.
        """

    }
    
    class RaceCellString {
        static let odds = "Odds"
        static let result = "Result"

    }
    
    class MemorialString {
        static let desMemorial = """
        Notice
        - The payout period for winning or refunded betting tickets is 60 days.
        - Payouts cannot be made using the betting ticket image.
        - The betting ticket image does not prove the purchase or ownership of the winning betting ticket.
        - Betting tickets purchased at J-PLACE cannot use the Betting Ticket Memorial service.
        """
        static let allYear = "All"

        
    }
    
    class WarningMemorialString {
        static let waringListTicket = "You have reached the maximum registration limit of 100 tickets. Please delete some betting ticket images to free up space before registering new ones."

    }
    
    class ShowToastString {
        static let toastCopyIdUser = "Copied"
        static let toastSaveImage = "Image saved"
        static let changeMailSuccess = "Email address has been successfully changed."
        static let changeMailFailure = "Failed to change email address."

    }
    
    class ComfirmUserInforString {
        static let centralHorseRacing = "Have you ever purchased betting tickets for Central Horse Racing (IMT)?"
        static let japanRacingAssociation = "What motivated you to participate in Central Horse Racing (IMT)?"
        
    }
    
    class QRCodeString {
        static let warningQrCode = "QR code could not be read. Please try again."
    }
    
    class MenuString {
        static let versionApp = "1.0.1"
    }
}

