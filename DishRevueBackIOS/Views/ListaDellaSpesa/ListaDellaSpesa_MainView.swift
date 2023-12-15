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
            let conservazione = ing.conservazione.imageAssociated()
            let produzione = ing.produzione == .biologico ? " bio " : " "
            let provenienza:String
            
            if ing.provenienza == .km0 || ing.provenienza == .italia {
                provenienza = "\(ing.provenienza.shortDescription())"
            } else { provenienza = "" }
            
            return conservazione + produzione + provenienza
        }()
        
       /* let statoInventario = self.viewModel.currentProperty.inventario.statoScorteIng(idIngredient: ing.id)*/
       // let statoInventario = ing.inventario?.statusScorte
        
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

         /*   DialogButtonElement(
                label: .onlyInPausa) {
                    self.cambioStatusIngredienti(soloAdUnTipo: .inPausa)
                }*/
            
            
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
        
      //  do {
            
            self.viewModel.updateModelCollection(
                items: bolle,
                sub: .archivioBolleAcquisto,
                encoder: bollaEncoder)
            
           self.viewModel.updateModelCollection(
                items: validate,
                sub: .allMyIngredients)
            
            
       /* } catch {
            
            print(error.localizedDescription)
        }*/
        
        
       
    }
    
  /*  private func filtraInventarioInArrivo(soloAdUnTipo:StatusTransition? = nil) -> [IngredientModel] {
        
        let allIDInArrivo = self.viewModel.currentProperty.inventario.allInArrivo()
        let allModelInArrivo = self.viewModel.modelCollectionFromCollectionID(collectionId: allIDInArrivo, modelPath: \.db.allMyIngredients)

        let allFilteredModel = allModelInArrivo.filter({
            
            if soloAdUnTipo == nil {
              return !$0.status.checkStatusTransition(check: .disponibile)
            } else {
              return $0.status.checkStatusTransition(check: soloAdUnTipo!)
            }
        })
        
        return allFilteredModel
    }*/
    
   /* private func cambioStatusIngredienti(soloAdUnTipo:StatusTransition? = nil) {
        
        let allFilteredModel = filtraInventarioInArrivo(soloAdUnTipo: soloAdUnTipo)
        
        var statusChangedModelCollection:[IngredientModel] = []
        
        for model in allFilteredModel {
            
            var copy = model
            copy.status = model.status.changeStatusTransition(changeIn: .disponibile)
            statusChangedModelCollection.append(copy)
        }
        
       // let today = csTimeFormatter().data.string(from: Date())
        let idInChange = allFilteredModel.map({$0.id})
        
        if self.viewModel.currentProperty.inventario.lockedId[self.currentDate] != nil {
            self.viewModel.currentProperty.inventario.lockedId[self.currentDate]!.append(contentsOf: idInChange)
        } else {
            self.viewModel.currentProperty.inventario.lockedId[self.currentDate] = idInChange
        }
        
        self.viewModel.updateItemModelCollection(items: statusChangedModelCollection)
        
    }*/
    
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
        
     /* let primaria:Bool = {
            let filterdInventario = filtraInventarioInArrivo()
            return filterdInventario.isEmpty
        }()*/
  
      return (nil,primaria,nil)
    }
        
    private func description() -> (breve:Text,estesa:Text) {
        
        let depennati = self.ingredientiInArrivo().count
        
        /*let reverseEnum = self.inventarioEnumerato.map({$0.element})

        let depennati = reverseEnum.filter({
            $0.transitionScorte() == .inArrivo
        }).count */
        
        let breve = "\(self.currentDate)\nAcquistati: \(depennati)/\(self.countInventario)"
        
        let estesa = "Gli ingredienti acquistati sono rimessi in stock (con lo status disponibile) e sono rimossi dalla lista della spesa."
        
        return (Text(breve),Text(estesa))
    }

   /* private func description() -> (breve:Text,estesa:Text) {
        
        //let today = csTimeFormatter().data.string(from: Date())
        let vmInventarioScorte:Inventario = self.viewModel.currentProperty.inventario
        
        let daAcquistare = vmInventarioScorte.ingEsauriti.count + vmInventarioScorte.ingInEsaurimento.count
        let acquistati = self.countInventario - daAcquistare
        let cambioStatus = vmInventarioScorte.lockedId[self.currentDate]?.count ?? 0
        
        let breve = "\(self.currentDate)\nAcquistati: \(acquistati)/\(self.countInventario) - ∆Status: \(cambioStatus)/\(self.countInventario)"
        let estesa = "Azione IRREVERSIBILE\nModifica lo Status degli ingredienti depennati da 'in pausa' e/o 'archiviato' a 'disponibile'.\n\nPer un'azione più selettiva clicca su cancel e modifica lo status manualmente dalla lista ingredienti."
        
        return (Text(breve),Text(estesa))
    }*/
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
            
            HStack(alignment:.top) {
                
                    HStack(alignment:.center,spacing:2) {

                            Text("\(position + 1).")
                                .font(.system(.subheadline, design: .monospaced, weight: .bold))
                                .foregroundStyle(Color.white.opacity(0.8))

                        HStack(spacing:5) {
     
                           RoundedRectangle(cornerRadius: 2.0)
                                        .frame(width: 5)
                                        .foregroundStyle(element.statusTransition.colorAssociated())
        
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
    
        let step_0:String = {
            
            if value != "" {
                let step_01 = csStringCleaner(string: value)
                let step_02 = csStringCut(testo: step_01, maxLenght: 100)
                let step_03 = step_02.replacingOccurrences(of: "_:", with: "-")
               // return "\(currentDate)|\(step_02)"
                return step_03
                
            } else { return value }
        }()
        
        var updateIng = self.element
        updateIng.addNotaToBolla(nota: step_0)
        
        self.viewModel.updateModelOnSub(itemModel: updateIng)
        
    }
    
    private func coloreAssociato(ingredient:IngredientModel) -> Color {
     
        let allergens = ingredient.allergeni ?? []
        
     if ingredient.origine == .vegetale { return .green}
     else if
             allergens.contains(.molluschi) ||
             allergens.contains(.crostacei) ||
             allergens.contains(.pesce) { return .indigo }
     else if allergens.contains(.latte_e_derivati) { return .white }
     else { return .pink }
         
     }
    
    private func depennaLogic(isInArrivo:Bool) -> some View {
        
       /* let value:(disable:Bool,opacity:CGFloat,checkColor:Color) = {
           
            if let key = self.viewModel.currentProperty.inventario.lockedId[self.currentDate] {
                if key.contains(id) {
                    return (true,0.4,.seaTurtle_4) }
                else { return (false,1.0,.seaTurtle_3) }
            } else {
                return (false,1.0,.seaTurtle_3)
            }
            
        }()*/
        
       /* let value:(disable:Bool,opacity:CGFloat,checkColor:Color) = {
           
            return (false,1.0,.seaTurtle_3)
            
        }()*/
        
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
            
           // if !value.disable {
                
            Image(systemName: value.image)
                    .imageScale(.medium)
                    .foregroundStyle(value.color)
                
          /*  } else {
                
                Image(systemName: "triangle")
                    .imageScale(.medium)
                    .foregroundStyle(Color.seaTurtle_2)
            }*/

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
                //  .opacity(value.opacity)
                //  .disabled(value.disable)
        }
       // }
    }
    
    private func undoDepennaAction() {
        
        guard let inventario = element.inventario,
              inventario.transitionState == .inArrivo else { return }
        
        var updateIng = element
        updateIng.changeTransizioneScorte(to: .pending)
        
        self.viewModel.updateModelOnSub(itemModel: updateIng) // sostituire con un save singleField

    }
    
    private func depennaAction() {
        
        guard let inventario = element.inventario,
              inventario.transitionState != .inArrivo else {
            
                  self.viewModel.alertItem = AlertModel(title: "Info", message: "Long Press to Cancel")
                  return
              }
        
        var updateIng = element
        updateIng.changeTransizioneScorte(to: .inArrivo)
        
        self.viewModel.updateModelOnSub(itemModel: updateIng) // sostituire con un save singleField

    }
    
   /* private func undoDepennaAction(id:String,isInArrivo:Bool) {
        
        if isInArrivo {
            
          /*  self.viewModel.inventarioScorte.cronologiaAcquisti[id]?.removeAll(where: {$0 == self.currentDate}) */
            self.viewModel.currentProperty.inventario.cronologiaAcquisti[id]?.removeAll(where: {$0.hasPrefix(self.currentDate)})
        
            if let key = self.viewModel.currentProperty.inventario.archivioIngInEsaurimento[self.currentDate] {
                
                if key.contains(id) {  self.viewModel.currentProperty.inventario.ingInEsaurimento.append(id) }
                else { self.viewModel.currentProperty.inventario.ingEsauriti.append(id) }
 
            } else {
                self.viewModel.currentProperty.inventario.ingEsauriti.append(id)
            }
        }
    }*/
    
   /* private func depennaAction(id:String,isInArrivo:Bool) {
        
        if !isInArrivo {
            self.viewModel.currentProperty.inventario.cambioStatoScorte(idIngrediente: id, nuovoStato: .inArrivo)
        } else {
            
            self.viewModel.alertItem = AlertModel(title: "Info", message: "Long Press to depenn")
        }
    }*/
}


