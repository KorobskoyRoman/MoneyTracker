//
//  TransactionView.swift
//  MoneyTracker
//
//  Created by Roman Korobskoy on 24.11.2022.
//

import SwiftUI

struct TransactionView: View {
    @Environment(\.dismiss) var presentationMode

    @State private var name = ""
    @State private var amount = ""
    @State private var date = Date()

    var body: some View {
        NavigationView {
            Form {
                Section(Titles.info) {
                    TextField(Titles.name, text: $name)
                    TextField(Titles.amount, text: $amount)
                    DatePicker(Titles.date,
                               selection: $date,
                               displayedComponents: .date)

                    NavigationLink {
                        
                    } label: {
                        Text(Titles.type)
                    }

                }

                Section(Titles.phoro) {
                    Button {

                    } label: {
                        Text(Titles.select)
                    }
                }
            }
            .navigationTitle(Titles.title)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    cancelButton
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    saveButton
                }

            }
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

            presentationMode.callAsFunction()
        },
               label: {
            Text(Titles.save)
        })
    }

}

extension TransactionView {
    private enum Titles {
        static let title = "Добавить покупку"
        static let cancel = "Отмена"
        static let save = "Сохранить"
        static let info = "Информация"
        static let phoro = "Фото"
        static let name = "Название"
        static let amount = "Описание"
        static let date = "Дата"
        static let type = "Тип"
        static let select = "Выбрать фото"
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView()
    }
}
