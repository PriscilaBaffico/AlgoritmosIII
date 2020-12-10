!classDefinition: #PortfolioTest category: 'ServiciosFinancieros-Ejercicio'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

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

!PortfolioTest methodsFor: 'tests' stamp: 'SO 12/9/2020 21:52:44'!
test07PortfolioHasZeroBalanceWhenCreated

	| portfolio |
	
	portfolio := Portfolio new.

	self assert: 0 equals: portfolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'SO 12/9/2020 21:53:32'!
test08PortfolioBalanceEqualsSumOfItsAccountsBalance

	| portfolio account |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio new.
	
	Deposit register: (100* peso) on: account.	
	portfolio add: account.

	self assert: (100 * peso) equals: portfolio balance! !

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

!PortfolioTest methodsFor: 'tests' stamp: 'SO 12/9/2020 21:55:41'!
test11CanCheckIfAnAccountIsInPortfolio

	| portfolio account |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio new.
	
	portfolio add: account.

	self assert: (account isInPortfolio: portfolio)! !


!classDefinition: #ReceptiveAccountTest category: 'ServiciosFinancieros-Ejercicio'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 9/20/2020 17:01:58'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 9/20/2020 20:55:33'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 * peso on: account.
		
	self assert: 100 * peso equals: account balance
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 9/20/2020 20:55:48'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 * peso on: account.
	Withdraw register: 50 * peso on: account.
		
	self assert: 50 * peso equals: account balance
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 9/20/2020 20:55:54'!
test04WithdrawValueMustBePositive 

	| account withdrawValue |
	
	account := ReceptiveAccount new.
	withdrawValue := 50 * peso.
	
	self assert: withdrawValue equals: (Withdraw register: withdrawValue on: account) value
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 9/20/2020 20:56:01'!
test05ReceptiveAccountKnowsRegisteredTransactions 

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 * peso on: account.
	withdraw := Withdraw register: 50 * peso on: account.
		
	self assert: (account hasRegistered: deposit).
	self assert: (account hasRegistered: withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 9/20/2020 20:56:08'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 100 * peso.
	withdraw := Withdraw for: 50 * peso.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered: withdraw).
! !


!classDefinition: #TransaferenceTest category: 'ServiciosFinancieros-Ejercicio'!
TestCase subclass: #TransaferenceTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!TransaferenceTest methodsFor: 'tests' stamp: 'SO 12/9/2020 19:34:14'!
test01TransferenceBetweenAccountsHasExpectedValue

	| transfer originAccount targetAccount |
	
	originAccount := ReceptiveAccount new.
	Deposit register: 100 * peso on: originAccount.
	targetAccount := ReceptiveAccount  new.
	
	transfer := Transference transferFrom: originAccount  to: targetAccount withAmount: 100 * peso.

	self assert: (100 * peso) equals: transfer value.! !

!TransaferenceTest methodsFor: 'tests' stamp: 'SO 12/9/2020 19:36:32'!
test02TransferenceWithdrawsAmountFromOriginAccountAndDepositsItIntoTargetAccount

	| originAccount targetAccount |
	
	originAccount := ReceptiveAccount new.
	Deposit register: 100 * peso on: originAccount.
	targetAccount := ReceptiveAccount  new.
	
	Transference transferFrom: originAccount  to: targetAccount withAmount: 100 * peso.

	self assert: (0 * peso) equals: originAccount balance.
	self assert: (100 * peso) equals: targetAccount balance.! !

!TransaferenceTest methodsFor: 'tests' stamp: 'SO 12/9/2020 19:37:46'!
test03CannotTransferAnAmountGreaterThanOriginsAccountBalance

	| originAccount targetAccount |
	
	originAccount := ReceptiveAccount new.	
	targetAccount := ReceptiveAccount  new.
	
	
	self should: [ Transference transferFrom: originAccount  to: targetAccount withAmount: 100 * peso. ] 
		raise: Error 
		withExceptionDo: [ :anException |
			self assert: (0 * peso) equals: originAccount balance.
			self assert: (0 * peso) equals: targetAccount balance.
		].! !

