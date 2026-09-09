//
//  FlexibleView.swift
//  MoviesAPIs
//
//  Created by mac on 14/5/25.
//

import SwiftUI

struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content
    @State private var elementsSize: [Data.Element: CGSize] = [:]
    
    var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            ForEach(computeRows(), id: \.self) { rowElements in
                HStack(alignment: .top, spacing: spacing) {
                    ForEach(rowElements, id: \.self) { element in
                        content(element)
                            .fixedSize()
                            .readSize { size in
                                elementsSize[element] = size
                            }
                    }
                }
            }
        }
    }
    
    func computeRows() -> [[Data.Element]] {
        var rows: [[Data.Element]] = [[]]
        var currentRow = 0
        var remainingWidth = UIScreen.main.bounds.width - 180 // Account for padding
        
        for element in data {
            let elementSize = elementsSize[element, default: CGSize(width: 100, height: 20)]
            let remaining = remainingWidth - (elementSize.width + spacing)
            print(remaining)
            
            if remaining >= 0 {
                rows[currentRow].append(element)
                remainingWidth -= elementSize.width + spacing
            } else {
                currentRow += 1
                rows.append([element])
                remainingWidth = UIScreen.main.bounds.width - elementSize.width - spacing - 32
            }
        }
        
        return rows
    }
}
