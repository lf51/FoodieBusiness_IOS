//
//  GenericModelList.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 23/09/22.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage
import MyFilterPackage

struct VistaIngredientiEspansa: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    let currentDish: ProductModel
    let backgroundColorView: Color
    let allING:[String]
    @State private var container:[String]

    init(currentDish: ProductModel, backgroundColorView: Color) {
        
        self.currentDish = currentDish
        self.backgroundColorView = backgroundColorView
        
        let all = (currentDish.ingredientiPrincipali ?? []) + (currentDish.ingredientiSecondari ?? [])
        self.allING = all
        _container = State(wrappedValue: all)
    }
    
    var body: some View {
        
        CSZStackVB(title: currentDish.intestazione, backgroundColorView: backgroundColorView) {
            
            VStack {
                
                HStack {
                    
                    Text("Count: \(self.container.count,format: .number)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.seaTurtle_2)
                        .padding(5)
                       /* .background {
                            Color.seaTurtle_3.cornerRadius(5.0)
                        }*/
                    Spacer()
                    
                    Picker("", selection: $container) {
                        
                        Text("Vedi Tutti")
                            .tag(self.allING)
                        Text("Solo Principali (\(currentDish.ingredientiPrincipali?.count ?? 0))")
                            .tag(currentDish.ingredientiPrincipali ?? [] as [String])
                        Text("Solo Secondari (\(currentDish.ingredientiSecondari?.count ?? 0))")
                            .tag(currentDish.ingredientiSecondari ?? [] as [String])
                       
                    }
                    .accentColor(Color.black)
                    .background(
                      
                      RoundedRectangle(cornerRadius: 5.0)
                        .fill(Color.white.opacity(0.8))
                        .shadow(radius: 1.0)
                    )
                }
                
                ScrollView(showsIndicators:false) {
                    
                    VStack {
                        
                        ForEach(container,id:\.self) { rif in
    
                           // vbIngredientOptionalScroll(rif: rif)
                            let (ingAndSub,labels) = compilaIngAndSubAndLabel(for: rif)
                            IngredientScrollWithLabel(ingAndSub: ingAndSub,labels:labels)
                        }
                    }
                }
                CSDivider()
            }
           // .padding(.horizontal)
            .csHpadding()
            .animation(.default, value: container)
        }
    }
    
    // Method
    
    /// Torna una tupla. Un array ordinato, dove il primo elemento [0] è l'ingrediente titolare e in posizione [1] l'eventuale sostituto, sia se attivo sia se dormiente. Ritorna altresi' un array contente le label, di modo da distitnguere, titolare, sotituto attivo, dormiente o assente.
    private func compilaIngAndSubAndLabel(for rif:String) -> (ing:[IngredientModel],label:[RowSubstitutionLabel]) {
        
        guard let model = self.viewModel.modelFromId(id: rif, modelPath: \.db.allMyIngredients) else { return ([],[]) }
        
        guard let subId = currentDish.offManager?.fetchSubstitute(for: rif),
              let subModel = self.viewModel.modelFromId(id: subId, modelPath: \.db.allMyIngredients)
        else { return ([model],[.titolare,.nessunSostituto]) }
        
        let isDisponibile = model.getStatusTransition() == .disponibile
        
        guard isDisponibile else { return ([model,subModel],[.titolare,.sostitutoTitolare]) }

        return ([model,subModel],[.titolare,.sostitutoDormiente])
        
    }
}