!TransaferenceTest methodsFor: 'tests' stamp: 'SO 12/9/2020 19:38:45'!
test04CannotTransferAnAmountThatIsLessOrEqualThanZero

	| originAccount targetAccount |
	
	originAccount := ReceptiveAccount new.	
	targetAccount := ReceptiveAccount  new.
	
	
	self should: [ Transference transferFrom: originAccount  to: targetAccount withAmount: 0 * peso. ] 
		raise: Error 
		withExceptionDo: [ :anException |
			self assert: (0 * peso) equals: originAccount balance.
			self assert: (0 * peso) equals: targetAccount balance.
		].! !

!TransaferenceTest methodsFor: 'tests' stamp: 'SO 12/9/2020 19:39:58'!
test05EachAccountInTransferenceRegistersRespectivePart

	| transfer originAccount targetAccount |
	
	originAccount := ReceptiveAccount new.
	Deposit register: 100 * peso on: originAccount.
	targetAccount := ReceptiveAccount  new.
	
	transfer := Transference transferFrom: originAccount  to: targetAccount withAmount: 100 * peso.
	
	self assert: (originAccount hasRegistered: (transfer withdrawLeg)).
	self assert: (targetAccount hasRegistered: (transfer depositLeg)).! !

!TransaferenceTest methodsFor: 'tests' stamp: 'SO 12/9/2020 19:40:59'!
test06EachTransferencePartKnowsItsCounterpart

	| transfer originAccount targetAccount |
	
	originAccount := ReceptiveAccount new.
	Deposit register: 100 * peso on: originAccount.
	targetAccount := ReceptiveAccount  new.
	
	transfer := Transference transferFrom: originAccount  to: targetAccount withAmount: 100 * peso.
	
	self assert: ((transfer withdrawLeg) isCounterpartOf: (transfer depositLeg)).
	self assert: ((transfer depositLeg) isCounterpartOf: (transfer withdrawLeg)).! !


!classDefinition: #AccountTransaction category: 'ServiciosFinancieros-Ejercicio'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!AccountTransaction methodsFor: 'value' stamp: 'SO 12/8/2020 13:59:28'!
accountBalanceValue

	^self subclassResponsibility ! !

!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: 'ServiciosFinancieros-Ejercicio'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/21/2019 18:54:27'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: 'ServiciosFinancieros-Ejercicio'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'SO 12/8/2020 13:59:47'!
accountBalanceValue

	^ value! !

!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'ServiciosFinancieros-Ejercicio'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #TransferenceDeposit category: 'ServiciosFinancieros-Ejercicio'!
Deposit subclass: #TransferenceDeposit
	instanceVariableNames: 'counterpart'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!TransferenceDeposit methodsFor: 'counterpart' stamp: 'SO 12/9/2020 19:23:27'!
addCounterpart: aTransferenceCounterpart

	counterpart := aTransferenceCounterpart ! !


!TransferenceDeposit methodsFor: 'testing' stamp: 'SO 12/9/2020 19:23:23'!
isCounterpartOf: aTransferenceTransaction

	^aTransferenceTransaction = counterpart! !


!classDefinition: #Withdraw category: 'ServiciosFinancieros-Ejercicio'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!Withdraw methodsFor: 'initialization' stamp: 'SO 12/3/2020 21:06:57'!
initializeFor: aValue

	value := aValue.! !


!Withdraw methodsFor: 'value' stamp: 'SO 12/8/2020 14:00:05'!
accountBalanceValue

	^ value negated! !

!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:33'!
value

	^ value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'ServiciosFinancieros-Ejercicio'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #TransferenceWithdraw category: 'ServiciosFinancieros-Ejercicio'!
Withdraw subclass: #TransferenceWithdraw
	instanceVariableNames: 'counterpart'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!TransferenceWithdraw methodsFor: 'testing' stamp: 'SO 12/9/2020 19:23:09'!
isCounterpartOf: aTransferenceTransaction

	^aTransferenceTransaction = counterpart! !


!TransferenceWithdraw methodsFor: 'counterpart' stamp: 'SO 12/9/2020 19:23:15'!
addCounterpart: aTransferenceCounterpart

	counterpart := aTransferenceCounterpart ! !


!classDefinition: #Portfolio category: 'ServiciosFinancieros-Ejercicio'!
Object subclass: #Portfolio
	instanceVariableNames: 'accounts parents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!Portfolio methodsFor: 'initialization' stamp: 'HAW 5/25/2019 12:03:18'!
initialize

	accounts := OrderedCollection new.
	parents := OrderedCollection new.! !


!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:19:20'!
add: accountToAdd

	self assertCanAdd: accountToAdd.
		
	accounts add: accountToAdd.
	accountToAdd addedTo: self 
	! !

