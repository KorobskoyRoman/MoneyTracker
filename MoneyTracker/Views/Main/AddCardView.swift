//
//  AddCardView.swift
//  MoneyTracker
//
//  Created by Roman Korobskoy on 11.11.2022.
//

import SwiftUI

struct AddCardView: View {
    @Environment(\.dismiss) var presentationMode

    @State private var name = ""
    @State private var cardNumber = ""
    @State private var limit = ""

    @State private var cardType = "Visa"
    @State private var month = 1
    @State private var year = Calendar.current.component(.year, from: Date())
    @State private var color = Color.blue

    let currentYear = Calendar.current.component(.year, from: Date())

    var body: some View {
        NavigationView {
            Form {
                Section(Titles.cardInfo) {
                    TextField(Titles.name, text: $name)
                    TextField(Titles.number, text: $cardNumber)
                        .keyboardType(.numberPad)
                    TextField(Titles.limit, text: $limit)
                        .keyboardType(.numberPad)

                    Picker(Titles.type, selection: $cardType) {
                        ForEach(["Visa", "MasterCard", "Мир"],
                                id: \.self) { cardType in
                            Text(cardType).tag(cardType)
                        }
                    }
                }

                Section(Titles.expInfo) {
                    Picker(Titles.month, selection: $month) {
                        ForEach(1..<13, id: \.self) { num in
                            Text(String(num)).tag(String(num))
                        }
                    }

                    Picker(Titles.year, selection: $year) {
                        ForEach(currentYear..<currentYear + 6, id: \.self) { num in
                            Text(String(num)).tag(String(num))
                        }
                    }
                }

                Section(Titles.color) {
                    ColorPicker(Titles.color, selection: $color)
                }
            }
            .navigationTitle(Titles.title)
            .navigationBarItems(leading: Button(
                action: {
                    presentationMode.callAsFunction()
                }, label: {
                    Text(Titles.cancel)
                        .foregroundColor(.red)
                }
            ))
        }
    }
}

extension AddCardView {
    private enum Titles {
        static let title = "Добавление карты"
        static let cancel = "Отмена"
        static let name = "Имя"
        static let cardInfo = "Информация о карте"
        static let expInfo = "Дата окончания"
        static let number = "Номер"
        static let limit = "Баланс"
        static let type = "Тип"
        static let color = "Цвет"
        static let month = "Месяц"
        static let year = "Год"
    }
}

struct Previews_AddCardView_Previews: PreviewProvider {
    static var previews: some View {
        AddCardView()
    }
}
