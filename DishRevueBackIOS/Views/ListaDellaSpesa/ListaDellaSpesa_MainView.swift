//
//  ListaDellaSpesa_MainView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 28/09/22.
//

import SwiftUI

struct ListaDellaSpesa_MainView: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    let currentDate:String = csTimeFormatter().data.string(from: Date())
    let allInventario:EnumeratedSequence<[IngredientModel]>
    let inventarioArchiviato:Inventario
    let backgroundColorView:Color
    
    init(onlyReaderVM: AccounterVM, backgroundColorView: Color) {
        
        let inventarioScorte = onlyReaderVM.inventarioScorte
        
        self.inventarioArchiviato = inventarioScorte
        self.backgroundColorView = backgroundColorView
        self.allInventario = inventarioScorte.inventarioFiltrato(viewModel: onlyReaderVM)
        
    }
    
    var body: some View {
       
        CSZStackVB(title: "Lista della Spesa", backgroundColorView: backgroundColorView) {
            
            VStack(alignment:.leading) {
                
                BottomView_ConVB(
                    primaryButtonTitle: "∆ Cambia Status",
                    paddingVerticalValue: .zero) {
                        self.deActiveCondition()
                    } description: {
                        self.description()
                    } primaryDialogAction: {
                        self.dialogAction()
                    }
                
                ScrollView(showsIndicators:false) {
                    
                    VStack(alignment:.leading,spacing:1) {
                        
                        ForEach(Array(allInventario),id:\.element) { position, element in

                                rowIngredient(ing: element, position: position)
                                .padding(.horizontal,5)
                                .padding(.vertical,14)
                                .background {
                                 coloreAssociato(ingredient: element)
                                        .opacity(0.4)
                                    .cornerRadius(4)
                                 }
                        }

                    }
                }
                
            }
            .padding(.horizontal)
        }
        
    }
    
    // Method
    
    @ViewBuilder private func rowIngredient(ing:IngredientModel, position:Int) -> some View {
        
        let moreInfo:String = {
            
            let conservazione = ing.conservazione != .altro ? "❄️ " : ""
            let produzione = ing.produzione == .biologico ? "bio " : ""
            let provenienza:String
            
            if ing.provenienza == .km0 || ing.provenienza == .italia {
                provenienza = "\(ing.provenienza.simpleDescription())"
            } else { provenienza = "" }
            
            return conservazione + produzione + provenienza
        }()
        
        let statoInventario = self.viewModel.inventarioScorte.statoScorteIng(idIngredient: ing.id)
        
        // Nota Vocale 01.10
        
        let statusChanged:Color? = {
           
            let model = self.viewModel.modelFromId(id: ing.id, modelPath: \.allMyIngredients)
            return model?.status.transitionStateColor()
            
        }()
        // end
        
        
    //    VStack(alignment:.leading,spacing: 5) {
            
            HStack {
                
                let condition = statoInventario == .inArrivo
                
                    HStack(alignment:.center,spacing:2) {
                        
                        Text("\(position + 1).")
                            .font(.system(.subheadline, design: .monospaced, weight: .bold))
                            .foregroundColor(Color.white.opacity(0.8))
                        
                        HStack(spacing:5) {

                            HStack(spacing:3) {
                               
                                RoundedRectangle(cornerRadius: 2.0)
                                        .frame(width: 5)
                                        .foregroundColor(statusChanged ?? Color.gray)
                                
                                RoundedRectangle(cornerRadius: 2.0)
                                        .frame(width: 3)
                                        .foregroundColor(ing.status.transitionStateColor())
                                
                            }
     
                            Text(ing.intestazione)
                                .italic()
                                .font(.title3)
                                .strikethrough(condition, color: Color("SeaTurtlePalette_3"))
                                .foregroundColor(Color.black)
                                .lineLimit(1)
                                .brightness(0.1)
                                .opacity(condition ? 0.5 : 1.0)
                        }
                    }
                    
                  //  Spacer()
                    Text(moreInfo.isEmpty ? "--" : "\(moreInfo)")
                        .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                        .foregroundColor(Color("SeaTurtlePalette_4"))
                
                //.opacity(statoInventario == .inArrivo ? 0.5 : 1.0)
           
                Spacer()
                
                if !condition {
                    
                    Text(statoInventario == .esaurito ? "!!!" : "!")
                        .italic()
                        .font(.title3)
                        .foregroundColor(statoInventario.coloreAssociato())
                }

                depennaLogic(id:ing.id,stato:statoInventario)
                   
                  //  .foregroundColor(ing.status.transitionStateColor())
              //  Spacer()
            }//.padding(.vertical,5)
           
         //   Divider()
              
   //     }
        
        
    }
    
    private func coloreAssociato(ingredient:IngredientModel) -> Color {
     
     if ingredient.origine == .vegetale { return .green}
     else if
             ingredient.allergeni.contains(.molluschi) ||
             ingredient.allergeni.contains(.crostacei) ||
             ingredient.allergeni.contains(.pesce) { return .indigo }
     else if ingredient.allergeni.contains(.latte_e_derivati) { return .white }
     else { return .pink }
         
     }
       
    
    private func depennaLogic(id:String,stato:Inventario.TransitoScorte) -> some View {
        
      //  let today = csTimeFormatter().data.string(from: Date())
        let value:(disable:Bool,opacity:CGFloat,checkColor:Color) = {
           
            if let key = self.viewModel.inventarioScorte.lockedId[self.currentDate] {
                if key.contains(id) {return (true,0.4,Color("SeaTurtlePalette_4")) }
                else { return (false,1.0,Color("SeaTurtlePalette_3")) }
            } else {
                return (false,1.0,Color("SeaTurtlePalette_3"))
            }
            
        }()
        
          return Image(systemName: "square")
                .imageScale(.large)
                .foregroundColor(Color.black)
                .brightness(0.3)
                .overlay {
                    if stato == .inArrivo {
                        Image(systemName: "checkmark")
                            .bold()
                            .imageScale(.large)
                            .foregroundColor(value.checkColor)
                    }
                }
                .onTapGesture {
                    withAnimation {
                        self.depennaAction(id: id, statoCorrente: stato)
                    }
                }
                .onLongPressGesture {
                    withAnimation {
                        self.undoDepennaAction(id: id, statoCorrente: stato)
                    }
                }
                .opacity(value.opacity)
                .disabled(value.disable)
       // }
    }
    
   /* private func undoStatusInArrivo(id:String) {
        
        let today = csTimeFormatter().data.string(from: Date())
        
        self.viewModel.inventarioScorte.cronologiaAcquisti[today]?.removeAll(where: {$0 == id})
        
    } */
    
    private func undoDepennaAction(id:String,statoCorrente:Inventario.TransitoScorte) {
        
        if statoCorrente == .inArrivo {
            
           /* self.viewModel.inventarioScorte.cronologiaAcquisti[self.currentDate]?.removeAll(where: {$0 == id}) */
            self.viewModel.inventarioScorte.cronologiaAcquisti[id]?.removeAll(where: {$0 == self.currentDate})
        
            if self.inventarioArchiviato.ingInEsaurimento.contains(id) {
                self.viewModel.inventarioScorte.ingInEsaurimento.append(id)
                
            } else {
                self.viewModel.inventarioScorte.ingEsauriti.append(id)
            }
        }
    }
    
    private func depennaAction(id:String,statoCorrente:Inventario.TransitoScorte) {
        
        if statoCorrente != .inArrivo {
            self.viewModel.inventarioScorte.cambioStatoScorte(idIngrediente: id, nuovoStato: .inArrivo)
        }
    }
    
    @ViewBuilder private func dialogAction() -> some View {
        
        Button("Cambia tutti in 'disponibile'", role: .destructive) {
            
            self.cambioStatusIngredienti()
            
        }

        Button("Cambia solo quelli 'in Pausa'", role: .none) {
            
            self.cambioStatusIngredienti(soloAdUnTipo: .inPausa)
        }
        
        
    }
    
    private func filtraInventarioInArrivo(soloAdUnTipo:StatusTransition? = nil) -> [IngredientModel] {
        
        let allIDInArrivo = self.viewModel.inventarioScorte.allInArrivo()
        let allModelInArrivo = self.viewModel.modelCollectionFromCollectionID(collectionId: allIDInArrivo, modelPath: \.allMyIngredients)

        let allFilteredModel = allModelInArrivo.filter({
            
            if soloAdUnTipo == nil {
              return !$0.status.checkStatusTransition(check: .disponibile)
            } else {
              return $0.status.checkStatusTransition(check: soloAdUnTipo!)
            }
        })
        
        return allFilteredModel
    }
    
    
    private func cambioStatusIngredienti(soloAdUnTipo:StatusTransition? = nil) {
        
        let allFilteredModel = filtraInventarioInArrivo(soloAdUnTipo: soloAdUnTipo)
        
        var statusChangedModelCollection:[IngredientModel] = []
        
        for model in allFilteredModel {
            
            var copy = model
            copy.status = model.status.changeStatusTransition(changeIn: .disponibile)
            statusChangedModelCollection.append(copy)
        }
        
       // let today = csTimeFormatter().data.string(from: Date())
        let idInChange = allFilteredModel.map({$0.id})
        
        if self.viewModel.inventarioScorte.lockedId[self.currentDate] != nil {
            self.viewModel.inventarioScorte.lockedId[self.currentDate]!.append(contentsOf: idInChange)
        } else {
            self.viewModel.inventarioScorte.lockedId[self.currentDate] = idInChange
        }
        
        self.viewModel.updateItemModelCollection(items: statusChangedModelCollection)
        
    }
    
    private func deActiveCondition() -> (general:Bool?,primary:Bool,secondary:Bool?) {
        
      let primaria:Bool = {
            let filterdInventario = filtraInventarioInArrivo()
            return filterdInventario.isEmpty
        }()
  
      return (nil,primaria,nil)
    }
        
    private func description() -> (breve:Text,estesa:Text) {
        
        //let today = csTimeFormatter().data.string(from: Date())
        let vmInventarioScorte:Inventario = self.viewModel.inventarioScorte
        
        let allIng = inventarioArchiviato.allInventario().count
        let daAcquistare = vmInventarioScorte.ingEsauriti.count + vmInventarioScorte.ingInEsaurimento.count
        let acquistati = allIng - daAcquistare
        let cambioStatus = vmInventarioScorte.lockedId[self.currentDate]?.count ?? 0
        
        let breve = "\(self.currentDate)\nAcquistati: \(acquistati)/\(allIng) - ∆Status: \(cambioStatus)/\(allIng)"
        let estesa = "Azione IRREVERSIBILE\nModifica lo Status degli ingredienti depennati da 'in pausa' e/o 'archiviato' a 'disponibile'.\n\nPer un'azione più selettiva clicca su cancel e modifica lo status manualmente dalla lista ingredienti."
        
        return (Text(breve),Text(estesa))
    }
    
        
   
    
}

struct ListaDellaSpesa_MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ListaDellaSpesa_MainView(onlyReaderVM: testAccount, backgroundColorView: Color("SeaTurtlePalette_1"))
                .environmentObject(testAccount)
        }
        
    }
}
