//
//  CardView.swift
//  MoneyTracker
//
//  Created by Roman Korobskoy on 11.11.2022.
//

import SwiftUI

struct CardView: View {
    let card: Card
    let vm: MainViewModelType

    @State private var actionSheetShow = false
    
    var body: some View {
        let corner: CGFloat = 8
        let shadow: CGFloat = 5
        let spacing: CGFloat = 12

        VStack(alignment: .leading, spacing: spacing) {
            HStack {
                titleText
                Spacer()
                ellipseButton
            }
            balanceView
            Text(card.number ?? "")
            Text("Credit limit: \(card.limit)")

            HStack { Spacer() }
        }
        .foregroundColor(.white)
        .padding()
        .background(
            VStack {

                if let colorData = card.color,
                   let uiColor = UIColor.color(data: colorData),
                   let actualColor = Color(uiColor) {

                    LinearGradient(
                        colors: [
                            actualColor.opacity(0.6),
                            actualColor
                        ],
                        startPoint: .center,
                        endPoint: .bottom
                    )
                } else {
                    Color.cyan
                }
            }
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
    private var titleText: some View {
        Text(card.name ?? "")
            .font(.system(size: 24, weight: .semibold))
    }

    private var balanceView: some View {
        HStack {
            Image("mir")
                .resizable()
                .scaledToFit()
                .frame(height: 33)
                .clipped()
            Spacer()
            Text("Balance: \(card.balance) Rub.")
                .font(.system(size: 18, weight: .semibold))
        }
    }

    private var ellipseButton: some View {
        Button {
            actionSheetShow.toggle()
        } label: {
            Image(systemName: "ellipsis")
                .font(.system(size: 28, weight: .bold))
        }
        .confirmationDialog(Titles.deleteCardTitle, isPresented: $actionSheetShow) {
            Button(role: .destructive) {
                vm.deleteItem(card)
            } label: {
                Text(Titles.deleteButtonTitle)
            }

        } message: {
            Text(Titles.deleteTitle)
        }

    }
}

extension CardView {
    private enum Titles {
        static let deleteCardTitle = "Удаление..."
        static let deleteButtonTitle = "Удалить"
        static let deleteTitle = "Удалить карту?"
    }
}

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView()
//    }
//}