private struct IngredientScrollWithLabel:View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    let ingAndSub:[IngredientModel]
    let labels:[RowSubstitutionLabel]
    
    @State private var selected:String? = RowSubstitutionLabel.titolare.rawValue

    var body: some View {
        
        VStack(alignment:.leading,spacing:0) {
            
            if let selected {
                
                let etichet = self.labels.map({ $0.rawValue })
                
                let value = Binding {
                    selected
                } set: { new in
                    self.selected = new
                }

                CSPickerClassificatore(
                    etichette: etichet,
                    etichettaDefault: value,
                    labelColor: .black,
                    backgroundColor: .white,
                    shadowColor: .seaTurtle_1,
                    fontStyle: .subheadline)
                .disabled(ingAndSub.count == 1)
                
            }
            
            let enumerated = Array(self.ingAndSub.enumerated())
            
            ScrollView(.horizontal,showsIndicators: false) {
                
                LazyHStack {
                    
                    ForEach(enumerated,id: \.element) { index, ing in
                        
                        let indexConversion = RowSubstitutionLabel.rawValuePosition(from: index,labels: self.labels)
                        
                        vbGenericRow(model: ing)
                            .id(indexConversion)
                            .scrollTransition(axis: .horizontal) { content, phase in
                                    
                                    content.scaleEffect(
                                        x: phase.isIdentity ? 1.0 : 0.80,
                                        y: phase.isIdentity ? 1.0 : 0.80)
                                
                                }
                            
                    }
                }
                .scrollTargetLayout()
            }
            .scrollDisabled(ingAndSub.count == 1)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $selected)
            
            vbSubsDescription()
                .italic()
                .font(.caption)
                .multilineTextAlignment(.leading)
                .foregroundStyle(Color.black)
                .opacity(0.8)
                .padding(.top,2)
        }
    }
    
    // ViewBuilder
    
    @ViewBuilder private func vbGenericRow<M:MyProVisualPack_L0>(model:M) -> some View  where M.RS == RowSize, M.VM == AccounterVM {
        
            GenericItemModel_RowViewMask(model: model, pushImage: "line.diagonal.arrow") {
                
                Button {
                    self.viewModel.showSpecificModel = model.id
                    self.viewModel.pathSelection = .ingredientList
                } label: {
                    Text("Vai all'Ingrediente")
                    Image(systemName: "arrow.up.forward.app")
                }

            }
    }
    
    // method
    
    private func vbSubsDescription() -> Text {
        
        let titolareIsDispo = self.ingAndSub[0].getStatusTransition() == .disponibile
        let ing = self.ingAndSub.map({$0.intestazione})

        let count = ing.count
        
        guard count > 1 else {
            
            if titolareIsDispo {
                
                return Text("L'elemento <\(ing[0])> non ha un sostituto. Quando viene esaurito l'eseguibilità della preparazione può risultare compromessa.")
                
            } else {
                
                return Text("L'elemento <\(ing[0])> non ha un sostituto ed è esaurito. L'eseguibilità della preparazione può risultare compromessa.")
            }
        }
        
        let subIsDispo = self.ingAndSub[1].getStatusTransition() == .disponibile
        
        let subString:String = {
            
            if subIsDispo { 
                return "viene sostituito dall'elemento <\(ing[1])>."
            }
            else { 
                return "non viene sostituito dall'elemento <\(ing[1])>, in quanto l'elemento <\(ing[1])> è al momento esaurito."
            }
            
        }()
        
        if titolareIsDispo
            {
            
            return Text("Quando esaurito, l'elemento <\(ing[0])> \(subString)")
            
        } else {
            
            return Text("L'elemento <\(ing[0])> è esaurito, e \(subString)")
        }
    
    }

}

// enum for local scope
private enum RowSubstitutionLabel:String {
    
    case titolare
    case sostitutoTitolare = "[sostituto attivo]"
    case sostitutoDormiente = "[sostituto dormiente]"
    case nessunSostituto = "[sostituto assente]"
    
    static func rawValuePosition(from position:Int,labels:[Self]) -> String {
        
        labels[position].rawValue
    }
}
/*
struct VistaIngredientiEspansa_Previews: PreviewProvider {
    
    @State static var ingredientSample =  IngredientModel(
        intestazione: "Guanciale Nero",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .altro,
        produzione: .biologico,
        provenienza: .defaultValue,
        allergeni: [.glutine],
        origine: .animale,
        status: .completo(.disponibile)
    )
    
    @State static var ingredientSample2 =  IngredientModel(
        intestazione: "Merluzzo",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .surgelato,
        produzione: .biologico,
        provenienza: .italia,
        allergeni: [.pesce],
        origine: .animale,
        status: .bozza(.disponibile)
            )
    
    @State static var ingredientSample3 =  IngredientModel(
        intestazione: "Basilico",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .altro,
        produzione: .biologico,
        provenienza: .restoDelMondo,
        allergeni: [],
        origine: .vegetale,
        status: .bozza(.inPausa))
    
    @State static var ingredientSample4 =  IngredientModel(
        intestazione: "Mozzarella di Bufala",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .congelato,
        produzione: .convenzionale,
        provenienza: .europa,
        allergeni: [.latte_e_derivati],
        origine: .animale,
        status: .bozza(.inPausa)
    )
    
    @State static var dishItem3: ProductModel = {
        
        var newDish = ProductModel()
        newDish.intestazione = "Bucatini alla Matriciana"
        newDish.status = .completo(.inPausa)
        newDish.ingredientiPrincipali = [ingredientSample4.id,ingredientSample3.id,ingredientSample.id]
        newDish.ingredientiSecondari = [ingredientSample2.id]
        newDish.elencoIngredientiOff = [ingredientSample4.id:ingredientSample.id]
        let price:DishFormat = {
            var pr = DishFormat(type: .mandatory)
            pr.label = "Porzione"
            pr.price = "22.5"
            return pr
        }()
        let price1:DishFormat = {
            var pr = DishFormat(type: .opzionale)
            pr.label = "1/2 Porzione"
            pr.price = "10.5"
            return pr
        }()
        newDish.pricingPiatto = [price,price1]
        
        return newDish
    }()
    
    @State static var viewModel: AccounterVM = {
         let user = UserRoleModel()
        var vm = AccounterVM(userManager: UserManager(userAuthUID: "TEST_USER_UID"))
         vm.db.allMyDish = [dishItem3]
         vm.db.allMyIngredients = [ingredientSample,ingredientSample2,ingredientSample3,ingredientSample4]
         return vm
     }()
    static var previews: some View {
        NavigationStack {
          VistaIngredientiEspansa(currentDish: dishItem3, backgroundColorView: Color.seaTurtle_1)
        }.environmentObject(viewModel)
    }
}*/
