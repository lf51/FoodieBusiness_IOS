//
//  SelettoreIngrediente_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/02/22.
//

import SwiftUI

///Main View Selettore Generico di MyModelProtocol. l'elencoModelList : [ModelList] usa degli array predefiniti. In caso di custom array, occorre tener presente che il limite max (teorico/grafico) è di 4 liste, di cui almeno una per tipo (container destinazione o container fonte), e il limite min è 2 (una per tipo). I keypath devono portare ad array.
struct SelettoreIngrediente_NewDishSubView<M1:MyModelProtocol,M2:MyModelProtocol>: View {
    
    var screenHeight: CGFloat = UIScreen.main.bounds.height

    @EnvironmentObject var viewModel: AccounterVM
    @Binding var itemModel: M1
    let elencoModelList: [ModelList]

    @State private var modelListCorrente: String = ""
    
    private var viewModelList: [ModelList] = []
    private var itemModelList: [ModelList] = []
    
    @State private var temporaryDestinationModelContainer: [String:[M2]] = [:]
    
    init(itemModel: Binding<M1>, elencoModelList: [ModelList]) {
        
        _itemModel = itemModel
        self.elencoModelList = elencoModelList
        (self.viewModelList, self.itemModelList) = separazioneListe(elencoModelList: elencoModelList)
        
        _modelListCorrente = State(initialValue: elencoModelList[0].returnAssociatedValue().0)
        
    }

    private var isButtonDisabled: Bool {
        
        print("IsButtonDisabled - step 1")
        
        for itemList in itemModelList {
            
            if itemList.returnAssociatedValue().0 == self.modelListCorrente { return true }
            
        }
        
        print("IsButtonDisabled - step 2")
        
        for (_,container) in temporaryDestinationModelContainer {
            
            if !container.isEmpty {return false}
            
        }
        print("IsButtonDisabled - step 3")
        
        return true
    }
    
  /*  private var isAggiungiButtonDisabled: Bool {
        
        modelListCorrente == .ingredientiPrincipali || modelListCorrente == .ingredientiSecondari || (temporarySelectionIngredients["IngredientiPrincipali"]!.isEmpty && temporarySelectionIngredients["IngredientiSecondari"]!.isEmpty)
  
    } */
    
    var body: some View {

        VStack(alignment: .leading) {
            
            SwitchItemModelContainer<_,M2>(itemModel:$itemModel,itemModelList: itemModelList, listaDaMostrare: $modelListCorrente)
                .padding(.horizontal)
                .padding(.top)
            
            SwitchViewModelContainer(viewModelList: viewModelList, listaDaMostrare: $modelListCorrente)
                .padding()
                .background(Color.cyan.opacity(0.5))
                
            ListaIngredienti_ConditionalView<_, M2>(itemModel: $itemModel, listaDaMostrare: $modelListCorrente, elencoModelList: elencoModelList, itemModelList: itemModelList, temporaryDestinationModelList: $temporaryDestinationModelContainer)
            // .refreshable -> per aggiornare
            
            CSButton_large(title: "Aggiungi", accentColor: Color.white, backgroundColor: Color.cyan.opacity(0.5), cornerRadius: 0.0) {
                
                self.aggiungiNewDishIngredients()
                
                }.disabled(isButtonDisabled)
        }
        .background(Color.white.cornerRadius(20.0).shadow(radius: 5.0))
        .frame(width: (screenHeight * 0.40))
        .frame(height: screenHeight * 0.60 )
  
    }
    
    // Methodi & Oggetti
    
    private func aggiungiNewDishIngredients() {
        
        for list in itemModelList {
            
            let (title,keyPath,_) = list.returnAssociatedValue()
            
            let currentKeyPath = keyPath as? WritableKeyPath<M1,[M2]>
            if currentKeyPath != nil {
                self.itemModel[keyPath: currentKeyPath!].append(contentsOf: self.temporaryDestinationModelContainer[title] ?? [])
                /*qualora la chiave nel temporaryDestination non esiste passa un array vuoto */
            }

            self.temporaryDestinationModelContainer[title] = []
            print("Dentro AggiungiAction - keycount: \(temporaryDestinationModelContainer.keys.count) - \(temporaryDestinationModelContainer.keys.description)")
        }
    }
    
    private func separazioneListe(elencoModelList:[ModelList]) -> (vmList:[ModelList],imList:[ModelList]){
        
        var fonteModelList:[ModelList] = []
        var destinazioneModelList:[ModelList] = []
        
        for list in elencoModelList {
            
            let(_,_,containerType) = list.returnAssociatedValue()

            if containerType == .fonte {fonteModelList.append(list)}
            else {destinazioneModelList.append(list)}
            
        }
        
      let destinazioneModelListOrdered = destinazioneModelList.sorted {
            
            $0.returnAssociatedValue().2.returnAssociatedValue().1.rawValue <
                $1.returnAssociatedValue().2.returnAssociatedValue().1.rawValue
            
        }
        
        print("Dentro SeparazioneListe: vmList:\(fonteModelList.count) - nameVMlist:\(fonteModelList.description), imList:\(destinazioneModelList.count)-nameIMlist:\(destinazioneModelList.description)")
        return (fonteModelList,destinazioneModelListOrdered)
        
    }
         
}

struct SelettoreIngrediente_NewDishSubView_Previews: PreviewProvider {
    
  //  static var propertyVM: PropertyVM = PropertyVM()
    static var viewModel: AccounterVM = AccounterVM()
    
    static var previews: some View {
        
        ZStack {
            Color.cyan.opacity(0.8)
            Group{
                VStack{
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                }
                .padding()
                .foregroundColor(Color.white)
        
            }
        
          //  SelettoreIngrediente_NewDishSubView(newDish: .constant(DishModel()))

        }.onTapGesture {
            SelettoreIngrediente_NewDishSubView_Previews.test()
        }
       
    }
    
    static func test() {
        
        for x in 1...20 {
            
        var ingrediente = IngredientModel()
            
            ingrediente.intestazione = "\(x.description)' ingredient"
            
            viewModel.allMyIngredients.append(ingrediente)
            
        }
        
    }
    
}
