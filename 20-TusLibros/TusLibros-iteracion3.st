!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: 'testObjectsFactory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test01NewCartsAreCreatedEmpty

	self assert: testObjectsFactory createCart isEmpty! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test02CanNotAddItemsThatDoNotBelongToStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [ cart add: testObjectsFactory itemNotSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test03AfterAddingAnItemTheCartIsNotEmptyAnymore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: testObjectsFactory itemSellByTheStore.
	self deny: cart isEmpty ! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test04CanNotAddNonPositiveNumberOfItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [cart add: 0 of: testObjectsFactory itemSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidQuantityErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test05CanNotAddMoreThanOneItemNotSellByTheStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [cart add: 2 of: testObjectsFactory itemNotSellByTheStore  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:11'!
test06CartRemembersAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: testObjectsFactory itemSellByTheStore.
	self assert: (cart includes: testObjectsFactory itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:11'!
test07CartDoesNotHoldNotAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self deny: (cart includes: testObjectsFactory itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:11'!
test08CartRemembersTheNumberOfAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: 2 of: testObjectsFactory itemSellByTheStore.
	self assert: (cart occurrencesOf: testObjectsFactory itemSellByTheStore) = 2! !


!CartTest methodsFor: 'setup' stamp: 'HernanWilkinson 6/17/2013 18:09'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.! !


!classDefinition: #CashierTest category: 'TusLibros'!
TestCase subclass: #CashierTest
	instanceVariableNames: 'testObjectsFactory debitBehavior'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:50'!
test01CanNotCheckoutAnEmptyCart

	| salesBook |
	
	salesBook := OrderedCollection new.
	self 
		should: [ Cashier 
			toCheckout: testObjectsFactory createCart 
			charging: testObjectsFactory notExpiredCreditCard 
			throught: self
			on: testObjectsFactory today
			registeringOn:  salesBook ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier cartCanNotBeEmptyErrorMessage.
			self assert: salesBook isEmpty ]! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:51'!
test02CalculatedTotalIsCorrect

	| cart cashier |
	
	cart := testObjectsFactory createCart.
	cart add: 2 of: testObjectsFactory itemSellByTheStore.
	
	cashier :=  Cashier
		toCheckout: cart 
		charging: testObjectsFactory notExpiredCreditCard 
		throught: self
		on: testObjectsFactory today 
		registeringOn: OrderedCollection new.
		
	self assert: cashier checkOut = (testObjectsFactory itemSellByTheStorePrice * 2)! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:51'!
test03CanNotCheckoutWithAnExpiredCreditCart

	| cart salesBook |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	salesBook := OrderedCollection new.
	
	self
		should: [ Cashier 
				toCheckout: cart 
				charging: testObjectsFactory expiredCreditCard 
				throught: self
				on: testObjectsFactory today
				registeringOn: salesBook ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText = Cashier canNotChargeAnExpiredCreditCardErrorMessage.
			self assert: salesBook isEmpty ]! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 19:04'!
test04CheckoutRegistersASale

	| cart cashier salesBook total |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart 
		charging: testObjectsFactory notExpiredCreditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	total := cashier checkOut.
					
	self assert: salesBook size = 1.
	self assert: salesBook first total = total.! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 19:00'!
test05CashierChargesCreditCardUsingMerchantProcessor

	| cart cashier salesBook total creditCard debitedAmout debitedCreditCard  |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	creditCard := testObjectsFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart 
		charging: creditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	debitBehavior := [ :anAmount :aCreditCard | 
		debitedAmout := anAmount.
		debitedCreditCard := aCreditCard ].
	total := cashier checkOut.
					
	self assert: debitedCreditCard = creditCard.
	self assert: debitedAmout = total.! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:59'!
test06CashierDoesNotSaleWhenTheCreditCardHasNoCredit

	| cart cashier salesBook creditCard |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	creditCard := testObjectsFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 	debitBehavior := [ :anAmount :aCreditCard | self error: Cashier creditCardHasNoCreditErrorMessage].
	
	cashier:= Cashier 
		toCheckout: cart 
		charging: creditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	self 
		should: [cashier checkOut ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier creditCardHasNoCreditErrorMessage.
			self assert: salesBook isEmpty ]! !


!CashierTest methodsFor: 'setup' stamp: 'HernanWilkinson 6/17/2013 19:03'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.
	debitBehavior := [ :anAmount :aCreditCard | ]! !


!CashierTest methodsFor: 'merchant processor protocol' stamp: 'HernanWilkinson 6/17/2013 19:02'!
debit: anAmount from: aCreditCard 

	^debitBehavior value: anAmount value: aCreditCard ! !


!classDefinition: #TusLibrosStoreTest category: 'TusLibros'!
TestCase subclass: #TusLibrosStoreTest
	instanceVariableNames: 'testObjectsFactory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TusLibrosStoreTest methodsFor: 'authenticator protocol' stamp: 'VP 11/28/2020 10:52:46'!
authenticate: aClientID withPassword: aPassword

	^aPassword ~= 'a wrong password'.! !


!TusLibrosStoreTest methodsFor: 'tests' stamp: 'VP 11/30/2020 19:18:59'!
test01CreateCartWithNonExistingClientIDFails

	| tusLibrosStore |
	
	tusLibrosStore := testObjectsFactory createStoreWithAuthenticationSystem: self.
	
	self should: [ tusLibrosStore createCartFor: '' withPassword: '123456' ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: TusLibrosStore nonExistingClientErrorMessage equals: anError messageText.
		].! !

!TusLibrosStoreTest methodsFor: 'tests' stamp: 'VP 11/29/2020 11:36:06'!
test02CreateCartWithWrongPasswordFails

	| tusLibrosStore |
	
	tusLibrosStore := testObjectsFactory createStoreWithAuthenticationSystem: self.
	
	self should: [ tusLibrosStore createCartFor: testObjectsFactory clientIDYenny withPassword: 'a wrong password' ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: TusLibrosStore invalidPasswordErrorMessage equals: anError messageText.
		].! !

!TusLibrosStoreTest methodsFor: 'tests' stamp: 'VP 11/29/2020 11:36:11'!
test03ListOfCreatedCartIsEmpty

	| tusLibrosStore cartId |
	
	tusLibrosStore := testObjectsFactory createStoreWithAuthenticationSystem: self.
	
	cartId := tusLibrosStore createCartFor: testObjectsFactory clientIDYenny withPassword: '1234 password'.
	
	self assert: (tusLibrosStore listCart: cartId) isEmpty.! !

!TusLibrosStoreTest methodsFor: 'tests' stamp: 'VP 11/29/2020 11:52:39'!
test05ListOfCartWithAddedItemContainsItem

	| tusLibrosStore cartList |
	
	tusLibrosStore := testObjectsFactory createStoreWithAuthenticationSystem: self.
	
	cartList := self listCartFor: testObjectsFactory clientIDYenny with: 2 of: testObjectsFactory itemSellByTheStore 
				inStore: tusLibrosStore.
	
	self assertArray: {
		testObjectsFactory itemSellByTheStore. 
		testObjectsFactory itemSellByTheStore.
	} isEquivalentTo: cartList.! !

!TusLibrosStoreTest methodsFor: 'tests' stamp: 'VP 11/29/2020 11:49:38'!
test06ListOfEachCartHasBooksCorrespondingToEach

	| tusLibrosStore cart1List cart2List |
	
	tusLibrosStore := testObjectsFactory createStoreWithAuthenticationSystem: self.
	
	cart1List := self listCartFor: testObjectsFactory clientIDYenny with: 2 of: testObjectsFactory itemSellByTheStore 
				inStore: tusLibrosStore.
						
	cart2List := self listCartFor: testObjectsFactory clientIDAteneo with: 1 of: testObjectsFactory itemSellByTheStore
				inStore: tusLibrosStore.
	
	self assertArray: {
		testObjectsFactory itemSellByTheStore. 
		testObjectsFactory itemSellByTheStore.
	} isEquivalentTo: cart1List.
	
	self assertArray: {
		testObjectsFactory itemSellByTheStore.
	} isEquivalentTo: cart2List.
	! !

!TusLibrosStoreTest methodsFor: 'tests' stamp: 'VP 11/30/2020 20:13:42'!
test07CheckoutCartReturnsTransactionID

	| tusLibrosStore transactionID |
	
	tusLibrosStore := testObjectsFactory createStoreWithAuthenticationSystem: self.
	
	transactionID := self createAndCheckoutCartFor: testObjectsFactory clientIDYenny with: 2 of: testObjectsFactory itemSellByTheStore
				inStore: tusLibrosStore.
		
	self assert: tusLibrosStore salesBook size equals: transactionID.
	self assert: tusLibrosStore salesBook last total equals: testObjectsFactory itemSellByTheStorePrice * 2.! !

!TusLibrosStoreTest methodsFor: 'tests' stamp: 'VP 11/30/2020 20:13:46'!
test08ListPurchasesOfClientShouldReturnAllPurchasesOfTheClient

	| tusLibrosStore purchaseList |
	
	tusLibrosStore := testObjectsFactory createStoreWithAuthenticationSystem: self.
	
	self createAndCheckoutCartFor: testObjectsFactory clientIDYenny with: 2 of: testObjectsFactory itemSellByTheStore 
				inStore: tusLibrosStore.
	self createAndCheckoutCartFor: testObjectsFactory clientIDYenny with: 1 of: testObjectsFactory itemSellByTheStore 
				inStore: tusLibrosStore.
		
	purchaseList := tusLibrosStore listPurchasesFor: testObjectsFactory clientIDYenny withPassword: '1234 password'.
	
	self assert: 2 equals: purchaseList size.
	
	self assertArray: {
		testObjectsFactory itemSellByTheStore.
		testObjectsFactory itemSellByTheStore.
	} isEquivalentTo: purchaseList first products.
	self assert: 2 * testObjectsFactory itemSellByTheStorePrice equals: purchaseList first total.
	
	self assertArray: {
		testObjectsFactory itemSellByTheStore.
	} isEquivalentTo: purchaseList second products.
	self assert: testObjectsFactory itemSellByTheStorePrice equals: purchaseList second total.
		
	! !

!TusLibrosStoreTest methodsFor: 'tests' stamp: 'VP 11/29/2020 11:36:37'!
test09ListPurchasesOfNonExistingClientFails

	| tusLibrosStore |
	
	tusLibrosStore := testObjectsFactory createStoreWithAuthenticationSystem: self.
	
	self should: [ tusLibrosStore listPurchasesFor: 'Inexistent Client' withPassword: '1234 password' ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: TusLibrosStore nonExistingClientErrorMessage equals: anError messageText.
		].! !

!TusLibrosStoreTest methodsFor: 'tests' stamp: 'VP 11/29/2020 11:36:43'!
test10ListPurchasesWithWrongPasswordFails

	| tusLibrosStore |
	
	tusLibrosStore := testObjectsFactory createStoreWithAuthenticationSystem: self.
	
	self should: [ tusLibrosStore listPurchasesFor: testObjectsFactory clientIDYenny withPassword: 'a wrong password' ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: TusLibrosStore invalidPasswordErrorMessage equals: anError messageText.
		].! !

!TusLibrosStoreTest methodsFor: 'tests' stamp: 'VP 11/30/2020 20:33:50'!
test11ListCartAfter30MinutesOfCartInactivityFails

	self assertCartActionFailsAfter30MinutesOfCartInactivity: [ :aTusLibrosStore :aCartId |
		aTusLibrosStore listCart: aCartId 
	].! !

!TusLibrosStoreTest methodsFor: 'tests' stamp: 'VP 11/30/2020 20:43:53'!
test12ListCartOperatingBefore30MinutesResetsInactivityTimer

	self assertCartActionSucceedsAfter29MinutesOfCartInactivity: [ :aTusLibrosStore :aCartId :aDateTimeProvider |
		aTusLibrosStore listCart: aCartId.
		aDateTimeProvider changeCurrentDateTimeTo: aDateTimeProvider now + self limitValidCartLife.
		aTusLibrosStore listCart: aCartId.
	].! !

!TusLibrosStoreTest methodsFor: 'tests' stamp: 'VP 11/30/2020 20:33:53'!
test13AddToCartAfter30MinutesOfCartInactivityFails

	self assertCartActionFailsAfter30MinutesOfCartInactivity: [ :aTusLibrosStore :aCartId |
		aTusLibrosStore add: 42 of: testObjectsFactory itemSellByTheStore to: aCartId 
	]! !

!TusLibrosStoreTest methodsFor: 'tests' stamp: 'VP 11/30/2020 20:42:36'!
test14AddToCartOperatingBefore30MinutesResetsInactivityTimer

	self assertCartActionSucceedsAfter29MinutesOfCartInactivity: [ :aTusLibrosStore :aCartId :aDateTimeProvider |
		aTusLibrosStore add: 21 of: testObjectsFactory itemSellByTheStore to: aCartId.
		aDateTimeProvider changeCurrentDateTimeTo: aDateTimeProvider now + self limitValidCartLife.
		aTusLibrosStore add: 21 of: testObjectsFactory itemSellByTheStore to: aCartId.
	].! !

!TusLibrosStoreTest methodsFor: 'tests' stamp: 'VP 11/30/2020 20:36:56'!
test15CheckoutAfter30MinutesOfCartInactivityFails

	self assertCartWithExtraSetUp: [ :aTusLibrosStore :aCartId |
		aTusLibrosStore add: 21 of: testObjectsFactory itemSellByTheStore to: aCartId.
	] actionFailsAfter30MinutesOfCartInactivity: [ :aTusLibrosStore :aCartId  |
		aTusLibrosStore checkout: aCartId
			chargingCardWithNumber: 1
			andExpirationDate: testObjectsFactory notExpiredCreditCardDate 
			andOwner: 'José Yenny'
			throught: self.
	].! !

!TusLibrosStoreTest methodsFor: 'tests' stamp: 'VP 11/30/2020 21:12:25'!
test16AddToInexistentCartFails

	| tusLibrosStore |
	
	tusLibrosStore := testObjectsFactory createStoreWithAuthenticationSystem: self.
		
	self should: [ tusLibrosStore add: 42 of: testObjectsFactory itemSellByTheStore to: 1 ]
		raise: Error
		withMessageText: TusLibrosCartManager nonExistingCartErrorMessage.! !

!TusLibrosStoreTest methodsFor: 'tests' stamp: 'VP 11/30/2020 21:12:31'!
test17ListInexistentCartFails

	| tusLibrosStore |
	
	tusLibrosStore := testObjectsFactory createStoreWithAuthenticationSystem: self.
		
	self should: [ tusLibrosStore listCart: 1 ]
		raise: Error
		withMessageText: TusLibrosCartManager nonExistingCartErrorMessage.! !

!TusLibrosStoreTest methodsFor: 'tests' stamp: 'VP 11/30/2020 21:12:37'!
test18CheckoutInexistentCartFails

	| tusLibrosStore |
	
	tusLibrosStore := testObjectsFactory createStoreWithAuthenticationSystem: self.
	
	self should: [ 
		tusLibrosStore checkout: 1
		chargingCardWithNumber: 1
		andExpirationDate: testObjectsFactory notExpiredCreditCardDate 
		andOwner: 'José Yenny'
		throught: self.
	] raise: Error withMessageText: TusLibrosCartManager nonExistingCartErrorMessage.! !

!TusLibrosStoreTest methodsFor: 'tests' stamp: 'VP 11/30/2020 21:19:27'!
test19DoubleCheckoutFails

	| tusLibrosStore cartId |
	
	tusLibrosStore := testObjectsFactory createStoreWithAuthenticationSystem: self.
	
	cartId := self createCartFor: testObjectsFactory clientIDYenny with: 2 of: testObjectsFactory itemSellByTheStore
				inStore: tusLibrosStore.
				
	self checkout: cartId on: tusLibrosStore.
	
	self should: [ 
		self checkout: cartId on: tusLibrosStore.
	] raise: Error withMessageText: TusLibrosCartManager cantCheckoutCartTwiceErrorMessage.! !


!TusLibrosStoreTest methodsFor: 'setUp/tearDown' stamp: 'VP 11/30/2020 20:12:53'!
setUp

	testObjectsFactory := StoreTestObjectsFactory new.! !


!TusLibrosStoreTest methodsFor: 'merchant processor protocol' stamp: 'VP 11/30/2020 20:13:00'!
debit: anAmount from: aCreditCard! !


!TusLibrosStoreTest methodsFor: 'assertions' stamp: 'VP 11/29/2020 11:42:13'!
assertArray: anExpectedArray isEquivalentTo: aCollection

	self assert: anExpectedArray equals: aCollection asArray.! !


!TusLibrosStoreTest methodsFor: 'support' stamp: 'VP 11/30/2020 20:36:56'!
assertCartActionFailsAfter30MinutesOfCartInactivity: aCartActionBlock

	self assertCartWithExtraSetUp: [ :aTusLibrosStore :aCartId | ] actionFailsAfter30MinutesOfCartInactivity: aCartActionBlock.! !

!TusLibrosStoreTest methodsFor: 'support' stamp: 'VP 11/30/2020 20:43:09'!
assertCartActionSucceedsAfter29MinutesOfCartInactivity: aCartActionBlock

	| dateTimeProvider tusLibrosStore cartId |
	
	dateTimeProvider := DateTimeProviderSimulator withDateTime: testObjectsFactory today.
	tusLibrosStore := testObjectsFactory createStoreWithAuthenticationSystem: self andDateTimeProvider: dateTimeProvider.
	
	cartId := tusLibrosStore createCartFor: testObjectsFactory clientIDYenny withPassword: '1234 password'.
	
	dateTimeProvider changeCurrentDateTimeTo: dateTimeProvider now + self limitValidCartLife.
	
	self shouldnt: [ aCartActionBlock value: tusLibrosStore value: cartId value: dateTimeProvider ] raise: Error.! !

!TusLibrosStoreTest methodsFor: 'support' stamp: 'VP 11/30/2020 21:12:05'!
assertCartWithExtraSetUp: aSetUpClosure actionFailsAfter30MinutesOfCartInactivity: aCartActionBlock

	| dateTimeProvider tusLibrosStore cartId |
	
	dateTimeProvider := DateTimeProviderSimulator withDateTime: testObjectsFactory today.
	tusLibrosStore := testObjectsFactory createStoreWithAuthenticationSystem: self andDateTimeProvider: dateTimeProvider.
	
	cartId := tusLibrosStore createCartFor: testObjectsFactory clientIDYenny withPassword: '1234 password'.
	
	aSetUpClosure value: tusLibrosStore value: cartId.
	
	dateTimeProvider changeCurrentDateTimeTo: dateTimeProvider now + TusLibrosCartManager validCartInactivitySpan.
	
	self should: [ aCartActionBlock value: tusLibrosStore value: cartId ]
		raise: Error
		withMessageText: TusLibrosCartManager expiredCartErrorMessage.! !

!TusLibrosStoreTest methodsFor: 'support' stamp: 'VP 11/30/2020 21:17:54'!
checkout: cartId on: tusLibrosStore

	^ tusLibrosStore checkout: cartId
		chargingCardWithNumber: 1
		andExpirationDate: testObjectsFactory notExpiredCreditCardDate 
		andOwner: 'José Yenny'
		throught: self! !

!TusLibrosStoreTest methodsFor: 'support' stamp: 'VP 11/30/2020 21:18:53'!
createAndCheckoutCartFor: aClientID with: aQuantity of: aBook inStore: aTusLibrosStore

	| cartId |
	
	cartId := self createCartFor: aClientID with: aQuantity of: aBook inStore: aTusLibrosStore.
	
	^self checkout: cartId on: aTusLibrosStore.! !

!TusLibrosStoreTest methodsFor: 'support' stamp: 'VP 11/29/2020 11:51:44'!
createCartFor: aClientID with: aQuantity of: aBook inStore: aTusLibrosStore

	| cartId |
	
	cartId := aTusLibrosStore createCartFor: aClientID withPassword: '1234 password'.
	
	aTusLibrosStore add: aQuantity of: aBook to: cartId.
	^cartId.! !

!TusLibrosStoreTest methodsFor: 'support' stamp: 'VP 11/30/2020 21:12:17'!
limitValidCartLife

	^ TusLibrosCartManager validCartInactivitySpan - (Duration minutes: 1)! !

!TusLibrosStoreTest methodsFor: 'support' stamp: 'VP 11/29/2020 11:52:02'!
listCartFor: aClientID with: aQuantity of: aBook inStore: aTusLibrosStore

	| cartId |
	
	cartId := self createCartFor: aClientID with: aQuantity of: aBook inStore: aTusLibrosStore.
	
	^aTusLibrosStore listCart: cartId! !


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


!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:06'!
assertIsValidItem: anItem

	(catalog includesKey: anItem) ifFalse: [ self error: self invalidItemErrorMessage ]! !

!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 17:51'!
assertIsValidQuantity: aQuantity

	aQuantity strictlyPositive ifFalse: [ self error: self invalidQuantityErrorMessage ]! !


!Cart methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 17:48'!
initializeAcceptingItemsOf: aCatalog

	catalog := aCatalog.
	items := OrderedCollection new.! !


!Cart methodsFor: 'queries' stamp: 'VP 11/28/2020 11:39:21'!
listItems

	^items copy.  ! !

!Cart methodsFor: 'queries' stamp: 'VP 11/28/2020 11:39:05'!
occurrencesOf: anItem

	^items occurrencesOf: anItem  ! !


!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
includes: anItem

	^items includes: anItem ! !

!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
isEmpty
	
	^items isEmpty ! !


!Cart methodsFor: 'total' stamp: 'HernanWilkinson 6/17/2013 19:09'!
total

	^ items sum: [ :anItem | catalog at: anItem ]! !


!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:44'!
add: anItem

	^ self add: 1 of: anItem ! !

!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:51'!
add: aQuantity of: anItem

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.

	1 to: aQuantity do: [ :aNumber | items add: anItem ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 17:48'!
acceptingItemsOf: aCatalog

	^self new initializeAcceptingItemsOf: aCatalog ! !


!classDefinition: #CartSale category: 'TusLibros'!
Object subclass: #CartSale
	instanceVariableNames: 'clientID products total'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartSale methodsFor: 'initialization' stamp: 'VP 11/29/2020 10:44:05'!
initializeWith: aClientID forProductsIn: aCart withTotal: aTotal

	clientID := aClientID.
	products := aCart listItems.
	total := aTotal.! !


!CartSale methodsFor: 'accessing' stamp: 'VP 11/29/2020 11:05:38'!
clientID

	^clientID.! !

!CartSale methodsFor: 'accessing' stamp: 'VP 11/29/2020 11:05:43'!
products

	^products copy.! !

!CartSale methodsFor: 'accessing' stamp: 'VP 11/29/2020 11:06:01'!
total

	^total.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CartSale class' category: 'TusLibros'!
CartSale class
	instanceVariableNames: ''!

!CartSale class methodsFor: 'instance creation' stamp: 'VP 11/29/2020 10:42:57'!
of: aClientID forProductsIn: aCart withTotal: aTotal

	^self new initializeWith: aClientID forProductsIn: aCart withTotal: aTotal.! !


!classDefinition: #Cashier category: 'TusLibros'!
Object subclass: #Cashier
	instanceVariableNames: 'cart salesBook merchantProcessor creditCard total'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:08'!
calculateTotal

	total := cart total.
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:07'!
createSale

	^ Sale of: total
! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:06'!
debitTotal

	merchantProcessor debit: total from: creditCard.
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:06'!
registerSale

	salesBook add: self createSale! !


!Cashier methodsFor: 'checkout' stamp: 'HernanWilkinson 6/17/2013 19:06'!
checkOut

	self calculateTotal.
	self debitTotal.
	self registerSale.

	^ total! !


!Cashier methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:53'!
initializeToCheckout: aCart charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook
	
	cart := aCart.
	creditCard := aCreditCard.
	merchantProcessor := aMerchantProcessor.
	salesBook := aSalesBook! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: 'TusLibros'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:22'!
assertIsNotEmpty: aCart 
	
	aCart isEmpty ifTrue: [self error: self cartCanNotBeEmptyErrorMessage ]! !

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:23'!
assertIsNotExpired: aCreditCard on: aDate
	
	(aCreditCard isExpiredOn: aDate) ifTrue: [ self error: self canNotChargeAnExpiredCreditCardErrorMessage ]! !


!Cashier class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:51'!
toCheckout: aCart charging: aCreditCard throught: aMerchantProcessor on: aDate registeringOn: aSalesBook
	
	self assertIsNotEmpty: aCart.
	self assertIsNotExpired: aCreditCard on: aDate.
	
	^self new initializeToCheckout: aCart charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook! !


!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 18:21'!
canNotChargeAnExpiredCreditCardErrorMessage
	
	^'Can not charge an expired credit card'! !

!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:56'!
cartCanNotBeEmptyErrorMessage
	
	^'Can not check out an empty cart'! !

!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 19:02'!
creditCardHasNoCreditErrorMessage
	
	^'Credit card has no credit'! !


!classDefinition: #Client category: 'TusLibros'!
Object subclass: #Client
	instanceVariableNames: 'id carts'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Client methodsFor: 'initialization' stamp: 'VP 11/29/2020 11:01:57'!
initializeWith: aClientID

	id := aClientID.
	carts := OrderedCollection new.! !


!Client methodsFor: 'accessing' stamp: 'VP 11/29/2020 11:03:15'!
carts

	^carts copy.! !

!Client methodsFor: 'accessing' stamp: 'VP 11/29/2020 10:57:47'!
id

	^id.! !


!Client methodsFor: 'operation' stamp: 'VP 11/29/2020 11:01:42'!
addCart: aCartID

	carts add: aCartID.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Client class' category: 'TusLibros'!
Client class
	instanceVariableNames: ''!

!Client class methodsFor: 'instance creation' stamp: 'VP 11/29/2020 10:57:06'!
withID: aClientID

	^self new initializeWith: aClientID.! !


!classDefinition: #CreditCard category: 'TusLibros'!
Object subclass: #CreditCard
	instanceVariableNames: 'expiration'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 18:39'!
isExpiredOn: aDate 
	
	^expiration start < (Month month: aDate monthIndex year: aDate yearNumber) start ! !


!CreditCard methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:38'!
initializeExpiringOn: aMonth 
	
	expiration := aMonth ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: 'TusLibros'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:38'!
expiringOn: aMonth 
	
	^self new initializeExpiringOn: aMonth! !


!classDefinition: #DateTimeProviderSimulator category: 'TusLibros'!
Object subclass: #DateTimeProviderSimulator
	instanceVariableNames: 'now'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!DateTimeProviderSimulator methodsFor: 'datetime' stamp: 'VP 11/30/2020 18:14:59'!
changeCurrentDateTimeTo: aNewDateTime

	now := aNewDateTime.! !

!DateTimeProviderSimulator methodsFor: 'datetime' stamp: 'VP 11/30/2020 18:28:55'!
initializeWithDateTime: aDateTime

	now := aDateTime.! !

!DateTimeProviderSimulator methodsFor: 'datetime' stamp: 'VP 11/30/2020 18:14:10'!
now

	^now.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DateTimeProviderSimulator class' category: 'TusLibros'!
DateTimeProviderSimulator class
	instanceVariableNames: ''!

!DateTimeProviderSimulator class methodsFor: 'instance creation' stamp: 'VP 11/30/2020 18:15:32'!
withDateTime: aDateTime

	^self new initializeWithDateTime: aDateTime.! !


!classDefinition: #Sale category: 'TusLibros'!
Object subclass: #Sale
	instanceVariableNames: 'total'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Sale methodsFor: 'total' stamp: 'HernanWilkinson 6/17/2013 18:48'!
total
	
	^ total! !


!Sale methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:47'!
initializeTotal: aTotal

	total := aTotal ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Sale class' category: 'TusLibros'!
Sale class
	instanceVariableNames: ''!

!Sale class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:47'!
of: aTotal

	"should assert total is not negative or 0!!"
	^self new initializeTotal: aTotal ! !


!classDefinition: #StoreTestObjectsFactory category: 'TusLibros'!
Object subclass: #StoreTestObjectsFactory
	instanceVariableNames: 'today'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/17/2013 18:08'!
itemNotSellByTheStore
	
	^'invalidBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/17/2013 18:08'!
itemSellByTheStore
	
	^ 'validBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/17/2013 18:08'!
itemSellByTheStorePrice
	
	^10! !


!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'HernanWilkinson 6/17/2013 18:08'!
createCart
	
	^Cart acceptingItemsOf: self defaultCatalog! !

!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'HernanWilkinson 6/17/2013 18:08'!
defaultCatalog
	
	^ Dictionary new
		at: self itemSellByTheStore put: self itemSellByTheStorePrice;
		yourself ! !


!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HernanWilkinson 6/17/2013 18:37'!
expiredCreditCard
	
	^CreditCard expiringOn: (Month month: today monthIndex year: today yearNumber - 1)! !

!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'VP 11/30/2020 20:21:08'!
notExpiredCreditCard
	
	^CreditCard expiringOn: self notExpiredCreditCardDate! !

!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'VP 11/30/2020 20:21:04'!
notExpiredCreditCardDate

	^ Month month: today monthIndex year: today yearNumber + 1! !


!StoreTestObjectsFactory methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:37'!
initialize

	today := DateAndTime now! !


!StoreTestObjectsFactory methodsFor: 'date' stamp: 'HernanWilkinson 6/17/2013 18:37'!
today
	
	^ today! !


!StoreTestObjectsFactory methodsFor: 'clients' stamp: 'VP 11/29/2020 11:16:22'!
clientIDAteneo
	^'Ateneo'.! !

!StoreTestObjectsFactory methodsFor: 'clients' stamp: 'VP 11/29/2020 11:16:15'!
clientIDYenny
	^'Yenny'.! !

!StoreTestObjectsFactory methodsFor: 'clients' stamp: 'VP 11/29/2020 11:16:34'!
clientList

	^OrderedCollection with: (Client withID: self clientIDYenny) with: (Client withID: self clientIDAteneo).! !


!StoreTestObjectsFactory methodsFor: 'store' stamp: 'VP 11/30/2020 18:24:08'!
createStoreWithAuthenticationSystem: anAuthenticationSystem
	
	^TusLibrosStore newWithAuthenticationSystem: anAuthenticationSystem withClients: self clientList dateTimeProvider: (DateTimeProviderSimulator withDateTime: self today).! !

!StoreTestObjectsFactory methodsFor: 'store' stamp: 'VP 11/30/2020 18:19:07'!
createStoreWithAuthenticationSystem: anAuthenticationSystem andDateTimeProvider: aDateTimeProvider
	
	^TusLibrosStore newWithAuthenticationSystem: anAuthenticationSystem withClients: self clientList dateTimeProvider: aDateTimeProvider.! !


!classDefinition: #TusLibrosCartManager category: 'TusLibros'!
Object subclass: #TusLibrosCartManager
	instanceVariableNames: 'carts cartLastUsed checkedOutCarts dateTimeProvider'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TusLibrosCartManager methodsFor: 'initialization' stamp: 'VP 11/30/2020 20:54:48'!
initializeWith: aDateTimeProvider

	carts := OrderedCollection new.
	cartLastUsed := OrderedCollection new.
	checkedOutCarts := OrderedCollection new.
	dateTimeProvider := aDateTimeProvider.! !


!TusLibrosCartManager methodsFor: 'testing' stamp: 'VP 11/30/2020 20:55:01'!
cartExpired: aCartID

	^ (self expirationTimeForCart: aCartID) <= dateTimeProvider now.! !


!TusLibrosCartManager methodsFor: 'accessing' stamp: 'VP 11/30/2020 21:05:05'!
cartWithID: aCartID

	^carts at: aCartID.! !

!TusLibrosCartManager methodsFor: 'accessing' stamp: 'VP 11/30/2020 20:55:22'!
expirationTimeForCart: aCartID

	^ (cartLastUsed at: aCartID) + (self class validCartInactivitySpan).! !


!TusLibrosCartManager methodsFor: 'adding' stamp: 'VP 11/30/2020 20:58:10'!
add: aCart

	carts add: aCart.
	cartLastUsed add: dateTimeProvider now.
	
	^carts size.! !

!TusLibrosCartManager methodsFor: 'adding' stamp: 'VP 11/30/2020 21:03:25'!
add: aQuantity of: aBook to: aCartID

	(carts at: aCartID) add: aQuantity of: aBook.! !


!TusLibrosCartManager methodsFor: 'assertions' stamp: 'VP 11/30/2020 21:00:07'!
assertCartExists: aCartID

	^ aCartID > carts size ifTrue: [ self error: self class nonExistingCartErrorMessage ]! !

!TusLibrosCartManager methodsFor: 'assertions' stamp: 'VP 11/30/2020 21:00:28'!
assertCartExistsAndIsNotExpired: aCartID

	self assertCartExists: aCartID.
	self assertCartNotExpired: aCartID.! !

!TusLibrosCartManager methodsFor: 'assertions' stamp: 'VP 11/30/2020 21:15:11'!
assertCartNeverCheckedOut: aCartID 
	
	^(checkedOutCarts includes: aCartID) ifTrue: [ self error: self class cantCheckoutCartTwiceErrorMessage ].! !

!TusLibrosCartManager methodsFor: 'assertions' stamp: 'VP 11/30/2020 21:00:38'!
assertCartNotExpired: aCartID

	^(self cartExpired: aCartID) ifTrue: [ self error: self class expiredCartErrorMessage ].! !


!TusLibrosCartManager methodsFor: 'updating' stamp: 'VP 11/30/2020 21:15:37'!
cartCheckedOut: aCartID

	^checkedOutCarts add: aCartID.! !

!TusLibrosCartManager methodsFor: 'updating' stamp: 'VP 11/30/2020 21:09:32'!
updateLastUsedForCart: aCartID

	^cartLastUsed at: aCartID put: dateTimeProvider now.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TusLibrosCartManager class' category: 'TusLibros'!
TusLibrosCartManager class
	instanceVariableNames: ''!

!TusLibrosCartManager class methodsFor: 'instance creation' stamp: 'VP 11/30/2020 20:59:21'!
newWith: aDateTimeProvider

	^self new initializeWith: aDateTimeProvider.! !


!TusLibrosCartManager class methodsFor: 'error messages -- private' stamp: 'VP 11/30/2020 21:10:54'!
cantCheckoutCartTwiceErrorMessage
	
	^'The given cart has already been checked out'.! !

!TusLibrosCartManager class methodsFor: 'error messages -- private' stamp: 'VP 11/30/2020 21:10:42'!
expiredCartErrorMessage
	
	^'The requested cart has expired, please create a new one'.! !

!TusLibrosCartManager class methodsFor: 'error messages -- private' stamp: 'VP 11/30/2020 21:10:16'!
nonExistingCartErrorMessage
	
	^'The cart you are trying to operate in does not exist'.! !


!TusLibrosCartManager class methodsFor: 'cart lifetime' stamp: 'VP 11/30/2020 21:11:09'!
validCartInactivitySpan

	^Duration minutes: 30! !


!classDefinition: #TusLibrosStore category: 'TusLibros'!
Object subclass: #TusLibrosStore
	instanceVariableNames: 'authenticationSystem cartManager bookCatalog salesBook clients dateTimeProvider'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TusLibrosStore methodsFor: 'initialization' stamp: 'VP 11/30/2020 20:58:56'!
initializeNewWithAuthenticationSystem: anAuthenticationSystem withClients: aClientList andDateTimeProvider: aDateTimeProvider

	authenticationSystem := anAuthenticationSystem.
	clients := aClientList.
	dateTimeProvider := aDateTimeProvider.
	bookCatalog := self class createStoreCatalog.
	
	cartManager := TusLibrosCartManager newWith: dateTimeProvider.
	salesBook := OrderedCollection new.! !


!TusLibrosStore methodsFor: 'create' stamp: 'VP 11/30/2020 20:57:42'!
createCartFor: aClientID withPassword: aPassword
	
	self validate: aClientID with: aPassword andDo: [ | cartID |
		cartID := cartManager add: (Cart acceptingItemsOf: bookCatalog)..
		(self clientWithID: aClientID) addCart: cartID.
		
		^cartID.
	]! !


!TusLibrosStore methodsFor: 'assertions -- private' stamp: 'VP 11/30/2020 21:01:15'!
assertNotExpired: aCartID updateLastUseAndDo: aNonExpiredCartClosure

	cartManager assertCartExistsAndIsNotExpired: aCartID.
	cartManager updateLastUsedForCart: aCartID.
	
	aNonExpiredCartClosure value.! !



!TusLibrosStore methodsFor: 'list' stamp: 'VP 11/30/2020 21:05:40'!
listCart: aCartID 
	
	self assertNotExpired: aCartID updateLastUseAndDo: [
		^(cartManager cartWithID: aCartID) listItems.
	].! !

!TusLibrosStore methodsFor: 'list' stamp: 'VP 11/29/2020 11:29:10'!
listPurchasesFor: aClientID withPassword: aPassword

	self validate: aClientID with: aPassword andDo: [
		^salesBook select: [ :aCartSale | aCartSale clientID = aClientID ].
	].! !


!TusLibrosStore methodsFor: 'add' stamp: 'VP 11/30/2020 21:03:44'!
add: aQuantity of: aBook to: aCartID
	
	self assertNotExpired: aCartID updateLastUseAndDo: [
		cartManager add: aQuantity of: aBook to: aCartID.
	].! !


!TusLibrosStore methodsFor: 'checkout' stamp: 'VP 11/30/2020 21:16:15'!
checkout: aCartID chargingCardWithNumber: aCreditCardNumber andExpirationDate: aCreditCardExpirationDate andOwner: aCreditCardOwner throught: aMerchantProcessor 

	| cashier cart clientID total |

	cartManager assertCartExistsAndIsNotExpired: aCartID.
	cartManager assertCartNeverCheckedOut: aCartID.

	"NOTA: Estamos usando la solución de la iteración 2 de la cátedra, donde la CreditCard no almacena ni número ni owner (suponemos porque el MerchantProcessorSimulator no lo usa y no hubo necesidad)"
	cart := cartManager cartWithID: aCartID.
	cashier := Cashier toCheckout: cart
		 charging: (CreditCard expiringOn: aCreditCardExpirationDate)
		 throught: aMerchantProcessor
		 on: dateTimeProvider now
		 registeringOn: OrderedCollection new.
	cartManager cartCheckedOut: aCartID.
		
	total := cashier checkOut.
	
	clientID := self clientIDFor: aCartID.
	self registerSaleOf: cart by: clientID withTotal: total.
	
	^salesBook size.! !


!TusLibrosStore methodsFor: 'sales' stamp: 'VP 11/28/2020 11:55:44'!
salesBook

	^salesBook copy.! !


!TusLibrosStore methodsFor: 'client -- private' stamp: 'VP 11/28/2020 10:55:42'!
assert: aClientID correspondsWith: aPassword

	^ (authenticationSystem authenticate: aClientID withPassword: aPassword) ifFalse: [ self error: self class invalidPasswordErrorMessage ]! !

!TusLibrosStore methodsFor: 'client -- private' stamp: 'VP 11/29/2020 11:23:53'!
assertClientExists: aClientID

	^(clients noneSatisfy: [ :aClient | aClient id = aClientID ])
		ifTrue: [ self error: self class nonExistingClientErrorMessage ]! !

!TusLibrosStore methodsFor: 'client -- private' stamp: 'VP 11/29/2020 11:04:35'!
clientIDFor: aCartID

	^(self clientWithCart: aCartID) id.! !

!TusLibrosStore methodsFor: 'client -- private' stamp: 'VP 11/29/2020 11:11:03'!
clientWithCart: aCartID

	^clients detect: [ :aClient | aClient carts includes: aCartID ].! !

!TusLibrosStore methodsFor: 'client -- private' stamp: 'VP 11/29/2020 11:13:55'!
clientWithID: aClientID

	^ clients detect: [ :aClient | aClient id = aClientID ]! !


!TusLibrosStore methodsFor: 'validation -- private' stamp: 'VP 11/29/2020 11:28:19'!
validate: aClientID with: aPassword andDo: aValidatedClosure

	self assertClientExists: aClientID.
	self assert: aClientID correspondsWith: aPassword.

	aValidatedClosure value.! !


!TusLibrosStore methodsFor: 'sales -- private' stamp: 'VP 11/29/2020 11:41:41'!
registerSaleOf: cart by: clientID withTotal: total

	^ salesBook add: (CartSale of: clientID forProductsIn: cart withTotal: total)! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TusLibrosStore class' category: 'TusLibros'!
TusLibrosStore class
	instanceVariableNames: ''!

!TusLibrosStore class methodsFor: 'instance creation' stamp: 'VP 11/30/2020 18:22:45'!
newWithAuthenticationSystem: anAuthenticationSystem withClients: aClientList dateTimeProvider: aDateTimeProvider
	
	^self new initializeNewWithAuthenticationSystem: anAuthenticationSystem withClients: aClientList andDateTimeProvider: aDateTimeProvider.! !


!TusLibrosStore class methodsFor: 'error messages -- private' stamp: 'VP 11/28/2020 10:52:12'!
invalidPasswordErrorMessage
	
	^'Invalid client id - password combination'.! !

!TusLibrosStore class methodsFor: 'error messages -- private' stamp: 'VP 11/29/2020 11:20:30'!
nonExistingClientErrorMessage
	
	^'There is no Client associated with the given ClientID'.! !


!TusLibrosStore class methodsFor: 'catalog' stamp: 'VP 11/28/2020 11:28:57'!
createStoreCatalog
	
	^Dictionary new
		at: 'validBook' put: 10;
		yourself.! !
