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

!CartTest methodsFor: 'as yet unclassified' stamp: 'SO 2/9/2021 22:56:56'!
test02AnItemCanBeAddedToACart

	| cart book |
	
	cart := Cart initialize.
	book := 123123.
	cart addBook: book numberOfCopies: 1.
	
	self deny: cart isEmpty.
	self assert: (cart hasBook: book).! !

!CartTest methodsFor: 'as yet unclassified' stamp: 'SO 2/9/2021 23:06:35'!
test03ManyItemsCanBeAddedToACart

	| cart book |
	
	cart := Cart initialize.
	book := 123123.
	cart addBook: book numberOfCopies: 2.
	
	self deny: cart isEmpty.
	self assert: (cart totalItems = 2).! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'books'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'testing' stamp: 'SO 2/9/2021 22:53:00'!
isEmpty
	
	^books isEmpty ! !


!Cart methodsFor: 'core' stamp: 'SO 2/9/2021 23:06:03'!
addBook: aBookToAdd numberOfCopies: aNumberOfCopiesToAdd

	1 to: aNumberOfCopiesToAdd do: [ :x | books add: aBookToAdd ].! !

!Cart methodsFor: 'core' stamp: 'SO 2/9/2021 22:52:12'!
hasBook: aBook

	^books includes: aBook.! !


!Cart methodsFor: 'as yet unclassified' stamp: 'SO 2/9/2021 22:51:04'!
initialize

	books := OrderedCollection new.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'SO 2/9/2021 22:59:48'!
totalItems
	
	^books size ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'as yet unclassified' stamp: 'SO 2/9/2021 22:50:42'!
initialize

	| cart |
	cart := Cart new.
	cart initialize.
	
	^cart.! !

Cart initialize!