!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'tests' stamp: 'LL 1/21/2021 20:09:58'!
test01NewCartIsEmpty

	| cart |
	
	cart := self createCart.
	
	self assert: cart isEmpty.! !

!CartTest methodsFor: 'tests' stamp: 'LL 1/21/2021 20:09:38'!
test02CanAddABookToACart

	| cart |
	cart := self createCart.
	
	cart add: self bookFromTheEditorial.
	
	self deny: cart isEmpty.! !

!CartTest methodsFor: 'tests' stamp: 'LL 1/21/2021 21:25:18'!
test03CannotAddABookNotInCatalog

	| cart bookNotInCatalog |
	cart := self createCart.
	bookNotInCatalog := 'DEF456'.

	self assert: cart isEmptyAfter: [ cart add: bookNotInCatalog ] raisesErrorWithMessage: Cart bookNotInCatalogErrorMessage.
	! !

!CartTest methodsFor: 'tests' stamp: 'LL 1/21/2021 20:12:27'!
test04CanAddTwoCopiesOfABook

	| cart |
	cart := self createCart.
	
	cart add: self bookFromTheEditorial quantity: 2.
	
	self assert: (cart quantityOf: self bookFromTheEditorial) equals: 2.! !

!CartTest methodsFor: 'tests' stamp: 'LL 1/21/2021 21:27:25'!
test05CannotAddNonPositiveNumberOfCopiesOfABook

	| cart |
	cart := self createCart.

	self assert: cart isEmptyAfter: [ cart add: self bookFromTheEditorial quantity: -1 ] raisesErrorWithMessage: Cart invalidNumberOfCopiesErrorMessage.! !

!CartTest methodsFor: 'tests' stamp: 'LL 1/21/2021 21:39:03'!
test06CartRemembersAddedBooks

	| cart |
	cart := self createCart.
	
	cart add: self bookFromTheEditorial quantity: 2.
	cart add: self bookFromTheEditorial quantity: 1.
	
	self assert: (cart includes: self bookFromTheEditorial).
	self assert: (cart quantityOf: self bookFromTheEditorial) equals: 3! !

!CartTest methodsFor: 'tests' stamp: 'LL 1/21/2021 21:26:35'!
test07CannotAddTwoCopiesOfABookNotInCatalog

	| cart bookNotInCatalog |
	cart := self createCart.
	bookNotInCatalog := 'DEF123'.
	
	self assert: cart isEmptyAfter: [ cart add: bookNotInCatalog quantity: 2 ] raisesErrorWithMessage: Cart bookNotInCatalogErrorMessage.! !


!CartTest methodsFor: 'private' stamp: 'LL 1/21/2021 21:24:13'!
assert: cart isEmptyAfter: blockExpectedToFail raisesErrorWithMessage: errorMessage
	
	self should: blockExpectedToFail raise: Error withExceptionDo: [ :anException |
		self assert: anException messageText equals: errorMessage.
		self assert: cart isEmpty.
	]! !

!CartTest methodsFor: 'private' stamp: 'LL 1/21/2021 20:08:01'!
bookFromTheEditorial

	^ 'ABC123'! !

!CartTest methodsFor: 'private' stamp: 'SO 2/17/2021 20:06:48'!
createCart

	| aCatalog |
	aCatalog := EditorialCatalog initialize.
	^Cart withCatalog: aCatalog.! !


!classDefinition: #CashierTest category: 'TusLibros'!
TestCase subclass: #CashierTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'tests' stamp: 'SO 2/17/2021 23:23:01'!
test01ACashierCannotCheckOutAnEmptyCart

	| cart cashier creditCard merchantPorcessor |
	cart := self createCart.
	cashier := self createCashier.
	creditCard := self createCreditCard.
	merchantPorcessor := MerchantProcessorSuccessMock new.
	
	self should: [ cashier checkOutCart: cart withCreditCard: creditCard withMerchantProcessor: merchantPorcessor forAmount: 100 * peso ] 
	raise: Error 
	withExceptionDo: [ :anException |
		self assert: anException messageText equals: cashier emptyCartErrorDescription.
		self assert: cart isEmpty.
	]! !

