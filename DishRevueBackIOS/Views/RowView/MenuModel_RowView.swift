//
//  MenuModel_RowView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/04/22.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage

class TimerVM:ObservableObject {
    
    static var menuItemCount:[MenuModel] = [] // da eliminare. Dato di controllo. 02.07 Mette dentro ogni modello due volte (BUG)
    
    var menuItem:MenuModel
    
   // @Published var isOnAir:Bool
    @Published var countDown:Int?
    var nextCheck:TimeInterval?
    var codiceOnOff:MenuModel.CodiceOnOffLive
   // var invalidate:Bool
    
    var timer:Timer?
    @Published var count:Int = 0 // 02.07.23 Serve per controllo del timer. Da eliminare
    
    init(menuItem:MenuModel) {
        
        self.menuItem = menuItem
    
        (self.codiceOnOff,self.nextCheck,self.countDown) = menuItem.timeScheduleInfo()
        
        Self.menuItemCount.append(menuItem) // temporanea
      //  self.timerInit(menuItem: menuItem)
        self.updateTimer()
    
    }
    
   private func updateTimer() {
        
       guard let checkNext = self.nextCheck else {
           self.timer = nil
           return }
       
        self.timer = Timer.scheduledTimer(
            withTimeInterval: checkNext,
            repeats: true,
            block: { timer in
                self.updateValue(timeInterval: timer.timeInterval)
                self.count += 1 // temporaneo
                
            })
    }
    
    private func updateValue(timeInterval:TimeInterval) {
        // Nota 03.07.23
        (self.codiceOnOff,self.nextCheck,self.countDown) = self.menuItem.timeScheduleInfo()

         if self.nextCheck != timeInterval {
            self.timer!.invalidate()
            self.updateTimer()
        }
    }
    
    func updateItemWithSchedule(menuItem:MenuModel) {
        // aggiorniamo l'item e forziamo l'aggiornamento per non dover aspettare il next check, e rendere la modifica immediata per l'utente al di là del nextcheck
        self.menuItem = menuItem
        
        (self.codiceOnOff,self.nextCheck,self.countDown) = menuItem.timeScheduleInfo()
        
        self.updateTimer()
    }
} // Deprecata

struct MenuModel_RowView: View {
    
    // Mod 05.10
    @EnvironmentObject var viewModel:AccounterVM
    
    @StateObject private var timerViewModel:TimerVM
    let menuItem: MenuModel
    let rowSize: RowSize

    init(menuItem: MenuModel, rowSize: RowSize = .normale()) {
   
        self.menuItem = menuItem
        self.rowSize = rowSize
        
        _timerViewModel = StateObject(wrappedValue: TimerVM(menuItem: menuItem))
        
    }

