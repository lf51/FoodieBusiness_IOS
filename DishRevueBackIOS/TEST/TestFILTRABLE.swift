//
//  ScanAndShowView.swift
//  FoodieClientIOS
//
//  Created by Calogero Friscia on 20/12/22.
//

import SwiftUI
import MyPackView_L0
import MyFilterPackage

public struct TEST_FiltrableContainerView<
    TrailingView:View,
    FilterRows:View,
    SorterRows:View,
    ElementView:View,
    M:Object_FPC,
    P:Property_FPC_Mappable,
    ChangeValue:Equatable>: View {
    
    let backgroundColorView: Color
    let title: String
    @Binding var coreFilter: CoreFilter<M>
    let placeHolderBarraRicerca: String
    let altezzaPopOverFiltri: CGFloat
    let altezzaPopOverSorter: CGFloat
    let paddingHorizontal: CGFloat?
    let buttonColor: Color
    let elementContainer: [M]
    let mapTree: MapTree<M,P>?
    let mapButtonAction: (() -> Void)?
    let onRefresh: (() -> Void)?
    
    let onChangeValue:ChangeValue
    let onChangeProxyControl: (_ :ScrollViewProxy) -> Void
    
    let generalDisable: Bool
    
    @ViewBuilder var trailingView:TrailingView
    @ViewBuilder var popOverFilter:FilterRows
    @ViewBuilder var popOverSorter:SorterRows
    @ViewBuilder var elementView:(_ :M) -> ElementView
    
    @State private var openFilter:Bool = false
    @State private var openSort:Bool = false
    
    /// ScrollReader inserito in un Vstack a sua volta dentro una CSZstackVB.
    ///
    /// Inseribile in un NavigationStack
    /// - Parameters:
    ///   - backgroundColorView: colore di sfondo della ZStack.
    ///   - title: navigationTitle qualora la view fosse inserita in una navigationStack
    ///   - filterProperties: istanza di un subObject FilterProperty
    ///   - placeHolderBarraRicerca: placeholder della barra di ricerca
    ///   - altezzaPopOverFiltri: altezza della view in popOver. Di default 600
    ///   - altezzaPopOverSorter: default 400
    ///   - buttonColor : Colore dei pulsanti. Uguale per tutti e tre
    ///   - elementContainer:
    ///   - mapTree:
    ///   - thirdButtonAction: azione per il terzo bottone. Azione di Mapping
    ///   - content: Contenuto del corpo, inserito in una scrollreader in posizione proxy 1. Sullo zero abbiamo la stringa di ricerca.OnAppear lo scroll parte da posizione 1 rendendo la barra nascosta
    ///   - trailingView: viewbuilder da mettere nella toolbar lato trailing
    ///   - filterView: viewBuilder per un popOver dove mostrare le FilterRow
    ///   - sorterView: viewBuilder per un popOver dove mostrare le SortRow
    public init(
        backgroundColorView: Color,
        title: String,
        filterCore: Binding<CoreFilter<M>>,
        placeHolderBarraRicerca: String,
        altezzaPopOverFiltri:CGFloat = 600,
        altezzaPopOverSorter:CGFloat = 400,
        paddingHorizontal:CGFloat? = nil,
        buttonColor:Color,
        elementContainer:[M],
        mapTree:MapTree<M,P>?,
        generalDisable:Bool,
        onChangeValue:ChangeValue,
        onChangeProxyControl:@escaping (_ :ScrollViewProxy) -> Void,
        mapButtonAction: (() -> Void)? = nil ,
        @ViewBuilder trailingView: () -> TrailingView,
        @ViewBuilder filterView: () -> FilterRows,
        @ViewBuilder sorterView: () -> SorterRows,
        @ViewBuilder elementView: @escaping (_ :M) -> ElementView,
        onRefreshAction: ( () -> Void)? = nil) {
            
        self.backgroundColorView = backgroundColorView
        self.title = title
        _coreFilter = filterCore
        self.placeHolderBarraRicerca = placeHolderBarraRicerca
        self.altezzaPopOverFiltri = altezzaPopOverFiltri
        self.altezzaPopOverSorter = altezzaPopOverSorter
        self.paddingHorizontal = paddingHorizontal
        self.buttonColor = buttonColor
        self.elementContainer = elementContainer
        self.mapTree = mapTree
            //24.02.23 Proxy Control Upgrade
        self.onChangeValue = onChangeValue
        self.onChangeProxyControl = onChangeProxyControl
           //24.02.23
        self.mapButtonAction = mapButtonAction
        self.elementView = elementView
        self.trailingView = trailingView()
        self.popOverFilter = filterView()
        self.popOverSorter = sorterView()
        self.onRefresh = onRefreshAction
            
        self.generalDisable = generalDisable
    }
    
    // Sticky Header
    @State private var frames: [CGRect] = []
    
   public var body: some View {
        
        CSZStackVB(title: title, backgroundColorView: backgroundColorView) {
            
            VStack {

                CSDivider()
                
                ScrollView(showsIndicators: false) {
                    
                    if let refreshAction = onRefresh {
                        PullToRefresh(
                            coordinateSpaceName: "MainScroll",
                            onRefresh: refreshAction)
                        
                    }
                  
                    ScrollViewReader { proxy in

                        CSTextField_4b(
                            textFieldItem: $coreFilter.stringaRicerca,
                            placeHolder: placeHolderBarraRicerca,
                            showDelete: true,
                            inlineContent: {
                                
                        Picker(selection: $coreFilter.tipologiaFiltro) {
                                             
                            ForEach(TipologiaFiltro.allCases,id:\.self) { tipologia in
                                             
                                    Text(tipologia.rawValue)
                                        .tag(tipologia)
                                                     
                                             }
                                         } label: {
                                             Text("")
                                         }
                                         .pickerStyle(.menu)
                                       
                            })
                            .id(0)
                            .disabled(generalDisable)

                        FiltrableBodyContent_SubView(
                            container: elementContainer,
                            mapTree: mapTree,
                            frames: $frames,
                            coordinateSpace: "MainScroll",
                            mapLabel: { labelProperty in
                                
                              //  Text(labelProperty.simpleDescription())
                                CSLabel_1Button(
                                    placeHolder: labelProperty.simpleDescription(),
                                    imageNameOrEmojy: labelProperty.imageAssociated(),
                                    backgroundColor: buttonColor,
                                    backgroundOpacity:0.8)
  
                            },
                            elementView: { element in
                                self.elementView(element)
                            })
                            .id(1)
                            .onAppear{
                                proxy.scrollTo(1, anchor: .top)
                            }
                            .onChange(of: self.coreFilter.filterProperties, {
                                onChangeLogic(proxy)
                            })
                            .onChange(of: self.coreFilter.sortConditions, {
                                onChangeLogic(proxy)
                            })
                            .onChange(of: self.onChangeValue) {
                                onChangeProxyControl(proxy)
                            }
                           /*.onChange(of: self.coreFilter.filterProperties) { _ in
                                onChangeLogic(proxy)
                            }
                            .onChange(of: self.coreFilter.sortConditions) { _ in
                             onChangeLogic(proxy)
                            }*/

                        // 24.02.23 Innesto per ResetProxy
                        
                           /* .onChange(of: self.onChangeValue) { _ in
                                onChangeProxyControl(proxy)
                            }*/
                        
                        
                        //
                        
                        
                    }
                }
                .coordinateSpace(name: "MainScroll")
                .onPreferenceChange(FramePreference.self, perform: {
                                frames = $0.sorted(by: { $0.minY < $1.minY })
                            })
                .scrollDismissesKeyboard(.immediately)
 
               // CSDivider()
                   
            }
            .padding(.horizontal,paddingHorizontal)
        }
        .toolbar {
            
            ToolbarItem(placement: .topBarLeading) {
              //  let sortActive = self.filterCore.conditions != nil
                let sortActive = self.coreFilter.sortConditions != .defaultValue
 
                        FiltraOrdinaMapppa_Bar(
                            openFilter: $openFilter,
                            openSort: $openSort,
                            filterCount: self.coreFilter.countChange,
                            sortActive: sortActive,
                            colorButton: buttonColor,
                            disableCondition: generalDisable,
                            mapButtonAction: self.mapButtonAction)
                            .opacity(generalDisable ? 0.6 : 1.0)
 
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                trailingView
            }
        }
        .popover(
            isPresented: $openFilter,
            attachmentAnchor: .point(.leading)) {
                
                let label = self.coreFilter.tipologiaFiltro.simpleDescription()
                
                FilterAndSort_PopView(
                    backgroundColorView: backgroundColorView,
                    label: label,
                    resetAction: {
                        // self.filterProperties = V()
                        self.coreFilter.filterProperties = M.FilterProperty()
                        // self.filterCore.properties = V.FilterProperty.init()
                    },
                    content: {
                            popOverFilter
                    })
                    .presentationDetents([.height(altezzaPopOverFiltri)])
        }
        .popover(
            isPresented: $openSort,
            attachmentAnchor: .point(.top)) {
                
                FilterAndSort_PopView(
                    backgroundColorView: backgroundColorView,
                    label: "Ordina",
                    resetAction: {
                        self.coreFilter.sortConditions = .defaultValue
                      //  self.filterProperties.sortCondition = .defaultValue
                      //  self.filterProperties.coreFilter
                      //  self.filterCore.conditions = nil
                    },
                    content: {
                        popOverSorter
                    })
                    .presentationDetents([.height(altezzaPopOverSorter)])
            }
            
       
    }
    
    // Method
    private func onChangeLogic(_ proxy:ScrollViewProxy) {
        
        let value = self.coreFilter.stringaRicerca == "" ? 1 : 0
        
        proxy.scrollTo(value,anchor: .top)
        print("Eseguita OnChange Logic")
    
    }
}

/// Copied by  https://stackoverflow.com/questions/56493660/pull-down-to-refresh-data-in-swiftui/65100922#65100922
public struct PullToRefresh: View {
    
    var coordinateSpaceName: String
    var onRefresh: () -> Void
    
    @State var needRefresh: Bool = false
     
    public init(coordinateSpaceName: String, onRefresh: @escaping () -> Void) {
         self.coordinateSpaceName = coordinateSpaceName
         self.onRefresh = onRefresh
        
     }
    
   public var body: some View {
        
        GeometryReader { geo in
            
            if (geo.frame(in: .named(coordinateSpaceName)).midY > 75) {
                Spacer()
                    .onAppear {
                        needRefresh = true
                    }
            } else if (geo.frame(in: .named(coordinateSpaceName)).maxY < 10) {
                Spacer()
                    .onAppear {
                        if needRefresh {
                            needRefresh = false
                            onRefresh()
                        }
                    }
            }
            
            HStack {
                Spacer()
                if needRefresh {
                    ProgressView()
                }
                Spacer()
            }
        }.padding(.top, -75)
    }
}