!CashierTest methodsFor: 'tests' stamp: 'SO 2/17/2021 23:23:05'!
test02ACashierCanCheckoutACartWithOneBook

	| cart cashier creditCard merchantProcessor |
	cart := self createCart.
	cart add: self bookFromTheEditorial.
	cashier := self createCashier.
	creditCard := self createCreditCard.
	merchantProcessor := MerchantProcessorSuccessMock new.
	
	cashier checkOutCart: cart withCreditCard: creditCard withMerchantProcessor: merchantProcessor forAmount: 100 * peso.
	
	self assert: (cashier lastPurchaseAmount) equals: (10 * peso).
! !

!CashierTest methodsFor: 'tests' stamp: 'SO 2/17/2021 23:23:12'!
test03ACashierCanCheckoutACartWithMoreThanOneBook

	| cart cashier creditCard merchantProcessor |
	cart := self createCart.
	cart add: self bookFromTheEditorial quantity: 2.
	cashier := self createCashier.
	creditCard := self createCreditCard.
	merchantProcessor := MerchantProcessorSuccessMock new.
	
	cashier checkOutCart: cart withCreditCard: creditCard withMerchantProcessor: merchantProcessor forAmount: 100 * peso.
	
	self assert: (cashier lastPurchaseAmount) equals: (20 * peso).! !

!CashierTest methodsFor: 'tests' stamp: 'SO 2/17/2021 23:23:17'!
test04ACashierKeepsTrackOfItsPurchaseHistory

	| aCart anotherCart cashier creditCard merchantProcessor |
	aCart := self createCart.
	anotherCart := self createCart.
	
	aCart add: self bookFromTheEditorial quantity: 2.
	anotherCart add: self bookFromTheEditorial.
	
	cashier := self createCashier.
	creditCard := self createCreditCard.
	merchantProcessor := MerchantProcessorSuccessMock new.
	
	cashier checkOutCart: aCart withCreditCard: creditCard withMerchantProcessor: merchantProcessor forAmount: 100 * peso.
	cashier checkOutCart: anotherCart withCreditCard: creditCard withMerchantProcessor: merchantProcessor forAmount: 100 * peso.
	
	self assert: (cashier lastPurchaseAmount) equals: (10 * peso).
	self assert: (cashier totalPurchaseHistoryAmount) equals: (30 * peso).! !

!CashierTest methodsFor: 'tests' stamp: 'SO 2/17/2021 23:53:34'!
test05ACashierCannotCheckoutACartForAnAmountOfZero

	| aCart cashier creditCard merchantProcessor |
	aCart := self createCart.	
	aCart add: self bookFromTheEditorial quantity: 2.	
	cashier := self createCashier.
	creditCard := self createCreditCard.
	merchantProcessor := MerchantProcessorSuccessMock new.
	
	self 
	should: [ cashier checkOutCart: aCart withCreditCard: creditCard withMerchantProcessor: merchantProcessor forAmount: 0 * peso. ] 
	raise: Error 
	withExceptionDo: [ :anException |
			self assert: anException messageText equals: cashier invalidAmountErrorDescription.
		]! !

!CashierTest methodsFor: 'tests' stamp: 'SO 2/18/2021 14:25:17'!
test06ACashierCannotCheckoutACartForAnAmountGreaterThan15Digits

	| aCart cashier creditCard merchantProcessor |
	aCart := self createCart.	
	aCart add: self bookFromTheEditorial quantity: 2.	
	cashier := self createCashier.
	creditCard := self createCreditCard.
	merchantProcessor := MerchantProcessorSuccessMock new.
	
	self 
	should: [ cashier checkOutCart: aCart withCreditCard: creditCard withMerchantProcessor: merchantProcessor forAmount: 1000000000000000 * peso. ]
	raise: Error 
	withExceptionDo: [ :anException |
			self assert: anException messageText equals: cashier invalidAmountErrorDescription.
		]! !

