//
//  Constants.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/5/20.
//

import Foundation
import UIKit
struct K {
    static let authVerificationId = "authVerificationID"
    static let contactCell = "ContactsCell"
    static let contactCellIdentifier = "ContactsReusableCell"
    static let personalCardCell = "PersonalCardCollectionViewCell"

    static let hasPreviousAuth = "hasPreviousAuth"

    struct ViewControllers {
        static let signupViewController = "SignupViewController"
        static let changePhoneNumberViewController = "ChangePhoneNumberViewController"
    }

    struct ColorString {
        static let mcBlue = "MC Blue"
        static let mcBlack = "MC Black"
        static let mcBlack10 = "MC Black 10"
        static let mcBlack40 = "MC Black 40"
        static let mcBlack5 = "MC Black 5"
        static let mcBlack60 = "MC Black 60"
        static let mcWhite = "MC White"
        static let mcYellow = "MC Yellow"
        static let mcGreen = "MC Green"
        static let mcWine = "MC Wine"
        static let mcRed = "MC Red"
    }

    struct Colors {
        static let Blue = UIColor(named: ColorString.mcBlue)
        static let Black = UIColor(named: ColorString.mcBlack)
        static let Black5 = UIColor(named: ColorString.mcBlack5)
        static let Black10 = UIColor(named: ColorString.mcBlack10)
        static let Black40 = UIColor(named: ColorString.mcBlack40)
        static let Black60 = UIColor(named: ColorString.mcBlack60)
        static let White = UIColor(named: ColorString.mcWhite)
        static let Yellow = UIColor(named: ColorString.mcYellow)
        static let Green = UIColor(named: ColorString.mcGreen)
        static let Wine = UIColor(named: ColorString.mcWine)
        static let Red = UIColor(named: ColorString.mcRed)

    }

    struct Storyboards {
        static let personalInfo = "PersonalInfo"
    }

    struct ViewIdentifiers {
        static let cardsTabBarController = "TabBarController"
        static let startScreenViewController = "StartScreenViewController"
        static let mainNavigationController = "MainNavigationController"
        static let socialMediaViewController = "SocialMediaViewController"
        static let cardDetailsViewController = "CardDetailsViewController"
        static let personalInfoViewController = "PersonalInfoViewController"
        static let qrCodeViewController = "QRCodeViewController"
    }

    struct TextStyles {
        static let heading1 = TextStyle(
            style: .extraLarge,
            color: .black,
            emphasis: .regular,
            alignment: .left,
            lineSpacing: 2)
        static let heading3 = TextStyle(
            style: .large,
            color: .black,
            emphasis: .semibold,
            alignment: .left,
            lineSpacing: 2)
        static let subTitle = TextStyle(
            style: .small,
            color: .black60,
            emphasis: .regular,
            alignment: .left,
            lineSpacing: 1.2)
        static let subTitleBlue = TextStyle(
            style: .small,
            color: .primary,
            emphasis: .regular,
            alignment: .left,
            lineSpacing: 1.2)
        static let bodyBlack40 = TextStyle(
            style: .normal,
            color: .black40,
            emphasis: .regular,
            alignment: .left,
            lineSpacing: 1.2)

        static let bodyBlack60 = TextStyle(
            style: .normal,
            color: .black60,
            emphasis: .regular,
            alignment: .left,
            lineSpacing: 1.2)
        static let bodyBlack5 = TextStyle(
            style: .normal,
            color: .black5,
            emphasis: .regular,
            alignment: .left,
            lineSpacing: 1.2)

        static let bodyBlue = TextStyle(
            style: .normal,
            color: .primary,
            emphasis: .regular,
            alignment: .left,
            lineSpacing: 1.2)
        static let bodyBlueMedium = TextStyle(
            style: .normal,
            color: .primary,
            emphasis: .medium,
            alignment: .left,
            lineSpacing: 1.2)
        static let bodyBlack = TextStyle(
            style: .normal,
            color: .black,
            emphasis: .regular,
            alignment: .left,
            lineSpacing: 1.2)
        static let bodyBlackSemiBold = TextStyle(
            style: .normal,
            color: .black,
            emphasis: .semibold,
            alignment: .left,
            lineSpacing: 1.2)
        static let captionBlack60 = TextStyle(
            style: .extraSmall,
            color: .black60,
            emphasis: .regular,
            alignment: .left,
            lineSpacing: 1.2)
        static let buttonWhite = TextStyle(
            style: .normal,
            color: .white,
            emphasis: .semibold,
            alignment: .center,
            lineSpacing: 1.2)
        static let captionWhite = TextStyle(
            style: .normal,
            color: .white,
            emphasis: .regular,
            alignment: .center,
            lineSpacing: 1.2)
        static let subTitleRed = TextStyle(
            style: .small,
            color: .red,
            emphasis: .regular,
            alignment: .center,
            lineSpacing: 1.2)

    }

