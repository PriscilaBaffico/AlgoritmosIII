!classDefinition: #AccountSummaryTest category: 'ServiciosFinancieros-Solucion-Portfolio'!
TestCase subclass: #AccountSummaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion-Portfolio'!

!AccountSummaryTest methodsFor: 'tests' stamp: 'SO 12/16/2020 18:39:24'!
test01SummaryOfEmptyAccountIsZero

	| account accountSummary expectedSummary |
	
	expectedSummary := OrderedCollection new.
	expectedSummary add: 'Balance = 0 pesos'.
	account := ReceptiveAccount new.
	accountSummary := AccountSummary for: account.
	
	self assert: (accountSummary generateReport = expectedSummary ).! !

!AccountSummaryTest methodsFor: 'tests' stamp: 'SO 12/16/2020 18:39:28'!
test02SummaryOfAccountWithDepositShowsSaidDepositWithCorrectValue

	| account accountSummary expectedSummary |
	
	expectedSummary := OrderedCollection new.
	expectedSummary add: 'Depósito por 10 pesos'.
	expectedSummary add: 'Balance = 10 pesos'.
	account := ReceptiveAccount new.
	accountSummary := AccountSummary for: account.
	
	Deposit register: (10 * peso) on: account.
	
	self assert: (expectedSummary = accountSummary generateReport ).! !

!AccountSummaryTest methodsFor: 'tests' stamp: 'SO 12/16/2020 18:39:33'!
test03SummaryOfAccountWithWithdrawShowsSaidWithdrawWithCorrectValue

	| account accountSummary expectedSummary |
	
	expectedSummary := OrderedCollection new.
	expectedSummary add: 'Depósito por 100 pesos'.
	expectedSummary add: 'Extracción por 50 pesos'.
	expectedSummary add: 'Balance = 50 pesos'.
	account := ReceptiveAccount new.
	accountSummary := AccountSummary for: account.
	
	Deposit register: (100 * peso) on: account.
	Withdraw register: (50 * peso) on: account.
	
	self assert: (expectedSummary = accountSummary generateReport ).! !

!AccountSummaryTest methodsFor: 'tests' stamp: 'SO 12/16/2020 18:39:38'!
test04SummaryOfAccountWithTransferWithdrawShowsSaidTransferWithdrawWithCorrectValue

	| account targetAccount accountSummary expectedSummary |
	
	expectedSummary := OrderedCollection new.
	expectedSummary add: 'Depósito por 100 pesos'.
	expectedSummary add: 'Extracción por 50 pesos'.
	expectedSummary add: 'Salida por transferencia de 20 pesos'.
	expectedSummary add: 'Balance = 30 pesos'.
	account := ReceptiveAccount new.
	targetAccount := ReceptiveAccount new.
	accountSummary := AccountSummary for: account.
	
	Deposit register: (100 * peso) on: account.
	Withdraw register: (50 * peso) on: account.
	Transfer amount: (20 * peso) from: account to: targetAccount.
	
	self assert: ( expectedSummary = accountSummary generateReport ).! !

!AccountSummaryTest methodsFor: 'tests' stamp: 'SO 12/16/2020 18:39:43'!
test05SummaryOfAccountWithTransferDepositShowsSaidTransferDepositWithCorrectValue

	| account targetAccount accountSummary expectedSummary |
	
	expectedSummary := OrderedCollection new.
	expectedSummary add: 'Depósito por 100 pesos'.
	expectedSummary add: 'Extracción por 50 pesos'.
	expectedSummary add: 'Salida por transferencia de 20 pesos'.
	expectedSummary add: 'Entrada por transferencia de 30 pesos'.
	expectedSummary add: 'Balance = 60 pesos'.
	account := ReceptiveAccount new.
	targetAccount := ReceptiveAccount new.
	accountSummary := AccountSummary for: account.
	
	Deposit register: (100 * peso) on: account.
	Deposit register: (100 * peso) on: targetAccount.
	Withdraw register: (50 * peso) on: account.
	Transfer amount: (20 * peso) from: account to: targetAccount.
	Transfer amount: (30 * peso) from: targetAccount to: account.
	
	self assert: ( expectedSummary = accountSummary generateReport ).! !

!AccountSummaryTest methodsFor: 'tests' stamp: 'SO 12/16/2020 18:39:48'!
test06SummaryOfEmptyPortfolioIsZero

	| account accountSummary expectedSummary portfolio |
	
	expectedSummary := OrderedCollection new.
	expectedSummary add: 'Balance = 0 pesos'.
	account := ReceptiveAccount new.
	portfolio := Portfolio with: account.
	accountSummary := AccountSummary for: portfolio.
	
	self assert: (accountSummary generateReport = expectedSummary ).! !