!CashierTest methodsFor: 'tests' stamp: 'SO 2/17/2021 23:57:57'!
test07ACashierCannotCheckoutDueToWrongParemetersInTransaction

	| aCart cashier creditCard merchantProcessor |
	aCart := self createCart.	
	aCart add: self bookFromTheEditorial quantity: 2.	
	cashier := self createCashier.
	creditCard := self createCreditCard.
	merchantProcessor := MerchantProcessorParameterErrorMock new.
	
	self 
	should: [ cashier checkOutCart: aCart withCreditCard: creditCard withMerchantProcessor: merchantProcessor forAmount: 100 * peso ]
	raise: Error 
	withExceptionDo: [ :anException |
			self assert: anException messageText equals: 'the parameters have an incorrect format'.
		]! !

!CashierTest methodsFor: 'tests' stamp: 'SO 2/17/2021 23:58:39'!
test08ACashierCannotCheckoutDueToUnexpectedErrorInTransactionProcessing

	| aCart cashier creditCard merchantProcessor |
	aCart := self createCart.	
	aCart add: self bookFromTheEditorial quantity: 2.	
	cashier := self createCashier.
	creditCard := self createCreditCard.
	merchantProcessor := MerchantProcessorUnsuccessfulMock new.
	
	self 
	should: [ cashier checkOutCart: aCart withCreditCard: creditCard withMerchantProcessor: merchantProcessor forAmount: 100 * peso ]
	raise: Error 
	withExceptionDo: [ :anException |
			self assert: anException messageText equals: 'an unexpected error occured'.
		]! !


!CashierTest methodsFor: 'private' stamp: 'SO 2/13/2021 00:27:23'!
bookFromTheEditorial

	^ 'ABC123'! !

!CashierTest methodsFor: 'private' stamp: 'SO 2/17/2021 20:13:31'!
createCart

	| aCatalog |
	aCatalog := EditorialCatalog initialize.
	^Cart withCatalog: aCatalog.! !

!CashierTest methodsFor: 'private' stamp: 'SO 2/17/2021 20:14:08'!
createCashier

	| aCatalog |
	aCatalog := EditorialCatalog initialize.
	^Cashier initializeWithCatalog: aCatalog.! !

!CashierTest methodsFor: 'private' stamp: 'SO 2/17/2021 22:57:58'!
createCreditCard

	| creditCardNumber expirationMonth expirationYear ownerName |
	
	creditCardNumber := 123123123123.
	expirationMonth := Month current monthIndex.
	expirationYear := Year current yearNumber.
	ownerName := 'asd'.
	
	^CreditCard initializeWithNumber: creditCardNumber withExpirationMonth: expirationMonth withExpirationYear: expirationYear withOwnerName: ownerName ! !


!classDefinition: #CreditCardTest category: 'TusLibros'!
TestCase subclass: #CreditCardTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCardTest methodsFor: 'tests' stamp: 'SO 2/17/2021 22:46:46'!
test01ACreditCardMustHaveAnExpirationYearEqualOrGreaterThanCurrentYear

	| creditCardNumber expirationMonth expirationYear ownerName |
	
	creditCardNumber := 123123123123.
	expirationMonth := Month current monthIndex.
	expirationYear := Year current previous yearNumber.
	ownerName := 'asd'.

	self 
	should: [ CreditCard initializeWithNumber: creditCardNumber withExpirationMonth: expirationMonth withExpirationYear: expirationYear withOwnerName: ownerName ] 
	raise: Error 
	withExceptionDo: [ :anException | 
		self assert: anException messageText equals: CreditCard expiredCardErrorDescription.
		]! !

!CreditCardTest methodsFor: 'tests' stamp: 'SO 2/17/2021 22:47:38'!
test02ACreditCardMustHaveMonthAndAYearEqualOrGreaterThanCurrentMonthAndYear

	| creditCardNumber expirationMonth expirationYear ownerName |
	
	creditCardNumber := 123123123123.
	expirationMonth := (Month current previous) monthIndex.
	expirationYear := Year current yearNumber.
	ownerName := 'asd'.

	self 
	should: [ CreditCard initializeWithNumber: creditCardNumber withExpirationMonth: expirationMonth withExpirationYear: expirationYear withOwnerName: ownerName ] 
	raise: Error 
	withExceptionDo: [ :anException | 
		self assert: anException messageText equals: CreditCard expiredCardErrorDescription.
		]! !

