//
//  GenreCapsule.swift
//  JahezDesign
//
//  Created by Mohamed Sadek on 19/04/2026.
//

import SwiftUI

// MARK: Genre Capsule View
public struct GenreCapsule: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    public init(title: String, isSelected: Bool, onTap: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.onTap = onTap
    }
    
    public var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.system(size: 13, weight: isSelected ? .semibold : .medium))
                .foregroundStyle(
                    isSelected ?
                    Color.black :
                    Color.white
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ?
                        Color.yellow:
                        Color.clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            isSelected ?
                            Color.clear :
                            Color.yellow,
                            lineWidth: 1
                        )
                )
        }
        .padding(.vertical, 2)
        .buttonStyle(.plain)
    }
}
