!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: 'objectsFactory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'tests' stamp: 'LL 2/16/2021 19:50:24'!
setUp

	objectsFactory := PublisherTestObjectsFactory new! !

!CartTest methodsFor: 'tests' stamp: 'LL 1/21/2021 20:09:58'!
test01NewCartIsEmpty

	| cart |
	
	cart := self createCart.
	
	self assert: cart isEmpty.! !

!CartTest methodsFor: 'tests' stamp: 'LL 2/16/2021 19:50:24'!
test02CanAddABookToACart

	| cart |
	cart := self createCart.
	
	cart add: objectsFactory bookFromTheEditorial.
	
	self deny: cart isEmpty.! !

!CartTest methodsFor: 'tests' stamp: 'LL 1/21/2021 21:25:18'!
test03CannotAddABookNotInCatalog

	| cart bookNotInCatalog |
	cart := self createCart.
	bookNotInCatalog := 'DEF456'.

	self assert: cart isEmptyAfter: [ cart add: bookNotInCatalog ] raisesErrorWithMessage: Cart bookNotInCatalogErrorMessage.
	! !

!CartTest methodsFor: 'tests' stamp: 'LL 2/16/2021 19:50:24'!
test04CanAddTwoCopiesOfABook

	| cart |
	cart := self createCart.
	
	cart add: objectsFactory bookFromTheEditorial quantity: 2.
	
	self assert: (cart quantityOf: objectsFactory bookFromTheEditorial) equals: 2.! !

!CartTest methodsFor: 'tests' stamp: 'LL 2/16/2021 19:50:24'!
test05CannotAddNonPositiveNumberOfCopiesOfABook

	| cart |
	cart := self createCart.

	self assert: cart isEmptyAfter: [ cart add: objectsFactory bookFromTheEditorial quantity: -1 ] raisesErrorWithMessage: Cart invalidNumberOfCopiesErrorMessage.! !

!CartTest methodsFor: 'tests' stamp: 'LL 2/16/2021 19:50:24'!
test06CartRemembersAddedBooks

	| cart |
	cart := self createCart.
	
	cart add: objectsFactory bookFromTheEditorial quantity: 2.
	cart add: objectsFactory bookFromTheEditorial quantity: 1.
	
	self assert: (cart includes: objectsFactory bookFromTheEditorial).
	self assert: (cart quantityOf: objectsFactory bookFromTheEditorial) equals: 3! !

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

!CartTest methodsFor: 'private' stamp: 'LL 2/16/2021 19:50:24'!
createCart

	^ objectsFactory anEmptyCart! !


!classDefinition: #CashierTest category: 'TusLibros'!
TestCase subclass: #CashierTest
	instanceVariableNames: 'objectsFactory merchantProcessorBehaviour'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'tests' stamp: 'LL 2/16/2021 19:50:04'!
setUp

	objectsFactory := PublisherTestObjectsFactory new.
	merchantProcessorBehaviour := [ :anAmountToDebit :aCreditCard |  ]! !

!CashierTest methodsFor: 'tests' stamp: 'LL 2/16/2021 19:51:40'!
test01CannotCheckoutAnEmptyCart

	| cart salesBook cashier |
	cart := objectsFactory anEmptyCart.
	salesBook := objectsFactory anEmptySalesBook.
	cashier := Cashier registeringSalesOn: salesBook.
	
	self should: [ self cashier: cashier checkout: cart ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anException |
			self assert: anException messageText equals: Cashier cannotCheckoutAnEmptyCart.
			self assert: salesBook isEmpty
		]! !

!CashierTest methodsFor: 'tests' stamp: 'LL 2/16/2021 19:50:05'!
test02TotalIsCalculatedCorrectlyAfterCheckout

	| cart ticket cashier |
	cart := objectsFactory cartWithABook.
	cashier := objectsFactory aCashier.
	
	ticket := self cashier: cashier checkout: cart.
	
	self assert: objectsFactory bookFromTheEditorialPrice equals: ticket value.! !

!CashierTest methodsFor: 'tests' stamp: 'LL 2/16/2021 19:51:50'!
test03CannotCheckoutIfCardIsExpired

	| cart cashier merchantProcessorWasContacted salesBook |
	cart := objectsFactory cartWithABook.
	salesBook := objectsFactory anEmptySalesBook.
	cashier := Cashier registeringSalesOn: salesBook.
	
	merchantProcessorWasContacted := false.
	self merchantProcessorBehaviour: [ :amountToDebit :aCreditCard |  merchantProcessorWasContacted := true ].
	
	self should: [ self cashier: cashier checkout: cart debitingOn: objectsFactory anExpiredCreditCard ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anException |
			self assert: anException messageText equals: Cashier cannotCheckoutUsingAnExpiredCard.
			self deny: merchantProcessorWasContacted.
			self assert: salesBook isEmpty.
		]! !

