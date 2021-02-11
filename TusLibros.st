!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'as yet unclassified' stamp: 'SO 2/9/2021 22:51:18'!
test01ANewCartIsEmpty

	| cart |
	
	cart := Cart initialize.
	
	self assert: cart isEmpty.! !

!CartTest methodsFor: 'as yet unclassified' stamp: 'SO 2/10/2021 21:59:05'!
test02ABookCanBeAddedToACart

	| cart book |
	
	cart := Cart initialize.
	book := '123123'.
	cart addBook: book numberOfCopies: 1.
	
	self deny: cart isEmpty.
	self assert: (cart hasBook: book).! !

!CartTest methodsFor: 'as yet unclassified' stamp: 'SO 2/10/2021 21:59:14'!
test03ManyBooksCanBeAddedToACart

	| cart book |
	
	cart := Cart initialize.
	book := '123123'.
	cart addBook: book numberOfCopies: 2.
	
	self deny: cart isEmpty.
	self assert: (cart totalItems = 2).! !

!CartTest methodsFor: 'as yet unclassified' stamp: 'SO 2/10/2021 22:09:08'!
test04ZeroBooksCannotBeAddedToACart

	| cart book |
	
	cart := Cart initialize.
	book := '123123'.
	
	self should: [ cart addBook: book numberOfCopies: 0 ] 
		raise: Error
		withExceptionDo: [ :anError |
			self assert: Cart cannotAddZeroNumberOfBookCopiesErrorDescription = anError messageText.
			self assert: cart isEmpty.
			self deny: (cart hasBook: book).
			].! !

!CartTest methodsFor: 'as yet unclassified' stamp: 'SO 2/10/2021 21:59:32'!
test05TheBooksInsideACartCanBeListed

	| cart book1 book2 result |
	
	cart := Cart initialize.
	result := '0|123123|2|321321|1|3'.
	book1 := '123123'.
	book2:= '321321'.
	
	cart addBook: book1 numberOfCopies: 2.
	cart addBook: book2 numberOfCopies: 1.
	
	self deny: cart isEmpty.
	self assert: (cart totalItems = 3).
	self assert: (cart listItems = result)! !

!CartTest methodsFor: 'as yet unclassified' stamp: 'SO 2/10/2021 22:09:02'!
test06CannotAddABookWhichDoesNotExistInTheEditorialCatalog

	| cart book |
	
	cart := Cart initialize.
	book := '987987'.
	
	self 
		should: [ cart addBook: book numberOfCopies: 1 ] 
		raise: Error 
		withExceptionDo: [ :anError |
			self assert: Cart cannotAddABookThatDoesNotExistInEditorialCatalogErrorDescription = anError messageText.
			self assert: cart isEmpty.
			self deny: (cart hasBook: book).
			]! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'books'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'testing' stamp: 'SO 2/9/2021 22:53:00'!
isEmpty
	
	^books isEmpty ! !


!Cart methodsFor: 'core' stamp: 'SO 2/10/2021 22:06:49'!
addBook: aBookToAdd numberOfCopies: aNumberOfCopiesToAdd

	self assertCanAddToCart: aNumberOfCopiesToAdd numberOfCopies: aBookToAdd.

	1 to: aNumberOfCopiesToAdd do: [ :x | books add: aBookToAdd ].! !

!Cart methodsFor: 'core' stamp: 'PB 2/10/2021 19:28:41'!
hasBook: aBook

	^books includes: aBook.! !

!Cart methodsFor: 'core' stamp: 'PB 2/10/2021 20:40:55'!
listItems
	| dic listedItems |
	
	dic := Dictionary new.
	listedItems := ''. 
	
	books do: [ 
		:aBook | | value |
		(dic includesKey:aBook) ifFalse: [ dic add: (Association key: aBook value: 0) ]. 
		value := (dic at: aBook) + 1.
		dic at: aBook put: value.
		 ].
	
	dic keysAndValuesDo: [ :key :value | listedItems := listedItems, key asString, '|', value asString, '|'].
	
 	^'0|', listedItems, self totalItems asString.! !

!Cart methodsFor: 'core' stamp: 'SO 2/9/2021 22:59:48'!
totalItems
	
	^books size ! !


!Cart methodsFor: 'errors' stamp: 'SO 2/10/2021 22:08:49'!
signalCannotAddABookThatDoesNotExistInEditorialCatalog
	
	self error: self class cannotAddABookThatDoesNotExistInEditorialCatalogErrorDescription! !

!Cart methodsFor: 'errors' stamp: 'SO 2/10/2021 22:08:54'!
signalCannotAddZeroNumberOfBookCopies
	
	self error: self class cannotAddZeroNumberOfBookCopiesErrorDescription! !


!Cart methodsFor: 'initialization' stamp: 'SO 2/9/2021 22:51:04'!
initialize

	books := OrderedCollection new.! !


!Cart methodsFor: 'assertions - private' stamp: 'SO 2/10/2021 22:06:49'!
assertCanAddToCart: aNumberOfCopiesToAdd numberOfCopies: aBookToAdd

	aNumberOfCopiesToAdd < 1 ifTrue: [ self signalCannotAddZeroNumberOfBookCopies ].
	
	(Editorial hasBookInCatalog: aBookToAdd) ifFalse: [ self signalCannotAddABookThatDoesNotExistInEditorialCatalog ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance-initialization' stamp: 'SO 2/9/2021 22:50:42'!
initialize

	| cart |
	cart := Cart new.
	cart initialize.
	
	^cart.! !


!Cart class methodsFor: 'error-messages' stamp: 'SO 2/10/2021 22:08:21'!
cannotAddABookThatDoesNotExistInEditorialCatalogErrorDescription
	
	^'cannot add a book that does not exist in editorial catalog'! !

!Cart class methodsFor: 'error-messages' stamp: 'SO 2/10/2021 22:08:33'!
cannotAddZeroNumberOfBookCopiesErrorDescription
	
	^'cannot add 0 number of book copies'! !


!classDefinition: #Editorial category: 'TusLibros'!
Object subclass: #Editorial
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Editorial class' category: 'TusLibros'!
Editorial class
	instanceVariableNames: ''!

!Editorial class methodsFor: 'as yet unclassified' stamp: 'SO 2/10/2021 21:56:37'!
hasBookInCatalog: aBook

	| booksCatalog |
	
	booksCatalog := OrderedCollection new.
	booksCatalog add: '123123'.
	booksCatalog add: '321321'.	
	
	^booksCatalog includes: aBook.! !

Cart initialize!