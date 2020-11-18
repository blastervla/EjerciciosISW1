!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'tests' stamp: 'VP 11/18/2020 16:04:23'!
test01NewCartIsEmpty

	| cart |
	
	cart := Cart newWithCatalog: #('1').
	
	self assert: cart isEmpty.! !

!CartTest methodsFor: 'tests' stamp: 'VP 11/18/2020 16:04:21'!
test02BookAddedToCartIsInCart

	| cart book |
	
	cart := Cart newWithCatalog: #('1').
	book := '1'.
	cart add: book.
	
	self deny: cart isEmpty.
	self assert: 1 equals: (cart quantityOfProduct: book).! !

!CartTest methodsFor: 'tests' stamp: 'VP 11/18/2020 16:04:16'!
test03CartCanHoldSameBookMultipleTimes

	| cart book |
	
	cart := Cart newWithCatalog: #('1').
	book := '1'.
	cart add: book.
	cart add: book.
	
	self deny: cart isEmpty.
	self assert: 2 equals: (cart quantityOfProduct: book).! !

!CartTest methodsFor: 'tests' stamp: 'VP 11/18/2020 16:04:09'!
test04CartCanHoldDifferentBooks

	| cart book1 book2 |
	
	cart := Cart newWithCatalog: #('1', '2').
	book1 := '1'.
	book2 := '2'.
	cart add: book1 times: 2.
	cart add: book2.
	
	self deny: cart isEmpty.
	self assert: 2 equals: (cart quantityOfProduct: book1).
	self assert: 1 equals: (cart quantityOfProduct: book2).! !

!CartTest methodsFor: 'tests' stamp: 'VP 11/18/2020 16:04:00'!
test05EmptyCartListingIsEmpty

	| cart |
	
	cart := Cart newWithCatalog: #('1').
	
	self assert: cart isEmpty.
	self assert: cart productListing isEmpty.! !

!CartTest methodsFor: 'tests' stamp: 'VP 11/18/2020 16:03:49'!
test06CartListingHasAllCartProductsGroupedByISBN

	| cart book1 book2 listing |
	
	cart := Cart newWithCatalog: #('1', '2').
	book1 := '1'.
	book2 := '2'.
	cart add: book1 times: 2.
	cart add: book2.
	
	listing := cart productListing.
	
	self deny: cart isEmpty.
	self assert: 2 equals: listing size.
	self assert: 2 equals: (listing at: book1).
	self assert: 1 equals: (listing at: book2).! !

!CartTest methodsFor: 'tests' stamp: 'VP 11/18/2020 16:07:47'!
test07CanNotAddProductOutsideCatalog

	| cart outsideBook |
	
	cart := Cart newWithCatalog: #('1').
	outsideBook := 'NOT_A_BOOK'.
	
	self should: [ cart add: outsideBook ] 
		raise: Error
		withExceptionDo: [ :anError |
			self assert: Cart productOutsideCatalogErrorMessage equals: anError messageText.
			self assert: cart isEmpty.
		].! !


!classDefinition: #MerchantProcessorClientTest category: 'TusLibros'!
TestCase subclass: #MerchantProcessorClientTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!MerchantProcessorClientTest methodsFor: 'as yet unclassified' stamp: 'VP 11/16/2020 17:38:04'!
test01ClientCallWithAllParamsShouldPerformRequest! !

!MerchantProcessorClientTest methodsFor: 'as yet unclassified' stamp: 'VP 11/16/2020 17:38:45'!
test02ClientCallWithMissingCreditCardNumberShouldFail! !

!MerchantProcessorClientTest methodsFor: 'as yet unclassified' stamp: 'VP 11/16/2020 17:42:20'!
test03ClientCallWithMissingCreditCardExpirationShouldFail

	"Seguiríamos escribiendo:
		- tests para cada parámetro como faltante
		- tests para validar el formato de cada parámetro (al ser cada request pago, 
		  no tiene sentido enviar requests que sabemos de antemano que van a fallar"! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'products productCatalog'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'accessing' stamp: 'VP 11/16/2020 19:21:05'!
isEmpty
	
	^products isEmpty.! !

!Cart methodsFor: 'accessing' stamp: 'VP 11/18/2020 15:59:47'!
productListing
	
	^products asSet inject: Dictionary new into: [ :listing :aProduct | 
		listing at: aProduct put: (products occurrencesOf: aProduct); yourself.
	].

	"
	Una alternativa viable es esta, pero nos pareció más operacional y menos declarativa.
	products inject: Dictionary new into: [ :listing :aProduct | 
		| amount |
		amount := listing at: aProduct ifAbsent: [ 0 ].
		listing at: aProduct put: amount + 1.
	].
	"! !

!Cart methodsFor: 'accessing' stamp: 'VP 11/16/2020 19:37:52'!
quantityOfProduct: aProduct 
	
	^products occurrencesOf: aProduct.! !


!Cart methodsFor: 'operations' stamp: 'VP 11/16/2020 19:20:56'!
add: aProduct 
	
	self add: aProduct times: 1.! !

!Cart methodsFor: 'operations' stamp: 'VP 11/18/2020 16:05:47'!
add: aProduct times: aQuantity
	
	self verifyProductInCatalog: aProduct.
	
	products add: aProduct withOccurrences: aQuantity.! !


!Cart methodsFor: 'initialization' stamp: 'VP 11/16/2020 19:37:12'!
initialize
	
	products := Bag new.! !

!Cart methodsFor: 'initialization' stamp: 'VP 11/18/2020 16:05:17'!
initializeNewWithCatalog: aProductCatalog 

	productCatalog := aProductCatalog.! !


!Cart methodsFor: 'testing' stamp: 'VP 11/18/2020 16:07:56'!
verifyProductInCatalog: aProduct
	
	(productCatalog includes: aProduct) ifFalse: [ self error: self class productOutsideCatalogErrorMessage ].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'VP 11/18/2020 16:08:08'!
newWithCatalog: aProductCatalog

	^self new initializeNewWithCatalog: aProductCatalog.! !


!Cart class methodsFor: 'error messages -- private' stamp: 'VP 11/18/2020 16:08:33'!
productOutsideCatalogErrorMessage

	^'The product you are trying to add is outside the catalog, and therefore cannot be added'.! !