/*
struct ListaDellaSpesa_MainView: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    let currentDate:String = csTimeFormatter().data.string(from: Date())
    let inventarioEnumerato:EnumeratedSequence<[IngredientModel]>
    let countInventario:Int
    let backgroundColorView:Color
    
    init(inventarioIngredienti:[IngredientModel], backgroundColorView: Color) {

        self.inventarioEnumerato = inventarioIngredienti.enumerated()
        self.countInventario = inventarioIngredienti.count
        self.backgroundColorView = backgroundColorView
        
        print("Init Lista della Spesa")

        
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
                
               /* BottomView_ConVB(
                    primaryButtonTitle: "∆ Cambia Status",
                    paddingVerticalValue: .zero) {
                        self.deActiveCondition()
                    } description: {
                        self.description()
                    } primaryDialogAction: {
                        self.dialogAction()
                    }*/
                
                
                BottomDialogView(
                    primaryButtonTitle: "∆ Cambia Status",
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
            
            let conservazione = ing.conservazione != .altro ? "❄️ " : ""
            let produzione = ing.produzione == .biologico ? "bio " : ""
            let provenienza:String
            
            if ing.provenienza == .km0 || ing.provenienza == .italia {
                provenienza = "\(ing.provenienza.shortDescription())"
            } else { provenienza = "" }
            
            return conservazione + produzione + provenienza
        }()
        
        let statoInventario = self.viewModel.currentProperty.inventario.statoScorteIng(idIngredient: ing.id)
        
        SpesaRowIngredientView(
            element: ing,
            position: position,
            moreInfo: moreInfo,
            statoInventario: statoInventario,
            currentDate: self.currentDate,
            showNote: self.espandiNote)
    
    }

    @ViewBuilder private func dialogAction() -> some View {
        
        csBuilderDialogButton {
            
            DialogButtonElement(
                label: .allAvaible,
                role: .destructive) {
                    self.cambioStatusIngredienti()
                }

            DialogButtonElement(
                label: .onlyInPausa) {
                    self.cambioStatusIngredienti(soloAdUnTipo: .inPausa)
                }
            
            
        } // chiusa result Builder
        
    }
    
    
   /* @ViewBuilder private func dialogAction() -> some View {
        
        Button("Cambia tutti in 'disponibile'", role: .destructive) {
            
            self.cambioStatusIngredienti()
            
        }

        Button("Cambia solo quelli 'in Pausa'", role: .none) {
            
            self.cambioStatusIngredienti(soloAdUnTipo: .inPausa)
        }
        
        
    }*/// deprecata
    
    private func filtraInventarioInArrivo(soloAdUnTipo:StatusTransition? = nil) -> [IngredientModel] {
        
        let allIDInArrivo = self.viewModel.currentProperty.inventario.allInArrivo()
        let allModelInArrivo = self.viewModel.modelCollectionFromCollectionID(collectionId: allIDInArrivo, modelPath: \.db.allMyIngredients)

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
        
        if self.viewModel.currentProperty.inventario.lockedId[self.currentDate] != nil {
            self.viewModel.currentProperty.inventario.lockedId[self.currentDate]!.append(contentsOf: idInChange)
        } else {
            self.viewModel.currentProperty.inventario.lockedId[self.currentDate] = idInChange
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
        let vmInventarioScorte:Inventario = self.viewModel.currentProperty.inventario
        
        let daAcquistare = vmInventarioScorte.ingEsauriti.count + vmInventarioScorte.ingInEsaurimento.count
        let acquistati = self.countInventario - daAcquistare
        let cambioStatus = vmInventarioScorte.lockedId[self.currentDate]?.count ?? 0
        
        let breve = "\(self.currentDate)\nAcquistati: \(acquistati)/\(self.countInventario) - ∆Status: \(cambioStatus)/\(self.countInventario)"
        let estesa = "Azione IRREVERSIBILE\nModifica lo Status degli ingredienti depennati da 'in pausa' e/o 'archiviato' a 'disponibile'.\n\nPer un'azione più selettiva clicca su cancel e modifica lo status manualmente dalla lista ingredienti."
        
        return (Text(breve),Text(estesa))
    }
    
        
   
    
}

