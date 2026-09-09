//
//  WaterFlowChartView.swift
//  MoviesAPIs
//
//  Created by mac on 28/4/26.
//

import SwiftUI
import Charts

struct WaterfallData: Identifiable {
    let id = UUID()
    let stage: String
    let value: Double
    let start: Double
    let end: Double
    let color: Color
}

struct WaterfallChartView: View {
    let data: [WaterfallData] = [
        WaterfallData(stage: "Start", value: 0, start: 0, end: 70000, color: Color(red: 204/255, green: 136/255, blue: 4/255, opacity: 0.55)),
        WaterfallData(stage: "Sales", value: 0, start: 50000, end: 70000, color: Color(red: 206/255, green: 68/255, blue: 52/255, opacity: 0.55)),
        WaterfallData(stage: "Costs", value: 0, start: 50000, end: 78000, color: Color(red: 100/255, green: 173/255, blue: 84/255, opacity: 0.55)),
        WaterfallData(stage: "Taxes", value: 0, start: 78000, end: 85000, color: Color(red: 9/255, green: 170/255, blue: 197/255, opacity: 0.55)),
        WaterfallData(stage: "Final", value: 0, start: 0, end: 85000, color: Color(red: 255/255, green: 255/255, blue: 255/255, opacity: 0.55))
    ]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 30) {
                
                Spacer()
                
                Text("80 350,00 DHs")
                    .font(.title3)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                Spacer()
                
                Chart {
                    ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
                        BarMark(
                            x: .value("Stage", item.stage),
                            yStart: .value("Start", item.start),
                            yEnd: .value("End", item.end)
                        )
                        .foregroundStyle(item.color)
                        .cornerRadius(8)
                        
                        if index < data.count - 1 {
                            let nextItem = data[index + 1]
                            RuleMark(
                                xStart: .value("Current", item.stage),
                                xEnd: .value("Next", nextItem.stage),
                                y: .value("Level", item.end)
                            )
                            .foregroundStyle(.gray.opacity(0.4))
                            .lineStyle(
                                StrokeStyle(
                                    lineWidth: 1,
                                    dash: [4, 4]
                                )
                            )
                            .offset(x: 20)
                        }
                    }
                }
                .frame(height:130)
                .chartYScale(domain: 0...100000)
                .chartXAxis(.hidden)
                .chartYAxis {
                    AxisMarks(
                        position: .leading,
                        values: Array(stride(from: 0.0, through: 100000.0, by: 20000.0))
                    ) { value in
                        
                        let axisColor = Color(red: 131/255, green: 135/255, blue: 140/255, opacity: 1)
                        let dashColor = Color(red: 255/255, green: 255/255, blue: 255/255, opacity: 0.12)
                        
                        if let doubleValue = value.as(Double.self) {
                            if doubleValue == 0 {
                                AxisGridLine(stroke: StrokeStyle(lineWidth: 1, dash: []))
                                    .foregroundStyle(dashColor)
                            }
                            else {
                                AxisGridLine(stroke: StrokeStyle(lineWidth: 1, dash: [2, 3]))
                                    .foregroundStyle(dashColor)
                            }
                        }
                        AxisTick()
                        AxisValueLabel {
                            if let doubleValue = value.as(Double.self) {
                                Text("\(Int(doubleValue / 1000))K")
                                    .padding(.horizontal, 16)
                            }
                        }
                        .foregroundStyle(axisColor)
                        .font(.system(size: 10, weight: .regular))
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .background(Color(red: 13/255, green: 13/255, blue: 13/255))
    }
}


struct PositiveNegativeWaterfallView: View {
    
