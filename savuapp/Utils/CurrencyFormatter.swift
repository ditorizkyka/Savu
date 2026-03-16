// CurrencyFormatter.swift
// savuapp > Utils

import Foundation

// MARK: - CurrencyFormatter
/// Centralised Indonesian Rupiah formatter.
/// Output format: "Rp. 1.000.000"  (negative: "-Rp. 1.000.000", signed: "+Rp. 1.000.000")
enum CurrencyFormatter {

    private static let formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.groupingSeparator = "."
        f.decimalSeparator = ","
        f.maximumFractionDigits = 0
        f.minimumFractionDigits = 0
        return f
    }()

    /// Plain format — "Rp. 1.000.000" (negative values include a leading minus)
    static func format(_ value: Double) -> String {
        let abs = Swift.abs(value)
        let number = formatter.string(from: NSNumber(value: abs)) ?? "0"
        let prefix = value < 0 ? "-" : ""
        return "\(prefix)Rp \(number)"
    }

    /// Signed format — always shows + or -. Useful for net totals.
    /// "+Rp. 1.000.000" / "-Rp. 500.000"
    static func formatSigned(_ value: Double) -> String {
        let abs = Swift.abs(value)
        let number = formatter.string(from: NSNumber(value: abs)) ?? "0"
        let sign = value >= 0 ? "+" : "-"
        return "\(sign)Rp \(number)"
    }
}

// MARK: - Double convenience extension
extension Double {
    /// "Rp. 1.000.000"
    var rupiahFormatted: String { CurrencyFormatter.format(self) }
    /// "+Rp. 1.000.000" / "-Rp. 500.000"
    var rupiahFormattedSigned: String { CurrencyFormatter.formatSigned(self) }
}