    var body: some View {
        
        // CSZStackVB_Framed { // ha uno sfondo bianco con opacità 0.3 - Questo conferisce un colore azzurro chiaro alle schedine
        /* let _ = Timer.scheduledTimer(withTimeInterval: timerViewModel.nextCheck, repeats: true) { timer in
         
         (self.isOnAir,self.nextCheck,self.invalidate,self.countDown) = self.menuItem.timeScheduleInfo()
         
         self.count += 1
         // if !self.invalidate { timer.invalidate() }
         } */
        VStack { // temporaneo
            vbIteratoreSize()
            VStack(alignment:.leading){ // temporaneo
                Text("viewModelClock:\(self.viewModel.internalClock.currentTimeOnAccess)")
                Text("Timer:\(timerViewModel.count)")
                Text("MenuCount:\(TimerVM.menuItemCount.count)")
                Text("NextCheck:\(timerViewModel.nextCheck ?? 444.0) min:\(timerViewModel.nextCheck ?? 1.0 / 60.0)")
                Text("countDownValue:\(timerViewModel.countDown ?? 444)")
                Text("menuItemLocal:\(menuItem.modelStatusDescription())")
                Text("menuItemTimerVM:\(timerViewModel.menuItem.modelStatusDescription())")
                
                Spacer()
                Text("\(timerViewModel.timer?.fireDate ?? Date.now )").font(.caption)
               // Text("\(self.viewModel.dbCompiler)")
            }
        }
            .onChange(of: menuItem) { _, newValue in
                self.timerViewModel.updateItemWithSchedule(menuItem: newValue)
                
            }
            .onChange(of: timerViewModel.codiceOnOff) { _, newValue in
                // Nota 06.07.23 onChangeCodiceOnOff
                guard newValue == .scadutoForEver else { return }
                let currentStatus = self.menuItem.getStatusTransition(viewModel: self.viewModel) == .archiviato
                
               /* if !currentStatus {
                    self.viewModel.manageCambioStatusModel(model: self.menuItem, nuovoStatus: .archiviato)
                }*/ // 24.02.24 chiusa ma da verificare
            }
            
               /* .overlay(alignment: .topLeading) {
                    PuntoLampeggiante(disableCondition: !isOnAir,fontPunto: .system(size: 5))
                        .offset(x: 3, y: 3)
                    }*/
            
              /*  .onAppear{
    
                 (self.isOnAir,self.nextCheck,self.invalidate,self.countDown) = self.menuItem.timeScheduleInfo()
                 
                    Timer.scheduledTimer(withTimeInterval: self.nextCheck, repeats: true) { time in
  
                     (self.isOnAir,self.nextCheck,self.invalidate,self.countDown) = self.menuItem.timeScheduleInfo()
                        
                     if self.invalidate { time.invalidate() }
                 }
             } */
 
       // } // chiusa Zstack Madre
        
    }
        
    // ViewBuilder Size
    
