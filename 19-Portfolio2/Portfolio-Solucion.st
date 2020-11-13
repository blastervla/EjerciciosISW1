!classDefinition: #AccountTest category: 'Portfolio-Solucion'!
TestCase subclass: #AccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountTest methodsFor: 'tests -- transfer net' stamp: 'VP 11/9/2020 22:00:17'!
test07EmptyAcountTransferNetIsZero

	| account transferNet |
	
	account := ReceptiveAccount new.
	
	transferNet := (TransferNet for: account) value.
	
	self assert: 0 equals: transferNet.! !

!AccountTest methodsFor: 'tests -- transfer net' stamp: 'VP 11/12/2020 21:14:01'!
test08SingleTransferAccountWithPositiveTransferNet

	| account1 account2 transferNet |
	
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	
	Transfer register: 30 from: account2 to: account1.
	
	transferNet := (TransferNet for: account1) value.
	
	self assert: 30 equals: transferNet.! !

!AccountTest methodsFor: 'tests -- transfer net' stamp: 'VP 11/12/2020 21:14:14'!
test09SingleTransferAccountWithNegativeTransferNet

	| account1 account2 transferNet |
	
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	
	Transfer register: 30 from: account1 to: account2.
	
	transferNet := (TransferNet for: account1) value.
	
	self assert: -30 equals: transferNet.! !

!AccountTest methodsFor: 'tests -- transfer net' stamp: 'VP 11/12/2020 21:18:52'!
test10MultipleTransfersAccountTransferNet

	| account1 account2 transferNet |
	
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	
	Transfer register: 30 from: account2 to: account1.
	Transfer register: 20 from: account1 to: account2.
	Transfer register: 5 from: account1 to: account2.
	
	transferNet := (TransferNet for: account1) value.
	
	self assert: 5 equals: transferNet.! !


!AccountTest methodsFor: 'tests -- account summary' stamp: 'VP 11/9/2020 21:38:02'!
test01EmptyAccountSummary

	| account summaryCollection |
	
	account := ReceptiveAccount new.
	
	summaryCollection := (AccountSummary for: account) asCollection.
	
	self assert: 1 equals: summaryCollection size.
	self assert: 'Balance = 0' equals: (summaryCollection at: 1).! !

!AccountTest methodsFor: 'tests -- account summary' stamp: 'VP 11/9/2020 21:59:41'!
test02AccountWithSingleDepositSummary

	| account summaryCollection |
	
	account := ReceptiveAccount new.
	
	Deposit register: 100 on: account.
	
	summaryCollection := (AccountSummary for: account) asCollection.
	
	self assert: 1 + 1 equals: summaryCollection size.
	self assert: 'Depósito por 100' equals: (summaryCollection at: 1).
	self assert: 'Balance = 100' equals: (summaryCollection at: 2).! !

!AccountTest methodsFor: 'tests -- account summary' stamp: 'VP 11/9/2020 22:03:03'!
test03AccountWithSingleWithdrawSummary

	| account summaryCollection |
	
	account := ReceptiveAccount new.
	
	Withdraw register: 100 on: account.
	
	summaryCollection := (AccountSummary for: account) asCollection.
	
	self assert: 1 + 1 equals: summaryCollection size.
	self assert: 'Extracción por 100' equals: (summaryCollection at: 1).
	self assert: 'Balance = -100' equals: (summaryCollection at: 2).! !

!AccountTest methodsFor: 'tests -- account summary' stamp: 'VP 11/9/2020 22:01:52'!
test04AccountWithSingleInboundTransferSummary

	| account1 account2 summaryCollection |
	
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	
	Transfer register: 100 from: account2 to: account1.
	
	summaryCollection := (AccountSummary for: account1) asCollection.
	
	self assert: 1 + 1 equals: summaryCollection size.
	self assert: 'Entrada por transferencia de 100' equals: (summaryCollection at: 1).
	self assert: 'Balance = 100' equals: (summaryCollection at: 2).! !

