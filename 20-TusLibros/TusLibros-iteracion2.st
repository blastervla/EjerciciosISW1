!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:08'!
test01NewCartsAreCreatedEmpty

	self assert: self createCart isEmpty! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:45'!
test02CanNotAddItemsThatDoNotBelongToStore

	| cart |
	
	cart := self createCart.
	
	self 
		should: [ cart add: self itemNotSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test03AfterAddingAnItemTheCartIsNotEmptyAnymore

	| cart |
	
	cart := self createCart.
	
	cart add: self itemSellByTheStore.
	self deny: cart isEmpty ! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test04CanNotAddNonPositiveNumberOfItems

	| cart |
	
	cart := self createCart.
	
	self 
		should: [cart add: 0 of: self itemSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidQuantityErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:45'!
test05CanNotAddMoreThanOneItemNotSellByTheStore

	| cart |
	
	cart := self createCart.
	
	self 
		should: [cart add: 2 of: self itemNotSellByTheStore  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test06CartRemembersAddedItems

	| cart |
	
	cart := self createCart.
	
	cart add: self itemSellByTheStore.
	self assert: (cart includes: self itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test07CartDoesNotHoldNotAddedItems

	| cart |
	
	cart := self createCart.
	
	self deny: (cart includes: self itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:45'!
test08CartRemembersTheNumberOfAddedItems

	| cart |
	
	cart := self createCart.
	
	cart add: 2 of: self itemSellByTheStore.
	self assert: (cart occurrencesOf: self itemSellByTheStore) = 2! !


!CartTest methodsFor: 'support' stamp: 'HernanWilkinson 6/17/2013 17:48'!
createCart
	
	^Cart acceptingItemsOf: self defaultCatalog! !

!CartTest methodsFor: 'support' stamp: 'HernanWilkinson 6/17/2013 17:43'!
defaultCatalog
	
	^ Array with: self itemSellByTheStore! !

!CartTest methodsFor: 'support' stamp: 'HernanWilkinson 6/17/2013 17:44'!
itemNotSellByTheStore
	
	^'invalidBook'! !

!CartTest methodsFor: 'support' stamp: 'HernanWilkinson 6/17/2013 17:43'!
itemSellByTheStore
	
	^ 'validBook'! !


!classDefinition: #CashierTest category: 'TusLibros'!
TestCase subclass: #CashierTest
	instanceVariableNames: 'validBookOf100 productCatalog validBookOf25 cardNumber expirationDate owner'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'support' stamp: 'VP 11/22/2020 17:18:51'!
addProductFileLineFor: aProduct withQuantity: aQuantity

	^'1,' , aProduct, ',', aQuantity asString! !

!CashierTest methodsFor: 'support' stamp: 'VP 11/19/2020 19:20:10'!
createCart
	
	^Cart acceptingItemsOf: productCatalog.! !

!CashierTest methodsFor: 'support' stamp: 'VP 11/21/2020 11:21:44'!
createCashier
	
	^self createCashierWithCardValidation: [ :aCreditCard | true ].! !

!CashierTest methodsFor: 'support' stamp: 'VP 11/21/2020 11:05:45'!
createCashierWithCardValidation: aCardValidationBlock
	
	^Cashier withMerchantProcessor: (self createMerchantProcessorWithCardValidation: aCardValidationBlock).! !

!CashierTest methodsFor: 'support' stamp: 'VP 11/22/2020 16:20:56'!
createCashierWithProcessorResponse: aProcessorResponse
	
	^Cashier withMerchantProcessor: (self createMerchantProcessorWithResponse: aProcessorResponse).! !

!CashierTest methodsFor: 'support' stamp: 'VP 11/21/2020 11:21:47'!
createMerchantProcessor
	
	^self createMerchantProcessorWithCardValidation: [ :aCreditCard | true ].! !

!CashierTest methodsFor: 'support' stamp: 'VP 11/22/2020 16:17:10'!
createMerchantProcessorWithCardValidation: aCardValidationBlock
	
	^MerchantProcessorSimulator newWithCardValidation: aCardValidationBlock responseBehaviour: [ ].! !

!CashierTest methodsFor: 'support' stamp: 'VP 11/22/2020 16:20:13'!
createMerchantProcessorWithResponse: aProcessorResponse
	
	^MerchantProcessorSimulator newWithCardValidation: [ :aCreditCard | true ] responseBehaviour: aProcessorResponse.! !

!CashierTest methodsFor: 'support' stamp: 'VP 11/19/2020 19:05:23'!
itemNotSellByTheStore
	
	^'invalidBook'! !

!CashierTest methodsFor: 'support' stamp: 'VP 11/19/2020 19:18:23'!
itemSellByTheStore
	
	^ validBookOf100.! !


!CashierTest methodsFor: 'tests' stamp: 'VP 11/21/2020 10:57:31'!
test01CheckoutOfEmptyCartIsNotAllowed

	| cart cashier chargedAmount creditCard |
	
	chargedAmount := nil.
	cart := self createCart.
	cashier := self createCashier.
	creditCard := CreditCard withNumber: cardNumber expiration: expirationDate owner: owner.
	
	self should: [ chargedAmount := cashier checkout: cart with: creditCard ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: Cashier emptyCartCheckoutErrorMessage equals: anError messageText.
			self assert: nil equals: chargedAmount.
		].! !

!CashierTest methodsFor: 'tests' stamp: 'VP 11/21/2020 10:58:14'!
test02CheckoutOfSingleProductCartWithValidCardSuccedsAndReturnsCorrectPrice

	| cart cashier chargedAmount creditCard |
	
	chargedAmount := nil.
	cart := self createCart.
	cashier := self createCashier.
	creditCard := CreditCard withNumber: cardNumber expiration: expirationDate owner: owner.
	
	cart add: validBookOf100.
	
	chargedAmount := cashier checkout: cart with: creditCard.
	
	self assert: 100 equals: chargedAmount.! !

!CashierTest methodsFor: 'tests' stamp: 'VP 11/21/2020 10:58:25'!
test03CheckoutOfMultipleProductsCartWithValidCardSuccedsAndReturnsCorrectPrice

	| cart cashier chargedAmount creditCard |
	
	chargedAmount := nil.
	cart := self createCart.
	cashier := self createCashier.
	creditCard := CreditCard withNumber: cardNumber expiration: expirationDate owner: owner.
	
	cart add: validBookOf100.
	cart add: 2 of: validBookOf25.
	
	chargedAmount := cashier checkout: cart with: creditCard.
	
	self assert: 100 + (2 * 25) equals: chargedAmount.! !

!CashierTest methodsFor: 'tests' stamp: 'VP 11/21/2020 11:22:57'!
test04CheckoutWithExpiredCreditCardFails

	| cart cashier chargedAmount creditCard |
	
	chargedAmount := nil.
	cart := self createCart.
	cashier := self createCashier.
	creditCard := CreditCard withNumber: cardNumber expiration: expirationDate previous owner: owner.
	
	cart add: validBookOf100.
	
	self should: [ chargedAmount := cashier checkout: cart with: creditCard. ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: Cashier invalidCreditCardErrorMessage equals: anError messageText.
			self assert: nil equals: chargedAmount.
		].! !

!CashierTest methodsFor: 'tests' stamp: 'VP 11/21/2020 11:21:51'!
test05CheckoutWithInvalidCreditCardFails

	| cart cashier chargedAmount creditCard |
	
	chargedAmount := nil.
	cart := self createCart.
	cashier := self createCashierWithCardValidation: [ :aCreditCard | false ].
	creditCard := CreditCard withNumber: cardNumber expiration: expirationDate owner: owner.
	
	cart add: validBookOf100.
	
	self should: [ chargedAmount := cashier checkout: cart with: creditCard. ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: Cashier invalidCreditCardErrorMessage equals: anError messageText.
			self assert: nil equals: chargedAmount.
		].! !


!CashierTest methodsFor: 'setUp/tearDown' stamp: 'VP 11/21/2020 10:54:55'!
setUp

	cardNumber := 4222222222222.
	expirationDate := GregorianMonthOfYear current.
	owner := 'John Smith'.

	validBookOf100 := 'Las Crónicas de Ñyarñya'.
	validBookOf25 := 'Los Llantos del Mañana'.
	
	productCatalog := Dictionary new.
	productCatalog at: validBookOf100 put: 100.
	productCatalog at: validBookOf25 put: 25.! !


!classDefinition: #CreditCardTest category: 'TusLibros'!
TestCase subclass: #CreditCardTest
	instanceVariableNames: 'cardNumber expirationDate owner'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCardTest methodsFor: 'tests' stamp: 'VP 11/19/2020 19:57:54'!
test01CreditCardWithFutureDateCorrectlyStoresCardDataAndIsNotExpired

	| creditCard |
	
	creditCard := CreditCard withNumber: cardNumber expiration: expirationDate owner: owner.
	
	self assert: cardNumber equals: creditCard number.
	self assert: expirationDate equals: creditCard expiration.
	self assert: owner equals: creditCard owner.
	
	self deny: creditCard isExpired.! !

!CreditCardTest methodsFor: 'tests' stamp: 'VP 11/19/2020 19:58:46'!
test02CreditCardWithPastExpirationDateIsExpired

	| creditCard |
	
	creditCard := CreditCard withNumber: cardNumber expiration: expirationDate previous owner: owner.
	
	self assert: creditCard isExpired.! !

!CreditCardTest methodsFor: 'tests' stamp: 'VP 11/21/2020 10:51:33'!
test03CreditCardWithEmptyOwnerCanNotBeCreated

	self should: [ CreditCard withNumber: cardNumber expiration: expirationDate previous owner: '' ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: CreditCard emptyNameErrorMessage equals: anError messageText.	
		].! !

!CreditCardTest methodsFor: 'tests' stamp: 'VP 11/26/2020 12:41:40'!
test04CreditCardWithNonPositiveNumberCanNotBeCreated

	self should: [ CreditCard withNumber: -1 expiration: expirationDate previous owner: owner ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: CreditCard invalidCardNumberErrorMessage equals: anError messageText.	
		].! !

!CreditCardTest methodsFor: 'tests' stamp: 'VP 11/26/2020 12:42:39'!
test05CreditCardWithNonIntegerNumberCanNotBeCreated

	self should: [ CreditCard withNumber: 1.5 expiration: expirationDate previous owner: owner ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: CreditCard invalidCardNumberErrorMessage equals: anError messageText.	
		].! !


!CreditCardTest methodsFor: 'setUp/tearDown' stamp: 'VP 11/19/2020 19:54:20'!
setUp

	cardNumber := 4222222222222.
	expirationDate := GregorianMonthOfYear current.
	owner := 'John Smith'.! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'catalog items'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:45'!
invalidItemErrorMessage
	
	^'Item is not in catalog'! !

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:45'!
invalidQuantityErrorMessage
	
	^'Invalid number of items'! !


!Cart methodsFor: 'assertions' stamp: 'VP 11/19/2020 19:21:01'!
assertIsValidItem: anItem

	(catalog keys includes: anItem) ifFalse: [ self error: self invalidItemErrorMessage ]! !

!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 17:51'!
assertIsValidQuantity: aQuantity

	aQuantity strictlyPositive ifFalse: [ self error: self invalidQuantityErrorMessage ]! !


!Cart methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 17:48'!
initializeAcceptingItemsOf: aCatalog

	catalog := aCatalog.
	items := OrderedCollection new.! !


!Cart methodsFor: 'queries' stamp: 'HernanWilkinson 6/17/2013 17:45'!
occurrencesOf: anItem

	^items occurrencesOf: anItem  ! !


!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
includes: anItem

	^items includes: anItem ! !

!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
isEmpty
	
	^items isEmpty ! !


!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:44'!
add: anItem

	^ self add: 1 of: anItem ! !

!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:51'!
add: aQuantity of: anItem

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.

	1 to: aQuantity do: [ :aNumber | items add: anItem ]! !


!Cart methodsFor: 'accessing' stamp: 'VP 11/22/2020 17:31:00'!
ledgerLines
	
	^items asSet collect: [ :anItem | '1,', anItem asString, ',', self occurrencesOf: anItem ].! !

!Cart methodsFor: 'accessing' stamp: 'VP 11/19/2020 19:26:39'!
totalPrice
	
	^items sum: [ :anItem | catalog at: anItem ] ifEmpty: [ 0 ].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 17:48'!
acceptingItemsOf: aCatalog

	^self new initializeAcceptingItemsOf: aCatalog ! !


!classDefinition: #Cashier category: 'TusLibros'!
Object subclass: #Cashier
	instanceVariableNames: 'productCatalog merchantProcessor pendingTransactionLedger'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'initialization' stamp: 'VP 11/21/2020 11:02:30'!
initializeWith: aMerchantProcessor

	merchantProcessor := aMerchantProcessor.! !


!Cashier methodsFor: 'operation' stamp: 'VP 11/22/2020 17:28:03'!
checkout: aCart with: aCreditCard

	self verifyCartNotEmpty: aCart.
	self verifyCardNotExpired: aCreditCard.
	
	[ merchantProcessor transactionWith: aCreditCard ofAmount: aCart totalPrice ]
		on: TimedOut do: [
			| ledgerFileLines |
			
			ledgerFileLines := aCart ledgerLines.
			ledgerFileLines addLast: (self pendingCheckoutFileLineFor: aCreditCard).
			
			pendingTransactionLedger at: self ledgerEntryNameForToday put: ledgerFileLines.
		].
	
	^aCart totalPrice.! !

!Cashier methodsFor: 'operation' stamp: 'VP 11/21/2020 11:24:42'!
verifyCardNotExpired: aCreditCard

	^ aCreditCard isExpired ifTrue: [ self error: self class invalidCreditCardErrorMessage ]! !


!Cashier methodsFor: 'validations -- private' stamp: 'VP 11/21/2020 11:03:33'!
verifyCartNotEmpty: aCart

	^ aCart isEmpty ifTrue: [ self error: self class emptyCartCheckoutErrorMessage ]! !


!Cashier methodsFor: 'accessing' stamp: 'VP 11/22/2020 17:40:02'!
pendingTransactionsLedger

	^ pendingTransactionLedger copy.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: 'TusLibros'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'error message -- private' stamp: 'VP 11/19/2020 19:12:27'!
emptyCartCheckoutErrorMessage
	
	^'Cannot checkout empty cart'.! !

!Cashier class methodsFor: 'error message -- private' stamp: 'VP 11/21/2020 11:16:46'!
invalidCreditCardErrorMessage
	
	^'The provided Credit Card is invalid'.! !

!Cashier class methodsFor: 'error message -- private' stamp: 'VP 11/22/2020 16:13:50'!
processorTimeOutErrorMessage
	
	^'The processor timed out'.! !


!Cashier class methodsFor: 'instance creation' stamp: 'VP 11/21/2020 11:01:56'!
withMerchantProcessor: aMerchantProcessor

	^self new initializeWith: aMerchantProcessor.! !


!Cashier class methodsFor: 'operations -- private' stamp: 'VP 11/22/2020 17:38:09'!
expirationDateFormatted: expirationDate

	^expirationDate year number asString, '_', (self stringOf2DigitsFor: expirationDate monthOfYear monthNumber), '_', (self stringOf2DigitsFor: expirationDate dayNumber).! !

!Cashier class methodsFor: 'operations -- private' stamp: 'VP 11/22/2020 17:36:40'!
formattedDate: aDate.

	^aDate year number asString, '_', (self stringOf2DigitsFor: aDate monthOfYear monthNumber), '_', (self stringOf2DigitsFor: aDate dayNumber).! !

!Cashier class methodsFor: 'operations -- private' stamp: 'VP 11/22/2020 17:37:06'!
ledgerEntryNameForToday

	^'TUSLIBROS_INPUT_', (self formattedDate: GregorianDateTime now), '.csv'.! !

!Cashier class methodsFor: 'operations -- private' stamp: 'VP 11/22/2020 17:38:03'!
pendingCheckoutFileLineFor: aCreditCard
	
	^ '2,', aCreditCard number asString, ',', (self expirationDateFormatted: aCreditCard expiration), ',', aCreditCard owner.! !

!Cashier class methodsFor: 'operations -- private' stamp: 'VP 11/22/2020 17:41:41'!
stringOf2DigitsFor: aNumber

	^aNumber printStringBase: 10 nDigits: 2.! !


!classDefinition: #CreditCard category: 'TusLibros'!
Object subclass: #CreditCard
	instanceVariableNames: 'number expiration owner'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'initialization' stamp: 'VP 11/19/2020 19:44:46'!
initializeWithNumber: aNumber expiration: anExpirationDate owner: anOwner 

	number := aNumber.
	expiration := anExpirationDate.
	owner := anOwner.! !


!CreditCard methodsFor: 'accessing' stamp: 'VP 11/19/2020 19:37:10'!
expiration
	
	^expiration! !

!CreditCard methodsFor: 'accessing' stamp: 'VP 11/19/2020 19:59:30'!
isExpired
	
	^expiration < GregorianMonthOfYear current.! !

!CreditCard methodsFor: 'accessing' stamp: 'VP 11/19/2020 19:37:01'!
number

	^number.! !

!CreditCard methodsFor: 'accessing' stamp: 'VP 11/19/2020 19:37:23'!
owner
	
	^owner.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: 'TusLibros'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'instance creation' stamp: 'VP 11/21/2020 10:51:04'!
verifyOwnerNotEmpty: anOwner

	^ anOwner isEmpty ifTrue: [ self error: self emptyNameErrorMessage ]! !

!CreditCard class methodsFor: 'instance creation' stamp: 'VP 11/26/2020 12:43:24'!
verifyValidCreditCardNumber: aCardNumber

	aCardNumber < 0 ifTrue: [ self error: self invalidCardNumberErrorMessage ].
	aCardNumber isInteger ifFalse: [ self error: self invalidCardNumberErrorMessage ].! !

!CreditCard class methodsFor: 'instance creation' stamp: 'VP 11/26/2020 12:42:11'!
withNumber: aNumber expiration: anExpirationDate owner: anOwner
	
	self verifyOwnerNotEmpty: anOwner.
	self verifyValidCreditCardNumber: 	aNumber.

	^self new initializeWithNumber: aNumber expiration: anExpirationDate owner: anOwner.! !


!CreditCard class methodsFor: 'error messages -- private' stamp: 'VP 11/21/2020 10:50:06'!
emptyNameErrorMessage

	^'Owner can not be empty'.! !

!CreditCard class methodsFor: 'error messages -- private' stamp: 'VP 11/26/2020 12:43:09'!
invalidCardNumberErrorMessage
	
	^'Can not create credit card with the given number. Card numbers must be positive, integers'.! !


!classDefinition: #MerchantProcessorSimulator category: 'TusLibros'!
Object subclass: #MerchantProcessorSimulator
	instanceVariableNames: 'cardValidationBlock processorResponseBlock'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!MerchantProcessorSimulator methodsFor: 'initialization' stamp: 'VP 11/22/2020 16:16:39'!
initializeWithCardValidation: aCardValidationBlock responseBehaviour: aProcessorResponseBlock

	cardValidationBlock := aCardValidationBlock.
	processorResponseBlock := aProcessorResponseBlock.! !


!MerchantProcessorSimulator methodsFor: 'validation' stamp: 'VP 11/21/2020 11:21:08'!
isValidCard: aCreditCard

	^cardValidationBlock value: aCreditCard! !


!MerchantProcessorSimulator methodsFor: 'transaction' stamp: 'VP 11/22/2020 16:18:15'!
transactionWith: aCreditCard ofAmount: anAmount

	(self isValidCard: aCreditCard) ifFalse: [ self error: Cashier invalidCreditCardErrorMessage ].
	
	processorResponseBlock value.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MerchantProcessorSimulator class' category: 'TusLibros'!
MerchantProcessorSimulator class
	instanceVariableNames: ''!

!MerchantProcessorSimulator class methodsFor: 'instance creation' stamp: 'VP 11/22/2020 16:16:34'!
newWithCardValidation: aCardValidationBlock responseBehaviour: aProcessorResponseBlock

	^self new initializeWithCardValidation: aCardValidationBlock responseBehaviour: aProcessorResponseBlock.! !