!AccountSummaryTest methodsFor: 'tests' stamp: 'SO 12/16/2020 18:39:52'!
test07SummaryOfPortfolioWithAccountIsTheAccountsSummary

	| account accountSummary portfolio expectedSummary |
	
	expectedSummary := OrderedCollection new.
	expectedSummary add: 'Depósito por 10 pesos'.
	expectedSummary add: 'Balance = 10 pesos'.
	account := ReceptiveAccount new.
	portfolio := Portfolio with: account.
	accountSummary := AccountSummary for: portfolio.
	
	Deposit register: (10 * peso) on: account.
	
	self assert: (expectedSummary = accountSummary generateReport ).! !

!AccountSummaryTest methodsFor: 'tests' stamp: 'SO 12/16/2020 18:39:56'!
test08SummaryOfPortfolioWithMultipleAccountsIsSummaryOfAllAccounts

	| account accountSummary anotherAccount portfolio expectedSummary |
	
	expectedSummary := OrderedCollection new.
	expectedSummary add: 'Depósito por 10 pesos'.
	expectedSummary add: 'Depósito por 10 pesos'.
	expectedSummary add: 'Balance = 20 pesos'.
	account := ReceptiveAccount new.
	anotherAccount := ReceptiveAccount new.
	portfolio := Portfolio with: account with: anotherAccount.
	accountSummary := AccountSummary for: portfolio.
	
	Deposit register: (10 * peso) on: account.
	Deposit register: (10 * peso) on: anotherAccount.
	
	self assert: (expectedSummary = accountSummary generateReport ).! !


!classDefinition: #PortfolioTest category: 'ServiciosFinancieros-Solucion-Portfolio'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion-Portfolio'!

!PortfolioTest methodsFor: 'tests' stamp: 'LL 9/20/2020 17:09:32'!
test01PortfolioCanNotIncludeTheSameAccountMoreThanOnce

	| account portfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio with: account.
	
	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: portfolio accountsSize.
			self assert: (portfolio hasAccount: account) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'LL 9/20/2020 17:09:38'!