    struct Segues {
        static let startToSetup = "startToSetup"
        static let setupToSignup = "setupToSignup"
        static let signupToVerifyNumber = "SignupToVerifyPhoneNumber"
        static let verifyNumberToCards = "VerifyNumberToCards"
        static let personalInfoToSocialMedia = "personalInfoToSocialMedia"
        static let personalInfoToWorkInfo = "PersonalInfoToWorkInfo"
        static let workInfoToConfirmDetails = "WorkInfoToConfirmDetails"
        static let capturePhotoToReviewPhoto = "CapturePhotoToReviewPhoto"
        static let cardsToCardDetails = "CardsToCardDetails"
        static let cameraToAuth = "CameratoAuth"
        static let authToCards = "AuthToCards"
        static let verifyNumberToProfileSetup = "VerifyNumberToProfileSetup"
        static let settingsToVerifyPhoneNumber = "SettingsToVerifyPhoneNumber"
        static let verifyPhoneNumberToSignup = "VerifyPhoneNumberToSignup"
        static let profileToCreateCard = "ProfileToCreateCard"
        static let cardsToCreateCard = "CardsToCreateCard"
        static let cardDetailsToPersonalInfo = "CardDetailsToPersonalInfo"
        static let cardDetailsToQR = "CardDetailsToQR"
        static let searchToCardDetails = "SearchToCardDetails"
        static let confirmDetailsToNotes = "ConfirmDetailsToNotes"
        static let cardDetailsToNotes = "CardDetailsToNotes"
        static let profileToSettings = "ProfileToSettings"
    }

    struct Notifications {
        static let phoneNumberNotification = "phoneNumberNotification"
        static let passNameNotification = "passNameNotification"
    }

    struct ImageString {
        static let facebook = "socials facebook"
        static let twitter = "socials twitter"
        static let instagram = "socials instagram"
        static let linkedin = "socials linkedin"
        static let chevronRight = "chevron right"
        static let userLight = "user light"
        static let mail = "mail"
        static let location = "location"
        static let office = "office"
        static let check = "check"
        static let edit = "edit"
        static let addToCollection = "add to collection"
        static let profilePlaceholder = "profile placeholder"
        static let scanQR = "scan card qr"
        static let delete = "delete"
        static let contacts = "contacts"
        static let share = "share"
        static let more = "more vertical"

//        system images
        static let minus = "minus"
        static let plus = "plus"
        static let phone = "phone"

    }

    struct Images {
        static let facebook = UIImage(named: ImageString.facebook)
        static let twitter = UIImage(named: ImageString.twitter)
        static let instagram = UIImage(named: ImageString.instagram)
        static let linkedin = UIImage(named: ImageString.linkedin)
        static let chevronRight = UIImage(named: ImageString.chevronRight)
        static let userLight = UIImage(named: ImageString.userLight)
        static let mail = UIImage(named: ImageString.mail)
        static let location = UIImage(named: ImageString.location)
        static let office = UIImage(named: ImageString.office)
        static let phone = UIImage(named: ImageString.phone)
        static let check = UIImage(named: ImageString.check)
        static let edit = UIImage(named: ImageString.edit)
        static let scanQR = UIImage(named: ImageString.scanQR)
        static let delete = UIImage(named: ImageString.delete)
        static let share = UIImage(named: ImageString.share)
        static let more = UIImage(named: ImageString.more)
        static let contacts = UIImage(named: ImageString.contacts)
        static let addToCollection = UIImage(named: ImageString.addToCollection)
        static let profilePlaceholder = UIImage(named: ImageString.profilePlaceholder)

//        system images
        static let minus = UIImage(systemName: ImageString.minus)
        static let plus = UIImage(systemName: ImageString.plus)

    }

    struct SocialMedia {
        static let facebook = "facebook"
        static let twitter = "twitter"
        static let instagram = "instagram"
        static let linkedin = "linkedin"
    }

    struct Firestore {
        static let cardsCollectionName = "cards"
        static let usersCollectionName = "users"
        static let addedCardsCollectionName = "addedCards"
        static let personalCardCollectionName = "personalCards"
    }
}

enum AuthFlowType {
    case authentication
    case confirmPhoneNumber
    case changePhoneNumber
}
