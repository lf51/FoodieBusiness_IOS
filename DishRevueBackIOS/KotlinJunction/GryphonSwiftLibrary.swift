//
// Copyright 2018 Vinicius Jorge Vendramini
//
// Licensed under the Hippocratic License, Version 2.1;
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// https://firstdonoharm.dev/version/2/1/license
//
// To the full extent allowed by law, this software comes "AS IS,"
// WITHOUT ANY WARRANTY, EXPRESS OR IMPLIED, and licensor and any other
// contributor shall not be liable to anyone for any damages or other
// liability arising from, out of, or in connection with the sotfware
// or this license, under any kind of legal claim.
// See the License for the specific language governing permissions and
// limitations under the License.
//

// MARK: - Template class declarations
// gryphon ignore
internal class GRYTemplate {
	static func dot(_ left: GRYTemplate, _ right: String) -> GRYDotTemplate {
		return GRYDotTemplate(left, right)
	}

	static func dot(_ left: String, _ right: String) -> GRYDotTemplate {
		return GRYDotTemplate(GRYLiteralTemplate(string: left), right)
	}

	static func call(
		_ function: GRYTemplate,
		_ parameters: [GRYParameterTemplate])
		-> GRYCallTemplate
	{
		return GRYCallTemplate(function, parameters)
	}

	static func call(
		_ function: String,
		_ parameters: [GRYParameterTemplate])
		-> GRYCallTemplate
	{
		return GRYCallTemplate(function, parameters)
	}
}

// gryphon ignore
internal class GRYDotTemplate: GRYTemplate {
	let left: GRYTemplate
	let right: String

	init(_ left: GRYTemplate, _ right: String) {
		self.left = left
		self.right = right
	}
}

// gryphon ignore
internal class GRYCallTemplate: GRYTemplate {
	let function: GRYTemplate
	let parameters: [GRYParameterTemplate]

	init(_ function: GRYTemplate, _ parameters: [GRYParameterTemplate]) {
		self.function = function
		self.parameters = parameters
	}

	//
	init(_ function: String, _ parameters: [GRYParameterTemplate]) {
		self.function = GRYLiteralTemplate(string: function)
		self.parameters = parameters
	}
}

// gryphon ignore
internal class GRYParameterTemplate: ExpressibleByStringLiteral {
	let label: String?
	let template: GRYTemplate

	internal init(_ label: String?, _ template: GRYTemplate) {
		if let existingLabel = label {
			if existingLabel == "_" || existingLabel == "" {
				self.label = nil
			}
			else {
				self.label = label
			}
		}
		else {
			self.label = label
		}

		self.template = template
	}

	required init(stringLiteral: String) {
		self.label = nil
		self.template = GRYLiteralTemplate(string: stringLiteral)
	}

	static func labeledParameter(
		_ label: String?,
		_ template: GRYTemplate)
		-> GRYParameterTemplate
	{
		return GRYParameterTemplate(label, template)
	}

	static func labeledParameter(
		_ label: String?,
		_ template: String)
		-> GRYParameterTemplate
	{
		return GRYParameterTemplate(label, GRYLiteralTemplate(string: template))
	}

	static func dot(
		_ left: GRYTemplate,
		_ right: String)
		-> GRYParameterTemplate
	{
		return GRYParameterTemplate(nil, GRYDotTemplate(left, right))
	}

	static func dot(
		_ left: String,
		_ right: String)
		-> GRYParameterTemplate
	{
		return GRYParameterTemplate(nil, GRYDotTemplate(GRYLiteralTemplate(string: left), right))
	}

	static func call(
		_ function: GRYTemplate,
		_ parameters: [GRYParameterTemplate])
		-> GRYParameterTemplate
	{
		return GRYParameterTemplate(nil, GRYCallTemplate(function, parameters))
	}

	static func call(
		_ function: String,
		_ parameters: [GRYParameterTemplate])
		-> GRYParameterTemplate
	{
		return GRYParameterTemplate(nil, GRYCallTemplate(function, parameters))
	}
}

// gryphon ignore
internal class GRYLiteralTemplate: GRYTemplate {
	let string: String

	init(string: String) {
		self.string = string
	}
}

// gryphon ignore
internal class GRYConcatenatedTemplate: GRYTemplate {
	let left: GRYTemplate
	let right: GRYTemplate

	init(left: GRYTemplate, right: GRYTemplate) {
		self.left = left
		self.right = right
	}
}

