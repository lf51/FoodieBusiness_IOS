//
//  SelettoreIngrediente_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/02/22.
//

import SwiftUI

// Creare un selettore che può inserire, rimuovere e ordinare gli ingredienti

struct SelettoreIngrediente_NewDishSubView: View {
    
    @ObservedObject var propertyVM: PropertyVM
    @Binding var newDish: DishModel
 
    var screenHeight: CGFloat = UIScreen.main.bounds.height
    @State private var listaAttiva: ListSwitcher = .baseModelloIngrediente

    // Liste Temporanee come preListe manipolabili localmente
    @State private var temporarySelectionModelloIngrediente: [String:[ModelloIngrediente]] = ["IngredientiPrincipali":[], "IngredientiSecondari":[]]
    @State private var temporarySelectionBaseModIngrediente: [String:[BaseModelloIngrediente]] = ["IngredientiPrincipali":[], "IngredientiSecondari":[]]
    
    var body: some View {

        VStack(alignment: .leading) {
            
            VStack(alignment: .leading) {
                
                HStack{
                    
                    Text("Ingredienti Principali")
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    CSButton_image(activeImage: "eye.fill", deActiveImage: "eye.fill", imageScale: .medium, activeColor: Color.blue, deActiveColor: Color.gray) {
                        
                        listaAttiva = .ingredientiPrincipali
                      
                    }
                    
                  //  Spacer()
                    
                    Text("(\(self.newDish.ingredientiPrincipali.count))")
                        .fontWeight(.light)
                        .padding(.horizontal)
                    
                    Image(systemName:"circle.fill")
                        .imageScale(.large)
                        .foregroundColor(Color.mint)
        
                }._tightPadding()

                
                HStack {
                    
                    Text("Ingredienti Secondari")
                        .fontWeight(.semibold)
                        .lineLimit(1)
                 
                    Spacer()
                    CSButton_image(activeImage: "eye.fill", deActiveImage: "eye.fill", imageScale: .medium, activeColor: Color.blue, deActiveColor: Color.gray) {
                        
                        listaAttiva = .ingredientiSecondari
                      
                    }
                    
                  //  Spacer()
                    
                    Text("(\(self.newDish.ingredientiSecondari.count))")
                        .fontWeight(.light)
                        .padding(.horizontal)
                    
                    Image(systemName:"circle.fill")
                        .imageScale(.large)
                        .foregroundColor(Color.orange)
                     
                }._tightPadding()
                
            }
            .padding(.horizontal)
            .padding(.top)
            
    
            SwitchListeIngredienti(listaAttiva: $listaAttiva)
                .padding()
                .background(Color.cyan.opacity(0.5))

            ListaIngredientiAttiva_GenericView(propertyVM: propertyVM, newDish: $newDish, listaAttiva: $listaAttiva, temporarySelectionModelloIngrediente: $temporarySelectionModelloIngrediente, temporarySelectionBaseModIngrediente: $temporarySelectionBaseModIngrediente)
            // .refreshable -> per aggiornare, ma forse funziona solo con List
            
            CSButton_2(title: "Aggiungi", accentColor: Color.white, backgroundColor: Color.cyan.opacity(0.5), cornerRadius: 0.0) {
                
                self.fillNewDishIngredients()
            }
  
            
            
        }
        .background(Color.white.cornerRadius(20.0).shadow(radius: 5.0))
        .frame(width: (screenHeight * 0.40))
        .frame(height: screenHeight * 0.60 )
  
    }
    
    // Methodi & Oggetti
    
   
    
    
    
    private func fillNewDishIngredients() {
        
        // convertiamo i BaseModello in Modello
        
        for key in self.temporarySelectionBaseModIngrediente.keys {
            
            for ing in self.temporarySelectionBaseModIngrediente[key]! {
                
                let newIng = ModelloIngrediente(nome: ing.nome)
                self.temporarySelectionModelloIngrediente[key]!.append(newIng)
                
            }
        }
        
    // riempiamo le liste ingredienti
        
        self.newDish.ingredientiPrincipali.append(contentsOf: self.temporarySelectionModelloIngrediente["IngredientiPrincipali"]!)
        
        self.newDish.ingredientiSecondari.append(contentsOf: self.temporarySelectionModelloIngrediente["IngredientiSecondari"]!)
      
    }
         
}

struct SelettoreIngrediente_NewDishSubView_Previews: PreviewProvider {
    
    static var propertyVM: PropertyVM = PropertyVM()
    
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
        