!CashierTest methodsFor: 'tests' stamp: 'LL 2/16/2021 23:04:34'!
test04CheckoutDebitsCreditCardUsingMerchantProcessor

	| cart ticket cashier debitedAmountFromCreditCard debitedCreditCard creditCard |
	cart := objectsFactory cartWithABook.
	cashier := objectsFactory aCashier.
	creditCard := objectsFactory aValidCreditCard.
		
	self merchantProcessorBehaviour: [ :anAmountToDebit :aCreditCard | 
		debitedAmountFromCreditCard := anAmountToDebit.
		debitedCreditCard := aCreditCard.
	].
	
	ticket := self cashier: cashier checkout: cart debitingOn: creditCard.
	
	self assert: debitedAmountFromCreditCard equals: ticket value.
	self assert: debitedCreditCard equals: creditCard.! !

!CashierTest methodsFor: 'tests' stamp: 'LL 2/16/2021 19:51:58'!
test05CheckoutFailsIfMerchantProcessorCantProcessPayment

	| cart cashier salesBook |
	cart := objectsFactory cartWithABook.
	salesBook := objectsFactory anEmptySalesBook.
	cashier := Cashier registeringSalesOn: salesBook.
	
	self merchantProcessorBehaviour: [ :anAmountToDebit :aCreditCard | Error new signal ].
	
	self should: [ self cashier: cashier checkout: cart ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :exceptionRaised | 
			self assert: exceptionRaised messageText equals: Cashier couldNotProcessPaymentErrorMessage.
			self assert: salesBook isEmpty.
		]! !

!CashierTest methodsFor: 'tests' stamp: 'LL 2/16/2021 19:52:03'!
test06CheckingOutACartRegistersASale

	| cart cashier ticket salesBook |
	cart := objectsFactory cartWithABook.
	salesBook := objectsFactory anEmptySalesBook.
	cashier := Cashier registeringSalesOn: salesBook.	
	
	ticket := self cashier: cashier checkout: cart.
	
	self assert: salesBook size equals: 1.
	self assert: salesBook first equals: ticket.! !


!CashierTest methodsFor: 'merchat processor protocol' stamp: 'LL 1/24/2021 18:26:00'!
debit: anAmountToDebit from: aCreditCard

	^merchantProcessorBehaviour value: anAmountToDebit value: aCreditCard! !


!CashierTest methodsFor: 'change mp behaviour' stamp: 'LL 1/24/2021 18:26:00'!
merchantProcessorBehaviour: newBehaviour

	merchantProcessorBehaviour := newBehaviour! !


!CashierTest methodsFor: 'private' stamp: 'LL 2/16/2021 19:50:05'!
cashier: cashier checkout: cart

	^self cashier: cashier checkout: cart debitingOn: objectsFactory aValidCreditCard! !

!CashierTest methodsFor: 'private' stamp: 'LL 2/16/2021 19:50:04'!
cashier: cashier checkout: cart debitingOn: aCreditCard

	^cashier checkout: cart payingWith: aCreditCard through: self merchantProcessorForTest on: objectsFactory now.! !

!CashierTest methodsFor: 'private' stamp: 'LL 2/16/2021 18:29:57'!
merchantProcessorForTest
	
	^self! !


!classDefinition: #CreditCardTest category: 'TusLibros'!
TestCase subclass: #CreditCardTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCardTest methodsFor: 'tests' stamp: 'LL 1/24/2021 18:15:23'!
test01CreditCardOwnerNameCannotBeBlank

	^self should: [ CreditCard of: '' number: 11111111 expiringOn: (FixedGregorianDate today) monthOfYear ] 
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :exceptionRaised | 
			self assert: exceptionRaised messageText equals: CreditCard nameCannotBeBlankErrorMessage.
		]! !


!classDefinition: #StorefrontTest category: 'TusLibros'!
TestCase subclass: #StorefrontTest
	instanceVariableNames: 'objectsFactory merchantProcessorBehaviour'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!StorefrontTest methodsFor: 'tests' stamp: 'SO 2/24/2021 23:17:00'!
test01cannotCreateACartWithEmptyCredentials
	
	| storefront |
	storefront := Storefront initializeWithCatalog: self createCatalog .
	
	self should: [ storefront createCartWithId: '' andPassword: '' . ]
	raise: Error 
	withExceptionDo: [ :anException |
		self assert: anException messageText equals: storefront wrongCredentialsErrorDescription.
	]! !

