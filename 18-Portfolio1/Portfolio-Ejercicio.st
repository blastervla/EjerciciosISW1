!classDefinition: #PortfolioTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: 'accountWith100 accountWith50 portfolioWith50WorthAccount depositOf100 depositOf50'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!PortfolioTest methodsFor: 'test -- balance' stamp: 'VP 11/2/2020 19:51:34'!
test01EmptyPortfolioBalanceIsZero

	| portfolio |
	
	portfolio := Portfolio new.
	
	self assert: 0 equals: portfolio balance.! !

!PortfolioTest methodsFor: 'test -- balance' stamp: 'VP 11/2/2020 20:40:40'!
test02SingleAccountPortfolioBalanceIsAccountBalance

	| portfolio |
	
	portfolio := Portfolio new.
	
	portfolio add: accountWith100.
	
	self assert: accountWith100 balance equals: portfolio balance.! !

!PortfolioTest methodsFor: 'test -- balance' stamp: 'VP 11/2/2020 20:41:16'!
test03PortfolioOfMultipleAccountsAndPortfoliosBalanceIsAllAccountsBalancesSummed

	| portfolio |
	
	portfolio := Portfolio new.
	
	portfolio add: accountWith100.
	portfolio add: portfolioWith50WorthAccount.
	
	self assert: accountWith100 balance + accountWith50 balance equals: portfolio balance.! !


!PortfolioTest methodsFor: 'setUp/tearDown' stamp: 'VP 11/2/2020 20:50:55'!
setUp
	
	accountWith100 := ReceptiveAccount new.
	depositOf100 := Deposit register: 100 on: accountWith100.
	
	accountWith50 := ReceptiveAccount new.
	depositOf50 := Deposit register: 50 on: accountWith50.
	
	portfolioWith50WorthAccount := Portfolio new.
	portfolioWith50WorthAccount add: accountWith50.! !


!PortfolioTest methodsFor: 'test -- hasRegistered' stamp: 'VP 11/2/2020 21:04:22'!
test04EmptyPortfolioDoesNotHaveAnyTransaction

	| portfolio transaction |
	
	portfolio := Portfolio new.
	
	transaction := Deposit for: 2000.
	
	self deny: (portfolio hasRegistered: transaction).! !

!PortfolioTest methodsFor: 'test -- hasRegistered' stamp: 'VP 11/2/2020 20:50:34'!
test05PortfolioHasASpecificTransactionRegistered

	| portfolio |
	
	portfolio := Portfolio new.
	
	portfolio add: accountWith100.
	portfolio add: portfolioWith50WorthAccount.
	
	self assert: (portfolio hasRegistered: depositOf100).
	self assert: (portfolio hasRegistered: depositOf50).! !

!PortfolioTest methodsFor: 'test -- hasRegistered' stamp: 'VP 11/2/2020 21:04:04'!
test06PortfolioDoesNotHaveASpecificTransactionRegistered

	| portfolio transaction |
	
	portfolio := Portfolio new.
	
	portfolio add: accountWith100.
	portfolio add: portfolioWith50WorthAccount.
	
	transaction := Deposit for: 2000.
	
	self deny: (portfolio hasRegistered: transaction).! !


!PortfolioTest methodsFor: 'test -- transactions' stamp: 'VP 11/2/2020 21:05:06'!
test07EmptyPortfolioHasZeroTransactions

	| portfolio |
	
	portfolio := Portfolio new.
	
	self assert: portfolio transactions isEmpty.! !

!PortfolioTest methodsFor: 'test -- transactions' stamp: 'VP 11/2/2020 21:07:29'!
test08PortfolioHasAllSubAccountablesTransactions

	| portfolio |
	
	portfolio := Portfolio new.
	portfolio add: accountWith100.
	portfolio add: portfolioWith50WorthAccount.
	
	self assert: portfolio transactions includes: depositOf100.
	self assert: portfolio transactions includes: depositOf50.! !


!PortfolioTest methodsFor: 'test -- add' stamp: 'VP 11/7/2020 17:11:59'!
test09PortfolioCanNotAddItself

	| portfolio |
	
	portfolio := Portfolio new.
	
	self should: [ portfolio add: portfolio ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: Portfolio duplicatedAccountableErrorMessage equals: anError messageText.
			self assert: 0 equals: portfolio balance.
		].! !

!PortfolioTest methodsFor: 'test -- add' stamp: 'VP 11/7/2020 17:11:59'!
test10PortfolioBlocksAddingDuplicatedDirectAccount

	| portfolio |
	
	portfolio := Portfolio new.
	portfolio add: accountWith100.
	
	self should: [ portfolio add: accountWith100 ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: Portfolio duplicatedAccountableErrorMessage equals: anError messageText.
			self assert: accountWith100 balance equals: portfolio balance.
		].! !

!PortfolioTest methodsFor: 'test -- add' stamp: 'VP 11/7/2020 17:11:59'!
test11PortfolioBlocksAddingDuplicatedIndirectAccount

	| portfolio |
	
	portfolio := Portfolio new.
	portfolio add: portfolioWith50WorthAccount.
	
	self should: [ portfolio add: accountWith50 ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: Portfolio duplicatedAccountableErrorMessage equals: anError messageText.
			self assert: portfolioWith50WorthAccount balance equals: portfolio balance.
		].! !