!CreditCardTest methodsFor: 'tests' stamp: 'SO 2/17/2021 22:48:10'!
test03ACreditCardCannotHaveAnOwnersNameWithMoreThan30Characters

	| creditCardNumber expirationMonth expirationYear ownerName |
	
	creditCardNumber := 123123123123.
	expirationMonth := (Month current next) monthIndex.
	expirationYear := Year current yearNumber.
	ownerName := 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'.

	self 
	should: [ CreditCard initializeWithNumber: creditCardNumber withExpirationMonth: expirationMonth withExpirationYear: expirationYear withOwnerName: ownerName ] 
	raise: Error 
	withExceptionDo: [ :anException | 
		self assert: anException messageText equals: CreditCard ownerNameTooLongErrorDescription.
		]! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'books bookCatalog'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'initialization' stamp: 'LL 1/21/2021 20:26:42'!
initializeWithCatalog: aBookCatalog
	
	bookCatalog := aBookCatalog.
	books := Bag new! !


!Cart methodsFor: 'adding' stamp: 'LL 1/21/2021 20:24:07'!
add: aBook
	
	self add: aBook quantity: 1.! !

!Cart methodsFor: 'adding' stamp: 'LL 1/21/2021 20:23:42'!
add: aBook quantity: numberOfBooksToAdd

	self assertIsInCatalog: aBook.
	self assertValidNumberOfCopies: numberOfBooksToAdd.
	
	books add: aBook withOccurrences: numberOfBooksToAdd.! !


!Cart methodsFor: 'accessing' stamp: 'LL 1/20/2021 22:11:43'!
contents
	^books copy! !

!Cart methodsFor: 'accessing' stamp: 'LL 1/21/2021 21:39:26'!
includes: aBook

	^ books includes: aBook! !

!Cart methodsFor: 'accessing' stamp: 'LL 1/20/2021 21:51:06'!
quantityOf: aBook
	
	^books occurrencesOf: aBook! !


!Cart methodsFor: 'testing' stamp: 'LL 1/20/2021 21:33:04'!
isEmpty

	^books isEmpty! !


!Cart methodsFor: 'private - assertions' stamp: 'SO 2/17/2021 20:12:02'!
assertIsInCatalog: aBook

	^ (bookCatalog hasBook: aBook) ifFalse: [ self error: self class bookNotInCatalogErrorMessage ]! !