!StorefrontTest methodsFor: 'tests' stamp: 'SO 2/24/2021 23:17:22'!
test02cannotCreateACartWithWrongCredentials
	
	| storefront |
	storefront := Storefront initializeWithCatalog: self createCatalog .
	
	self should: [ storefront createCartWithId: 'pepe' andPassword: 'asd123'. ]
	raise: Error 
	withExceptionDo: [ :anException |
		self assert: anException messageText equals: storefront wrongCredentialsErrorDescription.
	]! !

!StorefrontTest methodsFor: 'tests' stamp: 'SO 2/24/2021 23:17:54'!
test03aNewCartIsEmpty
	
	| storefront cartId |
	storefront := Storefront initializeWithCatalog: self createCatalog .
	
	cartId := storefront createCartWithId: self validUserId andPassword: self validUserPassword.
	self assert: (storefront listCart: cartId) isEmpty.! !

!StorefrontTest methodsFor: 'tests' stamp: 'SO 2/24/2021 23:18:18'!
test04aStoreFrontCanAddBooksToAnExistingCart
	
	| storefront cartId expectedResult |
	storefront := Storefront initializeWithCatalog: self createCatalog .
	expectedResult := Dictionary with: (Association key: objectsFactory bookFromTheEditorial value: 2).
	
	cartId := storefront createCartWithId: self validUserId andPassword: self validUserPassword .
	storefront addBook: objectsFactory bookFromTheEditorial toCart: cartId numberOfCopies: 2.
	self assert: (storefront listCart: cartId ) equals: expectedResult.! !

!StorefrontTest methodsFor: 'tests' stamp: 'SO 2/24/2021 23:18:45'!
test05aStoreFrontCanAddBooksToMultipleCarts

	| storefront cartId1  cartId2 expectedResult |
	storefront := Storefront initializeWithCatalog: self createCatalog .
	expectedResult := Dictionary with: (Association key: objectsFactory bookFromTheEditorial value: 2).
	
	cartId1 := storefront createCartWithId: self validUserId andPassword: self validUserPassword.
	cartId2 := storefront createCartWithId: self validUserId andPassword: self validUserPassword.
	storefront addBook: objectsFactory bookFromTheEditorial toCart: cartId1 numberOfCopies: 2.
	
	self assert: (storefront listCart: cartId1 ) equals: expectedResult.	
	self assert: (storefront listCart: cartId2 ) isEmpty.! !

!StorefrontTest methodsFor: 'tests' stamp: 'SO 2/24/2021 23:18:52'!
test06cannotAddABookToANonExistentCart
	
	| storefront cartId |
	storefront := Storefront initializeWithCatalog: self createCatalog .
	cartId := 1.
	
	self should: [ storefront addBook: objectsFactory bookFromTheEditorial toCart: cartId numberOfCopies: 2. ] 
	raise: Error 
	withExceptionDo: [ :anException |
			self assert: anException messageText equals: storefront couldNotFindCartErrorDescription.
		].! !

!StorefrontTest methodsFor: 'tests' stamp: 'SO 2/24/2021 23:29:50'!
test07cannotListPurchasesWithWrongCredentials

	| storefront |
	
	storefront := Storefront initializeWithCatalog: self createCatalog .
		
	self should: [ storefront listPurchasesOf: self validUserId withPassword: 'asd' . ]
	raise: Error 
	withExceptionDo: [ :anException |
		self assert: anException messageText equals: storefront wrongCredentialsErrorDescription.
	]

! !

!StorefrontTest methodsFor: 'tests' stamp: 'SO 2/25/2021 14:21:50'!
test08checkingOutACartRegistersTheTransaction

	| storefront totalTransaction expectedPurchaseDetail expectedTotalAmount |
	
	storefront := Storefront initializeWithCatalog: self createCatalog .
	expectedPurchaseDetail := Dictionary with: ( Association key: (objectsFactory bookFromTheEditorial ) value: 2 ).
	expectedTotalAmount := (objectsFactory bookFromTheEditorialPrice * 2).
	
	self checkoutNumberOfBooks: 2 from: storefront.
		
	totalTransaction := storefront listPurchasesOf: self validUserId withPassword: self validUserPassword.
	
.	self assert: (totalTransaction 	isPurchaseDetailOfTransaction: expectedPurchaseDetail).
.	self assert: (totalTransaction 	isTotalAmountOfTransaction: expectedTotalAmount).

! !