test02PortfolioCanNotIncludeAccountOfItsPortfolios

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	composedPortfolio := Portfolio with: simplePortfolio.
	
	self 
		should: [ composedPortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: composedPortfolio accountsSize.
			self assert: (composedPortfolio hasAccount: simplePortfolio) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'LL 9/20/2020 17:09:45'!
test03PortfolioCanNotIncludeItself

	| account simplePortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	
	self 
		should: [ simplePortfolio add: simplePortfolio ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: simplePortfolio accountsSize.
			self assert: (simplePortfolio hasAccount: account) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'LL 9/20/2020 17:09:51'!
test04ComposedPortfolioCanNotHaveParentPortfolioAccount

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio new.
	composedPortfolio := Portfolio with: simplePortfolio.
	composedPortfolio add: account.
	
	self 
		should: [ simplePortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: simplePortfolio hasAccounts ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'LL 9/20/2020 17:09:57'!
test05ComposedPortfolioCanNotHaveAccountOfAnyRootParentRecursively

	| account leftParentPortfolio leftRootParentPortfolio portfolio rightParentPortfolio rightRootParentPortfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio new.
	leftParentPortfolio := Portfolio with: portfolio .
	leftRootParentPortfolio := Portfolio with: leftParentPortfolio.
	leftRootParentPortfolio add: account.
	
	rightParentPortfolio := Portfolio with: portfolio .
	rightRootParentPortfolio := Portfolio with: rightParentPortfolio.
	rightRootParentPortfolio add: account.

	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolio hasAccounts ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'LL 9/20/2020 17:10:03'!
test06PortfolioCanNotIncludeAnyOfTheComposedAccountOfPortfolioToAdd

	| portfolioToAdd portfolioToModify rootPortfolio sharedAccount |
	
	sharedAccount := ReceptiveAccount new.
	portfolioToModify := Portfolio new.
	rootPortfolio := Portfolio with: sharedAccount with: portfolioToModify.
	portfolioToAdd := Portfolio with: sharedAccount.
	
	self 
		should: [ portfolioToModify add: portfolioToAdd ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError | 
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolioToModify hasAccounts ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'LL 9/20/2020 17:10:16'!
test07BalanceOfPortfolioWithoutAccountsIsZero

	self assert: 0 equals: Portfolio new balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'SO 12/9/2020 21:52:44'!
test07PortfolioHasZeroBalanceWhenCreated

	| portfolio |
	
	portfolio := Portfolio new.

	self assert: 0 equals: portfolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'LL 9/20/2020 20:57:31'!
test08BalanceOfPortfolioWithOneAccountIsAccountBalance

	| account portfolio |
	
	account := ReceptiveAccount new.
	Deposit register: 100 * peso on: account.
	portfolio := Portfolio with: account.
	
	self assert: account balance equals: portfolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'SO 12/9/2020 21:53:32'!
test08PortfolioBalanceEqualsSumOfItsAccountsBalance

	| portfolio account |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio new.
	
	Deposit register: (100* peso) on: account.	
	portfolio add: account.

	self assert: (100 * peso) equals: portfolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'LL 9/20/2020 20:57:37'!
test09BalanceOfPortfolioIsCalculatedRecursivelyOnPortfolios

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortofolio |
	
	simplePortfolioAccount := ReceptiveAccount new.
	Deposit register: 100 * peso on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	Withdraw register: 50 * peso on: composedPortfolioAccount.
	composedPortofolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolioAccount balance + simplePortfolio balance) equals: composedPortofolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'SO 12/9/2020 21:54:27'!
test09CanCheckIfATransactionIsRegisteredInAnyOfPortfoliosAccounts

	| portfolio account deposit |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio new.
	
	deposit := Deposit register: (100* peso) on: account.	
	portfolio add: account.

	self assert: (portfolio hasRegistered: deposit)! !

!PortfolioTest methodsFor: 'tests' stamp: 'SO 12/9/2020 21:55:26'!
test10APorfolioCannotKnowOfTransactionOfAnAccountOutsideOfIt

	| portfolio emptyAccount account deposit |
	
	account := ReceptiveAccount new.
	emptyAccount := ReceptiveAccount new.
	portfolio := Portfolio new.
	
	deposit := Deposit register: (100* peso) on: account.	
	portfolio add: emptyAccount.

	self deny: (portfolio hasRegistered: deposit)! !

!PortfolioTest methodsFor: 'tests' stamp: 'LL 9/20/2020 20:57:42'!
test10PortfolioWithoutAccountsHasNoRegisteredTransaction

	self deny: (Portfolio new hasRegistered: (Deposit for: 100 * peso))! !

!PortfolioTest methodsFor: 'tests' stamp: 'SO 12/9/2020 21:55:41'!
test11CanCheckIfAnAccountIsInPortfolio

	| portfolio account |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio new.
	
	portfolio add: account.

	self assert: (account isInPortfolio: portfolio)! !

!PortfolioTest methodsFor: 'tests' stamp: 'LL 9/20/2020 20:57:46'!
test11PortfolioHasRegisteredItsAccountsTransactions

	| account portfolio deposit |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 * peso on: account.
	portfolio := Portfolio with: account.
	
	self assert: (portfolio hasRegistered: deposit)! !

!PortfolioTest methodsFor: 'tests' stamp: 'LL 9/20/2020 20:57:51'!
test12PortfolioLooksForRegisteredTransactionsRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 * peso on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 * peso on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolio hasRegistered: simplePortfolioAccountDeposit).
	self assert: (composedPortfolio hasRegistered: composedPortfolioAccountWithdraw)! !


!classDefinition: #ReceptiveAccountTest category: 'ServiciosFinancieros-Solucion-Portfolio'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion-Portfolio'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 9/20/2020 17:01:58'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 9/20/2020 20:56:59'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 * peso on: account.
		
	self assert: 100 * peso equals: account balance
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 9/20/2020 20:57:06'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 * peso on: account.
	Withdraw register: 50 * peso on: account.
		
	self assert: 50 * peso equals: account balance
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 9/20/2020 20:57:10'!
test04WithdrawValueMustBePositive 

	| account withdrawValue |
	
	account := ReceptiveAccount new.
	withdrawValue := 50 * peso.
	
	self assert: withdrawValue equals: (Withdraw register: withdrawValue on: account) value
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 9/20/2020 20:57:15'!
test05ReceptiveAccountKnowsRegisteredTransactions 

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 * peso on: account.
	withdraw := Withdraw register: 50 * peso on: account.
		
	self assert: (account hasRegistered: deposit).
	self assert: (account hasRegistered: withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 9/20/2020 20:57:20'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 100 * peso.
	withdraw := Withdraw for: 50 * peso.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered: withdraw).
! !


!classDefinition: #TransferNetTest category: 'ServiciosFinancieros-Solucion-Portfolio'!
TestCase subclass: #TransferNetTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion-Portfolio'!

!TransferNetTest methodsFor: 'tests' stamp: 'SO 12/16/2020 18:38:53'!
test01TransferNetOfEmptyAccountIsZero

	| account transferNet expectedSummary |
	
	expectedSummary := 'Neto de Transferencias = 0 pesos'.
	account := ReceptiveAccount new.
	transferNet := TransferNet for: account.
	
	self assert: (transferNet generateReport = expectedSummary ).! !

!TransferNetTest methodsFor: 'tests' stamp: 'SO 12/16/2020 18:39:00'!
test02TransferNetForAccountWithTransferDepositLegIsTheTransferValue

	| account transferNet expectedSummary targetAccount |
	
	expectedSummary := 'Neto de Transferencias = 10 pesos'.
	account := ReceptiveAccount new.
	targetAccount := ReceptiveAccount new.
	transferNet := TransferNet for: targetAccount.
	
	Deposit register: (10 * peso) on: account.
	Transfer amount: (10 * peso) from: account to: targetAccount.
	
	self assert: (expectedSummary = transferNet generateReport ).! !

!TransferNetTest methodsFor: 'tests' stamp: 'SO 12/16/2020 18:39:05'!
test03TransferNetForAccountWithTransferWithdrawLegIsTheTransferValue

	| account transferNet expectedSummary targetAccount |
	
	expectedSummary := 'Neto de Transferencias = -10 pesos'.
	account := ReceptiveAccount new.
	targetAccount := ReceptiveAccount new.
	transferNet := TransferNet for: account.
	
	Deposit register: (10 * peso) on: account.
	Transfer amount: (10 * peso) from: account to: targetAccount.
	
	self assert: (expectedSummary = transferNet generateReport ).! !

!TransferNetTest methodsFor: 'tests' stamp: 'SO 12/16/2020 18:47:59'!
test04TransferNetOfPortfolioWithEmptyAccountIsZero

	| account portfolio transferNet expectedSummary |
	
	expectedSummary := 'Neto de Transferencias = 0 pesos'.
	account := ReceptiveAccount new.
	portfolio := Portfolio with: account.
	transferNet := TransferNet for: portfolio.
	
	self assert: (transferNet generateReport = expectedSummary ).! !

!TransferNetTest methodsFor: 'tests' stamp: 'SO 12/16/2020 18:48:21'!
test05TransferNetOfPortfolioIsTheSumOfItsAccountsTransferNets

	| account portfolio transferNet expectedSummary targetAccount |
	
	expectedSummary := 'Neto de Transferencias = 10 pesos'.
	account := ReceptiveAccount new.
	targetAccount := ReceptiveAccount new.
	portfolio := Portfolio with: targetAccount .
	transferNet := TransferNet for: portfolio.
	
	Deposit register: (10 * peso) on: account.
	Transfer amount: (10 * peso) from: account to: targetAccount.
	
	self assert: (expectedSummary = transferNet generateReport ).! !


!classDefinition: #TransferTest category: 'ServiciosFinancieros-Solucion-Portfolio'!
TestCase subclass: #TransferTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion-Portfolio'!

!TransferTest methodsFor: 'as yet unclassified' stamp: 'LL 9/20/2020 21:07:03'!
test01ATransferDecreasesBalanceFromOriginAccountAndIncreasesItForDestinationAccount

	| destinationAccount originAccount |
	
	originAccount := ReceptiveAccount new.
	Deposit register: 10 * peso on: originAccount.
	
	destinationAccount := ReceptiveAccount new.
	Deposit register: 10 * peso on: destinationAccount.
	
	Transfer amount: 2 * peso from: originAccount to: destinationAccount.
	
	self assert: 8 * peso equals: originAccount balance.
	self assert: 12 * peso equals: destinationAccount balance.! !

!TransferTest methodsFor: 'as yet unclassified' stamp: 'LL 9/20/2020 21:12:28'!
test02ATransferKnowsItsValue

	| destinationAccount originAccount transfer |
	
	originAccount := ReceptiveAccount new.
	Deposit register: 10 * peso on: originAccount.
	
	destinationAccount := ReceptiveAccount new.
	Deposit register: 10 * peso on: destinationAccount.
	
	transfer := Transfer amount: 2 * peso from: originAccount to: destinationAccount.
	
	self assert: 2 * peso equals: transfer value.! !

!TransferTest methodsFor: 'as yet unclassified' stamp: 'LL 9/20/2020 23:01:44'!
test03DepositLegKnowsItsWithdrawCounterpart

	| destinationAccount originAccount transfer |
	
	originAccount := ReceptiveAccount new.
	Deposit register: 10 * peso on: originAccount.
	
	destinationAccount := ReceptiveAccount new.
	Deposit register: 10 * peso on: destinationAccount.
	
	transfer := Transfer amount: 2 * peso from: originAccount to: destinationAccount.
	
	self assert: transfer withdrawLeg equals: transfer depositLeg withdrawLeg! !

!TransferTest methodsFor: 'as yet unclassified' stamp: 'LL 9/20/2020 23:01:51'!
test04WithdrawLegKnowsItsDepositCounterpart

	| destinationAccount originAccount transfer |
	
	originAccount := ReceptiveAccount new.
	Deposit register: 10 * peso on: originAccount.
	
	destinationAccount := ReceptiveAccount new.
	Deposit register: 10 * peso on: destinationAccount.
	
	transfer := Transfer amount: 2 * peso from: originAccount to: destinationAccount.
	
	self assert: transfer depositLeg equals: transfer withdrawLeg depositLeg! !

!TransferTest methodsFor: 'as yet unclassified' stamp: 'LL 9/20/2020 23:02:36'!
test05OriginAndDestinationAccountsCannotBeTheSame

	| originAccount |
	
	originAccount := ReceptiveAccount new.
	Deposit register: 10 * peso on: originAccount.
	
	self should: [ Transfer amount: 2 * peso from: originAccount to: originAccount ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Transfer cannotTransferToOriginErrorDescription equals: anError messageText.
			self assert: 10 * peso equals: originAccount balance.
		]
! !

!TransferTest methodsFor: 'as yet unclassified' stamp: 'LL 9/20/2020 23:02:44'!
test06CannotTransferAZeroAmount

	| originAccount destinationAccount |
	
	originAccount := ReceptiveAccount new.
	Deposit register: 10 * peso on: originAccount.
	
	destinationAccount := ReceptiveAccount new.
	Deposit register: 5 * peso on: destinationAccount.
	
	self should: [ Transfer amount: 0 from: originAccount to: destinationAccount ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Transfer cannotTransferZeroErrorDescription equals: anError messageText.
			self assert: 10 * peso equals: originAccount balance.
		]
! !


!classDefinition: #Account category: 'ServiciosFinancieros-Solucion-Portfolio'!
Object subclass: #Account
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion-Portfolio'!

!Account methodsFor: 'main protocol' stamp: 'HAW 5/25/2019 12:23:40'!
balance

	self subclassResponsibility ! !

!Account methodsFor: 'main protocol' stamp: 'HAW 5/25/2019 12:23:47'!
hasRegistered: aTransaction

	self subclassResponsibility ! !


!Account methodsFor: 'composition - private' stamp: 'HAW 5/25/2019 12:24:04'!
addedTo: aPortfolio

	self subclassResponsibility ! !

!Account methodsFor: 'composition - private' stamp: 'HAW 5/25/2019 12:24:25'!
isComposedBy: anAccount

	self subclassResponsibility ! !


!Account methodsFor: 'iterating' stamp: 'SO 12/15/2020 23:26:25'!
doOnEach: aClosure

	self subclassResponsibility ! !


!classDefinition: #Portfolio category: 'ServiciosFinancieros-Solucion-Portfolio'!
Account subclass: #Portfolio
	instanceVariableNames: 'accounts parents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion-Portfolio'!

!Portfolio methodsFor: 'initialization' stamp: 'HAW 5/25/2019 12:03:18'!
initialize

	accounts := OrderedCollection new.
	parents := OrderedCollection new.! !


!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 11:49:06'!
accountsSize
	
	^accounts size! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:19:20'!
add: accountToAdd

	self assertCanAdd: accountToAdd.
		
	accounts add: accountToAdd.
	accountToAdd addedTo: self 
	! !

!Portfolio methodsFor: 'accounts management' stamp: 'LL 9/20/2020 17:05:33'!
hasAccount: anAccount

	^accounts includes: anAccount ! !

!Portfolio methodsFor: 'accounts management' stamp: 'LL 9/20/2020 17:09:01'!
hasAccounts
	
	^accounts isEmpty ! !




!Portfolio methodsFor: 'composition - private' stamp: 'HAW 5/25/2019 12:17:31'!
addRootParentsTo: rootParents

	parents 
		ifEmpty: [ rootParents add: self ] 
		ifNotEmpty: [ parents do: [ :aParent | aParent addRootParentsTo: rootParents ]]! !

!Portfolio methodsFor: 'composition - private' stamp: 'HAW 5/25/2019 12:02:59'!
addedTo: aPortfolio 
	
	parents add: aPortfolio ! !

!Portfolio methodsFor: 'composition - private' stamp: 'HAW 5/25/2019 12:20:56'!
anyRootParentIsComposedBy: accountToAdd

	^self rootParents anySatisfy: [ :aParent | aParent isComposedBy: accountToAdd]! !

!Portfolio methodsFor: 'composition - private' stamp: 'HAW 5/25/2019 12:20:36'!
assertCanAdd: accountToAdd

	(self anyRootParentIsComposedBy: accountToAdd) ifTrue: [ self signalCanNotAddAccount ].
! !

!Portfolio methodsFor: 'composition - private' stamp: 'HAW 5/29/2019 16:24:54'!
isComposedBy: anAccount

	^ self = anAccount or: [ accounts anySatisfy: [ :composedAccount | (composedAccount isComposedBy: anAccount) or: [ anAccount isComposedBy: composedAccount ]]]! !

!Portfolio methodsFor: 'composition - private' stamp: 'HAW 5/25/2019 12:17:31'!
rootParents
	
	| rootParents |
	
	rootParents := Set new.
	self addRootParentsTo: rootParents.
	
	^ rootParents! !

!Portfolio methodsFor: 'composition - private' stamp: 'HAW 5/25/2019 11:48:34'!
signalCanNotAddAccount
	
	self error: self class canNotAddAccountErrorMessage! !


!Portfolio methodsFor: 'main protocol' stamp: 'LL 9/21/2020 01:35:22'!
balance
	
	^accounts sum: [ :anAccount | anAccount balance ] ifEmpty: [ 0 * peso ]! !

!Portfolio methodsFor: 'main protocol' stamp: 'HAW 5/25/2019 11:28:29'!
hasRegistered: aTransaction

	^accounts anySatisfy: [ :anAccount | anAccount hasRegistered: aTransaction ]! !


!Portfolio methodsFor: 'iterating' stamp: 'SO 12/16/2020 18:25:23'!
doOnEach: aClosure

	accounts do: [ :aReceptiveAccount | aReceptiveAccount doOnEach: aClosure ].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: 'ServiciosFinancieros-Solucion-Portfolio'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'instance creation' stamp: 'HAW 5/25/2019 11:18:21'!
with: anAccount

	^self new 
		add: anAccount;
		yourself! !

!Portfolio class methodsFor: 'instance creation' stamp: 'HAW 5/25/2019 11:23:59'!
with: anAccount with: anotherAccount

	^self new 
		add: anAccount;
		add: anotherAccount;
		yourself! !


!Portfolio class methodsFor: 'error messages' stamp: 'HAW 5/25/2019 11:48:55'!
canNotAddAccountErrorMessage
	
	^'Can not add repeated account to a portfolio'! !


!classDefinition: #ReceptiveAccount category: 'ServiciosFinancieros-Solucion-Portfolio'!
Account subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions parent'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion-Portfolio'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'LL 9/20/2020 17:01:23'!
initialize

	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'main protocol' stamp: 'LL 9/21/2020 01:35:28'!
balance

	^transactions 
		inject: 0 * peso
		into: [ :currentBalance :transaction | transaction affectBalance: currentBalance ]! !

!ReceptiveAccount methodsFor: 'main protocol' stamp: 'LL 9/20/2020 20:53:32'!
hasRegistered: aTransaction

	^transactions includes: aTransaction
! !

!ReceptiveAccount methodsFor: 'main protocol' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !


!ReceptiveAccount methodsFor: 'composition - private' stamp: 'SO 12/16/2020 18:47:20'!
addedTo: aPortfolio 
	
	^parent := aPortfolio 
	! !

!ReceptiveAccount methodsFor: 'composition - private' stamp: 'HAW 5/25/2019 11:54:51'!
isComposedBy: anAccount

	^self = anAccount ! !

!ReceptiveAccount methodsFor: 'composition - private' stamp: 'SO 12/9/2020 21:48:47'!
isInPortfolio: aPortfolio 
	
	^parent = aPortfolio! !


!ReceptiveAccount methodsFor: 'iterating' stamp: 'SO 12/15/2020 23:25:32'!
doOnEach: aClosure

	transactions do: [ :aTransaction | aClosure value: aTransaction ].! !


!classDefinition: #AccountTransaction category: 'ServiciosFinancieros-Solucion-Portfolio'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion-Portfolio'!

!AccountTransaction methodsFor: 'value' stamp: 'SO 12/8/2020 13:59:28'!
accountBalanceValue

	^self subclassResponsibility ! !

!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:39'!
affectBalance: aBalance

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'as yet unclassified' stamp: 'SO 12/16/2020 18:34:51'!
reportMessage: aReport

	^self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: 'ServiciosFinancieros-Solucion-Portfolio'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/21/2019 18:54:27'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: 'ServiciosFinancieros-Solucion-Portfolio'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion-Portfolio'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !


!Deposit methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:02'!
affectBalance: aBalance

	^aBalance + value ! !


!Deposit methodsFor: 'as yet unclassified' stamp: 'SO 12/16/2020 18:32:01'!
reportMessage: aReport

	^aReport reportMessageForDeposit: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'ServiciosFinancieros-Solucion-Portfolio'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #TransferLeg category: 'ServiciosFinancieros-Solucion-Portfolio'!
AccountTransaction subclass: #TransferLeg
	instanceVariableNames: 'transfer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion-Portfolio'!

!TransferLeg methodsFor: 'initialization' stamp: 'LL 9/20/2020 22:28:14'!
initializeWith: aTransfer

	transfer := aTransfer! !


!TransferLeg methodsFor: 'value' stamp: 'LL 9/20/2020 22:27:32'!
value

	^transfer value! !


!TransferLeg methodsFor: 'as yet unclassified' stamp: 'SO 12/16/2020 18:34:36'!
reportMessage: aReport

	^self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferLeg class' category: 'ServiciosFinancieros-Solucion-Portfolio'!
TransferLeg class
	instanceVariableNames: ''!

!TransferLeg class methodsFor: 'as yet unclassified' stamp: 'LL 9/20/2020 22:45:01'!
of: aTransfer on: anAccount

	| transaction |
	
	transaction := self new initializeWith: 	aTransfer.
	anAccount register: transaction.	
	
	^transaction! !


!classDefinition: #TransferDepositLeg category: 'ServiciosFinancieros-Solucion-Portfolio'!
TransferLeg subclass: #TransferDepositLeg
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion-Portfolio'!

!TransferDepositLeg methodsFor: 'balance' stamp: 'LL 9/20/2020 22:27:49'!
affectBalance: aBalance

	^aBalance + self value! !


!TransferDepositLeg methodsFor: 'accessing' stamp: 'LL 9/20/2020 22:26:10'!
withdrawLeg

	^transfer withdrawLeg! !


!TransferDepositLeg methodsFor: 'as yet unclassified' stamp: 'SO 12/16/2020 18:34:12'!
reportMessage: aTransferNet

	^aTransferNet reportMessageForTransferDepositLeg: self.! !


!classDefinition: #TransferWithdrawLeg category: 'ServiciosFinancieros-Solucion-Portfolio'!
TransferLeg subclass: #TransferWithdrawLeg
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion-Portfolio'!

!TransferWithdrawLeg methodsFor: 'balance' stamp: 'LL 9/20/2020 22:27:55'!
affectBalance: aBalance

	^aBalance - self value! !


!TransferWithdrawLeg methodsFor: 'accessing' stamp: 'LL 9/20/2020 22:25:47'!
depositLeg

	^transfer depositLeg! !


!TransferWithdrawLeg methodsFor: 'as yet unclassified' stamp: 'SO 12/16/2020 18:33:28'!
reportMessage: aReport

	^aReport reportMessageForTransferWithdrawLeg: self.! !


!classDefinition: #Withdraw category: 'ServiciosFinancieros-Solucion-Portfolio'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion-Portfolio'!

!Withdraw methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:46'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:33'!
value

	^ value! !


!Withdraw methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:15'!
affectBalance: aBalance

	^aBalance - value! !


!Withdraw methodsFor: 'as yet unclassified' stamp: 'SO 12/16/2020 18:32:46'!
reportMessage: aReport

	^aReport reportMessageForWithdraw: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'ServiciosFinancieros-Solucion-Portfolio'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Report category: 'ServiciosFinancieros-Solucion-Portfolio'!
Object subclass: #Report
	instanceVariableNames: 'account'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion-Portfolio'!

!Report methodsFor: 'main protocol' stamp: 'SO 12/16/2020 18:38:16'!
generateReport

	self subclassResponsibility ! !

!Report methodsFor: 'main protocol' stamp: 'SO 12/16/2020 18:29:34'!
reportMessageForDeposit: aDeposit

	self subclassResponsibility ! !

!Report methodsFor: 'main protocol' stamp: 'SO 12/16/2020 18:37:30'!
reportMessageForTransferDepositLeg: aTransferDepositLeg

	self subclassResponsibility ! !

!Report methodsFor: 'main protocol' stamp: 'SO 12/16/2020 18:37:43'!
reportMessageForTransferWithdrawLeg: aTransferWithdrawLeg

	self subclassResponsibility ! !

!Report methodsFor: 'main protocol' stamp: 'SO 12/16/2020 18:37:12'!
reportMessageForWithdraw: aWithdraw

	self subclassResponsibility ! !


!Report methodsFor: 'initialization' stamp: 'SO 12/16/2020 18:40:35'!
initializeWith: anAccount

	account := anAccount! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Report class' category: 'ServiciosFinancieros-Solucion-Portfolio'!
Report class
	instanceVariableNames: ''!

!Report class methodsFor: 'instance creation' stamp: 'SO 12/16/2020 18:42:59'!
for: anAccount

	self subclassResponsibility ! !


!classDefinition: #AccountSummary category: 'ServiciosFinancieros-Solucion-Portfolio'!
Report subclass: #AccountSummary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion-Portfolio'!

!AccountSummary methodsFor: 'main protocol' stamp: 'SO 12/16/2020 18:38:47'!
generateReport

	| summary |
	
	summary := OrderedCollection new.

	account doOnEach: [ :aTransaction |
			summary add: (aTransaction reportMessage: self)
		].
	
	summary add: ('Balance = ', account balance asString).
	^summary
	
	! !

!AccountSummary methodsFor: 'main protocol' stamp: 'SO 12/16/2020 18:36:01'!
reportMessageForDeposit: aDeposit

	^'Depósito por ', aDeposit value asString.! !

!AccountSummary methodsFor: 'main protocol' stamp: 'SO 12/16/2020 18:36:09'!
reportMessageForTransferDepositLeg: aTransferDeposit

	^'Entrada por transferencia de ', aTransferDeposit value asString.! !

!AccountSummary methodsFor: 'main protocol' stamp: 'SO 12/16/2020 18:36:19'!
reportMessageForTransferWithdrawLeg: aTransferWithdraw

	^'Salida por transferencia de ', aTransferWithdraw value asString.! !

!AccountSummary methodsFor: 'main protocol' stamp: 'SO 12/16/2020 18:36:29'!
reportMessageForWithdraw: aWithdraw

	^'Extracción por ', aWithdraw value asString.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountSummary class' category: 'ServiciosFinancieros-Solucion-Portfolio'!
AccountSummary class
	instanceVariableNames: ''!

!AccountSummary class methodsFor: 'instance creation' stamp: 'SO 12/15/2020 23:16:29'!
for: anAccount

	^self new initializeWith: anAccount! !


!classDefinition: #TransferNet category: 'ServiciosFinancieros-Solucion-Portfolio'!
Report subclass: #TransferNet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion-Portfolio'!

!TransferNet methodsFor: 'main protocol' stamp: 'SO 12/16/2020 18:38:36'!
generateReport

	| transferNet |
	
	transferNet := 0 * peso.
	
	account doOnEach: [ :aTransaction |
		transferNet := transferNet + (aTransaction reportMessage: self)
	].
	
	^'Neto de Transferencias = ', transferNet asString.! !

!TransferNet methodsFor: 'main protocol' stamp: 'SO 12/16/2020 18:29:55'!
reportMessageForDeposit: aTransferDeposit

	^0! !

!TransferNet methodsFor: 'main protocol' stamp: 'SO 12/16/2020 18:30:39'!
reportMessageForTransferDepositLeg: aTransferDeposit

	^aTransferDeposit affectBalance: 0 * peso.! !

!TransferNet methodsFor: 'main protocol' stamp: 'SO 12/16/2020 18:33:40'!
reportMessageForTransferWithdrawLeg: aTransferWithdraw

	^aTransferWithdraw affectBalance: 0 * peso.! !

!TransferNet methodsFor: 'main protocol' stamp: 'SO 12/16/2020 18:31:09'!
reportMessageForWithdraw: aTransferDeposit

	^0! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferNet class' category: 'ServiciosFinancieros-Solucion-Portfolio'!
TransferNet class
	instanceVariableNames: ''!

!TransferNet class methodsFor: 'instance creation' stamp: 'SO 12/15/2020 23:55:30'!
for: anAccount

	^self new initializeWith: anAccount! !


!classDefinition: #Transfer category: 'ServiciosFinancieros-Solucion-Portfolio'!
Object subclass: #Transfer
	instanceVariableNames: 'value withdrawLeg depositLeg'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion-Portfolio'!

!Transfer methodsFor: 'accessing' stamp: 'LL 9/20/2020 22:39:46'!
depositLeg

	^depositLeg! !

!Transfer methodsFor: 'accessing' stamp: 'LL 9/20/2020 21:25:56'!
withdrawLeg
	
	^withdrawLeg! !


!Transfer methodsFor: 'value' stamp: 'LL 9/20/2020 21:13:00'!
value

	^value! !


!Transfer methodsFor: 'initialization' stamp: 'LL 9/20/2020 21:25:21'!
initializeWith: aValue withdrawLeg: aWithdraw depositLeg: aDeposit

	value := aValue.
	withdrawLeg := aWithdraw.
	depositLeg := aDeposit! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Transfer class' category: 'ServiciosFinancieros-Solucion-Portfolio'!
Transfer class
	instanceVariableNames: ''!

!Transfer class methodsFor: 'instance creation' stamp: 'LL 9/20/2020 23:11:34'!
amount: anAmountOfMoney from: originAccount to: destinationAccount 
	
	| transfer depositLeg withdrawLeg |
	
	self assert: anAmountOfMoney canBeTransferedTo: destinationAccount from: originAccount.
	
	transfer := self new.
	
	withdrawLeg := TransferWithdrawLeg of: transfer on: originAccount.
	depositLeg := TransferDepositLeg of: transfer on: destinationAccount.
	
	^transfer initializeWith: anAmountOfMoney withdrawLeg: withdrawLeg depositLeg: depositLeg
	
	
	! !


!Transfer class methodsFor: 'assertions' stamp: 'LL 9/20/2020 23:05:22'!
assert: anAmountOfMoney canBeTransferedTo: destinationAccount from: originAccount

	self assertCanTransferTo: destinationAccount from: originAccount.
	self assertCanTransfer: anAmountOfMoney! !

!Transfer class methodsFor: 'assertions' stamp: 'LL 9/20/2020 23:11:50'!
assertCanTransfer: anAmountOfMoney

	^ anAmountOfMoney isZero ifTrue: [ self signalCannotTransferZero ]! !

!Transfer class methodsFor: 'assertions' stamp: 'LL 9/20/2020 23:04:58'!
assertCanTransferTo: destinationAccount from: originAccount

	^ originAccount = destinationAccount ifTrue: [ self signalCannotTransferToOrigin ]! !


!Transfer class methodsFor: 'errors' stamp: 'LL 9/20/2020 22:57:30'!
cannotTransferToOriginErrorDescription
	
	^'Transfer destionation cannot be the origin account'! !

!Transfer class methodsFor: 'errors' stamp: 'LL 9/20/2020 23:00:53'!
cannotTransferZeroErrorDescription

	^'Transfer amount should be positive'! !

!Transfer class methodsFor: 'errors' stamp: 'LL 9/20/2020 22:56:35'!
signalCannotTransferToOrigin
	
	self error: self cannotTransferToOriginErrorDescription! !

!Transfer class methodsFor: 'errors' stamp: 'LL 9/20/2020 23:06:17'!
signalCannotTransferZero

	self error: self cannotTransferZeroErrorDescription! !