!Cart methodsFor: 'private - assertions' stamp: 'LL 1/21/2021 21:27:21'!
assertValidNumberOfCopies: numberOfBooksToAdd

	^ numberOfBooksToAdd strictlyPositive ifFalse: [ self error: self class invalidNumberOfCopiesErrorMessage ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'LL 1/20/2021 21:37:38'!
withCatalog: aBookCatalog
 
	^self new initializeWithCatalog: aBookCatalog ! !


!Cart class methodsFor: 'error messages' stamp: 'LL 1/20/2021 21:45:09'!
bookNotInCatalogErrorMessage

	^'Cannot add a book that is not from the editorial'! !

!Cart class methodsFor: 'error messages' stamp: 'LL 1/21/2021 21:27:21'!
invalidNumberOfCopiesErrorMessage

	^'Cannot add zero books'! !


!classDefinition: #Cashier category: 'TusLibros'!
Object subclass: #Cashier
	instanceVariableNames: 'bookCatalog purchaseHistory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'initialization' stamp: 'SO 2/17/2021 19:57:34'!
initializeWithCatalog: aCatalog 
	
	bookCatalog := aCatalog.
	purchaseHistory := OrderedCollection new.! !


!Cashier methodsFor: 'errors' stamp: 'SO 2/17/2021 23:47:40'!
emptyCartErrorDescription
	^'Cannot checkout an empty cart'! !

!Cashier methodsFor: 'errors' stamp: 'SO 2/17/2021 23:47:24'!
invalidAmountErrorDescription
	^'Invalid amount'! !

!Cashier methodsFor: 'errors' stamp: 'SO 2/17/2021 19:25:58'!
signalEmptyCartError
	^self error: self emptyCartErrorDescription ! !

!Cashier methodsFor: 'errors' stamp: 'SO 2/17/2021 23:46:44'!
signalInvalidAmountError
	^self error: self invalidAmountErrorDescription ! !


!Cashier methodsFor: 'private' stamp: 'SO 2/18/2021 14:44:18'!
formatAmount: anAmount

	| truncatedAmount |
	
	truncatedAmount := (anAmount * 100) truncated.
	
	^truncatedAmount / 100 asFloat.! !


!Cashier methodsFor: 'testing' stamp: 'SO 2/13/2021 01:03:19'!
lastPurchaseAmount
	
	^purchaseHistory last! !

!Cashier methodsFor: 'testing' stamp: 'SO 2/17/2021 19:05:12'!
totalPurchaseHistoryAmount
	
	^purchaseHistory sum! !


!Cashier methodsFor: 'asserts - private' stamp: 'SO 2/18/2021 14:40:45'!
assertValidAmount: anAmount

	(anAmount isZero or: [ anAmount amount integerPart > 999999999999 ]) ifTrue: [ ^self signalInvalidAmountError ].! !


!Cashier methodsFor: 'checkout' stamp: 'SO 2/18/2021 14:44:24'!
checkOutCart: aCart withCreditCard: aCreditCard withMerchantProcessor: aMerchantProcessor forAmount: anAmount 
	
	| purchaseAmount transactionAmount |
	aCart isEmpty ifTrue: [ ^self signalEmptyCartError ].
	self assertValidAmount: anAmount.
	
	transactionAmount := self formatAmount: anAmount.
	
	purchaseAmount := aCart contents sum: [ :aBook | bookCatalog priceOf: aBook 		].
	
	aMerchantProcessor processTransactionWithCreditCard: aCreditCard forAmount: transactionAmount.
	
	purchaseHistory add: purchaseAmount.
	
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: 'TusLibros'!
Cashier class
	instanceVariableNames: 'catalog'!

!Cashier class methodsFor: 'initialization' stamp: 'SO 2/13/2021 00:57:55'!
initializeWithCatalog: aCatalog 
	
	| cashier |
	
	cashier := Cashier new.
	
	cashier initializeWithCatalog: aCatalog.
	
	^cashier.! !


!classDefinition: #CreditCard category: 'TusLibros'!
Object subclass: #CreditCard
	instanceVariableNames: 'creditCardNumber expirationDate ownerName'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'initialization' stamp: 'SO 2/17/2021 22:45:18'!
initializeWithNumber: aCreditCardNumber withExpirationMonth: anExpirationMonth withExpirationYear: anExpirationYear withOwnerName: anOwnerName

	creditCardNumber := aCreditCardNumber.
	expirationDate := Month month: anExpirationMonth year: anExpirationYear.
	ownerName := anOwnerName.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: 'TusLibros'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'errors' stamp: 'SO 2/17/2021 21:07:15'!
expiredCardErrorDescription
	
	
	^'this card is expired'! !

!CreditCard class methodsFor: 'errors' stamp: 'SO 2/17/2021 22:40:37'!
ownerNameTooLongErrorDescription
	
	^'owner''s name must have a maximum of 30 characters'! !

!CreditCard class methodsFor: 'errors' stamp: 'SO 2/17/2021 21:22:23'!
signalExpiredCardError

	self error: self expiredCardErrorDescription.! !

!CreditCard class methodsFor: 'errors' stamp: 'SO 2/17/2021 22:41:43'!
signalOwnerNameTooLongError

	self error: self ownerNameTooLongErrorDescription.! !


!CreditCard class methodsFor: 'instance creation' stamp: 'SO 2/17/2021 22:42:59'!
initializeWithNumber: aCreditCardNumber withExpirationMonth: anExpirationMonth withExpirationYear: anExpirationYear withOwnerName: anOwnerName

	| creditCard |
	
	self assertExpirationDateWithMonth: anExpirationMonth andYear: anExpirationYear.
	self assertValidOwnerName: anOwnerName.
	
	creditCard := CreditCard new.
	
	creditCard initializeWithNumber: aCreditCardNumber withExpirationMonth: anExpirationMonth withExpirationYear: anExpirationYear withOwnerName: anOwnerName.
	
	^creditCard.! !


!CreditCard class methodsFor: 'asserts - private' stamp: 'SO 2/17/2021 22:34:45'!
assertExpirationDateWithMonth: anExpirationMonth andYear: anExpirationYear

	Year current yearNumber > anExpirationYear ifTrue: [ self signalExpiredCardError ].
	(Year current yearNumber = anExpirationYear and: [ Month current monthIndex > anExpirationMonth ]) ifTrue: [ self signalExpiredCardError ]! !

!CreditCard class methodsFor: 'asserts - private' stamp: 'SO 2/17/2021 22:43:11'!
assertValidOwnerName: anOwnerName

	anOwnerName size > 30 ifTrue: [ self signalOwnerNameTooLongError ]! !


!classDefinition: #EditorialCatalog category: 'TusLibros'!
Object subclass: #EditorialCatalog
	instanceVariableNames: 'bookCatalog'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!EditorialCatalog methodsFor: 'initialization - private' stamp: 'SO 2/17/2021 20:13:07'!
initialize

	bookCatalog := Dictionary new.
	
	bookCatalog add: ( Association key: 'ABC123' value: (10 * peso)).! !


!EditorialCatalog methodsFor: 'accessing' stamp: 'SO 2/17/2021 20:12:31'!
hasBook: aBook
	
	^bookCatalog includesKey: aBook.! !

!EditorialCatalog methodsFor: 'accessing' stamp: 'SO 2/17/2021 20:16:37'!
priceOf: aBook
	
	^bookCatalog at: aBook.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'EditorialCatalog class' category: 'TusLibros'!
EditorialCatalog class
	instanceVariableNames: ''!

!EditorialCatalog class methodsFor: 'instance creation' stamp: 'SO 2/17/2021 20:04:42'!
initialize

	| catalog |
	
	catalog := EditorialCatalog new.

	catalog initialize.
	
	^catalog.! !


!classDefinition: #MerchantProcessorMock category: 'TusLibros'!
Object subclass: #MerchantProcessorMock
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!MerchantProcessorMock methodsFor: 'transaction-processing' stamp: 'SO 2/17/2021 23:17:01'!
processTransactionWithCreditCard: aCreditCard forAmount: anAmount

	^self subclassResponsibility.! !


!classDefinition: #MerchantProcessorParameterErrorMock category: 'TusLibros'!
MerchantProcessorMock subclass: #MerchantProcessorParameterErrorMock
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!MerchantProcessorParameterErrorMock methodsFor: 'transaction-processing' stamp: 'SO 2/17/2021 23:16:41'!
processTransactionWithCreditCard: aCreditCard forAmount: anAmount

	^self error: 'the parameters have an incorrect format'! !


!classDefinition: #MerchantProcessorSuccessMock category: 'TusLibros'!
MerchantProcessorMock subclass: #MerchantProcessorSuccessMock
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!MerchantProcessorSuccessMock methodsFor: 'transaction-processing' stamp: 'SO 2/17/2021 23:22:46'!
processTransactionWithCreditCard: aCreditCard forAmount: anAmount

	! !


!classDefinition: #MerchantProcessorUnsuccessfulMock category: 'TusLibros'!
MerchantProcessorMock subclass: #MerchantProcessorUnsuccessfulMock
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!MerchantProcessorUnsuccessfulMock methodsFor: 'transaction-processing' stamp: 'SO 2/17/2021 23:27:04'!
processTransactionWithCreditCard: aCreditCard forAmount: anAmount

	^self error: 'an unexpected error occured'! !

EditorialCatalog initialize!