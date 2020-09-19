!classDefinition: #CantSuspend category: #'CodigoRepetido-Ejercicio'!
Error subclass: #CantSuspend
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!


!classDefinition: #NotFound category: #'CodigoRepetido-Ejercicio'!
Error subclass: #NotFound
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!


!classDefinition: #CustomerBookTest category: #'CodigoRepetido-Ejercicio'!
TestCase subclass: #CustomerBookTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBookTest methodsFor: 'testing' stamp: 'VP 9/19/2020 12:03:39'!
test01AddingCustomerShouldNotTakeMoreThan50Milliseconds

	| customerBook |
	
	customerBook := CustomerBook new.

	self assertThatAction: [customerBook addCustomerNamed: self johnLennon] completesUnderTime: 50 * millisecond.
	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'VP 9/19/2020 12:03:49'!
test02RemovingCustomerShouldNotTakeMoreThan100Milliseconds

	| customerBook |
	
	customerBook := CustomerBook new.

	customerBook addCustomerNamed: self paulMcCartney.
	
	self assertThatAction: [customerBook removeCustomerNamed: self paulMcCartney] completesUnderTime: 100 * millisecond.
	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'VP 9/19/2020 12:00:38'!
test03CanNotAddACustomerWithEmptyName 

	| customerBook |
	
	customerBook := CustomerBook new.

	"Habría estado bueno crear un error especial (e.g: InvalidCustomerName)
	 en lugar de usar un Error genérico, para aumentar la declaratividad.
	 No lo hicimos, porque se supone que esto es un refactor y eso estaría
	 cambiando comportamiento."
	self assertThat: [ customerBook addCustomerNamed:'' ]
	      raisesError: Error
		andPerformErrorChecks:  [ :anError | 
			self assert: anError messageText = CustomerBook customerCanNotBeEmptyErrorMessage.
			self assert: customerBook isEmpty ].! !

!CustomerBookTest methodsFor: 'testing' stamp: 'VP 9/19/2020 12:00:38'!
test04CanNotRemoveAnInvalidCustomer

	| customerBook |
	
	customerBook := CustomerBook new.

	customerBook addCustomerNamed: self johnLennon.
	
	self assertThat: [ customerBook removeCustomerNamed: self paulMcCartney ]
	      raisesError: NotFound
	       andPerformErrorChecks: [ :anError | 
			self assert: customerBook numberOfCustomers = 1.
			self assert: (customerBook includesCustomerNamed: self johnLennon) ].
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'VP 9/19/2020 11:51:51'!
test05SuspendingACustomerShouldNotRemoveItFromCustomerBook
	
	| customerBook |
	
	customerBook := CustomerBook new.
	
	customerBook addCustomerNamed: self paulMcCartney.
	customerBook suspendCustomerNamed: self paulMcCartney.
	
	self assertThat: customerBook hasActiveCustomerAmount: 0 andSuspendedCustomerAmount: 1.
	self assert: (customerBook includesCustomerNamed: self paulMcCartney).
	

	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'VP 9/19/2020 11:52:13'!
test06RemovingASuspendedCustomerShouldRemoveItFromCustomerBook
	
	| customerBook |
	
	customerBook := CustomerBook new.
	
	customerBook addCustomerNamed: self paulMcCartney.
	customerBook suspendCustomerNamed: self paulMcCartney.
	customerBook removeCustomerNamed: self paulMcCartney.
	
	self assertThat: customerBook hasActiveCustomerAmount: 0 andSuspendedCustomerAmount: 0.
	self deny: (customerBook includesCustomerNamed: self paulMcCartney).


	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'VP 9/19/2020 12:00:38'!
test07CanNotSuspendAnInvalidCustomer

	| customerBook |
	
	customerBook := CustomerBook new.

	customerBook addCustomerNamed: self johnLennon.
	
	self assertThat: [ customerBook suspendCustomerNamed: self georgeHarrison ]
	      raisesError: CantSuspend
	       andPerformErrorChecks: [ :anError | 
			self assert: customerBook numberOfCustomers = 1.
			self assert: (customerBook includesCustomerNamed: self johnLennon) ].! !

!CustomerBookTest methodsFor: 'testing' stamp: 'VP 9/19/2020 12:00:38'!
test08CanNotSuspendAnAlreadySuspendedCustomer

	| customerBook |
	
	customerBook := CustomerBook new.

	customerBook addCustomerNamed: self johnLennon.
	customerBook suspendCustomerNamed: self johnLennon.
	
	self assertThat: [ customerBook suspendCustomerNamed: self johnLennon ]
	      raisesError: CantSuspend
	       andPerformErrorChecks: [ :anError |
			self assert: customerBook numberOfCustomers = 1.
			self assert: (customerBook includesCustomerNamed: self johnLennon) ].
! !


!CustomerBookTest methodsFor: 'constant' stamp: 'VP 9/17/2020 21:58:23'!
georgeHarrison
	^'George Harrison'! !

!CustomerBookTest methodsFor: 'constant' stamp: 'VP 9/17/2020 21:58:08'!
johnLennon
	^'John Lennon'! !

