//
//  TransactionsView.swift
//  MoneyTracker
//
//  Created by Roman Korobskoy on 28.11.2022.
//

import SwiftUI

struct TransactionsView: View {
    let vm: MainViewModelType
    let card: Card

    init(vm: MainViewModelType,
         card: Card) {
        self.vm = vm
        self.card = card

        fetchRequest = FetchRequest<CardTransaction>(
            entity: CardTransaction.entity(),
            sortDescriptors: [.init(key: "timestamp", ascending: false)],
            predicate: .init(format: "card == %@", self.card)
        )
    }

    var fetchRequest: FetchRequest<CardTransaction>

    var body: some View {
        ForEach(fetchRequest.wrappedValue) { transaction in
            TransactionView(transaction: transaction, vm: vm)
        }
    }
}

struct TransactionView: View {
    let transaction: CardTransaction
    let vm: MainViewModelType

    private let shadowRadius: CGFloat = 5
    private let paddings: CGFloat = 8

    @State private var actionSheetShow = false

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(transaction.name ?? .defaultValue)
                        .font(.headline)

                    if let date = transaction.timestamp {
                        Text(vm.dateFormatter.string(from: date))
                    }
                }
                
                Spacer()

                VStack(alignment: .trailing) {

                    Button {
                        actionSheetShow.toggle()
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 24))
                    }.padding(EdgeInsets(top: 6, leading: 8, bottom: 4, trailing: .zero))
                        .confirmationDialog(transaction.name ?? .defaultValue, isPresented: $actionSheetShow) {
                            Button(role: .destructive) {
                                withAnimation {
                                    vm.deleteTransaction(transaction)
                                }
                            } label: {
                                Text(Titles.deleteButtonTitle)
                            }

                        } message: {
                            Text(transaction.name ?? .defaultValue)
                        }

                    Text(String(transaction.amount))
                }
            }

            if let categories = transaction.categories as? Set<TransactionCategory> {
                let sortedCats = vm.sortCats(categories)

                HStack {
                    ForEach(sortedCats, id: \.self) { cat in
                        HStack {
                            if let color = vm.getColor(cat: cat) {
                                Text(cat.name ?? "")
                                    .font(.system(size: 16, weight: .semibold))
                                    .padding(.vertical, paddings)
                                    .padding(.horizontal, paddings)
                                    .background(color)
                                    .foregroundColor(.white)
                                    .cornerRadius(shadowRadius)
                            }
                        }
                    }
                    Spacer()
                }
            }

            if let photoData = transaction.photoData,
               let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            }
        }
        .foregroundColor(Color(.label))
        .padding()
        .background(.white)
        .cornerRadius(shadowRadius)
        .shadow(radius: shadowRadius)
        .padding()
    }
}

extension TransactionView {
    private enum Titles {
        static let deleteButtonTitle = "Удалить"
    }
}

//struct TransactionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        TransactionsView()
//    }
//}
