//
//  AddCardView.swift
//  MoneyTracker
//
//  Created by Roman Korobskoy on 11.11.2022.
//

import SwiftUI

struct AddCardView: View {
    @Environment(\.dismiss) var presentationMode

    var vm: MainViewModelType
    let card: Card?

    @State private var name = ""
    @State private var cardNumber = "".applyPattern()
    @State private var limit = ""
    @State private var balance = ""

    @State private var cardType = "Visa"
    @State private var month = Calendar.current.component(.month, from: Date())
    @State private var year = Calendar.current.component(.year, from: Date())
    @State private var color = Color.blue

    private let currentYear = Calendar.current.component(.year, from: Date())

    init(vm: MainViewModelType, card: Card? = nil) {
        self.vm = vm
        self.card = card

        _name = State(initialValue: self.card?.name ?? "")
        _cardNumber = State(initialValue: self.card?.number ?? "")
        _cardType = State(initialValue: self.card?.type ?? "")

        if let limit = card?.limit {
            _limit = State(initialValue: String(limit))
        }

        _month = State(initialValue: Int(self.card?.expMonth ??
                                         Int16(Calendar.current.component(.month, from: Date()))))
        _year = State(initialValue: Int(self.card?.expYear ?? Int16(currentYear)))

        if let data = self.card?.color,
           let uiColor = UIColor.color(data: data) {
            let c = Color(uiColor: uiColor)
            _color = State(initialValue: c)
        }
    }

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
            .navigationTitle(card != nil ? card?.name ?? "N/A" : Titles.title)
            .navigationBarItems(leading: cancelButton,
                                trailing: saveButton)

        }
    }

    private var cancelButton: some View {
        Button(action: {
            presentationMode.callAsFunction()
        }, label: {
            Text(Titles.cancel)
                .foregroundColor(.red)
        })
    }

    private var saveButton: some View {
        Button(action: {
            vm.saveItem(card: card,
                        name: name,
                        number: cardNumber,
                        limit: limit,
                        type: cardType,
                        month: month,
                        year: year,
                        timestamp: Date(),
                        balance: balance,
                        color: color)
            presentationMode.callAsFunction()
        },
               label: {
            Text(Titles.save)
        })
    }
}

extension AddCardView {
    private enum Titles {
        static let title = "Добавление карты"
        static let cancel = "Отмена"
        static let save = "Сохранить"
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
        AddCardView(vm: MainViewModel())
    }
}
