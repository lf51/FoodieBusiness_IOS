//
//  ListaDellaSpesa_MainView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 28/09/22.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage
import Firebase

struct ListaDellaSpesa_MainView: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    let currentDate:String = csTimeFormatter().data.string(from: Date())
    var inventarioEnumerato:EnumeratedSequence<[IngredientModel]>
    let countInventario:Int
    let backgroundColorView:Color
    
    init(
        inventarioIngredienti:[IngredientModel],
        backgroundColorView: Color) {

        self.inventarioEnumerato = inventarioIngredienti.enumerated()
        self.countInventario = inventarioIngredienti.count
        self.backgroundColorView = backgroundColorView
    }
    
    // Upgrade 08.03
    @State private var espandiNote:Bool = true
    
    var value:(title:String,color:Color,image:String) {
        if self.espandiNote {
            return (
                "Chiudi Note",
                Color.seaTurtle_2,
                "arrow.down.and.line.horizontal.and.arrow.up" )}
        else {
            return (
                "Espandi Note",
                Color.seaTurtle_3,
                "arrow.up.and.line.horizontal.and.arrow.down")}
    }
    
    var body: some View {
       
        CSZStackVB(title: "Lista della Spesa", backgroundColorView: backgroundColorView) {
            
            VStack(alignment:.leading) {

                BottomDialogView(
                    primaryButtonTitle: "∆ Validate",
                    paddingVerticalValue: .zero) {
                    self.description()
                } disableConditions: {
                    self.deActiveCondition()
                } primaryDialogAction: {
                    self.dialogAction()
                }

                ScrollView(showsIndicators:false) {
                    
                    VStack(alignment:.leading,spacing:1) {
                        
                        ForEach(Array(inventarioEnumerato),id:\.element) { position, element in

                                rowIngredient(ing: element, position: position)
    
                        }

                    }
                }
                .scrollDismissesKeyboard(.immediately)
                
                CSDivider()
            }
            .csHpadding()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {

                Button {
                    withAnimation {
                        self.espandiNote.toggle()
                    }
                } label: {
                
                    HStack {
                        
                        Image(systemName: value.image)
                            .imageScale(.medium)
                        Text(value.title)
                        
                    }
                    .foregroundStyle(value.color)
                    
                }

            }
        }
       
    }
    
    // Method
    
    @ViewBuilder private func rowIngredient(ing:IngredientModel, position:Int) -> some View {
        
        let moreInfo:String = {
            
           /* let conservazione = ing.conservazione != .altro ? "❄️ " : ""*/
            let conservazione = ing.values.conservazione.imageAssociated()
            let produzione = ing.values.produzione == .biologico ? " bio " : " "
            let provenienza:String
            
            if ing.values.provenienza == .km0 || ing.values.provenienza == .italia {
                provenienza = "\(ing.values.provenienza.shortDescription())"
            } else { provenienza = "" }
            
            return conservazione + produzione + provenienza
        }()
        
        SpesaRowIngredientView(
            element: ing,
            position: position,
            moreInfo: moreInfo,
            currentDate: self.currentDate,
            showNote: self.espandiNote)
    
    }

    @ViewBuilder private func dialogAction() -> some View {
        
        csBuilderDialogButton {
            
            DialogButtonElement(
                label: .validate) {
                    self.validateAcquisti()
                }
            
        } // chiusa result Builder
        
    }
    
    private func validateAcquisti() {
        
        let userCorrente = self.viewModel.currentUser?.userName
        let depennati = self.ingredientiInArrivo()
        
        let bolle = depennati.compactMap({
            let rif = $0.id
            if let inventario = $0.inventario,
               var bollaCorrente = inventario.bollaCorrente {
                bollaCorrente.rifIngrediente = rif
                bollaCorrente.user = userCorrente
                return bollaCorrente
            } else {
                return nil
            }
        })
        
        let validate = depennati.map({
            var current = $0
            current.changeTransizioneScorte(to: .validate)
            return current
        })
        
        let bollaEncoder:Firestore.Encoder = {
            let encoder = Firestore.Encoder()
            encoder.userInfo[BollaAcquisto.codingInfo] = MyCodingCase.subCollection
            return encoder
        }()
        
        Task {
            
            do {
                
               try await self.viewModel.updateModelCollection(
                    items: bolle,
                    sub: .archivioBolleAcquisto,
                    encoder: bollaEncoder)
                
              try await self.viewModel.updateModelCollection(
                    items: validate,
                    sub: .allMyIngredients)
                
                
            } catch let error {
                
                print(error.localizedDescription)
            }
            
        }
    }
    
    private func ingredientiInArrivo() -> [IngredientModel] {
        
        let reverseEnum = self.inventarioEnumerato.map({$0.element})

        let depennati = reverseEnum.filter({
            $0.transitionScorte() == .inArrivo
        })
        return depennati
    }
    
    private func deActiveCondition() -> (general:Bool?,primary:Bool,secondary:Bool?) {
        
      let depennati = ingredientiInArrivo()
      let primaria = depennati.isEmpty
        
      return (nil,primaria,nil)
    }
        
    private func description() -> (breve:Text,estesa:Text) {
        
        let depennati = self.ingredientiInArrivo().count
        
        let breve = "\(self.currentDate)\nAcquistati: \(depennati)/\(self.countInventario)"
        
        let estesa = "Gli ingredienti acquistati sono rimessi in stock (con lo status disponibile) e sono rimossi dalla lista della spesa."
        
        return (Text(breve),Text(estesa))
    }

}
/*
struct ListaDellaSpesa_MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ListaDellaSpesa_MainView( inventarioIngredienti: testAccount.inventarioIngredienti(), backgroundColorView: Color.seaTurtle_1)
                .environmentObject(testAccount)
        }
        
    }
}*/