struct SpesaRowIngredientView: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    let element:IngredientModel
    let position:Int
    let moreInfo:String
    let statoInventario:Inventario.TransitoScorte
    let currentDate:String
    
   // @State private var showNote:Bool = false
    let showNote:Bool
    @State private var openNoteUpdate:Bool = false
    
    @FocusState private var modelField:ModelField?
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            let isStatoInArrivo = statoInventario == .inArrivo
            
            HStack(alignment:.top) {
                
                    HStack(alignment:.center,spacing:2) {

                            Text("\(position + 1).")
                                .font(.system(.subheadline, design: .monospaced, weight: .bold))
                                .foregroundStyle(Color.white.opacity(0.8))

                        HStack(spacing:5) {
     
                           RoundedRectangle(cornerRadius: 2.0)
                                        .frame(width: 5)
                                        .foregroundStyle(element.status.transitionStateColor())
        
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
                    
                  //  Spacer()
                  /*  Text(moreInfo.isEmpty ? "--" : "\(moreInfo)")
                        .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                        .foregroundStyle(Color.seaTurtle_4) */
           
                Spacer()

                depennaLogic(id:element.id,isInArrivo: isStatoInArrivo)

            }
           //.padding(.horizontal,5)
           // .padding(.vertical,15)
            .padding(.top,15)
            .csModifier(!self.showNote) { view in
                view.padding(.bottom,15)
            }
           /* .overlay(alignment: .bottom) {
                
                ZStack {
                    Image(systemName:self.showNote ? "chevron.compact.up" : "chevron.compact.down")
                        //.bold()
                        .imageScale(.large)
                        .foregroundStyle(Color.seaTurtle_3)
                        .onTapGesture {
                            withAnimation {
                               // self.showNote.toggle()
                            }
                        }
                    
                    if showNote {
                        
                        Image(systemName: self.openNoteUpdate ? "pencil.slash" : "pencil.line")
                            .imageScale(.medium)
                            .foregroundStyle(self.openNoteUpdate ? Color.seaTurtle_4 : Color.seaTurtle_2)
                            .opacity(isStatoInArrivo ? 0.4 : 1.0)
                            .offset(x: 40)
                            .onTapGesture {
                                withAnimation {
                                    self.openNoteUpdate.toggle()
                                }
                            }.disabled(isStatoInArrivo)
                    }
                    
                }
            } */
            
            if showNote {
                
               vbNotaAcquisto(disableTap: isStatoInArrivo)
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
    
    @ViewBuilder private func vbNotaAcquisto(disableTap:Bool) -> some View {
        
        let nota = self.viewModel.currentProperty.inventario.estrapolaNota(idIngrediente: self.element.id,currentDate: self.currentDate)
        
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
                
                let opacoBase = disableTap ? 0.7 : 1.0
                if nota == "" { return ("Nessuna",(opacoBase - 0.1) ) }
                else { return (nota,opacoBase) }
                
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
            .disabled(disableTap)
               // .disabled(isStatoInArrivo)
            
        }
        
        
    
        
        
    }
    
   /* private func saveNota(value:String) {
        
    let string = value == "" ? "" : "\(currentDate)|\(value)"

    self.viewModel.inventarioScorte.archivioNotaAcquisto[self.element.id] = string
        
    } */ // 08.03.23 bk upgrade
    
    private func saveNota(value:String) {
    
        let step_0:String = {
            
            if value != "" {
                let step_01 = csStringCleaner(string: value)
                let step_02 = csStringCut(testo: step_01, maxLenght: 100)
                return "\(currentDate)|\(step_02)"
            } else { return value }
        }()
        
   // let string = step_0 == "" ? "" : "\(currentDate)|\(value)"

    self.viewModel.currentProperty.inventario.archivioNotaAcquisto[self.element.id] = step_0
        
    }
    
    private func coloreAssociato(ingredient:IngredientModel) -> Color {
     
        let allergens = ingredient.allergeni ?? []
        
     if ingredient.origine == .vegetale { return .green}
     else if
             allergens.contains(.molluschi) ||
             allergens.contains(.crostacei) ||
             allergens.contains(.pesce) { return .indigo }
     else if allergens.contains(.latte_e_derivati) { return .white }
     else { return .pink }
         
     }
    private func depennaLogic(id:String,isInArrivo:Bool) -> some View {
        
      //  let today = csTimeFormatter().data.string(from: Date())
        let value:(disable:Bool,opacity:CGFloat,checkColor:Color) = {
           
            if let key = self.viewModel.currentProperty.inventario.lockedId[self.currentDate] {
                if key.contains(id) {return (true,0.4,.seaTurtle_4) }
                else { return (false,1.0,.seaTurtle_3) }
            } else {
                return (false,1.0,.seaTurtle_3)
            }
            
        }()
        
        return HStack {
            
            if !value.disable {
                
                Image(systemName: self.statoInventario.imageAssociata())
                    .imageScale(.medium)
                    .foregroundStyle(self.statoInventario.coloreAssociato())
                
            } else {
                
                Image(systemName: "triangle")
                    .imageScale(.medium)
                    .foregroundStyle(Color.seaTurtle_2)
            }

            Image(systemName: "square")
                  .imageScale(.large)
                  .foregroundStyle(Color.black)
                  .brightness(0.3)
                  .overlay {
                      if isInArrivo {
                          Image(systemName: "checkmark")
                              .bold()
                              .imageScale(.large)
                              .foregroundStyle(value.checkColor)
                      }
                  }
                  .onTapGesture {
                      withAnimation {
                          self.depennaAction(id: id, isInArrivo:isInArrivo)
                      }
                  }
                  .onLongPressGesture {
                      withAnimation {
                          self.undoDepennaAction(id: id, isInArrivo:isInArrivo)
                      }
                  }
                  .opacity(value.opacity)
                  .disabled(value.disable)
        }
       // }
    }
    private func undoDepennaAction(id:String,isInArrivo:Bool) {
        
        if isInArrivo {
            
          /*  self.viewModel.inventarioScorte.cronologiaAcquisti[id]?.removeAll(where: {$0 == self.currentDate}) */
            self.viewModel.currentProperty.inventario.cronologiaAcquisti[id]?.removeAll(where: {$0.hasPrefix(self.currentDate)})
        
            if let key = self.viewModel.currentProperty.inventario.archivioIngInEsaurimento[self.currentDate] {
                
                if key.contains(id) {  self.viewModel.currentProperty.inventario.ingInEsaurimento.append(id) }
                else { self.viewModel.currentProperty.inventario.ingEsauriti.append(id) }
 
            } else {
                self.viewModel.currentProperty.inventario.ingEsauriti.append(id)
            }
        }
    }
    
    private func depennaAction(id:String,isInArrivo:Bool) {
        
        if !isInArrivo {
            self.viewModel.currentProperty.inventario.cambioStatoScorte(idIngrediente: id, nuovoStato: .inArrivo)
        } else {
            
            self.viewModel.alertItem = AlertModel(title: "Info", message: "Long Press to depenn")
        }
    }
}*/ // BackUp_29_11_23