!PortfolioTest methodsFor: 'test -- add' stamp: 'VP 11/7/2020 17:11:59'!
test12PortfolioBlocksAddingAccountableDirectlyReferencingIt

	| portfolio1 portfolio2 |
	
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.
	portfolio2 add: portfolio1.
	
	self should: [ portfolio1 add: portfolio2 ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: Portfolio duplicatedAccountableErrorMessage equals: anError messageText.
			self deny: (portfolio1 includes: portfolio2).
			self assert: (portfolio2 includes: portfolio1).
		].! !

!PortfolioTest methodsFor: 'test -- add' stamp: 'VP 11/7/2020 17:11:59'!
test13PortfolioBlocksAddingAccountableWithSharedAccount

	| portfolio1 portfolio2 |
	
	portfolio1 := Portfolio new.
	portfolio1 add: accountWith100.
	portfolio2 := Portfolio new.
	portfolio2 add: accountWith100.
	
	self should: [ portfolio1 add: portfolio2 ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: Portfolio duplicatedAccountableErrorMessage equals: anError messageText.
			self deny: (portfolio1 includes: portfolio2).
		].! !

!PortfolioTest methodsFor: 'test -- add' stamp: 'VP 11/7/2020 17:11:59'!
test14PortfolioBlocksAddingAccountableAlreadyInParent

	| portfolio1 portfolio2 |
	
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.
	
	portfolio1 add: portfolio2.
	portfolio1 add: accountWith100.
	
	self should: [ portfolio2 add: accountWith100. ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: Portfolio duplicatedAccountableErrorMessage equals: anError messageText.
			self deny: (portfolio2 includes: accountWith100).
			self assert: (portfolio1 includes: portfolio2).
			self assert: (portfolio1 includes: accountWith100).
		].! !

!PortfolioTest methodsFor: 'test -- add' stamp: 'VP 11/7/2020 17:42:35'!
test15PortfolioBlocksAddingAccountableWithIndirectlySharedAccountables

	| portfolio1 portfolio2 portfolio3 |
	
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.
	portfolio3 := Portfolio new.	
	
	portfolio1 add: portfolio2.
	portfolio1 add: accountWith100.
	portfolio3 add: accountWith100.
	
	self should: [ portfolio2 add: portfolio3. ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: Portfolio duplicatedAccountableErrorMessage equals: anError messageText.
			self deny: (portfolio2 includes: accountWith100).
			self assert: (portfolio1 includes: portfolio2).
			self assert: (portfolio1 includes: accountWith100).
		].! !