    let data: [WaterfallData] = [
        WaterfallData(stage: "lun", value: -4000, start: 0, end: -4000, color: .clear),
        WaterfallData(stage: "mar", value: 7000, start: 0, end: 7000, color: .clear),
        WaterfallData(stage: "merc", value: -1000, start: 0, end: -1000, color: .clear),
        WaterfallData(stage: "jeu", value: 4000, start: 0, end: 4000, color: .clear),
        WaterfallData(stage: "ven", value: -7000, start: 0, end: -7000, color: .clear),
        WaterfallData(stage: "sam", value: 7000, start: 0, end: 7000, color: .clear),
        WaterfallData(stage: "dim", value: 6000, start: 0, end: 6000, color: .clear)
    ]
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 30) {
                
                Spacer()
                
                Text("80 350,00 DHs")
                    .font(.title3)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                Spacer()
                
                Chart {
                    RuleMark(y: .value("Zero", 0))
                        .foregroundStyle(.gray)
                        .lineStyle(
                            StrokeStyle(
                                lineWidth: 2,
                                dash: [4, 4]
                            )
                        )
                    ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
                        
                        BarMark(
                            x: .value("Stage", item.stage),
                            yStart: .value("Start", item.start),
                            yEnd: .value("End", item.end)
                        )
                        .foregroundStyle(item.value >= 0 ? Color(red: 74/255, green: 222/255, blue: 128/255, opacity: 1) : Color(red: 248/255, green: 113/255, blue: 113/255, opacity: 1) )
                        .cornerRadius(8)
                    }
                }
                .chartYScale(domain: -10000...10000)
                .frame(height: 146)
                .chartYAxis {
                    AxisMarks(
                        position: .leading,
                        values: Array(stride(from: -10000.0, through: 10000.0, by: 5000.0))
                    ) { value in
                        
                        let axisColor = Color(red: 131/255, green: 135/255, blue: 140/255, opacity: 1)
                        let dashColor = Color(red: 255/255, green: 255/255, blue: 255/255, opacity: 0.12)
                        
                        if let doubleValue = value.as(Double.self) {
                            if doubleValue == 0 {
                                AxisGridLine(stroke: StrokeStyle(lineWidth: 1, dash: []))
                                    .foregroundStyle(dashColor)
                            }
                            else {
                                AxisGridLine(stroke: StrokeStyle(lineWidth: 1, dash: [2, 3]))
                                    .foregroundStyle(dashColor)
                            }
                        }
                        AxisTick()
                        AxisValueLabel {
                            if let doubleValue = value.as(Double.self) {
                                Text((doubleValue > 0 || doubleValue < 0) ? "\(Int(doubleValue / 1000))K" :"\(Int(doubleValue / 1000))")
                                    .padding(.horizontal, 16)
                            }
                        }
                        .foregroundStyle(axisColor)
                        .font(.system(size: 10, weight: .regular))
                    }
                }
                .chartXAxis {
                    AxisMarks { value in
                        let textColor = Color(red: 131/255, green: 135/255, blue: 140/255, opacity: 1)
                        
                        AxisValueLabel {
                            if let stage = value.as(String.self) {
                                Text(stage)
                                    .font(.system(size: 10, weight: .regular))
                                    .foregroundColor(textColor)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .background(Color(red: 13/255, green: 13/255, blue: 13/255))
    }
}

struct ExpenseSegmentedChatView: View {
    
    struct Expense: Identifiable {
        let id = UUID()
        let category: String
        let amount: Double
        let color: Color
    }
    
    let expenses: [Expense] = [
        .init(
            category: "Food",
            amount: 320,
            color: .orange
        ),
        .init(
            category: "Transport",
            amount: 180,
            color: .blue
        ),
        .init(
            category: "Shopping",
            amount: 450,
            color: .pink
        ),
        .init(
            category: "Entertainment",
            amount: 120,
            color: .purple
        )
    ]
    
    @State private var selectedIndex = 0
    
    var total: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        VStack(spacing: 30) {
            
            // MARK: - Segmented Expense Bar
            
            GeometryReader { geo in
                HStack(spacing: 2) {
                    ForEach(expenses.indices, id: \.self) { index in
                        
                        let expense = expenses[index]
                        let widthRatio = expense.amount / total
                        
                        RoundedRectangle(cornerRadius: 7)
                            .fill(expense.color)
                            .frame(
                                width: geo.size.width * widthRatio,
                                height: 12
                            )
                    }
                }
            }
            .frame(height: 30)
            .padding(.horizontal)
            
            VStack(spacing: 18) {
                
                ForEach(expenses) { expense in
                    
                    HStack(spacing: 7) {
                        Circle()
                            .fill(expense.color)
                            .frame(width: 8, height: 8)
                        
                        // Category
                        Text(expense.category)
                            .font(.body)
                        
                        Spacer()
                        
                        // Amount
                        Text("$\(Int(expense.amount))")
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .padding(.top, 40)
    }
}

#Preview {
    ExpenseSegmentedChatView()
}
#Preview {
    PositiveNegativeWaterfallView()
        .background(Color.white)
}