            SelettoreIngrediente_NewDishSubView(propertyVM: propertyVM, newDish: .constant(DishModel()))
               
            
            /*{ ingrediente in
                //
            } */
        }.onTapGesture {
            SelettoreIngrediente_NewDishSubView_Previews.test()
        }
       
    }
    
    static func test() {
        
        for x in 1...20 {
            
        var ingrediente = ModelloIngrediente()
            
            ingrediente.nome = "\(x.description)' ingredient"
            
            propertyVM.listaMyIngredients.append(ingrediente)
            
        }
        
    }
    
}

struct MostraOrdinamentoIngredientiGenerics<G:IngredientConformation>:View {
    
    @Binding var listaAttiva: [G]
   // let attributeIngredient: (_ ingredient: G) -> (colore: Color,image: String)
   // let action: (_ ingredient: G) -> NSItemProvider
  //  let delete: (indexset: IndexSet) -> Void
    
    @Environment(\.editMode) var mode
    
    var body: some View {
            
        //VStack -> non lo inseriamo perchè non fa funzionare onMove e onDelete
            ForEach(listaAttiva) { ingrediente in

                VStack {
                    HStack {
                            
                            Text(ingrediente.nome)
                                    .fontWeight(.semibold)
                                    .lineLimit(1)

                            Spacer()
                    }
                    ._tightPadding()
                    Divider()
                }
            
            }
            .onDelete(perform: removeFromList)
            .onMove(perform: makeOrder)
            .onAppear(perform: editActivation)
            .listRowSeparator(.hidden)
    }
    
    private func removeFromList(indexSet: IndexSet){
        
        self.listaAttiva.remove(atOffsets: indexSet)
        
    }
    
    private func makeOrder(from: IndexSet, to: Int) {
        
        self.listaAttiva.move(fromOffsets: from, toOffset: to)
    }
    
    private func editActivation() {
        
        self.mode?.wrappedValue = .active
        
    }
    
}

struct MostraSelettoreIngredientiGenerics<G:IngredientConformation>:View {
    
    var listaAttiva: [G]
    let attributeIngredient: (_ ingredient: G) -> (colore: Color,image: String)
    let action: (_ ingredient: G) -> Void
 
    var body: some View {
            
            ForEach(listaAttiva) { ingrediente in

                VStack {
                    
                    HStack {
                        
                        Text(ingrediente.nome)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                              //  .minimumScaleFactor(0.7) -> Tolto perchè lo scala sempre

                       Spacer()
                        
                        Image(systemName: self.attributeIngredient(ingrediente).image)
                            .imageScale(.large)
                            .foregroundColor(self.attributeIngredient(ingrediente).colore)
                            .onTapGesture {
                                
                                withAnimation {
                                    action(ingrediente)
                                }
                            }
                    }
                    .opacity(ingrediente.nome == "basilico" ? 0.2 : 1.0)
                    .disabled(ingrediente.nome == "basilico")
                    ._tightPadding()
                    
                    Divider()
                       
                }

            }.listRowSeparator(.hidden)
    }
}

struct SwitchListeIngredienti: View {
    
    @Binding var listaAttiva: ListSwitcher
    
    var body: some View {
        
        HStack {
            
            Spacer()
            
            Text("Miei Ingredienti")
                .fontWeight(listaAttiva == .myIngredients ? .bold : .light)
                .onTapGesture {
                    
                    withAnimation(.easeOut) {
                        self.listaAttiva = .myIngredients
                    }
                }
            
            Spacer()
            
            Text("Community")
                .fontWeight(listaAttiva == .baseModelloIngrediente ? .bold : .light)
                .onTapGesture {
                
                    withAnimation(.easeOut) {
                        self.listaAttiva = .baseModelloIngrediente
                    }
                }
            
            Spacer()
        }
       
    }
}

enum ListSwitcher: String {
   
    case myIngredients = "Miei Ingredienti"
    case baseModelloIngrediente = "Community"
    case ingredientiPrincipali = "Ingredienti Principali"
    case ingredientiSecondari = "Ingredienti Secondari"
//    case noList = "Empty List"

}

struct ListaIngredientiAttiva_GenericView: View {
    
    @ObservedObject var propertyVM: PropertyVM
    @Binding var newDish: DishModel
    @Binding var listaAttiva: ListSwitcher
    
    @Binding var temporarySelectionModelloIngrediente: [String:[ModelloIngrediente]]
    @Binding var temporarySelectionBaseModIngrediente: [String:[BaseModelloIngrediente]]
    
