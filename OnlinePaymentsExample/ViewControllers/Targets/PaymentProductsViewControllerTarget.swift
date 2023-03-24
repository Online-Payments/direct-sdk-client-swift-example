//
//  PaymentProductsViewControllerTarget.swift
//  OnlinePaymentsExample
//
//  Created for Online Payments on 15/12/2016.
//  Copyright © 2016 Global Collect Services. All rights reserved.
//

import Foundation
import PassKit
import OnlinePaymentsKit
import SVProgressHUD

class PaymentProductsViewControllerTarget: NSObject, PKPaymentAuthorizationViewControllerDelegate,
                                           PaymentProductSelectionTarget, PaymentRequestTarget {

    var session: Session!
    var context: PaymentContext!
    var navigationController: UINavigationController!

    var applePayPaymentProduct: PaymentProduct?
    var summaryItems: [PKPaymentSummaryItem] = []
    var authorizationViewController: PKPaymentAuthorizationViewController?

    var paymentFinishedTarget: PaymentFinishedTarget?

    init(navigationController: UINavigationController, session: Session!, context: PaymentContext!) {
        self.navigationController = navigationController
        self.session = session
        self.context = context
    }

    convenience override init() {
        NSException(
            name: NSExceptionName.internalInconsistencyException,
            reason: "-init is not a valid initializer for the class PaymentProductsViewControllerTarget",
            userInfo: nil
        ).raise()

        self.init()
    }

    // MARK: - PaymentProduct selection target

    func didSelect(paymentItem: BasicPaymentItem, accountOnFile: AccountOnFile?) {

        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
        let status =
            NSLocalizedString(
                "gc.app.general.loading.body",
                tableName: SDKConstants.kSDKLocalizable,
                bundle: AppConstants.sdkBundle,
                value: "",
                comment: ""
            )
        SVProgressHUD.show(withStatus: status)

        // ***************************************************************************
        //
        // After selecting a payment product or an account on file associated to a
        // payment product in the payment product selection screen, the Session
        // object is used to retrieve all information for this payment product.
        //
        // Afterwards, a screen is shown that allows the user to fill in all
        // relevant information, unless the payment product has no fields.
        // This screen is also not part of the SDK and is offered for demonstration
        // purposes only.
        //
        // If the payment product has no fields, the merchant is responsible for
        // fetching the URL for a redirect to a third party and show the corresponding
        // website.
        //
        // ***************************************************************************

        session.paymentProduct(
            withId: paymentItem.identifier,
            context: context,
            success: {(_ paymentProduct: PaymentProduct) -> Void in
                if paymentItem.identifier.isEqual(SDKConstants.kApplePayIdentifier) {
                    self.showApplePayPaymentItem(paymentProduct: paymentProduct)
                } else {
                    SVProgressHUD.dismiss()
                    if paymentProduct.fields.paymentProductFields.count > 0 {
                        self.show(paymentItem: paymentProduct, accountOnFile: accountOnFile)
                    } else {
                        let request =
                            PaymentRequest(
                                paymentProduct: paymentProduct,
                                accountOnFile: accountOnFile,
                                tokenize: false
                            )
                        self.didSubmitPaymentRequest(paymentRequest: request)
                    }
                }
            },
            failure: { _ in
                SVProgressHUD.dismiss()
                let alert =
                    UIAlertController(
                        title:
                            NSLocalizedString(
                                "ConnectionErrorTitle",
                                tableName: AppConstants.kAppLocalizable,
                                bundle: AppConstants.appBundle,
                                value: "",
                                comment: "Title of the connection error dialog."
                            ),
                        message: NSLocalizedString(
                            "PaymentProductErrorExplanation",
                            tableName: AppConstants.kAppLocalizable,
                            bundle: AppConstants.appBundle,
                            value: "",
                            comment: ""
                        ),
                        preferredStyle: .alert
                    )
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.navigationController.topViewController?.present(alert, animated: true, completion: nil)
            }
        )
    }

    func show(paymentItem: PaymentItem, accountOnFile: AccountOnFile?) {
        var paymentProductForm: PaymentProductViewController! = nil
        if (paymentItem as? PaymentProduct)?.paymentMethod == "card" {
            paymentProductForm =
                CardProductViewController(
                    paymentItem: paymentItem,
                    session: session,
                    context: context,
                    accountOnFile: accountOnFile
                )
        } else {
            paymentProductForm =
                PaymentProductViewController(
                    paymentItem: paymentItem,
                    session: session,
                    context: context,
                    accountOnFile: accountOnFile
                )
        }
        paymentProductForm.paymentRequestTarget = self
        navigationController.pushViewController(paymentProductForm, animated: true)
    }

    // MARK: - ApplePay selection handling

    func showApplePayPaymentItem(paymentProduct: PaymentProduct) {
        if self.systemVersionIsGreaterThan(version: "8.0") &&
           PKPaymentAuthorizationViewController.canMakePayments() {

            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
            let status =
                NSLocalizedString(
                    "gc.app.general.loading.body",
                    tableName: SDKConstants.kSDKLocalizable,
                    bundle: AppConstants.sdkBundle,
                    value: "",
                    comment: ""
                )
            SVProgressHUD.show(withStatus: status)

            // ***************************************************************************
            //
            // If the payment product is Apple Pay, the supported networks are retrieved.
            //
            // A view controller for Apple Pay will be shown when these networks have been
            // retrieved.
            //
            // ***************************************************************************

            session.paymentProductNetworks(
                forProductId: SDKConstants.kApplePayIdentifier,
                context: context,
                success: {(_ paymentProductNetworks: PaymentProductNetworks) -> Void in
                    self.showApplePaySheet(for: paymentProduct, withAvailableNetworks: paymentProductNetworks)
                    SVProgressHUD.dismiss()
                },
                failure: { _ in
                    SVProgressHUD.dismiss()

                    let alert =
                        UIAlertController(
                            title:
                                NSLocalizedString(
                                    "ConnectionErrorTitle",
                                    tableName: AppConstants.kAppLocalizable,
                                    bundle: AppConstants.appBundle,
                                    value: "",
                                    comment: "Title of the connection error dialog."
                                ),
                            message:
                                NSLocalizedString(
                                    "PaymentProductNetworksErrorExplanation",
                                    tableName: AppConstants.kAppLocalizable,
                                    bundle: AppConstants.appBundle,
                                    value: "",
                                    comment: ""
                                ),
                            preferredStyle: .alert
                        )
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.navigationController.topViewController?.present(alert, animated: true, completion: nil)
                }
            )
        }
    }

    private func systemVersionIsGreaterThan(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: String.CompareOptions.numeric) != .orderedAscending
    }

    func showApplePaySheet(
        for paymentProduct: PaymentProduct,
        withAvailableNetworks paymentProductNetworks: PaymentProductNetworks
    ) {

        if UserDefaults.standard.object(forKey: AppConstants.kMerchantId) == nil {
            return
        }

        // This merchant should be the merchant id specified in the merchants developer portal.
        guard let merchantId = UserDefaults.standard.value(forKey: AppConstants.kMerchantId) as? String else {
            fatalError("MerchantId could not be retrieved as a String")
        }

        generateSummaryItems()
        let paymentRequest = PKPaymentRequest()
        paymentRequest.countryCode = context.countryCodeString
        paymentRequest.currencyCode = context.amountOfMoney.currencyCodeString
        paymentRequest.supportedNetworks = paymentProductNetworks.paymentProductNetworks
        paymentRequest.paymentSummaryItems = summaryItems

        // These capabilities should always be set to this value,
        // unless the merchant specifically does not want either Debit or Credit
        if #available(iOS 9.0, *) {
            paymentRequest.merchantCapabilities = [.capability3DS, .capabilityDebit, .capabilityCredit]
        } else {
            paymentRequest.merchantCapabilities = [.capability3DS]
        }

        // This merchant id is set in the merchants apple developer portal and is linked to a certificate
        paymentRequest.merchantIdentifier = merchantId

        // These shipping and billing address fields are optional and can be chosen by the merchant
        paymentRequest.requiredShippingAddressFields = .all
        paymentRequest.requiredBillingAddressFields = .all
        authorizationViewController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
        authorizationViewController?.delegate = self

        // The authorizationViewController will be nil if the paymentRequest was incomplete or not created correctly
        if let authorizationViewController = authorizationViewController,
           PKPaymentAuthorizationViewController.canMakePayments(
            usingNetworks: paymentProductNetworks.paymentProductNetworks
           ) {
            applePayPaymentProduct = paymentProduct
            navigationController!.topViewController!.present(
                authorizationViewController,
                animated: true,
                completion: { return }
            )
        }
    }

    func generateSummaryItems() {

        // ***************************************************************************
        //
        // The summaryItems for the paymentRequest is a list of values with the only
        // value being the subtotal. You are able to add more values to the list if
        // desired, like a shipping cost and total. ApplePay expects the last summary
        // item to be the grand total, this will be displayed differently from the
        // other summary items.
        //
        // The value is specified in cents and converted to a NSDecimalNumber with
        // a exponent of -2.
        //
        // ***************************************************************************

        let subtotal = context.amountOfMoney.totalAmount

        var summaryItems = [PKPaymentSummaryItem]()
        summaryItems.append(
            PKPaymentSummaryItem(
                label:
                    NSLocalizedString(
                        "gc.app.general.shoppingCart.subtotal",
                        tableName: SDKConstants.kSDKLocalizable,
                        bundle: AppConstants.sdkBundle,
                        value: "",
                        comment: "subtotal summary item title"
                    ),
                amount: NSDecimalNumber(mantissa: UInt64(subtotal), exponent: -2, isNegative: false)
            )
        )

        self.summaryItems = summaryItems
    }

    // MARK: -

    // MARK: Payment request target

    func didSubmitPaymentRequest(paymentRequest: PaymentRequest) {
        didSubmitPaymentRequest(paymentRequest, success: nil, failure: nil)
    }

    func didSubmitPaymentRequest(_ paymentRequest: PaymentRequest, success: (() -> Void)?, failure: (() -> Void)?) {
        SVProgressHUD.setDefaultMaskType(.clear)
        let status =
            NSLocalizedString(
                "gc.app.general.loading.body",
                tableName: SDKConstants.kSDKLocalizable,
                bundle: AppConstants.sdkBundle,
                value: "",
                comment: ""
            )
        SVProgressHUD.show(withStatus: status)

        self.session.prepare(paymentRequest, success: {(_ preparedPaymentRequest: PreparedPaymentRequest) -> Void in
            SVProgressHUD.dismiss()

            // ***************************************************************************
            //
            // The information contained in `preparedPaymentRequest.encryptedFields` should
            // be provided via the S2S Create Payment API, using field `encryptedCustomerInput`.
            //
            // ***************************************************************************
            self.paymentFinishedTarget?.didFinishPayment()
            success?()
        }, failure: { _ in
            SVProgressHUD.dismiss()
            let alert =
                UIAlertController(
                    title:
                        NSLocalizedString(
                        "ConnectionErrorTitle",
                        tableName: AppConstants.kAppLocalizable,
                        bundle: AppConstants.appBundle,
                        value: "",
                        comment: "Title of the connection error dialog."
                        ),
                    message:
                        NSLocalizedString(
                            "SubmitErrorExplanation",
                            tableName: AppConstants.kAppLocalizable,
                            bundle: AppConstants.appBundle,
                            value: "",
                            comment: ""
                        ),
                    preferredStyle: .alert
                )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.navigationController.topViewController?.present(alert, animated: true, completion: nil)

            if failure != nil {
                failure!()
            }
        })
    }

    func didCancelPaymentRequest() {
        navigationController!.popToRootViewController(animated: true)
    }

    // MARK: - PKPaymentAuthorizationViewControllerDelegate
    // Sent to the delegate after the user has acted on the payment request.  The application
    // should inspect the payment to determine whether the payment request was authorized.
    //
    // If the application requested a shipping address then the full address is now part of the payment.
    //
    // The delegate must call completion with an appropriate authorization status, as may be determined
    // by submitting the payment credential to a processing gateway for payment authorization.

    func paymentAuthorizationViewController(
        _ controller: PKPaymentAuthorizationViewController,
        didAuthorizePayment payment: PKPayment,
        completion: @escaping (PKPaymentAuthorizationStatus) -> Void
    ) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: {() -> Void in

                guard let applePayPaymentProduct = self.applePayPaymentProduct else {
                    Macros.DLog(message: "Invalid Apple pay product.")
                    return
                }

                let request = PaymentRequest(paymentProduct: applePayPaymentProduct)

                guard let paymentDataString =
                        String(data: payment.token.paymentData, encoding: String.Encoding.utf8) else {
                    completion(.failure)
                    return
                }
                request.setValue(forField: "encryptedPaymentData", value: paymentDataString)
                request.setValue(forField: "transactionId", value: payment.token.transactionIdentifier)

                self.didSubmitPaymentRequest(request, success: {() -> Void in
                    completion(.success)
                }, failure: {() -> Void in
                    completion(.failure)
                })
            }
        )
    }

    // Sent to the delegate when payment authorization is finished.  This may occur when
    // the user cancels the request, or after the PKPaymentAuthorizationStatus parameter of the
    // paymentAuthorizationViewController:didAuthorizePayment:completion: has been shown to the user.
    //
    // The delegate is responsible for dismissing the view controller in this method.
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        applePayPaymentProduct = nil
        authorizationViewController?.dismiss(animated: true, completion: { return })
    }

    // Sent when the user has selected a new payment card.  Use this delegate callback if you need to
    // update the summary items in response to the card type changing (for example, applying credit card surcharges)
    //
    // The delegate will receive no further callbacks except paymentAuthorizationViewControllerDidFinish:
    // until it has invoked the completion block.
    @available(iOS 9.0, *)
    func paymentAuthorizationViewController(
        _ controller: PKPaymentAuthorizationViewController,
        didSelect paymentMethod: PKPaymentMethod,
        completion: @escaping ([PKPaymentSummaryItem]) -> Void
    ) {
        completion(summaryItems)
    }

    // MARK: -
}