!CustomerBookTest methodsFor: 'constant' stamp: 'VP 9/17/2020 21:57:59'!
paulMcCartney
	^'Paul McCartney'! !


!CustomerBookTest methodsFor: 'assert' stamp: 'VP 9/19/2020 12:06:02'!
assertThat: aCustomerBook hasActiveCustomerAmount: activeAmount andSuspendedCustomerAmount: suspendedAmount
	
	self assert: activeAmount equals: aCustomerBook numberOfActiveCustomers.
	self assert: suspendedAmount equals: aCustomerBook numberOfSuspendedCustomers.
	self assert: activeAmount + suspendedAmount equals: aCustomerBook numberOfCustomers.


	
! !

!CustomerBookTest methodsFor: 'assert' stamp: 'VP 9/19/2020 12:07:41'!
assertThat: anErrorProneOperation raisesError: errorType andPerformErrorChecks: extraConditionChecks

	[ anErrorProneOperation value.
	self fail ]
		on: errorType 
		do: extraConditionChecks.
! !

!CustomerBookTest methodsFor: 'assert' stamp: 'VP 9/19/2020 12:07:51'!
assertThatAction: anOperationToMeasure completesUnderTime: maxTime

	| millisBeforeAction millisAfterAction |
	  
	millisBeforeAction := Time millisecondClockValue * millisecond.
	anOperationToMeasure value.
	millisAfterAction := Time millisecondClockValue * millisecond.
	
	self assert: (millisAfterAction - millisBeforeAction) < (maxTime)! !


!classDefinition: #CustomerBook category: #'CodigoRepetido-Ejercicio'!
Object subclass: #CustomerBook
	instanceVariableNames: 'suspended active'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBook methodsFor: 'testing' stamp: 'NR 4/3/2019 10:14:26'!
includesCustomerNamed: aName

	^(active includes: aName) or: [ suspended includes: aName ]! !

!CustomerBook methodsFor: 'testing' stamp: 'VP 9/19/2020 11:36:25'!
isEmpty
	
	" Elegimos hacer este cambio porque de esta manera si se fuera
	  a cambiar la representación interna del objeto (e.g: agregar una
	  categoría 'banned', etc.), u ocurriera algún otro cambio conceptual,
	  sólo necesitaríamos modificar el método `numberOfCustomers`. "
	
	^self numberOfCustomers = 0.! !


!CustomerBook methodsFor: 'initialization' stamp: 'NR 9/17/2020 07:23:04'!
initialize

	active := OrderedCollection new.
	suspended:= OrderedCollection new.! !


!CustomerBook methodsFor: 'customer management' stamp: 'VP 9/19/2020 11:09:45'!
addCustomerNamed: aName

	aName isEmpty ifTrue: [ self signalCustomerNameCannotBeEmpty ].
	(self includesCustomerNamed: aName) ifTrue: [ self signalCustomerAlreadyExists ].
	
	active add: aName! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
numberOfActiveCustomers
	
	^active size! !

!CustomerBook methodsFor: 'customer management' stamp: 'VP 9/19/2020 11:10:12'!
numberOfCustomers
	
	^self numberOfActiveCustomers + self numberOfSuspendedCustomers! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 9/19/2018 17:36:09'!
numberOfSuspendedCustomers
	
	^suspended size! !

!CustomerBook methodsFor: 'customer management' stamp: 'VP 9/19/2020 11:28:19'!
removeCustomerNamed: aName

	self removeCustomerNamed: aName fromCollection: active andDoOnSuccess: [^aName].
	self removeCustomerNamed: aName fromCollection: suspended andDoOnSuccess: [^aName].
	
	^ NotFound signal.
! !

!CustomerBook methodsFor: 'customer management' stamp: 'VP 9/19/2020 12:05:24'!
removeCustomerNamed: aName fromCollection: aCustomerCollection andDoOnSuccess: anOnSuccessClosure
 
	1 to: aCustomerCollection size do: 
	[ :index |
		aName = (aCustomerCollection at: index)
			ifTrue: [
				aCustomerCollection removeAt: index.
				anOnSuccessClosure value.
			] 
	].! !

!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:52'!
signalCustomerAlreadyExists 

	self error: self class customerAlreadyExistsErrorMessage! !

!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:51'!
signalCustomerNameCannotBeEmpty 

	self error: self class customerCanNotBeEmptyErrorMessage ! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
suspendCustomerNamed: aName 
	
	(active includes: aName) ifFalse: [^CantSuspend signal].
	
	active remove: aName.
	
	suspended add: aName
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerBook class' category: #'CodigoRepetido-Ejercicio'!
CustomerBook class
	instanceVariableNames: ''!

!CustomerBook class methodsFor: 'error messages' stamp: 'NR 9/17/2020 06:01:49'!
customerAlreadyExistsErrorMessage

	^'customer already exists!!'! !

!CustomerBook class methodsFor: 'error messages' stamp: 'NR 9/17/2020 06:02:05'!
customerCanNotBeEmptyErrorMessage

	^'customer name cannot be empty!!'! !