    @ViewBuilder private func vbIteratoreSize() -> some View {
        switch self.rowSize {
            
        case .normale:
            vbNormalSizeMenu()
        case .sintetico:
            vbSinteticSizeMenu()
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder private func vbSinteticSizeMenu() -> some View {
        
        CSZStackVB_Framed(frameWidth:300) {
 
            VStack(alignment:.leading,spacing: 2) {
                
                iteratingIntestazioneMenu()
                subIntestazione()
  
            }
            .padding(.vertical,5)
            .padding(.horizontal,10)
            
            
        }
        
    }
    
    @ViewBuilder private func vbNormalSizeMenu() -> some View {
        
        CSZStackVB_Framed {
            
            VStack {

                VStack(alignment:.leading,spacing: 2)  {
       
                        iteratingIntestazioneMenu()
                        subIntestazione()
                        
                    }

                Spacer()
                
                iteratingCalendarMenuInformation()
                
                Spacer()
                
                HStack(spacing:2){
                    
                    ForEach(GiorniDelServizio.allCases) { day in
                        
                        iteratingGiorniDelServizio(day: day)
                            .opacity(timerViewModel.codiceOnOff == .liveNow ? 1.0 : 0.4)
                    }
                    
                    Spacer()
                }
           
                
            } // chiuda VStack madre
             .padding(.vertical,5)
             .padding(.horizontal,10)
        }
    }

    // Method
   
    @ViewBuilder private func iteratingCalendarMenuInformation() -> some View {
          
        let avaibility = self.menuItem.availability
        let(incipit,postFix,showPost) = avaibility.iteratingAvaibilityMenu()
        //
        let value:(opacity:CGFloat,image:String,imageColor:Color,caption:String,fontWeight:Font.Weight) = {
        
            let openClose:String = {
                
                if let countDown = self.timerViewModel.countDown {
                    
                    let count = "\(self.timerViewModel.codiceOnOff.openCloseDescription())\(countDown) min"
                    return count
                        }
                else {
                    return self.timerViewModel.codiceOnOff.simpleDescription()
                   }
                    }()
  
            if self.timerViewModel.codiceOnOff == .liveNow {
                
                return (1.0,"eye",.green,"on (\(openClose))",.semibold)
                
            } else {
                return (0.4,"eye.slash",.gray,"off (\(openClose))",.light)
                
            }
            
        }() // add 17.09
        
        let dataInizio = csTimeFormatter().data.string(from:self.menuItem.giornoInizio)
        let dataFine = csTimeFormatter().data.string(from:self.menuItem.giornoFine ?? Date.now) // 16.02.24 da sistemare
        let oraInizio = csTimeFormatter().ora.string(from:self.menuItem.oraInizio)
        let oraFine = csTimeFormatter().ora.string(from:self.menuItem.oraFine)

        VStack(alignment:.leading) {
            
            HStack {
                
                Group {
                    
                    Text(incipit)
                    Text(dataInizio)
                                            
                }
                .fontWeight(.semibold)
                .font(.headline)
                .foregroundStyle(Color.seaTurtle_3)
                
                Spacer()
                
                HStack(alignment:.bottom,spacing:2) {
                    Text("apre")
                        .italic()
                        .font(.caption2)
                        .foregroundStyle(Color.seaTurtle_3)
                    Text(oraInizio)
                        .fontWeight(.semibold)
                        .font(.headline)
                        .foregroundStyle(Color.white)
                }
            
            }

            HStack {
                
                Group {
                    Text(postFix)
                        .italic(!showPost)
                    if showPost {Text(dataFine) }
                    
                }
                .fontWeight(.semibold)
                .font(.subheadline)
                .foregroundStyle(Color.seaTurtle_3)
               
                Spacer()
                
                HStack(alignment: .bottom, spacing: 2) {
                    Text("chiude")
                        .italic()
                        .font(.caption2)
                        .foregroundStyle(Color.red.opacity(0.8))
                    Text(oraFine)
                        .fontWeight(.semibold)
                        .font(.subheadline)
                        .foregroundStyle(Color.white)
                }
            }
    
        }
        .opacity(value.opacity)  // Start Modifiche 17.09
        ._tightPadding()
        .background {
            RoundedRectangle(cornerRadius: 5.0)
               // .strokeBorder(Color.red)
                .fill(Color.black.opacity(0.1))
        }
        .overlay(alignment: .topLeading) {
            
                CSEtichetta(
                    text: value.caption,
                    fontWeight: value.fontWeight,
                    textColor: Color.black,
                    image: value.image,
                    imageColor: value.imageColor,
                    imageSize: .small,
                    backgroundColor: Color.seaTurtle_1,
                    backgroundOpacity: 0.4)
                    .offset(x: -5, y: -10)
                
            
        }
        
    }
    
    @ViewBuilder private func iteratingGiorniDelServizio(day:GiorniDelServizio) -> some View {
        
        if self.menuItem.giorniDelServizio.contains(day) {
            
            let image = "\(day.imageAssociated()).fill"
            
            Image(systemName: image)
                .imageScale(.large)
                .foregroundStyle(Color.seaTurtle_2)
                .zIndex(0)
            
        } else {
            
            ZStack {
                
                Image(systemName: day.imageAssociated())
                    .imageScale(.large)
                    .foregroundStyle(Color.seaTurtle_2)
                    .zIndex(0)
                    
                Image(systemName: "circle.slash")
                        .imageScale(.large)
                        .foregroundStyle(Color.seaTurtle_2)
                        .zIndex(1)
                    
            }
        }
    }
    
    @ViewBuilder private func iteratingIntestazioneMenu() -> some View {
        
      //  HStack {
        let value:Font = {
            if self.rowSize.returnType() == .normale() { return .title2}
            else { return .title3}
        }()

        HStack(alignment:.bottom) {
            
            Text(self.menuItem.intestazione.capitalized)
                .font(value)
                .fontWeight(.semibold)
                .lineLimit(1)
                .allowsTightening(true)
                .foregroundStyle(Color.white)
            
            Spacer()
            
            vbEstrapolaStatusImage(
                itemModel: self.menuItem,
                viewModel: self.viewModel)
           /* .overlay(alignment:.center) {
               ImageLampeggiante(
                image: "circle.dashed",
                sizeImage: .large,
                disableCondition: self.timerViewModel.codiceOnOff != .liveNow)
               
                    
            }*/
            
        }
      
       /* .overlay(alignment: .topLeading) {
      
            PuntoLampeggiante(disableCondition: !isOnAir)
               // .offset(x:0 ,y: -10)
        }*/

               
            
      /*  switch self.menuItem.tipologia {
            
        case .fisso(let pax, _):
            Spacer()
            Image(systemName: pax.imageAssociated())
                 .imageScale(.large)
                 .foregroundStyle(Color.seaTurtle_2)
                 .padding(.trailing,-10)
            
        default: EmptyView()
            
            } */
      //  }
    }

    @ViewBuilder private func vbDishCountInMenu() -> some View {
           
        let value:(imageSize:Image.Scale,textSize:Font.TextStyle) = {
           
            if self.rowSize.returnType() == .normale() { return (.large,.title3)}
            else { return (.medium,.headline)}
        }()
        
        let media = self.menuItem.mediaValorePiattiInMenu(readOnlyVM: self.viewModel)
        let mediaString = String(format:"%.1f",media)
        
        HStack {
            
            CSEtichetta( // 21.09
                text: mediaString,
                fontStyle: value.textSize,
                fontWeight: .semibold,
                textColor: Color.yellow.opacity(0.7),
                image: "medal.fill",
                imageColor: Color.yellow.opacity(0.8),
                imageSize: value.imageSize,
                backgroundColor: Color.green.opacity(0.4),
                backgroundOpacity: 1.0)
            
            
            CSEtichetta( // 21.09
                text: "\(self.menuItem.rifDishIn.count)",
                fontStyle: value.textSize,
                fontWeight: .semibold,
                textColor: Color.seaTurtle_4,
                image: "fork.knife.circle",
                imageColor: Color.seaTurtle_4,
                imageSize: value.imageSize,
                backgroundColor: Color.seaTurtle_2,
                backgroundOpacity: 1.0)
   
        }
   
    }
    
    @ViewBuilder private func subIntestazione() -> some View {
        
        HStack(alignment:.top) {
            
            iteratingTipologiaMenu()
            Spacer()
            vbDishCountInMenu()
            
        }
    }
    
    @ViewBuilder private func iteratingTipologiaMenu() -> some View {

        HStack {
                
                Text(self.menuItem.tipologia.simpleDescription().lowercased())
                    .italic()
                
                switch self.menuItem.tipologia {
     
                case .fisso(let pax, let price):
                    let currencyCode = Locale.current.currency?.identifier ?? "EUR"
                    let priceDouble = Double(price) ?? 0
                      //  Text("€ \(price)") // 21.09
                    Text("\(priceDouble,format: .currency(code: currencyCode))")
                            .bold()
                    HStack(alignment:.top,spacing:0) {
                            Text("x")
                            Image(systemName: pax.imageAssociated())
                                 .imageScale(.medium)
                                 .foregroundStyle(Color.seaTurtle_3)
                        }
                    
                case .allaCarta(_):
                    Image(systemName: self.menuItem.tipologia.imageAssociated())
                        .imageScale(.medium)
                    
              //  case .noValue: EmptyView()
             /*   default:
                    Image(systemName: self.menuItem.tipologia.imageAssociated())
                        .imageScale(.medium)*/
                    
                }
            }
            .font(.callout)
            .foregroundStyle(Color.seaTurtle_3)
    }
    
    
}

/*
struct MenuModel_RowView: View {
    
    // Mod 05.10
    @EnvironmentObject var viewModel:AccounterVM
    
    @StateObject private var timerViewModel:TimerVM
    let menuItem: MenuModel
    let rowSize: RowSize

    init(menuItem: MenuModel, rowSize: RowSize = .normale()) {
   
        self.menuItem = menuItem
        self.rowSize = rowSize
        
        _timerViewModel = StateObject(wrappedValue: TimerVM(menuItem: menuItem))
        
    }

    var body: some View {
        
        // CSZStackVB_Framed { // ha uno sfondo bianco con opacità 0.3 - Questo conferisce un colore azzurro chiaro alle schedine
        /* let _ = Timer.scheduledTimer(withTimeInterval: timerViewModel.nextCheck, repeats: true) { timer in
         
         (self.isOnAir,self.nextCheck,self.invalidate,self.countDown) = self.menuItem.timeScheduleInfo()
         
         self.count += 1
         // if !self.invalidate { timer.invalidate() }
         } */
        VStack { // temporaneo
            vbIteratoreSize()
            VStack(alignment:.leading){ // temporaneo
                Text("Timer:\(timerViewModel.count)")
                Text("MenuCount:\(TimerVM.menuItemCount.count)")
                Text("NextCheck:\(timerViewModel.nextCheck ?? 444.0) min:\(timerViewModel.nextCheck ?? 1.0 / 60.0)")
                Text("countDownValue:\(timerViewModel.countDown ?? 444)")
                Text("menuItemLocal:\(menuItem.modelStatusDescription())")
                Text("menuItemTimerVM:\(timerViewModel.menuItem.modelStatusDescription())")
                
                Spacer()
                Text("\(timerViewModel.timer?.fireDate ?? Date.now )").font(.caption)
               // Text("\(self.viewModel.dbCompiler)")
            }
        }
            .onChange(of: menuItem) { _, newValue in
                self.timerViewModel.updateItemWithSchedule(menuItem: newValue)
                
            }
            .onChange(of: timerViewModel.codiceOnOff) { _, newValue in
                // Nota 06.07.23 onChangeCodiceOnOff
                guard newValue == .scadutoForEver else { return }
                let currentStatus = self.menuItem.getStatusTransition(viewModel: self.viewModel) == .archiviato
    
                if !currentStatus {
                    self.viewModel.manageCambioStatusModel(model: self.menuItem, nuovoStatus: .archiviato)
                }
            }
            
               /* .overlay(alignment: .topLeading) {
                    PuntoLampeggiante(disableCondition: !isOnAir,fontPunto: .system(size: 5))
                        .offset(x: 3, y: 3)
                    }*/
            
              /*  .onAppear{
    
                 (self.isOnAir,self.nextCheck,self.invalidate,self.countDown) = self.menuItem.timeScheduleInfo()
                 
                    Timer.scheduledTimer(withTimeInterval: self.nextCheck, repeats: true) { time in
  
                     (self.isOnAir,self.nextCheck,self.invalidate,self.countDown) = self.menuItem.timeScheduleInfo()
                        
                     if self.invalidate { time.invalidate() }
                 }
             } */
 
       // } // chiusa Zstack Madre
        
    }
        
