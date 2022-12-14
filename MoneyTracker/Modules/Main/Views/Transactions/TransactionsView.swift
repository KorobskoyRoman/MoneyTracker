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

    @State private var addTransactionFormIsPresented = false
    @State private var filterSheetIsPresented = false
    @State private var selectedCategories = Set<TransactionCategory>()
    @State private var disableTransaction: Bool = false

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
        VStack {
            if fetchRequest.wrappedValue.isEmpty {
                Text(Titles.addTransaction)
                Button {
                    addTransactionFormIsPresented.toggle()
                } label: {
                    Text(Titles.addTransactionButton)
                        .foregroundColor(Color.bwText)
                        .font(.system(size: 14, weight: .bold))
                        .padding(EdgeInsets(
                            top: 8,
                            leading: 12,
                            bottom: 8,
                            trailing: 12)
                        )
                        .background(Color.bwBackground)
                        .cornerRadius(5)
                }
            } else {
                HStack {
                    Spacer()
                    addTransactionButton
                        .disabled(card.limit < 0)
                    filterButton
                        .fullScreenCover(isPresented: $filterSheetIsPresented) {
                            FilterSheet(vm: vm, didSaveFilters: { categories in
                                selectedCategories = categories
                            }, selectedCategories: selectedCategories)
                        }
                }
                .padding(.horizontal)

                ForEach(filterTransactions(selectedCategories)) { transaction in
                    TransactionView(transaction: transaction, vm: vm, card: card)
                }
            }
        }
        .fullScreenCover(isPresented: $addTransactionFormIsPresented) {
            NewTransactionView(vm: vm, card: card)
        }
    }

    private func filterTransactions(_ selectedCategories: Set<TransactionCategory>) -> [CardTransaction] {
        if selectedCategories.isEmpty {
            return Array(fetchRequest.wrappedValue)
        }

        return fetchRequest.wrappedValue.filter { transaction in
            var filtered = false

            if let categories = transaction.categories as? Set<TransactionCategory> {
                categories.forEach({ cat in
                    if selectedCategories.contains(cat) {
                        filtered = true
                    }
                })
            }
            return filtered
        }
    }

    private var addTransactionButton: some View {
        Button {
            addTransactionFormIsPresented.toggle()
        } label: {
            Text(Titles.addTransactionButton)
                .foregroundColor(Color.bwText)
                .font(.system(size: 14, weight: .bold))
                .padding(EdgeInsets(
                    top: 8,
                    leading: 12,
                    bottom: 8,
                    trailing: 12)
                )
                .background(card.limit < 0 ? Color.gray : Color.bwBackground)
                .cornerRadius(5)
        }
    }

    private var filterButton: some View {
        Button {
            filterSheetIsPresented.toggle()
        } label: {
            HStack {
                Image(systemName: "line.horizontal.3.decrease.circle")
                Text(Titles.filterButton)
            }
            .foregroundColor(Color.bwText)
            .font(.system(size: 14, weight: .bold))
            .padding(EdgeInsets(
                top: 8,
                leading: 12,
                bottom: 8,
                trailing: 12)
            )
            .background(Color.bwBackground)
            .cornerRadius(5)
        }
    }
}

struct TransactionView: View {
    let transaction: CardTransaction
    let vm: MainViewModelType
    let card: Card

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
                                    vm.deleteTransaction(transaction, card)
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
        .foregroundColor(Color.bwBackground)
        .padding()
        .background(Color.cardTransactionBackground)
        .cornerRadius(shadowRadius)
        .shadow(radius: shadowRadius)
        .padding()
    }
}

extension TransactionView {
    private enum Titles {
        static let deleteButtonTitle = "??????????????"
    }
}

extension TransactionsView {
    private enum Titles {
        static let navTitle = "???????? ??????????"
        static let addButtonTitle = "+ ????????????????"
        static let noCardsTitle = "?????? ?????????????????? ?????? ?????????????????????? ????????. ???????????? ?????????????????"
        static let addFirstCardTitle = "+ ???????????????? ???????????? ??????????"
        static let addTransaction = "?????????????? ?? ???????????????????? ???????????? ??????????????!"
        static let addTransactionButton = "+ ????????????????????"
        static let countOfCards = "???????? ??????????????: "
        static let filterButton = "??????????????"
    }
}


struct TransactionsView_Previews: PreviewProvider {
    static let firstCard: Card? = {
        let context = PersistenceController.shared.container.viewContext
        let request = Card.fetchRequest()
        request.sortDescriptors = [.init(key: "timestamp", ascending: false)]
        return try? context.fetch(request).first
    }()

    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        ScrollView {
            if let card = firstCard {
                TransactionsView(vm: MainViewModel(), card: card)
            }

        }
        .environment(\.managedObjectContext, context)
    }
}
