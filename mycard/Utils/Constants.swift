//
//  Constants.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/5/20.
//

import Foundation

struct K {
    
    static let contactCell = "ContactsCell"
    static let contactCellIdentifier = "ContactsReusableCell"
    
    
    struct Colors {
        static let mcBlue = "MC Blue"
        static let mcBlack = "MC Black"
        static let mcBlack10 = "MC Black 10"
        static let mcBlack40 = "MC Black 40"
        static let mcBlack5 = "MC Black 5"
        static let mcBlack60 = "MC Black 60"
        static let mcWhite = "MC White"
    }
    
    struct TextStyles {
        static let heading1 = TextStyle(style: .extraLarge, color: .black, emphasis: .regular, alignment: .left, lineSpacing: 2)
        static let subTitle = TextStyle(style: .small, color: .black60, emphasis: .regular, alignment: .left, lineSpacing: 1.2)
        static let subTitleBlue = TextStyle(style: .small, color: .primary, emphasis: .regular, alignment: .left, lineSpacing: 1.2)
        static let bodyBlack40 = TextStyle(style: .normal, color: .black40, emphasis: .regular, alignment: .left, lineSpacing: 1.2)
        
        static let bodyBlack60 = TextStyle(style: .normal, color: .black60, emphasis: .regular, alignment: .left, lineSpacing: 1.2)
        static let bodyBlack5 = TextStyle(style: .normal, color: .black5, emphasis: .regular, alignment: .left, lineSpacing: 1.2)
        
        static let bodyBlue = TextStyle(style: .normal, color: .primary, emphasis: .regular, alignment: .left, lineSpacing: 1.2)
        static let bodyBlueMedium = TextStyle(style: .normal, color: .primary, emphasis: .medium, alignment: .left, lineSpacing: 1.2)
        static let bodyBlack = TextStyle(style: .normal, color: .black, emphasis: .regular, alignment: .left, lineSpacing: 1.2)
        static let bodyBlackSemiBold = TextStyle(style: .normal, color: .black, emphasis: .semibold, alignment: .left, lineSpacing: 1.2)
        static let captionBlack60 = TextStyle(style: .extraSmall, color: .black60, emphasis: .regular, alignment: .left, lineSpacing: 1.2)
        static let buttonWhite = TextStyle(style: .normal, color: .white, emphasis: .semibold, alignment: .center, lineSpacing: 1.2)
        static let captionWhite = TextStyle(style: .normal, color: .white, emphasis: .regular, alignment: .center, lineSpacing: 1.2)
        
    }
    
    struct Segues {
        static let startToSetup = "startToSetup"
        static let setupToSignup = "setupToSignup"
        static let signupToVerifyNumber = "SignupToVerifyPhoneNumber"
        static let verifyNumberToCards = "verifyNumberToCards"
        static let personalInfoToSocialMedia = "personalInfoToSocialMedia"
        static let personalInfoToWorkInfo = "PersonalInfoToWorkInfo"
        static let workInfoToConfirmDetails = "WorkInfoToConfirmDetails"
        static let capturePhotoToReviewPhoto = "CapturePhotoToReviewPhoto"
        static let cardsToCardDetails = "CardsToCardDetails"
    }

    struct Notifications {
        static let phoneNumberNotification = "phoneNumberNotification"
        static let passNameNotification = "passNameNotification"
    }

    struct Images {
        static let facebook = "socials facebook"
        static let twitter = "socials twitter"
        static let instagram = "socials instagram"
        static let linkedin = "socials linkedin"
        static let chevron_right = "chevron right"
        static let minus = "minus"
        static let plus = "plus"
    }
    
    struct SocialMedia {
        static let facebook = "facebook"
        static let twitter = "twitter"
        static let instagram = "instagram"
        static let linkedin = "linkedin"
    }
}