!AccountTest methodsFor: 'tests -- account summary' stamp: 'VP 11/9/2020 22:02:53'!
test05AccountWithSingleOutboundTransferSummary

	| account1 account2 summaryCollection |
	
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	
	Transfer register: 100 from: account2 to: account1.
	
	summaryCollection := (AccountSummary for: account2) asCollection.
	
	self assert: 1 + 1 equals: summaryCollection size.
	self assert: 'Salida por transferencia de 100' equals: (summaryCollection at: 1).
	self assert: 'Balance = -100' equals: (summaryCollection at: 2).! !

!AccountTest methodsFor: 'tests -- account summary' stamp: 'VP 11/9/2020 22:00:14'!
test06PortfolioWithTransactionsSummary

	| portfolio account1 account2 summaryCollection |
	
	portfolio := Portfolio new.
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	
	Transfer register: 30 from: account2 to: account1.
	Transfer register: 20 from: account1 to: account2.
	Withdraw register: 50 on: account1.
	Deposit register: 100 on: account1.
	
	portfolio add: account1.
	
	summaryCollection := (AccountSummary for: portfolio) asCollection.
	
	self assert: 4 + 1 equals: summaryCollection size.
	self assert: 'Depósito por 100' equals: (summaryCollection at: 1).
	self assert: 'Extracción por 50' equals: (summaryCollection at: 2).
	self assert: 'Salida por transferencia de 20' equals: (summaryCollection at: 3).
	self assert: 'Entrada por transferencia de 30' equals: (summaryCollection at: 4).
	self assert: 'Balance = 60' equals: (summaryCollection at: 5).! !


!classDefinition: #PortfolioTest category: 'Portfolio-Solucion'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:16:26'!
test01BalanceOfPortfolioWithoutAccountsIsZero

	self assert: 0 equals: Portfolio new balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:17:51'!
test02BalanceOfPortfolioWithOneAccountIsAccountBalance

	| account portfolio |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	self assert: account balance equals: portfolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:23:25'!
test03BalanceOfPortfolioIsCalculatedRecursivelyOnPortfolios

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortofolio |
	
	simplePortfolioAccount := ReceptiveAccount new.
	Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	Withdraw register: 50 on: composedPortfolioAccount.
	composedPortofolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolioAccount balance + simplePortfolio balance) equals: composedPortofolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:43:15'!
test04PortfolioWithoutAccountsHasNoRegisteredTransaction

	self deny: (Portfolio new hasRegistered: (Deposit for: 100))! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:43:11'!
test05PortfolioHasRegisteredItsAccountsTransactions

	| account portfolio deposit |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	self assert: (portfolio hasRegistered: deposit)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:06'!