!Portfolio methodsFor: 'accounts management' stamp: 'SO 12/9/2020 20:01:55'!
balance

	^accounts sum: [ :anAccount | anAccount balance ] ifEmpty: [ 0 * peso ]! !

!Portfolio methodsFor: 'accounts management' stamp: 'SO 12/9/2020 21:56:35'!
hasRegistered: aTransaction 
	
	accounts do: [ :anAccount | (anAccount hasRegistered: aTransaction) ifTrue: [^true] ].
	^false.! !


!Portfolio methodsFor: 'testing' stamp: 'LL 9/20/2020 17:05:33'!
hasAccount: anAccount

	^accounts includes: anAccount ! !

!Portfolio methodsFor: 'testing' stamp: 'LL 9/20/2020 17:09:01'!
hasAccounts
	
	^accounts isEmpty ! !


!Portfolio methodsFor: 'accessing' stamp: 'HAW 5/25/2019 11:49:06'!
accountsSize
	
	^accounts size! !


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

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: 'ServiciosFinancieros-Ejercicio'!
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


!classDefinition: #ReceptiveAccount category: 'ServiciosFinancieros-Ejercicio'!
Object subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions parent'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'LL 9/20/2020 17:01:23'!
initialize

	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'main protocol' stamp: 'SO 12/8/2020 14:00:20'!
balance

	^transactions sum: [ :aTransaction | aTransaction accountBalanceValue ] ifEmpty: [ 0 * peso ]! !

!ReceptiveAccount methodsFor: 'main protocol' stamp: 'LL 9/20/2020 20:48:29'!
hasRegistered: aTransaction

	^transactions includes: aTransaction
! !

!ReceptiveAccount methodsFor: 'main protocol' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !


!ReceptiveAccount methodsFor: 'composition - private' stamp: 'SO 12/9/2020 21:47:08'!
addedTo: aPortfolio 
	
	parent := aPortfolio! !

!ReceptiveAccount methodsFor: 'composition - private' stamp: 'HAW 5/25/2019 11:54:51'!
isComposedBy: anAccount

	^self = anAccount ! !

!ReceptiveAccount methodsFor: 'composition - private' stamp: 'SO 12/9/2020 21:48:47'!
isInPortfolio: aPortfolio 
	
	^parent = aPortfolio! !


!classDefinition: #Transference category: 'ServiciosFinancieros-Ejercicio'!
Object subclass: #Transference
	instanceVariableNames: 'originAccount targetAccount amount withdrawLeg depositLeg'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!Transference methodsFor: 'initialization' stamp: 'SO 12/9/2020 19:16:32'!
initializeTransferFrom: anOriginAccount to: aTargetAccount withAmount: anAmount 
	
	originAccount := anOriginAccount.
	targetAccount := aTargetAccount.
	amount := anAmount.
	
	depositLeg :=TransferenceDeposit register: anAmount on: targetAccount.
	withdrawLeg := TransferenceWithdraw register: anAmount on: originAccount.
	
	depositLeg addCounterpart: withdrawLeg.
	withdrawLeg addCounterpart: depositLeg.! !


!Transference methodsFor: 'accessing' stamp: 'SO 12/9/2020 19:01:48'!
depositLeg
	
	^depositLeg! !

!Transference methodsFor: 'accessing' stamp: 'SO 12/9/2020 19:18:59'!
value

	^amount.! !

!Transference methodsFor: 'accessing' stamp: 'SO 12/9/2020 19:01:21'!
withdrawLeg
	
	^withdrawLeg! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Transference class' category: 'ServiciosFinancieros-Ejercicio'!
Transference class
	instanceVariableNames: ''!

!Transference class methodsFor: 'instance creation' stamp: 'SO 12/8/2020 14:42:11'!
transferFrom: anOriginAccount to: aTargetAccount withAmount: anAmount 

	(self canTransferFrom: anOriginAccount theAmountOf: anAmount) ifTrue: [self fail].

	^self new initializeTransferFrom: anOriginAccount to: aTargetAccount withAmount: anAmount ! !


!Transference class methodsFor: 'validation' stamp: 'SO 12/8/2020 14:41:05'!
canTransferFrom: anOriginAccount theAmountOf: anAmount

	^((anOriginAccount balance < anAmount) or: [anAmount = (0 * peso)])! !