!StorefrontTest methodsFor: 'tests' stamp: 'SO 2/25/2021 14:21:27'!
test09checkingOutMultipleCartsFromSameUserRegistersAllOfTheTransactions

	| storefront totalTransaction expectedPurchaseDetail expectedTotalAmount |
	
	storefront := Storefront initializeWithCatalog: self createCatalog .
	expectedPurchaseDetail := Dictionary with: ( Association key: (objectsFactory bookFromTheEditorial ) value: 3 ).
	expectedTotalAmount := (objectsFactory bookFromTheEditorialPrice * 3).
	
	self checkoutNumberOfBooks: 2 from: storefront.
	
	self checkoutNumberOfBooks: 1 from: storefront.
		
	totalTransaction := storefront listPurchasesOf: self validUserId withPassword: self validUserPassword.
	
.	self assert: (totalTransaction 	isPurchaseDetailOfTransaction: expectedPurchaseDetail).
.	self assert: (totalTransaction 	isTotalAmountOfTransaction: expectedTotalAmount).

! !

!StorefrontTest methodsFor: 'tests' stamp: 'SO 2/24/2021 23:29:26'!
test10cannotAddABookToAnExpiredCart

	| aBook cartId storefront |
	
	storefront := Storefront initialize.
	aBook := 'ASD123'.
	cartId := storefront createCartWithId: self validUserId andPassword: self validUserPassword.	
	
	self 
	should: [ storefront addBook: aBook toCart: cartId ]
	raise: Error
	withExceptionDo: [ :anException | 
			self assert: anException messageText equals: storefront expiredCartErrorDescription.
		]! !


!StorefrontTest methodsFor: 'as yet unclassified' stamp: 'SO 2/25/2021 13:47:54'!
checkout: aCartId from: aStorefront

	aStorefront checkOutCart: aCartId 
		withCreditCard: objectsFactory 
		aValidCreditCard onCashier: objectsFactory aCashier 
		through: self merchantProcessorForTest 
		onDateTime: objectsFactory now.! !

!StorefrontTest methodsFor: 'as yet unclassified' stamp: 'SO 2/25/2021 14:20:44'!
checkoutNumberOfBooks: aNumberOfBooks from: aStorefront

	| cartId |
	cartId := aStorefront createCartWithId: self validUserId andPassword: self validUserPassword.		
	aStorefront addBook: objectsFactory bookFromTheEditorial toCart: cartId numberOfCopies: aNumberOfBooks.
	self checkout: cartId from: aStorefront.! !

!StorefrontTest methodsFor: 'as yet unclassified' stamp: 'SO 2/24/2021 16:55:21'!
createCatalog

	^Dictionary newFromPairs: {objectsFactory bookFromTheEditorial. objectsFactory bookFromTheEditorialPrice}.! !

!StorefrontTest methodsFor: 'as yet unclassified' stamp: 'SO 2/24/2021 21:27:32'!
debit: anAmountToDebit from: aCreditCard

	^merchantProcessorBehaviour value: anAmountToDebit value: aCreditCard! !

!StorefrontTest methodsFor: 'as yet unclassified' stamp: 'SO 2/24/2021 21:27:46'!
merchantProcessorBehaviour: newBehaviour

	merchantProcessorBehaviour := newBehaviour! !

!StorefrontTest methodsFor: 'as yet unclassified' stamp: 'SO 2/24/2021 21:25:26'!
merchantProcessorForTest
	
	^self! !

!StorefrontTest methodsFor: 'as yet unclassified' stamp: 'SO 2/24/2021 21:31:54'!
setUp

	objectsFactory := PublisherTestObjectsFactory new.
	merchantProcessorBehaviour := [ :anAmountToDebit :aCreditCard |  ]! !

!StorefrontTest methodsFor: 'as yet unclassified' stamp: 'SO 2/22/2021 21:08:13'!
validUserId

	^'pepe'! !

!StorefrontTest methodsFor: 'as yet unclassified' stamp: 'SO 2/22/2021 21:08:28'!
validUserPassword

	^'pass123'! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'books bookCatalog'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'initialization' stamp: 'LL 1/25/2021 18:50:24'!
initializeWithCatalog: aBookCatalog
	
	bookCatalog := aBookCatalog.
	books := Bag new.! !


!Cart methodsFor: 'adding' stamp: 'LL 1/21/2021 20:24:07'!
add: aBook
	
	self add: aBook quantity: 1.! !

!Cart methodsFor: 'adding' stamp: 'LL 1/21/2021 20:23:42'!
add: aBook quantity: numberOfBooksToAdd

	self assertIsInCatalog: aBook.
	self assertValidNumberOfCopies: numberOfBooksToAdd.
	
	books add: aBook withOccurrences: numberOfBooksToAdd.! !