    // ViewBuilder Size
    
    @ViewBuilder private func vbIteratoreSize() -> some View {
        switch self.rowSize {
            
        case .normale:
            vbNormalSizeMenu()
        case .sintetico:
            vbSinteticSizeMenu()
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder private func vbSinteticSizeMenu() -> some View {
        
        CSZStackVB_Framed(frameWidth:300) {
 
            VStack(alignment:.leading,spacing: 2) {
                
                iteratingIntestazioneMenu()
                subIntestazione()
  
            }
            .padding(.vertical,5)
            .padding(.horizontal,10)
            
            
        }
        
    }
    
    @ViewBuilder private func vbNormalSizeMenu() -> some View {
        
        CSZStackVB_Framed {
            
            VStack {

                VStack(alignment:.leading,spacing: 2)  {
       
                        iteratingIntestazioneMenu()
                        subIntestazione()
                        
                    }

                Spacer()
                
                iteratingCalendarMenuInformation()
                
                Spacer()
                
                HStack(spacing:2){
                    
                    ForEach(GiorniDelServizio.allCases) { day in
                        
                        iteratingGiorniDelServizio(day: day)
                            .opacity(timerViewModel.codiceOnOff == .liveNow ? 1.0 : 0.4)
                    }
                    
                    Spacer()
                }
           
                
            } // chiuda VStack madre
             .padding(.vertical,5)
             .padding(.horizontal,10)
        }
    }

    // Method
   
    @ViewBuilder private func iteratingCalendarMenuInformation() -> some View {
          
        let avaibility = self.menuItem.availability
        let(incipit,postFix,showPost) = avaibility.iteratingAvaibilityMenu()
        //
        let value:(opacity:CGFloat,image:String,imageColor:Color,caption:String,fontWeight:Font.Weight) = {
        
            let openClose:String = {
                
                if let countDown = self.timerViewModel.countDown {
                    
                    let count = "\(self.timerViewModel.codiceOnOff.openCloseDescription())\(countDown) min"
                    return count
                        }
                else {
                    return self.timerViewModel.codiceOnOff.simpleDescription()
                   }
                    }()
  
            if self.timerViewModel.codiceOnOff == .liveNow {
                
                return (1.0,"eye",.green,"on (\(openClose))",.semibold)
                
            } else {
                return (0.4,"eye.slash",.gray,"off (\(openClose))",.light)
                
            }
            
        }() // add 17.09
        
        let dataInizio = csTimeFormatter().data.string(from:self.menuItem.giornoInizio)
        let dataFine = csTimeFormatter().data.string(from:self.menuItem.giornoFine ?? Date.now) // 16.02.24 da sistemare
        let oraInizio = csTimeFormatter().ora.string(from:self.menuItem.oraInizio)
        let oraFine = csTimeFormatter().ora.string(from:self.menuItem.oraFine)

        VStack(alignment:.leading) {
            
            HStack {
                
                Group {
                    
                    Text(incipit)
                    Text(dataInizio)
                                            
                }
                .fontWeight(.semibold)
                .font(.headline)
                .foregroundStyle(Color.seaTurtle_3)
                
                Spacer()
                
                HStack(alignment:.bottom,spacing:2) {
                    Text("apre")
                        .italic()
                        .font(.caption2)
                        .foregroundStyle(Color.seaTurtle_3)
                    Text(oraInizio)
                        .fontWeight(.semibold)
                        .font(.headline)
                        .foregroundStyle(Color.white)
                }
            
            }

            HStack {
                
                Group {
                    Text(postFix)
                        .italic(!showPost)
                    if showPost {Text(dataFine) }
                    
                }
                .fontWeight(.semibold)
                .font(.subheadline)
                .foregroundStyle(Color.seaTurtle_3)
               
                Spacer()
                
                HStack(alignment: .bottom, spacing: 2) {
                    Text("chiude")
                        .italic()
                        .font(.caption2)
                        .foregroundStyle(Color.red.opacity(0.8))
                    Text(oraFine)
                        .fontWeight(.semibold)
                        .font(.subheadline)
                        .foregroundStyle(Color.white)
                }
            }
    
        }
        .opacity(value.opacity)  // Start Modifiche 17.09
        ._tightPadding()
        .background {
            RoundedRectangle(cornerRadius: 5.0)
               // .strokeBorder(Color.red)
                .fill(Color.black.opacity(0.1))
        }
        .overlay(alignment: .topLeading) {
            
                CSEtichetta(
                    text: value.caption,
                    fontWeight: value.fontWeight,
                    textColor: Color.black,
                    image: value.image,
                    imageColor: value.imageColor,
                    imageSize: .small,
                    backgroundColor: Color.seaTurtle_1,
                    backgroundOpacity: 0.4)
                    .offset(x: -5, y: -10)
                
            
        }
        
    }
    
    @ViewBuilder private func iteratingGiorniDelServizio(day:GiorniDelServizio) -> some View {
        
        if self.menuItem.giorniDelServizio.contains(day) {
            
            let image = "\(day.imageAssociated()).fill"
            
            Image(systemName: image)
                .imageScale(.large)
                .foregroundStyle(Color.seaTurtle_2)
                .zIndex(0)
            
        } else {
            
            ZStack {
                
                Image(systemName: day.imageAssociated())
                    .imageScale(.large)
                    .foregroundStyle(Color.seaTurtle_2)
                    .zIndex(0)
                    
                Image(systemName: "circle.slash")
                        .imageScale(.large)
                        .foregroundStyle(Color.seaTurtle_2)
                        .zIndex(1)
                    
            }
        }
    }
    
    @ViewBuilder private func iteratingIntestazioneMenu() -> some View {
        
      //  HStack {
        let value:Font = {
            if self.rowSize.returnType() == .normale() { return .title2}
            else { return .title3}
        }()

        HStack(alignment:.bottom) {
            
            Text(self.menuItem.intestazione)
                .font(value)
                .fontWeight(.semibold)
                .lineLimit(1)
                .allowsTightening(true)
                .foregroundStyle(Color.white)
            
            Spacer()
            
            vbEstrapolaStatusImage(
                itemModel: self.menuItem,
                viewModel: self.viewModel)
            .overlay(alignment:.center) {
               ImageLampeggiante(
                image: "circle.dashed",
                sizeImage: .large,
                disableCondition: self.timerViewModel.codiceOnOff != .liveNow)
               
                    
            }
            
        }
      
       /* .overlay(alignment: .topLeading) {
      
            PuntoLampeggiante(disableCondition: !isOnAir)
               // .offset(x:0 ,y: -10)
        }*/

               
            
      /*  switch self.menuItem.tipologia {
            
        case .fisso(let pax, _):
            Spacer()
            Image(systemName: pax.imageAssociated())
                 .imageScale(.large)
                 .foregroundStyle(Color.seaTurtle_2)
                 .padding(.trailing,-10)
            
        default: EmptyView()
            
            } */
      //  }
    }

    @ViewBuilder private func vbDishCountInMenu() -> some View {
           
        let value:(imageSize:Image.Scale,textSize:Font.TextStyle) = {
           
            if self.rowSize.returnType() == .normale() { return (.large,.title3)}
            else { return (.medium,.headline)}
        }()
        
        let media = self.menuItem.mediaValorePiattiInMenu(readOnlyVM: self.viewModel)
        let mediaString = String(format:"%.1f",media)
        
        HStack {
            
            CSEtichetta( // 21.09
                text: mediaString,
                fontStyle: value.textSize,
                fontWeight: .semibold,
                textColor: Color.yellow.opacity(0.7),
                image: "medal.fill",
                imageColor: Color.yellow.opacity(0.8),
                imageSize: value.imageSize,
                backgroundColor: Color.green.opacity(0.4),
                backgroundOpacity: 1.0)
            
            
            CSEtichetta( // 21.09
                text: "\(self.menuItem.rifDishIn.count)",
                fontStyle: value.textSize,
                fontWeight: .semibold,
                textColor: Color.seaTurtle_4,
                image: "fork.knife.circle",
                imageColor: Color.seaTurtle_4,
                imageSize: value.imageSize,
                backgroundColor: Color.seaTurtle_2,
                backgroundOpacity: 1.0)
   
        }
   
    }
    
    @ViewBuilder private func subIntestazione() -> some View {
        
        HStack(alignment:.top) {
            
            iteratingTipologiaMenu()
            Spacer()
            vbDishCountInMenu()
            
        }
    }
    
    @ViewBuilder private func iteratingTipologiaMenu() -> some View {

        HStack {
                
                Text(self.menuItem.tipologia.simpleDescription().lowercased())
                    .italic()
                
                switch self.menuItem.tipologia {
     
                case .fisso(let pax, let price):
                    let currencyCode = Locale.current.currency?.identifier ?? "EUR"
                    let priceDouble = Double(price) ?? 0
                      //  Text("€ \(price)") // 21.09
                    Text("\(priceDouble,format: .currency(code: currencyCode))")
                            .bold()
                    HStack(alignment:.top,spacing:0) {
                            Text("x")
                            Image(systemName: pax.imageAssociated())
                                 .imageScale(.medium)
                                 .foregroundStyle(Color.seaTurtle_3)
                        }
                    
                case .allaCarta(_):
                    Image(systemName: self.menuItem.tipologia.imageAssociated())
                        .imageScale(.medium)
                    
              //  case .noValue: EmptyView()
             /*   default:
                    Image(systemName: self.menuItem.tipologia.imageAssociated())
                        .imageScale(.medium)*/
                    
                }
            }
            .font(.callout)
            .foregroundStyle(Color.seaTurtle_3)
    }
    
    
}*/ // Backup 22.02.23
/*
struct MenuModel_RowView_Previews: PreviewProvider {
    
     static var menuItem: MenuModel = {
         var menu = MenuModel()
        menu.intestazione = "SomeDay"
        menu.tipologia = .allaCarta()
        menu.isAvaibleWhen = .dataEsatta
        menu.dataInizio = Date(timeIntervalSinceNow: 0)
        menu.oraInizio = Date(timeIntervalSinceNow: -7200)
        menu.oraFine =  Date(timeIntervalSinceNow: 1800)
      //   menu.giorniDelServizio = [ .lunedi,.martedi,.mercoledi]
        menu.status = .completo(.disponibile)
       
        return menu
        
    }()
        
    static var menuItem2: MenuModel = {
        var menu = MenuModel()
        menu.intestazione = "EveryDay"
        menu.tipologia = .fisso(persone: .uno, costo: "12.5")
        menu.isAvaibleWhen = .intervalloAperto
        menu.dataInizio = Date(timeIntervalSinceNow: 0)
        menu.oraInizio = Date(timeIntervalSinceNow: 60)
        menu.oraFine = Date(timeIntervalSinceNow: 6000)
        menu.giorniDelServizio = [ .lunedi,.martedi,.mercoledi,.giovedi,.venerdi,.sabato,.domenica]
        menu.status = .completo(.disponibile)
       
       return menu
       
   }()
    
    static var menuItem3: MenuModel = {
        var menu = MenuModel()
        menu.intestazione = "SunDay"
        menu.tipologia = .fisso(persone: .due, costo: "23.5")
        menu.isAvaibleWhen = .intervalloChiuso
        menu.giorniDelServizio = [ .domenica]
        menu.dataInizio = Date(timeIntervalSinceNow: -172800)
        menu.dataFine = Date(timeIntervalSinceNow: 31536000)
        menu.oraInizio = Date(timeIntervalSinceNow: 0)
        menu.oraFine = Date(timeIntervalSinceNow: 600)
        menu.status = .bozza(.disponibile)
       
       return menu
       
   }()
    
    static var menuItem4: MenuModel = {
        var menu = MenuModel()
        menu.intestazione = "AlmostEveryDay"
        menu.tipologia = .fisso(persone: .uno, costo: "12.5")
        menu.giorniDelServizio = [ .lunedi,.martedi,.mercoledi,.giovedi,.venerdi,.sabato]
        menu.status = .completo(.inPausa)
       return menu
       
   }()
    
    //static var menudelgiorno = MenuModel(tipologia: .allaCarta( .delGiorno))
    static var menudelgiorno = MenuModel(tipologiaDiSistema: .delGiorno)
    
    static var previews: some View {
        

        NavigationStack {
                    
            ZStack {
                
                Color.seaTurtle_1.ignoresSafeArea()

                VStack(spacing:40) {
                    
                    MenuModel_RowView(menuItem: menuItem)
                        .frame(height:150)
                    MenuModel_RowView(menuItem: menuItem2)
                        .frame(height:150)
                    MenuModel_RowView(menuItem: menudelgiorno)
                        .frame(height:150)
                    
                  //  MenuModel_RowView(menuItem: menuItem3)
                 //   MenuModel_RowView(menuItem: menuItem4)
                }
            }
        
        }.environmentObject(testAccount)
    
        
    }
}
*/