// gryphon ignore
internal func + (
	left: GRYTemplate,
	right: GRYTemplate)
	-> GRYConcatenatedTemplate
{
	GRYConcatenatedTemplate(left: left, right: right)
}

// gryphon ignore
internal func + (left: String, right: GRYTemplate) -> GRYConcatenatedTemplate {
	GRYConcatenatedTemplate(left: GRYLiteralTemplate(string: left), right: right)
}

// gryphon ignore
internal func + (left: GRYTemplate, right: String) -> GRYConcatenatedTemplate {
	GRYConcatenatedTemplate(left: left, right: GRYLiteralTemplate(string: right))
}

// MARK: - Templates
// Replacement for Comparable
// gryphon ignore
private struct _Comparable: Comparable {
	static func < (lhs: _Comparable, rhs: _Comparable) -> Bool {
		return false
	}
}

// Replacement for Hashable
// gryphon ignore
private struct _Hashable: Hashable { }

private func gryphonTemplates() {
	let _array1: MutableList<Any> = [1, 2, 3]
	let _array2: MutableList<Any> = [1, 2, 3]
	let _array3: [Any] = [1, 2, 3]
	let _dictionary: [_Hashable: Any] = [:]
	let _list: ListGSL<Any> = []
	let _map: MapGSL<_Hashable, Any> = [:]
	let _any: Any = 0
	let _string: String = ""
	let _index = _string.startIndex
	let _comparableArray: ListGSL<_Comparable> = []
	let _closure: (_Comparable, _Comparable) -> Bool = { _, _ in true }

	// Templates with an input that references methods defined in this file
	_ = zip(_array1, _array2)
	_ = GRYTemplate.call(.dot("_array1", "zip"), ["_array2"])

	_ = _array1.toList()
	_ = GRYTemplate.call(.dot("_array1", "toList"), [])

	_ = _array1.appending(_any)
	_ = "_array1 + _any"

	_ = _array1.appending(contentsOf: _array2)
	_ = "_array1 + _array2"

	_ = ListGSL(_array3)
	_ = GRYTemplate.call(.dot("_array3", "toList"), [])

	_ = MutableList(_array3)
	_ = GRYTemplate.call(.dot("_array3", "toMutableList"), [])

	_ = MapGSL(_dictionary)
	_ = GRYTemplate.call(.dot("_dictionary", "toMap"), [])

	_ = MutableMap(_dictionary)
	_ = GRYTemplate.call(.dot("_dictionary", "toMutableMap"), [])

	_ = _list.array
	_ = GRYTemplate.call(.dot("_list", "toList"), [])

	_ = _map.dictionary
	_ = GRYTemplate.call(.dot("_map", "toMap"), [])

	// Templates with an output that references methods defined in the GryphonKotlinLibrary.kt file
	_ = _string.suffix(from: _index)
	_ = GRYTemplate.call(.dot("_string", "suffix"), [.labeledParameter("startIndex", "_index")])

	_ = _comparableArray.sorted(by: _closure)
	_ = GRYTemplate.call(
		.dot("_comparableArray", "sorted"), [.labeledParameter("isAscending", "_closure")])

	_ = _array1.removeLast()
	_ = GRYTemplate.call(.dot("_array1", "removeLast"), [])
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Collections

/// According to http://swiftdoc.org/v4.2/type/Array/hierarchy/
/// (link found via https://www.raywenderlich.com/139591/building-custom-collection-swift)
/// the Array type in Swift conforms exactly to these protocols,
/// plus CustomReflectable (which is beyond Gryphon's scope for now).
// gryphon ignore
public struct _ListSlice<Element>: Collection,
	BidirectionalCollection,
	RandomAccessCollection,
	MutableCollection,
	RangeReplaceableCollection
{
	public typealias Index = Int
	public typealias SubSequence = _ListSlice<Element>

	let list: ListGSL<Element>
	let range: Range<Int>

	public init(
		list: ListGSL<Element>,
		range: Range<Int>)
	{
		self.list = list
		self.range = range
	}

	public var startIndex: Int {
		return range.startIndex
	}

	public var endIndex: Int {
		return range.endIndex
	}

	public subscript(position: Int) -> Element {
		get {
			return list[position]
		}

		// MutableCollection
		set {
			list._setElement(newValue, atIndex: position)
		}
	}

	public subscript(bounds: Range<Index>) -> _ListSlice<Element> {
		// From Collection.swift
		_failEarlyRangeCheck(bounds, bounds: startIndex..<endIndex)
		return _ListSlice(list: list, range: bounds)
	}

	public func index(after i: Int) -> Int {
		return list.index(after: i)
	}

	// BidirectionalCollection
	public func index(before i: Int) -> Int {
		return list.index(before: i)
	}

	// RangeReplaceableCollection
	public init() {
		self.list = []
		self.range = 0..<0
	}

	// Other methods
	public func filter(_ isIncluded: (Element) throws -> Bool) rethrows -> ListGSL<Element> {
		let array = list.array[range]
		return try ListGSL(array.filter(isIncluded))
	}

	public func map<T>(_ transform: (Element) throws -> T) rethrows -> ListGSL<T> {
		let array = list.array[range]
		return try ListGSL<T>(array.map(transform))
	}

	public func compactMap<T>(_ transform: (Element) throws -> T?) rethrows -> ListGSL<T> {
		let array = list.array[range]
		return try ListGSL<T>(array.compactMap(transform))
	}

	public func flatMap<SegmentOfResult>(
		_ transform: (Element) throws -> SegmentOfResult)
		rethrows -> ListGSL<SegmentOfResult.Element>
		where SegmentOfResult: Sequence
	{
		let array = list.array[range]
		return try ListGSL<SegmentOfResult.Element>(array.flatMap(transform))
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// gryphon ignore
public class ListGSL<Element>: CustomStringConvertible, // from List to ListGSL per risolvere conflitto con List in swift
	CustomDebugStringConvertible,
	ExpressibleByArrayLiteral,
	Sequence,
	Collection,
	BidirectionalCollection,
	RandomAccessCollection
{
	public typealias Buffer = [Element]
	public typealias ArrayLiteralElement = Element
	public typealias Index = Int
	public typealias SubSequence = _ListSlice<Element>

	public var array: Buffer

	public init(_ array: Buffer) {
		self.array = array
	}

	// Custom (Debug) String Convertible
	public var description: String {
		return array.description
	}

	public var debugDescription: String {
		return array.debugDescription
	}

	// Expressible By Array Literal
	public required init(arrayLiteral elements: Element...) {
		self.array = elements
	}

	// Sequence
	public func makeIterator() -> IndexingIterator<ListGSL<Element>> {
		return IndexingIterator(_elements: self)
	}

	// Collection
	public var startIndex: Int {
		return array.startIndex
	}

	public var endIndex: Int {
		return array.endIndex
	}

	public subscript(position: Int) -> Element {
		return array[position]
	}

	public subscript(bounds: Range<Index>) -> _ListSlice<Element> {
		// From Collection.swift
		_failEarlyRangeCheck(bounds, bounds: startIndex..<endIndex)
		return _ListSlice(list: self, range: bounds)
	}

	public func index(after i: Int) -> Int {
		return array.index(after: i)
	}

	// BidirectionalCollection
	public func index(before i: Int) -> Int {
		return array.index(before: i)
	}

	// Used for _ListSlice to conform to MutableCollection
	fileprivate func _setElement(_ element: Element, atIndex index: Int) {
		array[index] = element
	}

	// Other methods
	public init<S>(_ sequence: S) where Element == S.Element, S: Sequence {
		self.array = Array(sequence)
	}

	public init() {
		self.array = []
	}

	/// Used to obtain a List with a new element type. If all elements in the list can be casted to
	/// the new type, the method succeeds and the new MutableList is returned. Otherwise, the method
	/// returns `nil`.
	public func `as`<CastedType>(_ type: ListGSL<CastedType>.Type) -> ListGSL<CastedType>? {
		if let castedList = self.array as? [CastedType] {
			return ListGSL<CastedType>(castedList)
		}
		else {
			return nil
		}
	}

	/// Used to obtain a List with a new element type. If all elements in the list can be casted to
	/// the new type, the method succeeds and the new MutableList is returned. Otherwise, the method
	/// crashes.
	public func forceCast<CastedType>(to type: ListGSL<CastedType>.Type) -> ListGSL<CastedType> {
		ListGSL<CastedType>(array as! [CastedType])
	}

	public func toList() -> ListGSL<Element> {
		return ListGSL(array)
	}

	public var isEmpty: Bool {
		return array.isEmpty
	}

	public var first: Element? {
		return array.first
	}

	public var last: Element? {
		return array.last
	}

	public func dropFirst(_ k: Int = 1) -> ListGSL<Element> {
		return ListGSL(array.dropFirst(k))
	}

	public func dropLast(_ k: Int = 1) -> ListGSL<Element> {
		return ListGSL(array.dropLast(k))
	}

	public func drop(while predicate: (Element) throws -> Bool) rethrows -> ListGSL<Element> {
		return try ListGSL(array.drop(while: predicate))
	}

	public func appending(_ newElement: Element) -> ListGSL<Element> {
		return ListGSL<Element>(self.array + [newElement])
	}

	public func filter(_ isIncluded: (Element) throws -> Bool) rethrows -> ListGSL<Element> {
		return try ListGSL(self.array.filter(isIncluded))
	}

	public func map<T>(_ transform: (Element) throws -> T) rethrows -> ListGSL<T> {
		return try ListGSL<T>(self.array.map(transform))
	}

	public func compactMap<T>(_ transform: (Element) throws -> T?) rethrows -> ListGSL<T> {
		return try ListGSL<T>(self.array.compactMap(transform))
	}

	public func flatMap<SegmentOfResult>(
		_ transform: (Element) throws -> SegmentOfResult)
		rethrows -> ListGSL<SegmentOfResult.Element>
		where SegmentOfResult: Sequence
	{
		return try ListGSL<SegmentOfResult.Element>(array.flatMap(transform))
	}

	public func prefix(while predicate: (Element) throws -> Bool) rethrows -> ListGSL<Element> {
		return try ListGSL<Element>(array.prefix(while: predicate))
	}

	@inlinable
	public func sorted(
		by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows
		-> ListGSL<Element>
	{
		return ListGSL(try array.sorted(by: areInIncreasingOrder))
	}

	public func appending<S>(contentsOf newElements: S) -> ListGSL<Element>
		where S: Sequence, Element == S.Element
	{
		return ListGSL<Element>(self.array + newElements)
	}

	public func reversed() -> ListGSL<Element> {
		return ListGSL(array.reversed())
	}

	public var indices: Range<Int> {
		return array.indices
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// gryphon ignore
extension ListGSL {
	public func toMutableList() -> MutableList<Element> {
		return MutableList(array)
	}
}

// gryphon ignore
extension ListGSL {
	@inlinable
	public static func + <Other>(
		lhs: ListGSL<Element>,
		rhs: Other)
		-> ListGSL<Element>
		where Other: Sequence,
		ListGSL.Element == Other.Element
	{
		var array = lhs.array
		for element in rhs {
			array.append(element)
		}
		return ListGSL(array)
	}
}

// gryphon ignore
extension ListGSL: Equatable where Element: Equatable {
	public static func == (lhs: ListGSL, rhs: ListGSL) -> Bool {
		return lhs.array == rhs.array
	}

	//
	public func firstIndex(of element: Element) -> Int? {
		return array.firstIndex(of: element)
	}
}

// gryphon ignore
extension ListGSL: Hashable where Element: Hashable {
	public func hash(into hasher: inout Hasher) {
		array.hash(into: &hasher)
	}
}

// gryphon ignore
extension ListGSL where Element: Comparable {
	@inlinable
	public func sorted() -> ListGSL<Element> {
		return ListGSL(array.sorted())
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// gryphon ignore
public class MutableList<Element>: ListGSL<Element>,
	MutableCollection,
	RangeReplaceableCollection
{
	// MutableCollection
	public override subscript(position: Int) -> Element {
		get {
			return array[position]
		}
		set {
			array[position] = newValue
		}
	}

	// RangeReplaceableCollection
	override public required init() {
		super.init([])
	}

	public required init(arrayLiteral elements: Element...) {
		super.init(elements)
	}

	// Other methods
	public func append(_ newElement: Element) {
		array.append(newElement)
	}

	public func append<S>(contentsOf newElements: S) where S: Sequence, Element == S.Element {
		self.array.append(contentsOf: newElements)
	}

	public func insert(_ newElement: Element, at i: Index) {
		array.insert(newElement, at: i)
	}

	@discardableResult
	public func removeFirst() -> Element {
		return array.removeFirst()
	}

	@discardableResult
	public func removeLast() -> Element {
		return array.removeLast()
	}

	public func removeAll(keepingCapacity keepCapacity: Bool = false) {
		array.removeAll(keepingCapacity: keepCapacity)
	}

	@discardableResult
	public func remove(at index: Int) -> Element {
		return array.remove(at: index)
	}

	public func reverse() {
		self.array = self.array.reversed()
	}

	override public func drop(while predicate: (Element) throws -> Bool) rethrows -> ListGSL<Element> {
		return try ListGSL(array.drop(while: predicate))
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// gryphon ignore
extension ListGSL {

	/// Used to obtain a MutableList with a new element type. If all elements in the list can be
	/// casted to the new type, the method succeeds and the new MutableList is returned. Otherwise,
	/// the method returns `nil`.
	public func `as`<CastedType>(
		_ type: MutableList<CastedType>.Type)
		-> MutableList<CastedType>?
	{
		if let castedList = self.array as? [CastedType] {
			return MutableList<CastedType>(castedList)
		}
		else {
			return nil
		}
	}

	/// Used to obtain a MutableList with a new element type. If all elements in the list can be
	/// casted to the new type, the method succeeds and the new MutableList is returned. Otherwise,
	/// the method crashes.
	public func forceCast<CastedType>(
		to type: MutableList<CastedType>.Type)
		-> MutableList<CastedType>
	{
		MutableList<CastedType>(array as! [CastedType])
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// gryphon ignore
public func zip<ASequence, ListElement>(
	_ array1: ASequence,
	_ array2: ListGSL<ListElement>)
	-> ListGSL<(ASequence.Element, ListElement)>
	where ASequence: Sequence
{
	return ListGSL(Swift.zip(array1, array2))
}

// gryphon ignore
public func zip<ASequence, ListElement>(
	_ array1: ListGSL<ListElement>,
	_ array2: ASequence)
	-> ListGSL<(ListElement, ASequence.Element)>
	where ASequence: Sequence
{
	return ListGSL(Swift.zip(array1, array2))
}

// gryphon ignore
public func zip<List1Element, List2Element>(
	_ array1: ListGSL<List1Element>,
	_ array2: ListGSL<List2Element>)
	-> ListGSL<(List1Element, List2Element)>
{
	return ListGSL(Swift.zip(array1, array2))
}

////////////////////////////////////////////////////////////////////////////////////////////////////

/// According to https://swiftdoc.org/v4.2/type/dictionary/hierarchy/
/// the Dictionary type in Swift conforms exactly to these protocols,
/// plus CustomReflectable (which is beyond Gryphon's scope for now).
// gryphon ignore
public class MapGSL<Key, Value>: CustomStringConvertible, // modificato nome from Map to MapGSL in data 24.01.2022 - Vedere KotlinJunction 
	CustomDebugStringConvertible,
	ExpressibleByDictionaryLiteral,
	Collection
	where Key: Hashable
{
	public typealias Buffer = [Key: Value]
	public typealias KeyValueTuple = (key: Key, value: Value)

	public typealias SubSequence = Slice<Buffer>
	public typealias Index = Buffer.Index
	public typealias Element = KeyValueTuple

	public var dictionary: Buffer

	public init(_ dictionary: Buffer) {
		self.dictionary = dictionary
	}

	// The tuple inside the list has to be translated as a Pair for Kotlin compatibility
	public func toList() -> ListGSL<(Key, Value)> {
		return ListGSL(dictionary).map { ($0.0, $0.1) }
	}

	// Custom (Debug) String Convertible
	public var description: String {
		return dictionary.description
	}

	public var debugDescription: String {
		return dictionary.debugDescription
	}

	// Expressible By Dictionary Literal
	public required init(dictionaryLiteral elements: (Key, Value)...) {
		self.dictionary = Buffer(uniqueKeysWithValues: elements)
	}

	// Sequence
	public func makeIterator() -> IndexingIterator<MapGSL<Key, Value>> {
		return IndexingIterator(_elements: self)
	}

	// Collection
	public var startIndex: Index {
		return dictionary.startIndex
	}

	public var endIndex: Index {
		return dictionary.endIndex
	}

	@inlinable
	public subscript(position: Index) -> Element {
		return dictionary[position]
	}

	public func index(after i: Index) -> Index {
		return dictionary.index(after: i)
	}

	public subscript(bounds: Range<Index>) -> Slice<Buffer> {
		// From Collection.swift
		_failEarlyRangeCheck(bounds, bounds: startIndex..<endIndex)
		return Slice(base: self.dictionary, bounds: bounds)
	}

	// Other methods

	/// Used to obtain a Map with new key and/or value types. If all keys and values in the map can
	/// be casted to the new types, the method succeeds and the new Map is returned. Otherwise, the
	/// method returns `nil`.
	public func `as`<CastedKey, CastedValue>(
		_ type: MapGSL<CastedKey, CastedValue>.Type)
		-> MapGSL<CastedKey, CastedValue>?
	{
		if let castedDictionary = self.dictionary as? [CastedKey: CastedValue] {
			return MapGSL<CastedKey, CastedValue>(castedDictionary)
		}
		else {
			return nil
		}
	}

	/// Used to obtain a Map with new key and/or value types. If all keys and values in the map can
	/// be casted to the new types, the method succeeds and the new Map is returned. Otherwise, the
	/// method crashes.
	public func forceCast<CastedKey, CastedValue>(
		to type: MapGSL<CastedKey, CastedValue>.Type)
		-> MapGSL<CastedKey, CastedValue>
	{
		MapGSL<CastedKey, CastedValue>(dictionary as! [CastedKey: CastedValue])
	}

	public func toMap() -> MapGSL<Key, Value> {
		return MapGSL(dictionary)
	}

	public subscript (_ key: Key) -> Value? {
		return dictionary[key]
	}

	@inlinable
	public func formIndex(after i: inout Index) {
		dictionary.formIndex(after: &i)
	}

	@inlinable
	public func index(forKey key: Key) -> Index? {
		return dictionary.index(forKey: key)
	}

	@inlinable public var count: Int {
		return dictionary.count
	}

	@inlinable public var isEmpty: Bool {
		return dictionary.isEmpty
	}

	public func map<T>(_ transform: (KeyValueTuple) throws -> T)
		rethrows -> ListGSL<T>
	{
		return try ListGSL<T>(self.dictionary.map(transform))
	}

	@inlinable
	public func mapValues<T>(_ transform: (Value) throws -> T) rethrows -> MapGSL<Key, T> {
		return try MapGSL<Key, T>(dictionary.mapValues(transform))
	}

	@inlinable
	public func sorted(
		by areInIncreasingOrder: (KeyValueTuple, KeyValueTuple) throws -> Bool)
		rethrows -> MutableList<KeyValueTuple>
	{
		return MutableList<KeyValueTuple>(try dictionary.sorted(by: areInIncreasingOrder))
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// gryphon ignore
extension MapGSL {
	public func toMutableMap() -> MutableMap<Key, Value> {
		return MutableMap(dictionary)
	}
}

// gryphon ignore
extension MapGSL: Equatable where Value: Equatable {
	public static func == (lhs: MapGSL, rhs: MapGSL) -> Bool {
		return lhs.dictionary == rhs.dictionary
	}
}

// gryphon ignore
extension MapGSL: Hashable where Value: Hashable {
	public func hash(into hasher: inout Hasher) {
		dictionary.hash(into: &hasher)
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// gryphon ignore
public class MutableMap<Key, Value>: MapGSL<Key, Value> where Key: Hashable {
	override public subscript (_ key: Key) -> Value? {
		get {
			return dictionary[key]
		}
		set {
			dictionary[key] = newValue
		}
	}
}

// gryphon ignore
extension MapGSL {
	/// Used to obtain a MutableMap with new key and/or value types. If all keys and values in the
	/// map can be casted to the new types, the method succeeds and the new MutableMap is returned.
	/// Otherwise, the method returns `nil`.
	public func `as`<CastedKey, CastedValue>(
		_ type: MutableMap<CastedKey, CastedValue>.Type)
		-> MutableMap<CastedKey, CastedValue>?
	{
		if let castedDictionary = self.dictionary as? [CastedKey: CastedValue] {
			return MutableMap<CastedKey, CastedValue>(castedDictionary)
		}
		else {
			return nil
		}
	}

	/// Used to obtain a Map with new key and/or value types. If all keys and values in the map can
	/// be casted to the new types, the method succeeds and the new Map is returned. Otherwise, the
	/// method crashes.
	public func forceCast<CastedKey, CastedValue>(
		to type: MutableMap<CastedKey, CastedValue>.Type)
		-> MutableMap<CastedKey, CastedValue>
	{
		MutableMap<CastedKey, CastedValue>(dictionary as! [CastedKey: CastedValue])
	}
}