struct SpesaRowIngredientView: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    let element:IngredientModel
    let position:Int
    let moreInfo:String
   
    let currentDate:String
    
    let showNote:Bool
    @State private var openNoteUpdate:Bool = false
    
    @FocusState private var modelField:ModelField?
    
    var statoInventario:TransizioneScorte { element.transitionScorte() }
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            let isStatoInArrivo = statoInventario == .inArrivo
            let statusTransition = element.getStatusTransition()
            
            HStack(alignment:.top) {
                
                    HStack(alignment:.center,spacing:2) {

                            Text("\(position + 1).")
                                .font(.system(.subheadline, design: .monospaced, weight: .bold))
                                .foregroundStyle(Color.white.opacity(0.8))

                        HStack(spacing:5) {
     
                           RoundedRectangle(cornerRadius: 2.0)
                                        .frame(width: 5)
                                        .foregroundStyle(statusTransition.colorAssociated())
        
                            VStack(alignment:.leading,spacing:0) {
                                
                                Text(element.intestazione)
                                    .italic()
                                    .font(.title3)
                                    .strikethrough(isStatoInArrivo, color: .seaTurtle_3)
                                    .foregroundStyle(Color.black)
                                    .lineLimit(1)
                                    .brightness(0.1)
                                    .opacity(isStatoInArrivo ? 0.5 : 1.0)
                                
                                Text(moreInfo.isEmpty ? "--" : "\(moreInfo)")
                                    .font(.system(.caption, design: .monospaced, weight: .semibold))
                                    .foregroundStyle(Color.seaTurtle_4)
                            } // vstack intestazione
                        }
                    }
           
                Spacer()

                self.depennaLogic(isInArrivo: isStatoInArrivo)

            }
            .padding(.top,15)
            .csModifier(!self.showNote) { view in
                view.padding(.bottom,15)
            }
            .onTapGesture {
                if self.openNoteUpdate {
                    withAnimation {
                        self.openNoteUpdate.toggle()
                    }
                }
            }
            
            if showNote {
                
               vbNotaAcquisto()
                    .focused($modelField, equals: .descrizione)
                    .padding(.bottom,5)
            }
            
        }
        .padding(.horizontal,5)
        .background {
            coloreAssociato(ingredient: element)
                .opacity(0.4)
                .cornerRadius(4)
        }
        .onChange(of: self.statoInventario) { _, newValue in
            if newValue == .inArrivo {
                self.openNoteUpdate = false
            }
        }
        
    }
    
    // Method
    
    @ViewBuilder private func vbNotaAcquisto() -> some View {
        
      /*  let nota = self.viewModel.currentProperty.inventario.estrapolaNota(idIngrediente: self.element.id,currentDate: self.currentDate)*/
        let nota = self.element.notaBollaCorrente()
        
        if openNoteUpdate {
            
            CSTextField_ExpandingBoxPlain(
                value: nota,
                dismissButton:$openNoteUpdate,
                maxDescriptionLenght: 100,
                modelField: $modelField) { value in
                saveNota(value: value)
            }
            
        } else {
            
          //  let localBool = nota == ""
            let value:(note:String, opacity:CGFloat) = {
                
                if nota == "" { 
                    return ("[+] double tap",0.5 ) }
                else {
                    return (nota,0.7) }
                
            }()
            
            HStack(alignment:.top,spacing:5) {
                Text("Note:")
                    .fontWeight(.semibold)
            
                Text(value.note)
                    .italic()
                   //.font(.subheadline)
                    .foregroundStyle(Color.black)
                    .opacity(value.opacity)
                    .multilineTextAlignment(.leading)
            }
            .font(.subheadline)
            .onTapGesture(count:2) {
                    withAnimation {
                        self.openNoteUpdate.toggle()
                    }
                }
           // .disabled(disableTap)
               // .disabled(isStatoInArrivo)
            
        }

    }
    
    private func saveNota(value:String) {
    
        guard element.inventario != nil else { return }
        
        let step_0:String = {
            
            if value != "" {
                let step_01 = csStringCleaner(string: value)
                let step_02 = csStringCut(testo: step_01, maxLenght: 100)
               /* let step_03 = step_02.replacingOccurrences(of: "_:", with: "-")*/
               // return "\(currentDate)|\(step_02)"
                return step_02
                
            } else { return value }
        }()
        
       // var updateIng = self.element
       // updateIng.addNotaToBolla(nota: step_0)
        
       // self.viewModel.updateModelOnSub(itemModel: updateIng)
        
        
       // let bolla = inventario.updateBollaWith(note: step_0)
        
        updateBollaAcquisto(field: .nota, value: step_0)
        
       /* let value = bolla.encodeSingleValue()
        let mainKey = IngredientModel.CodingKeys.inventario.rawValue
        let subKey = InventarioScorte.CodingKeys.bollaCorrente.rawValue
        let path = [mainKey:[subKey:value]]
        
        self.viewModel.updateSingleField(
            docId: element.id,
            sub: .allMyIngredients,
            path: path) */
        
    }
    
    private func coloreAssociato(ingredient:IngredientModel) -> Color {
     
        let allergens = ingredient.values.allergeni ?? []
        
        if ingredient.values.origine == .vegetale { return .green}
     else if
             allergens.contains(.molluschi) ||
             allergens.contains(.crostacei) ||
             allergens.contains(.pesce) { return .indigo }
     else if allergens.contains(.latte_e_derivati) { return .white }
     else { return .pink }
         
     }
    
    private func depennaLogic(isInArrivo:Bool) -> some View {
        
        let value:(image:String,color:Color) = {
            
            var image:String
            var colore:Color
            
            if isInArrivo {
                let stato = self.statoInventario
                image = stato.imageAssociata()
                colore = stato.coloreAssociato()
            } else {
                let scorte = self.element.statusScorte()
                image = scorte.imageAssociata()
                colore = scorte.coloreAssociato()
            }
            return(image,colore)
        }()
        
        return HStack {
 
            Image(systemName: value.image)
                    .imageScale(.medium)
                    .foregroundStyle(value.color)
  
            Image(systemName: "square")
                  .imageScale(.large)
                  .foregroundStyle(Color.black)
                  .brightness(0.3)
                  .overlay {
                      if isInArrivo {
                          Image(systemName: "checkmark")
                              .bold()
                              .imageScale(.large)
                              .foregroundStyle(Color.seaTurtle_3)
                      }
                  }
                  .onTapGesture {
                      withAnimation {
                          self.depennaAction()
                      }
                  }
                  .onLongPressGesture {
                      withAnimation {
                          self.undoDepennaAction()
                      }
                  }
        }
    }
    
    private func undoDepennaAction() {
        
        guard let inventario = element.inventario,
              inventario.transitionState == .inArrivo else { return }
        
       // var updateIng = element
       // updateIng.changeTransizioneScorte(to: .pending)
        
       // self.viewModel.updateModelOnSub(itemModel: updateIng) // sostituire con un save singleField
       // let bolla = inventario.setDataBollaToNil()
        
       // guard let bolla else { return }
        let nullValue:Date? = nil
        updateBollaAcquisto(field: .data, value: nullValue as Any)
        
       /* let value = bolla.encodeSingleValue()
        let mainKey = IngredientModel.CodingKeys.inventario.rawValue
        let subKey = InventarioScorte.CodingKeys.bollaCorrente.rawValue
        let path = [mainKey:[subKey:value]]
        
        self.viewModel.updateSingleField(
            docId: element.id,
            sub: .allMyIngredients,
            path: path)*/

    }
    
    private func depennaAction() {
        
        guard let inventario = element.inventario,
              inventario.transitionState != .inArrivo else {
            
                  self.viewModel.alertItem = AlertModel(title: "Info", message: "Long Press to Cancel")
                  return
              }
        
       // let bolla = inventario.getUpdatedBolla()
        let timeStamp:Date = Date()
        updateBollaAcquisto(field: .data, value: timeStamp)
       /* let value = bolla.encodeSingleValue()
        
        let mainKey = IngredientModel.CodingKeys.inventario.rawValue
        let subKey = InventarioScorte.CodingKeys.bollaCorrente.rawValue
        let path = [mainKey:[subKey:value]]
        
        self.viewModel.updateSingleField(
            docId: element.id,
            sub: .allMyIngredients,
            path: path)*/

    }
    
    private func updateBollaAcquisto(field:BollaAcquisto.CodingKeys,value:Any) {
        
        let mainKey = IngredientModel.CodingKeys.inventario.rawValue
        let subKey = InventarioScorte.CodingKeys.bollaCorrente.rawValue
        
        let fieldValue = field.rawValue

        let path = [
            mainKey:[subKey:[fieldValue:value]]
        ]
        
        Task {
            
           try await self.viewModel.updateSingleField(
                docId: element.id,
                sub: .allMyIngredients,
                path: path)
            
        }
    }
    
}