!classDefinition: #ReceptiveAccountTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:44'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:48'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:52'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:32'!
test04WithdrawValueMustBePositive 

	| account withdrawValue |
	
	account := ReceptiveAccount new.
	withdrawValue := 50.
	
	self assert: withdrawValue equals: (Withdraw register: withdrawValue on: account) value
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:46'!
test05ReceptiveAccountKnowsRegisteredTransactions 

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	withdraw := Withdraw register: 50 on: account.
		
	self assert: (account hasRegistered: deposit).
	self assert: (account hasRegistered: withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:14:15'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| deposit withdraw account |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 100.
	withdraw := Withdraw for: 50.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered:withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:14:01'!
test07AccountKnowsItsTransactions 

	| account1 deposit1 |
	
	account1 := ReceptiveAccount new.
	
	deposit1 := Deposit register: 50 on: account1.
		
	self assert: 1 equals: account1 transactions size.
	self assert: (account1 transactions includes: deposit1).
! !


!classDefinition: #AccountTransaction category: 'Portfolio-Ejercicio'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'operation' stamp: 'VP 11/2/2020 20:12:22'!
operateOnBalance: balance

	^self subclassResponsibility.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: 'Portfolio-Ejercicio'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/17/2019 03:22:00'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: 'Portfolio-Ejercicio'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !


!Deposit methodsFor: 'operation' stamp: 'VP 11/2/2020 20:11:23'!
operateOnBalance: balance

	^balance + value.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'Portfolio-Ejercicio'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Withdraw category: 'Portfolio-Ejercicio'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Withdraw methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:46'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:33'!
value

	^ value! !


!Withdraw methodsFor: 'operation' stamp: 'VP 11/2/2020 20:11:30'!
operateOnBalance: balance

	^balance - value.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'Portfolio-Ejercicio'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Accountable category: 'Portfolio-Ejercicio'!
Object subclass: #Accountable
	instanceVariableNames: 'parentAccountables'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Accountable methodsFor: 'balance' stamp: 'VP 11/2/2020 19:46:27'!
balance

	self subclassResponsibility.! !


!Accountable methodsFor: 'testing' stamp: 'VP 11/2/2020 19:47:01'!
hasRegistered: aTransaction

	self subclassResponsibility.
! !

!Accountable methodsFor: 'testing' stamp: 'VP 11/7/2020 11:11:47'!
includes: anAccountable

	self subclassResponsibility.
! !


!Accountable methodsFor: 'transactions' stamp: 'VP 11/2/2020 19:48:29'!
transactions

	self subclassResponsibility.
! !


!Accountable methodsFor: 'testing -- private' stamp: 'VP 11/7/2020 16:32:05'!
addedTo: anAccountable

	parentAccountables add: anAccountable.! !

!Accountable methodsFor: 'testing -- private' stamp: 'VP 11/7/2020 16:07:47'!
allAccountables

	self subclassResponsibility.! !

!Accountable methodsFor: 'testing -- private' stamp: 'VP 11/7/2020 17:41:39'!
rootAccountables

	"No nos pareció un if que valiera la pena evitar; no es una situación en la que buscar agregar nuevos comportamientos
	 a futuro vaya a obligarnos a mantener este código (salvo casos muy particulares, pero a priori no tendría sentido crear
	 una nueva abstracción."
	parentAccountables isEmpty ifTrue: [ ^OrderedCollection with: self ].
	^parentAccountables inject: OrderedCollection new addingAll: [ :aParentAccountable |
		aParentAccountable rootAccountables.
	].! !


!Accountable methodsFor: 'initialization' stamp: 'VP 11/7/2020 16:31:38'!
initialize

	parentAccountables := OrderedCollection new.! !


!classDefinition: #Portfolio category: 'Portfolio-Ejercicio'!
Accountable subclass: #Portfolio
	instanceVariableNames: 'accountables'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Portfolio methodsFor: 'balance' stamp: 'VP 11/2/2020 20:36:48'!
balance
	
	^accountables inject: 0 into: [ :currentBalance :anAccount | currentBalance + anAccount balance ].! !


!Portfolio methodsFor: 'operation' stamp: 'VP 11/7/2020 17:13:18'!
add: anAccountable

	self verifyNoSharedAccountablesInHierarchyWith: anAccountable.
	accountables add: anAccountable.
	anAccountable addedTo: self.! !


!Portfolio methodsFor: 'initialization' stamp: 'VP 11/7/2020 16:34:02'!
initialize

	super initialize.
	accountables := OrderedCollection new.! !


!Portfolio methodsFor: 'transactions' stamp: 'VP 11/7/2020 17:39:55'!
transactions
	
	^accountables inject: OrderedCollection new addingAll: [ :anAccountable |
		anAccountable transactions
	].! !


!Portfolio methodsFor: 'testing' stamp: 'VP 11/2/2020 20:58:32'!
hasRegistered: aTransaction 
	
	^accountables anySatisfy: [ :accountable | accountable hasRegistered: aTransaction ].! !

!Portfolio methodsFor: 'testing' stamp: 'VP 11/7/2020 11:51:14'!
includes: anAccountable

	^(accountables includes: anAccountable)
		or: [ accountables anySatisfy: [ :childAccountable | 
			childAccountable includes: anAccountable]
		].! !


!Portfolio methodsFor: 'testing -- private' stamp: 'VP 11/7/2020 17:39:49'!
allAccountables

	^accountables inject: (OrderedCollection with: self) addingAll: [ :anAccountable |
		anAccountable allAccountables
	].! !

!Portfolio methodsFor: 'testing -- private' stamp: 'VP 11/7/2020 16:01:54'!
sharedAccountablesWith: anAccountable

	^self allAccountables intersection: anAccountable allAccountables.! !


!Portfolio methodsFor: 'operation -- private' stamp: 'VP 11/7/2020 16:46:02'!
anyRootHasSharedAccountablesWith: anAccountable

	^self rootAccountables anySatisfy: [ :aRootAccountable | 
		(aRootAccountable sharedAccountablesWith: anAccountable) isEmpty not
	].! !

!Portfolio methodsFor: 'operation -- private' stamp: 'VP 11/7/2020 17:31:45'!
verifyNoSharedAccountablesInHierarchyWith: anAccountable

	(self anyRootHasSharedAccountablesWith: anAccountable) ifTrue: [ self error: self class duplicatedAccountableErrorMessage ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: 'Portfolio-Ejercicio'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'error messages' stamp: 'VP 11/7/2020 17:11:59'!
duplicatedAccountableErrorMessage
	^'Can not add the requested accountable, as it is already in the portfolio'! !


!classDefinition: #ReceptiveAccount category: 'Portfolio-Ejercicio'!
Accountable subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'VP 11/7/2020 16:34:08'!
initialize

	super initialize.
	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'VP 11/2/2020 19:48:10'!
transactions

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'VP 11/2/2020 20:10:44'!
balance

	^transactions inject: 0 into: [ :currentBalance :aTransaction | aTransaction operateOnBalance: currentBalance ].! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'NR 10/17/2019 03:28:43'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'VP 11/7/2020 11:47:58'!
includes: anAccountable

	^false.! !


!ReceptiveAccount methodsFor: 'testing -- private' stamp: 'VP 11/7/2020 16:07:19'!
allAccountables

	^OrderedCollection with: self.! !