!Cart methodsFor: 'accessing' stamp: 'LL 1/20/2021 21:51:06'!
quantityOf: aBook
	
	^books occurrencesOf: aBook! !

!Cart methodsFor: 'accessing' stamp: 'LL 1/24/2021 17:42:15'!
total
	
	^books sum: [ :aBook | bookCatalog at: aBook ].! !


!Cart methodsFor: 'testing' stamp: 'LL 1/21/2021 21:39:26'!
includes: aBook

	^ books includes: aBook! !

!Cart methodsFor: 'testing' stamp: 'LL 1/20/2021 21:33:04'!
isEmpty

	^books isEmpty! !


!Cart methodsFor: 'private - assertions' stamp: 'LL 1/24/2021 15:49:03'!
assertIsInCatalog: aBook

	^ (bookCatalog includesKey: aBook) ifFalse: [ self error: self class bookNotInCatalogErrorMessage ]! !

!Cart methodsFor: 'private - assertions' stamp: 'LL 1/21/2021 21:27:21'!
assertValidNumberOfCopies: numberOfBooksToAdd

	^ numberOfBooksToAdd strictlyPositive ifFalse: [ self error: self class invalidNumberOfCopiesErrorMessage ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'LL 1/25/2021 18:29:34'!
acceptingItemsOf: aBookCatalog
 
	^self new initializeWithCatalog: aBookCatalog ! !


!Cart class methodsFor: 'error messages' stamp: 'LL 1/20/2021 21:45:09'!
bookNotInCatalogErrorMessage

	^'Cannot add a book that is not from the editorial'! !

!Cart class methodsFor: 'error messages' stamp: 'LL 1/21/2021 21:27:21'!
invalidNumberOfCopiesErrorMessage

	^'Cannot add zero books'! !


!classDefinition: #Cashier category: 'TusLibros'!
Object subclass: #Cashier
	instanceVariableNames: 'salesBook'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'initialization' stamp: 'LL 1/25/2021 18:49:19'!
initializeWithSalesBook: aSalesBook

	salesBook := aSalesBook! !


!Cashier methodsFor: 'checkout' stamp: 'LL 1/25/2021 23:10:38'!
checkout: aCart payingWith: aCreditCard through: aMerchantProcessor on: aCheckoutDateTime  

	| ticket |
	self assertCanCheckout: aCart using: aCreditCard on: aCheckoutDateTime.
	
	ticket := aCart total.
	
	self debit: ticket value from: aCreditCard using: aMerchantProcessor.
	
	self registerSale: ticket.
	
	^ticket! !


!Cashier methodsFor: 'assertions' stamp: 'LL 1/25/2021 23:10:22'!
assertCanCheckout: aCart using: aCreditCard on: aDateTime 

	self assertContainsBooks: aCart.
	self assertIsNotExpired: aCreditCard on: aDateTime! !

!Cashier methodsFor: 'assertions' stamp: 'LL 1/24/2021 17:45:42'!
assertContainsBooks: aCart

	^ aCart isEmpty ifTrue: [	 self error: Cashier cannotCheckoutAnEmptyCart ]! !

!Cashier methodsFor: 'assertions' stamp: 'LL 1/25/2021 23:11:12'!
assertIsNotExpired: aCreditCard on: aDateTime 

	^ (aCreditCard isExpiredOn: aDateTime) ifTrue: [ self error: Cashier cannotCheckoutUsingAnExpiredCard ]! !


!Cashier methodsFor: 'private' stamp: 'LL 1/24/2021 18:23:28'!
debit: anAmount from: aCreditCard using: aMerchantProcessor

	^ [ aMerchantProcessor debit: anAmount from: aCreditCard ]
		on: Error - MessageNotUnderstood 
		do: [ :exceptionRaised |
			self error: self class couldNotProcessPaymentErrorMessage.
		]! !

!Cashier methodsFor: 'private' stamp: 'LL 1/25/2021 19:50:24'!
registerSale: ticket

	^ salesBook add: ticket! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: 'TusLibros'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'as yet unclassified' stamp: 'LL 1/21/2021 21:50:07'!
cannotCheckoutAnEmptyCart
	^'Cannot checkout an empty cart'! !

!Cashier class methodsFor: 'as yet unclassified' stamp: 'LL 1/24/2021 16:44:06'!
cannotCheckoutUsingAnExpiredCard

	^'Cannot checkout using an expired card'! !

!Cashier class methodsFor: 'as yet unclassified' stamp: 'LL 1/24/2021 18:13:36'!
couldNotProcessPaymentErrorMessage

	^'Cart was rejected'! !

!Cashier class methodsFor: 'as yet unclassified' stamp: 'LL 1/25/2021 18:48:59'!
registeringSalesOn: aSalesBook

	^ self new initializeWithSalesBook: aSalesBook.! !


!classDefinition: #CredentialAuthenticator category: 'TusLibros'!
Object subclass: #CredentialAuthenticator
	instanceVariableNames: 'credentials'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CredentialAuthenticator methodsFor: 'as yet unclassified' stamp: 'PB 2/21/2021 23:32:54'!
initialize
	credentials  := Dictionary with: (Association key: 'pepe' value: 'pass123').! !

!CredentialAuthenticator methodsFor: 'as yet unclassified' stamp: 'PB 2/22/2021 00:02:01'!
validateClientId: clientId andPassword: password

	(credentials includesKey: clientId) ifFalse: [ ^ false ].
	(credentials at: clientId) = password ifFalse: [ ^ false ].
	^true.
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CredentialAuthenticator class' category: 'TusLibros'!
CredentialAuthenticator class
	instanceVariableNames: ''!

!CredentialAuthenticator class methodsFor: 'as yet unclassified' stamp: 'PB 2/21/2021 23:30:25'!
initialize
	| credentialAuthenticator |
	credentialAuthenticator := CredentialAuthenticator new.
	credentialAuthenticator  initialize.
	^credentialAuthenticator.! !


!classDefinition: #CreditCard category: 'TusLibros'!
Object subclass: #CreditCard
	instanceVariableNames: 'creditCardNumber owner expirationDate'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'initialization' stamp: 'LL 2/16/2021 18:05:42'!
initializeOf: aPerson number: aCreditCardNumber expiringOn: aMonthOfYear 

	owner := aPerson.
	creditCardNumber := aCreditCardNumber.
	expirationDate := aMonthOfYear.! !


!CreditCard methodsFor: 'testing' stamp: 'LL 2/16/2021 18:05:42'!
isExpiredOn: aDateTime

	^ aDateTime > (expirationDate lastDate)! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: 'TusLibros'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'instance creation' stamp: 'LL 1/24/2021 18:15:40'!
of: nameOfTheOwner number: aCreditCardNumber expiringOn: aMonthOfYear

	nameOfTheOwner isEmpty ifTrue: [ self error: self nameCannotBeBlankErrorMessage ].
	
	^self new initializeOf: nameOfTheOwner number: aCreditCardNumber expiringOn: aMonthOfYear ! !


!CreditCard class methodsFor: 'as yet unclassified' stamp: 'LL 1/24/2021 18:01:14'!
nameCannotBeBlankErrorMessage

	^'Name cannot be blank'! !


!classDefinition: #PublisherTestObjectsFactory category: 'TusLibros'!
Object subclass: #PublisherTestObjectsFactory
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!PublisherTestObjectsFactory methodsFor: 'as yet unclassified' stamp: 'LL 2/16/2021 19:41:18'!
aCashier

	| salesBook |
	salesBook := OrderedCollection new.
	^ Cashier registeringSalesOn: salesBook.! !

!PublisherTestObjectsFactory methodsFor: 'as yet unclassified' stamp: 'LL 2/16/2021 19:45:08'!
aValidCreditCard

	| nextMonth |
	nextMonth := (FixedGregorianDate today next: GregorianMonth oneMonth) monthOfYear.
	^CreditCard of: 'Juan Perez' number: 11111111 expiringOn: nextMonth.! !

!PublisherTestObjectsFactory methodsFor: 'as yet unclassified' stamp: 'LL 1/25/2021 18:29:34'!
anEmptyCart

	| aCatalog |
	aCatalog := Dictionary newFromPairs: {self bookFromTheEditorial. self bookFromTheEditorialPrice}.
	^Cart acceptingItemsOf: aCatalog.! !

!PublisherTestObjectsFactory methodsFor: 'as yet unclassified' stamp: 'LL 2/16/2021 19:51:21'!
anEmptySalesBook

	^OrderedCollection new.! !

!PublisherTestObjectsFactory methodsFor: 'as yet unclassified' stamp: 'LL 2/16/2021 19:43:38'!
anExpiredCreditCard
	
	| lastMonth |
	lastMonth := (FixedGregorianDate today previous: GregorianMonth oneMonth) monthOfYear.
	^CreditCard of: 'Juan Perez' number: 11111111 expiringOn: lastMonth.! !

!PublisherTestObjectsFactory methodsFor: 'as yet unclassified' stamp: 'LL 1/24/2021 15:59:26'!
bookFromTheEditorial

	^ 'ABC123'! !

!PublisherTestObjectsFactory methodsFor: 'as yet unclassified' stamp: 'LL 1/24/2021 17:11:28'!
bookFromTheEditorialPrice

	^ 1000 * peso! !

!PublisherTestObjectsFactory methodsFor: 'as yet unclassified' stamp: 'LL 2/16/2021 19:46:27'!
cartWithABook

	| cart |
	cart := self anEmptyCart.
	cart add: self bookFromTheEditorial.
	^cart! !

!PublisherTestObjectsFactory methodsFor: 'as yet unclassified' stamp: 'LL 2/16/2021 19:48:31'!
now 

	^GregorianDateTime now! !


!classDefinition: #Storefront category: 'TusLibros'!
Object subclass: #Storefront
	instanceVariableNames: 'credentialAuthenticator clients carts transactions purchases catalog'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Storefront methodsFor: 'as yet unclassified' stamp: 'SO 2/25/2021 14:30:50'!
addBook: aBook toCart: aCartId numberOfCopies: aNumber 

	| cart |
	
	cart := self findCart: aCartId.
	cart add: aBook quantity: aNumber.! !

!Storefront methodsFor: 'as yet unclassified' stamp: 'SO 2/25/2021 14:09:05'!
checkOutCart: aCartId withCreditCard: aCreditCard onCashier: aCashier through: aMerchantProcessor onDateTime: aCheckoutDateTime

	| cart totalAmount transactionId purchaseDetail |
	
	cart := self findCart: aCartId.	
	totalAmount := aCashier checkout: cart payingWith: aCreditCard through: aMerchantProcessor on: aCheckoutDateTime.
	purchaseDetail := self listCart: aCartId.
	
	transactionId := self generateNextIdOf: transactions.		
	
	transactions add: ( Association key: transactionId value: (Transaction withPurchaseDetail: purchaseDetail andTotalAmount: totalAmount) ).
	self addToDictionary: purchases withKey: aCartId withValue: transactionId.	
	
	^transactionId.! !

!Storefront methodsFor: 'as yet unclassified' stamp: 'SO 2/24/2021 21:05:41'!
couldNotFindCartErrorDescription
	
	^'the cart could not be found'! !

!Storefront methodsFor: 'as yet unclassified' stamp: 'SO 2/25/2021 14:09:26'!
createCartWithId: aClientId andPassword: aPassword

	| cartId cart |
	
	(credentialAuthenticator validateClientId: aClientId andPassword:aPassword) 
		ifFalse: [self signalWrongCredentialsError]	.
	
	cartId := self generateNextIdOf: carts.	
	cart := Cart acceptingItemsOf: catalog.
	carts add: (Association key: cartId value: cart).	
	self addToDictionary: clients withKey: aClientId withValue: cartId.	
	
	^ cartId.
! !

!Storefront methodsFor: 'as yet unclassified' stamp: 'SO 2/22/2021 21:23:32'!
expiredCartErrorDescription

	^'the cart has expired'! !

!Storefront methodsFor: 'as yet unclassified' stamp: 'SO 2/24/2021 23:20:00'!
initializeWithCatalog: aCatalog
	
	credentialAuthenticator := CredentialAuthenticator initialize.
	clients := Dictionary new.
	carts := Dictionary new.
	transactions := Dictionary new.
	purchases := Dictionary new.
	catalog := aCatalog.! !

!Storefront methodsFor: 'as yet unclassified' stamp: 'SO 2/24/2021 23:14:33'!
listCart: aCartId
	
	| cart listedItems |
	
	cart := self findCart: aCartId.
	listedItems := Dictionary new.
	
	catalog keysDo: [ :aBook | (cart includes: aBook) ifTrue: [ listedItems add: (Association key: aBook value: (cart quantityOf: aBook) ) ] ].
	
	^listedItems! !

!Storefront methodsFor: 'as yet unclassified' stamp: 'SO 2/25/2021 14:16:47'!
listPurchasesOf: aClientId withPassword: aPassword

	| cartIds transactionIds totalAmount totalPurchaseDetail |
	
	(credentialAuthenticator validateClientId: aClientId andPassword:aPassword) 
		ifFalse: [self signalWrongCredentialsError]	.
	
	cartIds := clients at: aClientId.	
	totalAmount := 0.
	totalPurchaseDetail := Dictionary new.
	
	cartIds do: [ :aCartId |
			transactionIds := purchases at: aCartId.
			transactionIds do: [ :aTransactionId | | transaction |
				transaction := transactions at: aTransactionId.			
				transaction addPurchaseDetailTo: totalPurchaseDetail.			
				totalAmount := transaction addToTotalAmount: totalAmount.
			].
		].	
	
	^Transaction withPurchaseDetail: totalPurchaseDetail andTotalAmount: totalAmount.! !

!Storefront methodsFor: 'as yet unclassified' stamp: 'SO 2/24/2021 21:06:41'!
signalCouldNotFindCartError

	self error: self couldNotFindCartErrorDescription.! !

!Storefront methodsFor: 'as yet unclassified' stamp: 'SO 2/22/2021 21:23:17'!
signalExpiredCartError

	^self error: self expiredCartErrorDescription! !

!Storefront methodsFor: 'as yet unclassified' stamp: 'PB 2/21/2021 23:25:15'!
signalWrongCredentialsError
	^self error: self wrongCredentialsErrorDescription.! !

!Storefront methodsFor: 'as yet unclassified' stamp: 'PB 2/21/2021 23:26:20'!
wrongCredentialsErrorDescription
	^ 'invalid credentials'.! !


!Storefront methodsFor: 'private' stamp: 'SO 2/25/2021 14:08:16'!
addToDictionary: aDictionary withKey: aKey withValue: aValueToAdd

	aDictionary at: aKey 
		ifPresent: [ :aValue | aValue add: aValueToAdd ] 
		ifAbsent: [ aDictionary add: (Association key: aKey value: (OrderedCollection with: aValueToAdd) ) ].! !

!Storefront methodsFor: 'private' stamp: 'SO 2/24/2021 21:06:13'!
findCart: cartId

	^ carts at: cartId ifAbsent: [ self signalCouldNotFindCartError ].! !

!Storefront methodsFor: 'private' stamp: 'SO 2/25/2021 13:57:00'!
generateNextIdOf: aDictionary

	(aDictionary isEmpty) ifTrue: [^1].
	(aDictionary isEmpty) ifFalse: [^aDictionary keys last + 1].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Storefront class' category: 'TusLibros'!
Storefront class
	instanceVariableNames: ''!

!Storefront class methodsFor: 'as yet unclassified' stamp: 'SO 2/24/2021 23:15:29'!
initializeWithCatalog: aCatalog

	| storefront |
	
	storefront := Storefront new.
	storefront initializeWithCatalog: aCatalog.
	
	^storefront.! !


!classDefinition: #Transaction category: 'TusLibros'!
Object subclass: #Transaction
	instanceVariableNames: 'purchaseDetail totalAmount'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Transaction methodsFor: 'as yet unclassified' stamp: 'SO 2/24/2021 23:46:16'!
addPurchaseDetailTo: aPurchaseDetail

	purchaseDetail keysDo: [ :aBook |
					aPurchaseDetail 
					at: aBook 
					ifPresent: [ :aValue | aPurchaseDetail at: aBook put: aValue + ( purchaseDetail at: aBook ) ] 
					ifAbsent: [ aPurchaseDetail add: (Association key: aBook value: ( purchaseDetail at: aBook ) ) ].
				].! !

!Transaction methodsFor: 'as yet unclassified' stamp: 'SO 2/24/2021 23:50:52'!
addToTotalAmount: aTotalAmount

	^aTotalAmount + totalAmount! !

!Transaction methodsFor: 'as yet unclassified' stamp: 'SO 2/24/2021 22:27:31'!
initializeWithPurchaseDetail: aPurchaseDetail andTotalAmount: aTotalAmount.

	purchaseDetail := aPurchaseDetail.
	totalAmount := aTotalAmount.! !

!Transaction methodsFor: 'as yet unclassified' stamp: 'SO 2/24/2021 23:38:11'!
isPurchaseDetailOfTransaction: aPurchaseDetail

	^purchaseDetail = aPurchaseDetail.! !

!Transaction methodsFor: 'as yet unclassified' stamp: 'SO 2/24/2021 23:38:02'!
isTotalAmountOfTransaction: aTotalAmount

	^totalAmount = aTotalAmount ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Transaction class' category: 'TusLibros'!
Transaction class
	instanceVariableNames: ''!

!Transaction class methodsFor: 'as yet unclassified' stamp: 'SO 2/24/2021 22:27:02'!
withPurchaseDetail: aPurchaseDetail andTotalAmount: aTotalAmount

	| transaction |
	transaction := Transaction new.
	
	transaction initializeWithPurchaseDetail: aPurchaseDetail andTotalAmount: aTotalAmount.
	
	^transaction.! !

CredentialAuthenticator initialize!