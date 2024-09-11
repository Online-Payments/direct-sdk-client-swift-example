//
//  PaymentProductsViewController.swift
//  OnlinePaymentsExample
//
//  Created for Online Payments on 15/12/2016.
//  Copyright © 2016 Global Collect Services. All rights reserved.
//

import UIKit
import OnlinePaymentsKit

class PaymentProductsViewController: UITableViewController {

    var paymentItems: PaymentItems!

    var target: PaymentProductSelectionTarget?
    var amount = 0
    var currencyCode = ""

    var sections = [PaymentProductsTableSection]()
    var header: SummaryTableHeaderView!

    init(style: UITableView.Style, paymentItems: PaymentItems) {
        super.init(style: style)

        self.paymentItems = paymentItems
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        navigationItem.titleView = MerchantLogoImageView()
        initializeHeader()

        if paymentItems.hasAccountsOnFile {
            let accountsSection =
                TableSectionConverter.paymentProductsTableSectionFromAccounts(
                    onFile: paymentItems.accountsOnFile,
                    paymentItems: paymentItems
                )
            accountsSection.title =
                NSLocalizedString(
                    "AccountsOnFileTitle",
                    tableName: AppConstants.kAppLocalizable,
                    bundle: AppConstants.appBundle,
                    value: "",
                    comment: "Title of the section that displays stored payment products."
                )
            sections.append(accountsSection)
        }
        let productsSection = TableSectionConverter.paymentProductsTableSection(from: paymentItems)
        productsSection.title =
            NSLocalizedString(
                "SelectPaymentProductText",
                tableName: AppConstants.kAppLocalizable,
                bundle: AppConstants.appBundle,
                value: "",
                comment: "Title of the section that shows all available payment products."
            )
        sections.append(productsSection)

        // Register reusable views
        tableView.register(
            PaymentProductTableViewCell.self,
            forCellReuseIdentifier: PaymentProductTableViewCell.reuseIdentifier
        )
    }

    func initializeHeader() {
        header = SummaryTableHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 70))
        let totalLabel =
            NSLocalizedString(
                "TotalText",
                tableName: AppConstants.kAppLocalizable,
                bundle: AppConstants.appBundle,
                value: "",
                comment: "Total of the shopping cart title"
            )
        header.setSummary(summary: "\(totalLabel):")

        let amountAsNumber = (Double(amount) / Double(100)) as NSNumber
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = currencyCode

        if let amountAsString = numberFormatter.string(from: amountAsNumber) {
            header.setAmount(amount: amountAsString)
        } else {
            header.setAmount(amount: "Error retrieving total amount")
        }
        header.setSecurePayment(
            securePayment:
                NSLocalizedString(
                    "SecurePaymentText",
                    tableName: AppConstants.kAppLocalizable,
                    bundle: AppConstants.appBundle,
                    value: "",
                    comment: "Text indicating that a secure payment method is used."
                )
        )
        tableView.tableHeaderView = header
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableSection = sections[section]
        return tableSection.rows.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        let tableSection = sections[section]
        return tableSection.title
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =
                tableView.dequeueReusableCell(
                    withIdentifier: PaymentProductTableViewCell.reuseIdentifier
                ) as? PaymentProductTableViewCell else {
            fatalError("Could not cast cell to PaymentProductTableViewCell")
        }

        let section = sections[indexPath.section]
        let row = section.rows[indexPath.row]
        cell.name = row.name
        cell.logo = row.logo

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let row = section.rows[indexPath.row]
        let paymentItem = paymentItems.paymentItem(withIdentifier: row.paymentProductIdentifier)

        if section.type == .gcAccountOnFileType,
            let product = paymentItem as? BasicPaymentProduct,
            let accountOnFile = product.accountOnFile(withIdentifier: row.accountOnFileIdentifier) {
            target?.didSelect(paymentItem: product, accountOnFile: accountOnFile)
        } else if let paymentItem = paymentItem {
            target?.didSelect(paymentItem: paymentItem, accountOnFile: nil)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
