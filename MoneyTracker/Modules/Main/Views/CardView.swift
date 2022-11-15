//
//  CardView.swift
//  MoneyTracker
//
//  Created by Roman Korobskoy on 11.11.2022.
//

import SwiftUI

struct CardView: View {
    var body: some View {
        let corner: CGFloat = 8
        let shadow: CGFloat = 5
        let spacing: CGFloat = 12

        VStack(alignment: .leading, spacing: spacing) {
            titleText
            balanceView
            Text("1234 1234 1234 1324")
            Text("Credit limit: 50000 Rub.")

            HStack { Spacer() }
        }
        .foregroundColor(.white)
        .padding()
        .background(
            LinearGradient(
                colors: [
                    .blue.opacity(0.6),
                    .blue
                ],
                startPoint: .center,
                endPoint: .bottom
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: corner)
                .stroke(Color.black.opacity(0.5), lineWidth: 1)
        )
        .cornerRadius(corner)
        .shadow(radius: shadow)
        .padding(.horizontal)
        .padding(.top, corner)
    }
}

extension CardView {
    var titleText: some View {
        Text("Visa card")
            .font(.system(size: 24, weight: .semibold))
    }

    var balanceView: some View {
        HStack {
            Image("mir")
                .resizable()
                .scaledToFit()
                .frame(height: 33)
                .clipped()
            Spacer()
            Text("Balance: 400000 Rub.")
                .font(.system(size: 18, weight: .semibold))
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}
