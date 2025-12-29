//
//  SwiftUIView.swift
//  Financial_Management
//
//  Created by Lã Quốc Trung on 8/12/25.
//

import SwiftUI
import Charts

struct Sales: Identifiable {
    let id = UUID()
    let day: String
    let value: Double
}

struct BarChartSwiftChartsDemo: View {
    let data: [Sales] = [
        .init(day: "Mon", value: 12),
        .init(day: "Tue", value: 8),
        .init(day: "Wed", value: 15),
        .init(day: "Thu", value: 6),
        .init(day: "Fri", value: 18),
        .init(day: "Sat", value: 10),
        .init(day: "Sun", value: 14)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Weekly Sales")
                .font(.headline)

            Chart(data) { item in
                BarMark(
                    x: .value("Day", item.day),
                    y: .value("Value", item.value)
                )
                .annotation(position: .top) {
                    Text("\(Int(item.value))")
                        .font(.caption2)
                }
            }
            .frame(height: 240)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
        .padding()
    }
}

import SwiftUI

struct SimpleBarChart: View {
    let labels: [String]
    let values: [Double]

    private var maxValue: Double { values.max() ?? 1 }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Simple Bar Chart")
                .font(.headline)

            HStack(alignment: .bottom, spacing: 12) {
                ForEach(values.indices, id: \.self) { i in
                    VStack(spacing: 6) {
                        Text("\(Int(values[i]))")
                            .font(.caption2)

                        RoundedRectangle(cornerRadius: 6)
                            .frame(height: CGFloat(values[i] / maxValue) * 180)

                        Text(labels[i])
                            .font(.caption2)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 240)
        }
        .padding()
    }
}

struct SimpleBarChartDemo: View {
    var body: some View {
        SimpleBarChart(
            labels: ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"],
            values: [12, 8, 15, 6, 18, 10, 14]
        )
    }
}

#Preview("Swift Charts") {
    BarChartSwiftChartsDemo()
}