test06PortfolioLooksForRegisteredTransactionsRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolio hasRegistered: simplePortfolioAccountDeposit).
	self assert: (composedPortfolio hasRegistered: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:10'!
test07PortfolioHasNoTransactionWhenHasNoAccounts

	self assert: Portfolio new transactions isEmpty! !

!PortfolioTest methodsFor: 'tests' stamp: 'NR 6/22/2020 07:31:19'!
test08PortfolioTransactionsIncludesAllItsAccountsTransactions

	| account portfolio accountDeposit anotherAccount portfolioTransactions anotherAccountWithdraw |
	
	account := ReceptiveAccount new.
	accountDeposit := Deposit register: 100 on: account.
	anotherAccount := ReceptiveAccount new.
	anotherAccountWithdraw := Withdraw register: 100 on: account.
	portfolio := Portfolio with: account.
	
	portfolioTransactions := portfolio transactions.
	
	self assert: 2 equals: portfolioTransactions size.
	self assert: (portfolioTransactions includes: accountDeposit).
	self assert: (portfolioTransactions includes: anotherAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:20'!
test09PortfolioTransactionsAreCalculatedRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit composedPortfolioTransactions |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	composedPortfolioTransactions := composedPortfolio transactions.
	self assert: 2 equals: composedPortfolioTransactions size.
	self assert: (composedPortfolioTransactions includes: simplePortfolioAccountDeposit).
	self assert: (composedPortfolioTransactions includes: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:24'!
test10PortfolioCanNotIncludeTheSameAccountMoreThanOnce

	| account portfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio with: account.
	
	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: portfolio accountsSize.
			self assert: (portfolio accountsIncludes: account) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:28'!
test11PortfolioCanNotIncludeAccountOfItsPortfolios

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
			self assert: (composedPortfolio accountsIncludes: simplePortfolio) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:32'!
test12PortfolioCanNotIncludeItself

	| account simplePortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	
	self 
		should: [ simplePortfolio add: simplePortfolio ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: simplePortfolio accountsSize.
			self assert: (simplePortfolio accountsIncludes: account) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 12:01:51'!
test13ComposedPortfolioCanNotHaveParentPortfolioAccount

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
			self assert: simplePortfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 12:12:16'!
test14ComposedPortfolioCanNotHaveAccountOfAnyRootParentRecursively

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
			self assert: portfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/29/2019 16:31:18'!
test15PortfolioCanNotIncludeAnyOfTheComposedAccountOfPortfolioToAdd

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
			self assert: portfolioToModify accountsIsEmpty ]! !


!classDefinition: #ReceptiveAccountTest category: 'Portfolio-Solucion'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:19:48'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:19:54'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:02'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 equals: account balance .
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

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/9/2020 06:00:12'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| deposit withdraw account |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 100.
	withdraw := Withdraw for: 50.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered:withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/9/2020 06:02:30'!
test07AccountKnowsItsTransactions 

	| account deposit |
	
	account := ReceptiveAccount new.
	
	deposit := Deposit register: 100 on: account.
		
	self assert: 1 equals: account transactions size .
	self assert: (account transactions includes: deposit).
! !


!ReceptiveAccountTest methodsFor: 'tests -- transfer' stamp: 'VP 11/9/2020 20:11:33'!
test08TransferBetweenAccountsEffectivelyAffectsBalance

	| srcAccount dstAccount transfer |
	
	srcAccount := ReceptiveAccount new.
	dstAccount := ReceptiveAccount new.
	
	transfer := Transfer register: 100 from: srcAccount to: dstAccount.
		
	self assert: 100 equals: transfer value.
	self assert: -100 equals: srcAccount balance.
	self assert: 100 equals: dstAccount balance.! !

!ReceptiveAccountTest methodsFor: 'tests -- transfer' stamp: 'VP 11/9/2020 20:12:53'!
test09TransferBetweenAccountsAreRegisteredInAccountTransactions

	| srcAccount dstAccount transfer |
	
	srcAccount := ReceptiveAccount new.
	dstAccount := ReceptiveAccount new.
	
	transfer := Transfer register: 100 from: srcAccount to: dstAccount.
		
	self assert: (srcAccount transactions includes: transfer withdrawTransaction).
	self assert: (dstAccount transactions includes: transfer depositTransaction).! !

!ReceptiveAccountTest methodsFor: 'tests -- transfer' stamp: 'VP 11/9/2020 20:16:44'!
test10TransactionRegisteredOnAccountsForTransferHasLinkToTransfer

	| srcAccount dstAccount transfer |
	
	srcAccount := ReceptiveAccount new.
	dstAccount := ReceptiveAccount new.
	
	transfer := Transfer register: 100 from: srcAccount to: dstAccount.
		
	self assert: transfer equals: transfer withdrawTransaction associatedTransfer.
	self assert: transfer equals: transfer depositTransaction associatedTransfer.! !

!ReceptiveAccountTest methodsFor: 'tests -- transfer' stamp: 'VP 11/9/2020 20:19:58'!
test11NegativeTransfersAreProhibited

	| srcAccount dstAccount |
	
	srcAccount := ReceptiveAccount new.
	dstAccount := ReceptiveAccount new.
	
	
	self should: [ Transfer register: -100 from: srcAccount to: dstAccount ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: Transfer negativeTransferErrorMessage equals: anError messageText.
			self assert: 0 equals: srcAccount balance.
			self assert: 0 equals: dstAccount balance.
		].! !

!ReceptiveAccountTest methodsFor: 'tests -- transfer' stamp: 'VP 11/9/2020 20:22:05'!
test12EmptyTransfersAreProhibited

	| srcAccount dstAccount |
	
	srcAccount := ReceptiveAccount new.
	dstAccount := ReceptiveAccount new.
	
	
	self should: [ Transfer register: 0 from: srcAccount to: dstAccount ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: Transfer emptyTransferErrorMessage equals: anError messageText.
			self assert: 0 equals: srcAccount balance.
			self assert: 0 equals: dstAccount balance.
		].! !

!ReceptiveAccountTest methodsFor: 'tests -- transfer' stamp: 'VP 11/9/2020 20:24:44'!
test13SelfTransfersAreProhibited

	| srcAccount dstAccount |
	
	srcAccount := ReceptiveAccount new.
	dstAccount := srcAccount.
	
	
	self should: [ Transfer register: 100 from: srcAccount to: dstAccount ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: Transfer selfTransferErrorMessage equals: anError messageText.
			self assert: 0 equals: srcAccount balance.
			self assert: 0 equals: dstAccount balance.
		].! !


!classDefinition: #Account category: 'Portfolio-Solucion'!
Object subclass: #Account
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Account methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:23:47'!
hasRegistered: aTransaction

	self subclassResponsibility ! !

!Account methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:24:25'!
isComposedBy: anAccount

	self subclassResponsibility ! !


!Account methodsFor: 'balance' stamp: 'HAW 5/25/2019 12:23:40'!
balance

	self subclassResponsibility ! !


!Account methodsFor: 'transactions' stamp: 'HAW 5/25/2019 12:23:27'!
addTransactionsTo: aCollectionOfTransactions

	self subclassResponsibility ! !

!Account methodsFor: 'transactions' stamp: 'HAW 5/25/2019 12:23:15'!
transactions

	self subclassResponsibility ! !


!Account methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:24:04'!
addedTo: aPortfolio

	self subclassResponsibility ! !


!classDefinition: #Portfolio category: 'Portfolio-Solucion'!
Account subclass: #Portfolio
	instanceVariableNames: 'accounts parents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 11:49:20'!
accountsIncludes: anAccount

	^accounts includes: anAccount ! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:05:04'!
accountsIsEmpty
	
	^accounts isEmpty ! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 11:49:06'!
accountsSize
	
	^accounts size! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:19:20'!
add: accountToAdd

	self assertCanAdd: accountToAdd.
		
	accounts add: accountToAdd.
	accountToAdd addedTo: self 
	! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:17:31'!
rootParents
	
	| rootParents |
	
	rootParents := Set new.
	self addRootParentsTo: rootParents.
	
	^ rootParents! !


!Portfolio methodsFor: 'initialization' stamp: 'HAW 5/25/2019 12:03:18'!
initialize

	accounts := OrderedCollection new.
	parents := OrderedCollection new.! !


!Portfolio methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:19:36'!
balance
	
	^accounts sum: [ :anAccount | anAccount balance ] ifEmpty: [ 0 ]! !


!Portfolio methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:42:55'!
addTransactionsTo: aCollectionOfTransactions

	accounts do: [ :anAccount | anAccount addTransactionsTo: aCollectionOfTransactions ]! !

!Portfolio methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:38:32'!
transactions
	
	| transactions |
	
	transactions := OrderedCollection new.
	accounts do: [ :anAccount | anAccount addTransactionsTo: transactions ].
	
	^transactions ! !


!Portfolio methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:02:59'!
addedTo: aPortfolio 
	
	parents add: aPortfolio ! !


!Portfolio methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:20:56'!
anyRootParentIsComposedBy: accountToAdd

	^self rootParents anySatisfy: [ :aParent | aParent isComposedBy: accountToAdd]! !

!Portfolio methodsFor: 'testing' stamp: 'HAW 5/25/2019 11:28:29'!
hasRegistered: aTransaction

	^accounts anySatisfy: [ :anAccount | anAccount hasRegistered: aTransaction ]! !

!Portfolio methodsFor: 'testing' stamp: 'HAW 5/29/2019 16:24:54'!
isComposedBy: anAccount

	^ self = anAccount or: [ accounts anySatisfy: [ :composedAccount | (composedAccount isComposedBy: anAccount) or: [ anAccount isComposedBy: composedAccount ]]]! !


!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 12:17:31'!
addRootParentsTo: rootParents

	parents 
		ifEmpty: [ rootParents add: self ] 
		ifNotEmpty: [ parents do: [ :aParent | aParent addRootParentsTo: rootParents ]]! !

!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 12:20:36'!
assertCanAdd: accountToAdd

	(self anyRootParentIsComposedBy: accountToAdd) ifTrue: [ self signalCanNotAddAccount ].
! !

!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 11:48:34'!
signalCanNotAddAccount
	
	self error: self class canNotAddAccountErrorMessage! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: 'Portfolio-Solucion'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'NR 11/9/2020 06:01:26'!
canNotAddAccountErrorMessage
	
	^'Can not add repeated account to a portfolio!!'! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:18:21'!
with: anAccount

	^self new 
		add: anAccount;
		yourself! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:23:59'!
with: anAccount with: anotherAccount

	^self new 
		add: anAccount;
		add: anotherAccount;
		yourself! !


!classDefinition: #ReceptiveAccount category: 'Portfolio-Solucion'!
Account subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:35'!
initialize

	super initialize.
	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'NR 11/9/2020 05:56:36'!
addTransactionsTo: aCollectionOfTransactions

	aCollectionOfTransactions addAll: transactions copy! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:24:46'!
balance

	^transactions 
		inject: 0
		into: [ :currentBalance :transaction | transaction affectBalance: currentBalance ]! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'NR 10/21/2019 18:55:56'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'HAW 5/25/2019 11:54:51'!
isComposedBy: anAccount

	^self = anAccount ! !


!ReceptiveAccount methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:03:32'!
addedTo: aPortfolio 
	
	! !


!classDefinition: #AccountReport category: 'Portfolio-Solucion'!
Object subclass: #AccountReport
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountReport methodsFor: 'report building -- private' stamp: 'VP 11/12/2020 21:27:02'!
affectForDeposit: aDeposit

	self subclassResponsibility.! !

!AccountReport methodsFor: 'report building -- private' stamp: 'VP 11/12/2020 21:27:22'!
affectForTransferDeposit: aTransferDeposit

	self subclassResponsibility.! !

!AccountReport methodsFor: 'report building -- private' stamp: 'VP 11/12/2020 21:27:15'!
affectForTransferWithdraw: aTransferWithdraw

	self subclassResponsibility.! !

!AccountReport methodsFor: 'report building -- private' stamp: 'VP 11/12/2020 21:27:11'!
affectForWithdraw: aWithdraw

	self subclassResponsibility.! !

!AccountReport methodsFor: 'report building -- private' stamp: 'VP 11/12/2020 21:42:52'!
buildReportFor: anAccount

	anAccount transactions do: [ :aTransaction |
		aTransaction affectReport: self.
	].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountReport class' category: 'Portfolio-Solucion'!
AccountReport class
	instanceVariableNames: ''!

!AccountReport class methodsFor: 'instance creation' stamp: 'VP 11/9/2020 21:39:35'!
for: anAccount 
	
	^self new initializeFor: anAccount.! !


!classDefinition: #AccountSummary category: 'Portfolio-Solucion'!
AccountReport subclass: #AccountSummary
	instanceVariableNames: 'summaryCollection'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountSummary methodsFor: 'initialization' stamp: 'VP 11/12/2020 21:42:52'!
initializeFor: anAccount

	summaryCollection := self basicAccountReportFor: anAccount.
	self buildReportFor: anAccount.! !


!AccountSummary methodsFor: 'accessing' stamp: 'VP 11/9/2020 21:33:02'!
asCollection

	^summaryCollection copy.! !


!AccountSummary methodsFor: 'initialization -- private' stamp: 'VP 11/9/2020 21:35:48'!
basicAccountReportFor: anAccount

	^OrderedCollection with: (self class balanceReportMessageFor: anAccount)! !


!AccountSummary methodsFor: 'report building -- private' stamp: 'VP 11/12/2020 21:31:28'!
addTransactionDescription: aTransactionDescription

	summaryCollection addFirst: aTransactionDescription.! !

!AccountSummary methodsFor: 'report building -- private' stamp: 'VP 11/12/2020 21:31:42'!
affectForDeposit: aDeposit

	self addTransactionDescription: 'Depósito por ', aDeposit value asString.! !

!AccountSummary methodsFor: 'report building -- private' stamp: 'VP 11/12/2020 21:33:07'!
affectForTransferDeposit: aTransferDeposit

	self addTransactionDescription: 'Entrada por transferencia de ', aTransferDeposit value asString! !

!AccountSummary methodsFor: 'report building -- private' stamp: 'VP 11/12/2020 21:33:19'!
affectForTransferWithdraw: aTransferWithdraw

	self addTransactionDescription: 'Salida por transferencia de ', aTransferWithdraw value asString! !

!AccountSummary methodsFor: 'report building -- private' stamp: 'VP 11/12/2020 21:32:05'!
affectForWithdraw: aWithdraw

	self addTransactionDescription: 'Extracción por ', aWithdraw value asString.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountSummary class' category: 'Portfolio-Solucion'!
AccountSummary class
	instanceVariableNames: ''!

!AccountSummary class methodsFor: 'report messages -- private' stamp: 'VP 11/9/2020 21:20:01'!
balanceReportMessageFor: anAccount

	^ 'Balance = ', anAccount balance asString! !


!classDefinition: #TransferNet category: 'Portfolio-Solucion'!
AccountReport subclass: #TransferNet
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferNet methodsFor: 'initialization' stamp: 'VP 11/12/2020 21:43:08'!
initializeFor: anAccount

	value := 0.
	self buildReportFor: anAccount.! !


!TransferNet methodsFor: 'accessing' stamp: 'VP 11/12/2020 21:35:57'!
value
	
	^value.! !


!TransferNet methodsFor: 'report building -- private' stamp: 'VP 11/12/2020 21:36:14'!
affectForDeposit: aDeposit! !

!TransferNet methodsFor: 'report building -- private' stamp: 'VP 11/12/2020 21:38:05'!
affectForTransferDeposit: aTransferDeposit

	value := value + aTransferDeposit value.! !

!TransferNet methodsFor: 'report building -- private' stamp: 'VP 11/12/2020 21:38:19'!
affectForTransferWithdraw: aTransferWithdraw

	value := value - aTransferWithdraw value.! !

!TransferNet methodsFor: 'report building -- private' stamp: 'VP 11/12/2020 21:36:21'!
affectForWithdraw: aWithdraw! !


!classDefinition: #AccountTransaction category: 'Portfolio-Solucion'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'balance' stamp: 'VP 11/12/2020 21:24:49'!
affectBalance: aBalance

	self subclassResponsibility! !


!AccountTransaction methodsFor: 'report' stamp: 'VP 11/12/2020 21:24:20'!
affectReport: aReport

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: 'Portfolio-Solucion'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/21/2019 18:54:27'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: 'Portfolio-Solucion'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !


!Deposit methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:02'!
affectBalance: aBalance

	^aBalance + value ! !


!Deposit methodsFor: 'report' stamp: 'VP 11/12/2020 21:25:26'!
affectReport: aReport

	aReport affectForDeposit: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'Portfolio-Solucion'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #TransferComponents category: 'Portfolio-Solucion'!
AccountTransaction subclass: #TransferComponents
	instanceVariableNames: 'transfer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferComponents methodsFor: 'initialization' stamp: 'VP 11/9/2020 20:11:20'!
initializeFor: aTransfer

	transfer := aTransfer.! !


!TransferComponents methodsFor: 'value' stamp: 'VP 11/9/2020 20:08:41'!
value

	^transfer value.! !


!TransferComponents methodsFor: 'navigation -- private' stamp: 'VP 11/9/2020 20:17:05'!
associatedTransfer

	^transfer.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferComponents class' category: 'Portfolio-Solucion'!
TransferComponents class
	instanceVariableNames: ''!

!TransferComponents class methodsFor: 'instance creation' stamp: 'VP 11/9/2020 20:05:18'!
for: aValue

	^self new initializeFor: aValue! !


!classDefinition: #TransferDeposit category: 'Portfolio-Solucion'!
TransferComponents subclass: #TransferDeposit
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferDeposit methodsFor: 'balance' stamp: 'VP 11/9/2020 20:08:15'!
affectBalance: aBalance

	^aBalance + self value. ! !


!TransferDeposit methodsFor: 'report' stamp: 'VP 11/12/2020 21:26:01'!
affectReport: aReport

	aReport affectForTransferDeposit: self.! !


!classDefinition: #TransferWithdraw category: 'Portfolio-Solucion'!
TransferComponents subclass: #TransferWithdraw
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferWithdraw methodsFor: 'balance' stamp: 'VP 11/9/2020 20:08:07'!
affectBalance: aBalance

	^aBalance - self value. ! !


!TransferWithdraw methodsFor: 'report' stamp: 'VP 11/12/2020 21:26:16'!
affectReport: aReport

	aReport affectForTransferWithdraw: self.! !


!classDefinition: #Withdraw category: 'Portfolio-Solucion'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Withdraw methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:46'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:33'!
value

	^ value! !


!Withdraw methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:15'!
affectBalance: aBalance

	^aBalance - value! !


!Withdraw methodsFor: 'report' stamp: 'VP 11/12/2020 21:26:31'!
affectReport: aReport

	aReport affectForWithdraw: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'Portfolio-Solucion'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Transfer category: 'Portfolio-Solucion'!
Object subclass: #Transfer
	instanceVariableNames: 'value withdrawTransaction depositTransaction'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Transfer methodsFor: 'initialization' stamp: 'VP 11/9/2020 20:14:12'!
initializeWithValue: aValue from: aSourceReceptiveAccount to: aDestinationReceptiveAccount

	value := aValue.
	withdrawTransaction := TransferWithdraw register: self on: aSourceReceptiveAccount.
	depositTransaction := TransferDeposit register: self on: aDestinationReceptiveAccount.! !

!Transfer methodsFor: 'initialization' stamp: 'VP 11/9/2020 20:09:13'!
value

	^value.! !



!Transfer methodsFor: 'transactions' stamp: 'VP 11/9/2020 20:14:25'!
depositTransaction
	
	^depositTransaction.! !

!Transfer methodsFor: 'transactions' stamp: 'VP 11/9/2020 20:13:35'!
withdrawTransaction
	
	^withdrawTransaction.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Transfer class' category: 'Portfolio-Solucion'!
Transfer class
	instanceVariableNames: ''!

!Transfer class methodsFor: 'instance creation' stamp: 'VP 11/9/2020 20:27:04'!
register: aValue from: aSourceReceptiveAccount to: aDestinationReceptiveAccount 
	
	self verifyValidTransferFor: aValue from: aSourceReceptiveAccount to: aDestinationReceptiveAccount.
	
	^self new initializeWithValue: aValue from: aSourceReceptiveAccount to: aDestinationReceptiveAccount.! !


!Transfer class methodsFor: 'error messages' stamp: 'VP 11/9/2020 20:22:26'!
emptyTransferErrorMessage

	^'Empty (zero value) transfers are prohibited'.! !

!Transfer class methodsFor: 'error messages' stamp: 'VP 11/9/2020 20:20:33'!
negativeTransferErrorMessage

	^'Negative transfers are prohibited'.! !

!Transfer class methodsFor: 'error messages' stamp: 'VP 11/9/2020 20:23:51'!
selfTransferErrorMessage

	^'Self transfers are prohibited'.! !


!Transfer class methodsFor: 'instance creation -- private' stamp: 'VP 11/9/2020 20:26:38'!
verifyValidTransferFor: aValue from: aSourceReceptiveAccount to: aDestinationReceptiveAccount

	aValue < 0 ifTrue: [ self error: self negativeTransferErrorMessage ].
	aValue = 0 ifTrue: [ self error: self emptyTransferErrorMessage ].
	aSourceReceptiveAccount = aDestinationReceptiveAccount ifTrue: [ self error: self selfTransferErrorMessage ]! !
