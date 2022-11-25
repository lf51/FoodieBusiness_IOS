//
//  MenuModel_RowView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/04/22.
//

import SwiftUI

struct MenuModel_RowView: View {
    
    // Mod 05.10
    @EnvironmentObject var viewModel:AccounterVM
    
    // Le State sono modificate dalla scheduleTimer
    @State private var isOnAir: Bool = false
    @State private var countDown:Int = 0
    @State private var nextCheck:TimeInterval = 1.0
    @State private var invalidate:Bool = false
    // Mod 05.10
    
    let menuItem: MenuModel
    let rowSize: RowSize
    
    init(menuItem: MenuModel, rowSize: RowSize = .normale) {
   
        self.menuItem = menuItem
        self.rowSize = rowSize
    }
        
    var body: some View {
        
       // CSZStackVB_Framed { // ha uno sfondo bianco con opacità 0.3 - Questo conferisce un colore azzurro chiaro alle schedine

            vbIteratoreSize()
                .overlay(alignment: .topLeading) {
                    PuntoLampeggiante(disableCondition: !isOnAir,fontPunto: .system(size: 5))
                        .offset(x: 3, y: 3)
                    }
                .onAppear{
    
                 (self.isOnAir,self.nextCheck,self.invalidate,self.countDown) = self.menuItem.timeScheduleInfo()
                 
                 Timer.scheduledTimer(withTimeInterval: nextCheck, repeats: true) { time in
  
                     (self.isOnAir,self.nextCheck,self.invalidate,self.countDown) = self.menuItem.timeScheduleInfo()
                     if self.invalidate { time.invalidate()}
                 }
             }
 
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
                
                iteratingCalendarMenuInformation(isOnAir: isOnAir)
                
                Spacer()
                
                HStack(spacing:2){
                    
                    ForEach(GiorniDelServizio.allCases) { day in
                        
                        iteratingGiorniDelServizio(day: day)
                            .opacity(isOnAir ? 1.0 : 0.4)
                    }
                    
                    Spacer()
                }
           
                
            } // chiuda VStack madre
             .padding(.vertical,5)
             .padding(.horizontal,10)
        }
    }

    // Method
   
    @ViewBuilder private func iteratingCalendarMenuInformation(isOnAir:Bool) -> some View {
          
        let avaibility = self.menuItem.isAvaibleWhen
        let(incipit,postFix,showPost) = avaibility.iteratingAvaibilityMenu()
        //
        let value:(opacity:CGFloat,image:String,imageColor:Color,caption:String,fontWeight:Font.Weight) = {
        
            let isCountDownStarted = self.countDown < self.viewModel.setupAccount.startCountDownMenuAt.rawValue
            let countString = isCountDownStarted ? " (Chiude in \(countDown)min)" : ""
          
            if isOnAir { return (1.0,"eye",.green,"on\(countString)",.semibold)}
            else { return (0.4,"eye.slash",.gray,"off",.light)}
            
        }() // add 17.09
        
        let dataInizio = csTimeFormatter().data.string(from:self.menuItem.dataInizio)
        let dataFine = csTimeFormatter().data.string(from:self.menuItem.dataFine)
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
                .foregroundColor(Color("SeaTurtlePalette_3"))
                
                Spacer()
                
                HStack(alignment:.bottom,spacing:2) {
                    Text("dalle")
                        .italic()
                        .font(.caption2)
                        .foregroundColor(Color("SeaTurtlePalette_3"))
                    Text(oraInizio)
                        .fontWeight(.semibold)
                        .font(.headline)
                        .foregroundColor(Color.white)
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
                .foregroundColor(Color("SeaTurtlePalette_3"))
               
                Spacer()
                
                HStack(alignment: .bottom, spacing: 2) {
                    Text("alle")
                        .italic()
                        .font(.caption2)
                        .foregroundColor(Color.red.opacity(0.8))
                    Text(oraFine)
                        .fontWeight(.semibold)
                        .font(.subheadline)
                        .foregroundColor(Color.white)
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
            
          /*  HStack(alignment: .center,spacing:2) {
                Image(systemName: value.image)
                    .imageScale(.small)
                    .foregroundColor(value.imageColor)
                Text(value.caption)
                    .bold(value.isBold)
                    .font(.caption)
                    
            }
            .padding(2)
            .background(content: {
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(Color("SeaTurtlePalette_1").opacity(0.4))
            }) */
            CSEtichetta(
                text: value.caption,
                fontWeight: value.fontWeight,
                textColor: Color.black,
                image: value.image,
                imageColor: value.imageColor,
                imageSize: .small,
                backgroundColor: Color("SeaTurtlePalette_1"),
                backgroundOpacity: 0.4)
                .offset(x: -5, y: -10)
        } // end Modifche 17.09
        
    }
    
    @ViewBuilder private func iteratingGiorniDelServizio(day:GiorniDelServizio) -> some View {
        
        if self.menuItem.giorniDelServizio.contains(day) {
            
            let image = "\(day.imageAssociated()).fill"
            
            Image(systemName: image)
                .imageScale(.large)
                .foregroundColor(Color("SeaTurtlePalette_2"))
                .zIndex(0)
            
        } else {
            
            ZStack {
                
                Image(systemName: day.imageAssociated())
                    .imageScale(.large)
                    .foregroundColor(Color("SeaTurtlePalette_2"))
                    .zIndex(0)
                    
                Image(systemName: "circle.slash")
                        .imageScale(.large)
                        .foregroundColor(Color("SeaTurtlePalette_2"))
                        .zIndex(1)
                    
            }
        }
    }
    
    @ViewBuilder private func iteratingIntestazioneMenu() -> some View {
        
      //  HStack {
        let value:Font = {
            if self.rowSize == .normale { return .title2}
            else { return .title3}
        }()
            
        HStack(alignment:.bottom) {
            
            Text(self.menuItem.intestazione)
                .font(value)
                .fontWeight(.semibold)
                .lineLimit(1)
                .allowsTightening(true)
                .foregroundColor(Color.white)
            
            Spacer()
            
            vbEstrapolaStatusImage(itemModel: self.menuItem)
            
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
                 .foregroundColor(Color("SeaTurtlePalette_2"))
                 .padding(.trailing,-10)
            
        default: EmptyView()
            
            } */
      //  }
    }

    @ViewBuilder private func vbDishCountInMenu() -> some View {
           
        let value:(imageSize:Image.Scale,textSize:Font.TextStyle) = {
           
            if self.rowSize == .normale { return (.large,.title3)}
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
                textColor: Color("SeaTurtlePalette_4"),
                image: "fork.knife.circle",
                imageColor: Color("SeaTurtlePalette_4"),
                imageSize: value.imageSize,
                backgroundColor: Color("SeaTurtlePalette_2"),
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
                                 .foregroundColor(Color("SeaTurtlePalette_3"))
                        }
                    
                case .allaCarta(_):
                    Image(systemName: self.menuItem.tipologia.imageAssociated())
                        .imageScale(.medium)
                    
                case .noValue: EmptyView()
             /*   default:
                    Image(systemName: self.menuItem.tipologia.imageAssociated())
                        .imageScale(.medium)*/
                    
                }
            }
            .font(.callout)
            .foregroundColor(Color("SeaTurtlePalette_3"))
    }
    
    
}

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
                
                Color("SeaTurtlePalette_1").ignoresSafeArea()
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
        
        }
    
        
    }
}


