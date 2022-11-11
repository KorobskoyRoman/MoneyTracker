//
//  MainView.swift
//  MoneyTracker
//
//  Created by Roman Korobskoy on 11.11.2022.
//

import SwiftUI

struct MainView: View {
    @State private var addCardFormIsPresented = false

    var body: some View {
        NavigationView {
            ScrollView {
                TabView {
                    ForEach(0..<5) { num in
                        CardView()
                            .padding(.bottom, 40)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 280)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            }
            .navigationTitle(Titles.navTitle)
            .navigationBarItems(trailing: addCardButton)
        }
    }

    var addCardButton: some View {
        Button(action: {

        }, label: {
            let cornerRadius: CGFloat = 5

            Text(Titles.addButtonTitle)
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .bold))
                .padding(EdgeInsets(
                    top: 8,
                    leading: 12,
                    bottom: 8,
                    trailing: 12)
                )
                .background(Color.black)
                .cornerRadius(cornerRadius)
        })
    }
}

extension MainView {
    private enum Titles {
        static let navTitle = "Ваши карты"
        static let addButtonTitle = "+ Добавить"
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