    var body: some View {

        List {
            
         //   VStack(alignment:.leading) { // -> non lo inseriamo in un Vstack perchè non fa funzionare l'onMove e l'onDelete

                if listaAttiva == .baseModelloIngrediente {
                    
                    MostraSelettoreIngredientiGenerics(listaAttiva:propertyVM.listaBaseModelloIngrediente) { ingredient in
                        self.discoverIngredientAttribute(ingredient: ingredient).imageColor
                    } action: { ingredient in
                        self.addIngredientsTemporary(ingredient: ingredient)
                    }
                    
                }
                
                else if listaAttiva == .myIngredients {
                    
                    MostraSelettoreIngredientiGenerics(listaAttiva: propertyVM.listaMyIngredients) { ingredient in
                        self.discoverIngredientAttribute(ingredient: ingredient).imageColor
                    } action: { ingredient in
                        self.addIngredientsTemporary(ingredient: ingredient)
                    }
 
                }
                
                else if listaAttiva == .ingredientiPrincipali {
                    
                   MostraOrdinamentoIngredientiGenerics(listaAttiva: $newDish.ingredientiPrincipali)
                    
          
                }
                
                else if listaAttiva == .ingredientiSecondari {
                    
                    MostraOrdinamentoIngredientiGenerics(listaAttiva: $newDish.ingredientiSecondari)
                    
                }
             
         //   }//.padding(.horizontal)
            
        }
        .listStyle(.plain)
        
    }
    
 //Method
    
   /* private func makeOrderIngredients<G:IngredientConformation>(ingredient: G) -> NSItemProvider {
        
        
        
    } */
    
    private func addIngredientsTemporary<G:IngredientConformation>(ingredient: G) {

        let((_,_),ingredientType,ingredientKey) = discoverIngredientAttribute(ingredient: ingredient)
      
        if ingredientType == "ModelloIngrediente" {
            
            if ingredientKey == "" {
                
                temporarySelectionModelloIngrediente["IngredientiPrincipali"]!.append(ingredient as! ModelloIngrediente)
                
            }
            
            else if ingredientKey == "IngredientiPrincipali" {
                
            let index = temporarySelectionModelloIngrediente["IngredientiPrincipali"]!.firstIndex(of: ingredient as! ModelloIngrediente)
                
                temporarySelectionModelloIngrediente["IngredientiPrincipali"]!.remove(at: index!)
                temporarySelectionModelloIngrediente["IngredientiSecondari"]!.append(ingredient as! ModelloIngrediente)
                
            }
            
            else {
                
                let index = temporarySelectionModelloIngrediente["IngredientiSecondari"]!.firstIndex(of: ingredient as! ModelloIngrediente)
                temporarySelectionModelloIngrediente["IngredientiSecondari"]!.remove(at: index!)
                
            }
            
        } else if ingredientType == "BaseModelloIngrediente" {
            
            
            if ingredientKey == "" {
                
                temporarySelectionBaseModIngrediente["IngredientiPrincipali"]!.append(ingredient as! BaseModelloIngrediente)
                
            }
            
            else if ingredientKey == "IngredientiPrincipali" {
                
            let index = temporarySelectionBaseModIngrediente["IngredientiPrincipali"]!.firstIndex(of: ingredient as! BaseModelloIngrediente)
                
                temporarySelectionBaseModIngrediente["IngredientiPrincipali"]!.remove(at: index!)
                temporarySelectionBaseModIngrediente["IngredientiSecondari"]!.append(ingredient as! BaseModelloIngrediente)
                
            }
            
            else {
                
                let index = temporarySelectionBaseModIngrediente["IngredientiSecondari"]!.firstIndex(of: ingredient as! BaseModelloIngrediente)
                temporarySelectionBaseModIngrediente["IngredientiSecondari"]!.remove(at: index!)
                
            }
                    
        }

    }
    
    
    private func discoverIngredientAttribute<G:IngredientConformation>(ingredient: G) -> (imageColor:(Color,String), type: String, key: String) {
               
        if let value = ingredient as? ModelloIngrediente {
            
            if temporarySelectionModelloIngrediente["IngredientiPrincipali"]!.contains(value) {return ((Color.mint, "circle.fill"),"ModelloIngrediente","IngredientiPrincipali")}
            
            else if temporarySelectionModelloIngrediente["IngredientiSecondari"]!.contains(value) {return ((Color.orange, "circle.fill"),"ModelloIngrediente","IngredientiSecondari")}
            
            else {return ((Color.black, "circle"),"ModelloIngrediente","")}
  
        } else if let value = ingredient as? BaseModelloIngrediente {
            
            if temporarySelectionBaseModIngrediente["IngredientiPrincipali"]!.contains(value) {return ((Color.mint, "circle.fill"),"BaseModelloIngrediente","IngredientiPrincipali")}
            
            else if temporarySelectionBaseModIngrediente["IngredientiSecondari"]!.contains(value) {return ((Color.orange,"circle.fill"),"BaseModelloIngrediente","IngredientiSecondari")}
            
            else {return ((Color.black, "circle"),"BaseModelloIngrediente","") }
                    
        } else { return ((Color.clear,"circle"),"","" )}
    
    }

    
}