/* // BackUp 27.10 - Creazione size sintentica e utilizzo di un iteratore fra size
 struct MenuModel_RowView: View {
     
     // Mod 05.10
     @EnvironmentObject var viewModel:AccounterVM
     
     // Le State sono modificate dalla scheduleTimer
     @State private var isOnAir: Bool = false
     @State private var countDown:Int = 0
     @State private var nextCheck:TimeInterval = 1.0
     @State private var invalidate:Bool = false
     // Mod 05.10
     
     let menuItem: MenuModel
         
     var body: some View {
         
         CSZStackVB_Framed { // ha uno sfondo bianco con opacità 0.3 - Questo conferisce un colore azzurro chiaro alle schedine
             
             VStack {
                 
              //   let isOnAir = self.menuItem.isOnAir()
                 
                 HStack(alignment:.top) {
                     
                     VStack(alignment:.leading) {
        
                         iteratingIntestazioneMenu()
                         iteratingTipologiaMenu()
                         
                     }
                     
                     Spacer()
                     // Status
                     VStack(alignment:.trailing,spacing:3) {
                         
                         vbEstrapolaStatusImage(itemModel: menuItem)
                         vbDishCountInMenu()
                         
                     }
    
                 }
                 //  .padding(.horizontal)
                 .padding(.top,5)
                 
                 Spacer()
                 
                 iteratingCalendarMenuInformation(isOnAir: isOnAir)
                 
                 Spacer()
                 
                 HStack(spacing:2){
                     
                     ForEach(GiorniDelServizio.allCases) { day in
                         
                         iteratingGiorniDelServizio(day: day)
                             .opacity(isOnAir ? 1.0 : 0.4)
                     }
                     
                     Spacer()
                     
                     /*   Text("\(menuItem.dishIn.count)")
                      .fontWeight(.light)
                      .foregroundColor(Color.white)
                      Image(systemName: "fork.knife.circle.fill")
                      .imageScale(.large)
                      .foregroundColor(Color.white) */
                     
                     //  Spacer()
                     
                 }
                 //  .padding(.horizontal)
                 .padding(.bottom,5)
                 
             } // chiuda VStack madre
              .padding(.horizontal)
              .onAppear{
     
                  (self.isOnAir,self.nextCheck,self.invalidate,self.countDown) = self.menuItem.timeScheduleInfo()
                  
                  Timer.scheduledTimer(withTimeInterval: nextCheck, repeats: true) { time in
   
                      (self.isOnAir,self.nextCheck,self.invalidate,self.countDown) = self.menuItem.timeScheduleInfo()
                      if self.invalidate { time.invalidate()}
                  }
              }
             /* .onReceive(self.menuItem.orologioInterno.timer) { time in
                 
                  isOnAir = self.menuItem.isOnAir()
                  count = time.description
                  
              } */
         } // chiusa Zstack Madre
         
     }
     
     // Method
    
     @ViewBuilder private func iteratingCalendarMenuInformation(isOnAir:Bool) -> some View {
           
         let avaibility = self.menuItem.isAvaibleWhen
         let(incipit,postFix,showPost) = avaibility.iteratingAvaibilityMenu()
         //
         let value:(opacity:CGFloat,image:String,imageColor:Color,caption:String,fontWeight:Font.Weight) = {
         
             let countString = self.countDown < 60 ? " (Chiude in \(countDown)m)" : ""
            // let isOnAir = self.menuItem.isOnAir()
             if isOnAir { return (1.0,"eye",.green,"online\(countString)",.semibold)}
             else { return (0.4,"eye.slash",.gray,"offline",.light)}
             
         }() // add 17.09
         
         let dataInizio = csTimeFormatter().data.string(from:self.menuItem.dataInizio)
         let dataFine = csTimeFormatter().data.string(from:self.menuItem.dataFine)
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
                 .foregroundColor(Color("SeaTurtlePalette_3"))
                 
                 Spacer()
                 
                 HStack(alignment:.bottom,spacing:2) {
                     Text("dalle")
                         .italic()
                         .font(.caption2)
                         .foregroundColor(Color("SeaTurtlePalette_3"))
                     Text(oraInizio)
                         .fontWeight(.semibold)
                         .font(.headline)
                         .foregroundColor(Color.white)
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
                 .foregroundColor(Color("SeaTurtlePalette_3"))
                
                 
                 Spacer()
                 
                 HStack(alignment: .bottom, spacing: 2) {
                     Text("alle")
                         .italic()
                         .font(.caption2)
                         .foregroundColor(Color.red.opacity(0.8))
                     Text(oraFine)
                         .fontWeight(.semibold)
                         .font(.subheadline)
                         .foregroundColor(Color.white)
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
             
           /*  HStack(alignment: .center,spacing:2) {
                 Image(systemName: value.image)
                     .imageScale(.small)
                     .foregroundColor(value.imageColor)
                 Text(value.caption)
                     .bold(value.isBold)
                     .font(.caption)
                     
             }
             .padding(2)
             .background(content: {
                 RoundedRectangle(cornerRadius: 5.0)
                     .fill(Color("SeaTurtlePalette_1").opacity(0.4))
             }) */
             CSEtichetta(
                 text: value.caption,
                 fontWeight: value.fontWeight,
                 textColor: Color.black,
                 image: value.image,
                 imageColor: value.imageColor,
                 imageSize: .small,
                 backgroundColor: Color("SeaTurtlePalette_1"),
                 backgroundOpacity: 0.4)
                 .offset(x: -5, y: -10)
         } // end Modifche 17.09
         
     }
     
     @ViewBuilder private func iteratingGiorniDelServizio(day:GiorniDelServizio) -> some View {
         
         if self.menuItem.giorniDelServizio.contains(day) {
             
             let image = "\(day.imageAssociated()).fill"
             
             Image(systemName: image)
                 .imageScale(.large)
                 .foregroundColor(Color("SeaTurtlePalette_2"))
                 .zIndex(0)
             
         } else {
             
             ZStack {
                 
                 Image(systemName: day.imageAssociated())
                     .imageScale(.large)
                     .foregroundColor(Color("SeaTurtlePalette_2"))
                     .zIndex(0)
                     
                 Image(systemName: "circle.slash")
                         .imageScale(.large)
                         .foregroundColor(Color("SeaTurtlePalette_2"))
                         .zIndex(1)
                     
             }
         }
     }
     
     @ViewBuilder private func iteratingIntestazioneMenu() -> some View {
         
       //  HStack {
             
             Text(self.menuItem.intestazione)
                 .font(.title2)
                 .fontWeight(.semibold)
                 .lineLimit(1)
                 .allowsTightening(true)
                 .foregroundColor(Color.white)
              //   .fixedSize()
                
             
       /*  switch self.menuItem.tipologia {
             
         case .fisso(let pax, _):
             Spacer()
             Image(systemName: pax.imageAssociated())
                  .imageScale(.large)
                  .foregroundColor(Color("SeaTurtlePalette_2"))
                  .padding(.trailing,-10)
             
         default: EmptyView()
             
             } */
       //  }
     }

     @ViewBuilder private func vbDishCountInMenu() -> some View {
                 
         HStack {
             
             CSEtichetta( // 21.09
                 text: "8.8",
                 fontStyle: .title3,
                 fontWeight: .semibold,
                 textColor: Color.yellow.opacity(0.7),
                 image: "medal.fill",
                 imageColor: Color.yellow.opacity(0.8),
                 imageSize: .large,
                 backgroundColor: Color.green.opacity(0.4),
                 backgroundOpacity: 1.0)
             
             
             CSEtichetta( // 21.09
                 text: "\(self.menuItem.rifDishIn.count)",
                 fontStyle: .title3,
                 fontWeight: .semibold,
                 textColor: Color("SeaTurtlePalette_4"),
                 image: "fork.knife.circle",
                 imageColor: Color("SeaTurtlePalette_4"),
                 imageSize: .large,
                 backgroundColor: Color("SeaTurtlePalette_2"),
                 backgroundOpacity: 1.0)
    
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
                                  .foregroundColor(Color("SeaTurtlePalette_3"))
                         }
                     
                 case .noValue: EmptyView()
                 default:
                     Image(systemName: self.menuItem.tipologia.imageAssociated())
                         .imageScale(.medium)
                     
                 }
             }
             .font(.callout)
             .foregroundColor(Color("SeaTurtlePalette_3"))
     }
     
     
 }
 
 */



/* HStack(alignment: .center,spacing:2) {
      
      let value:(image:String,imageColor:Color,caption:String,fontWeight:Font.Weight) = {
      
          let countString = self.countDown < 60 ? " (Chiude in \(countDown)m)" : ""
          if isOnAir { return ("eye",.green,"online\(countString)",.semibold)}
          else { return ("eye.slash",.gray,"offline",.light)}
          
      }()
      
      csVbSwitchImageText(string: value.image, size: .small)
          .foregroundColor(value.imageColor)
      Text(value.caption)
          .font(.system(.caption, design: .monospaced, weight: value.fontWeight))
          .foregroundColor(Color.black)
    
  }
  
  .padding(.trailing,4)
 // .padding(1)
  .background(content: {
      RoundedRectangle(cornerRadius: 5.0)
          .fill(Color("SeaTurtlePalette_1").opacity(0.4))
  }) */
  
/*  CSEtichetta(
      text: value.caption,
      fontWeight: value.fontWeight,
      textColor: Color.black,
      image: value.image,
      imageColor: value.imageColor,
      imageSize: .small,
      backgroundColor: Color("SeaTurtlePalette_1"),
      backgroundOpacity: 0.4) */
