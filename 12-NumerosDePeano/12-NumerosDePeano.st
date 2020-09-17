!classDefinition: #I category: #NumerosDePeano!
DenotativeObject subclass: #I
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'NumerosDePeano'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'I class' category: #NumerosDePeano!
I class
	instanceVariableNames: ''!

!I class methodsFor: 'operaciones' stamp: 'VP 9/14/2020 21:56:13'!
* unNumeroDePeano 
	^unNumeroDePeano.! !

!I class methodsFor: 'operaciones' stamp: 'VP 9/14/2020 22:09:05'!
+ unNumeroDePeano 
	^unNumeroDePeano next.! !

!I class methodsFor: 'operaciones' stamp: 'VP 9/17/2020 17:14:02'!
- unNumeroDePeano 
	self error:self descripcionDeErrorDeNumerosNegativosNoSoportados.! !

!I class methodsFor: 'operaciones' stamp: 'VP 9/17/2020 17:17:37'!
/ unNumeroDePeano
	unNumeroDePeano = self ifTrue: [ ^self ].
	^self error:self descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor.! !

!I class methodsFor: 'operaciones' stamp: 'VP 9/17/2020 17:15:52'!
descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor
	^'No se puede dividir por un número mayor'.! !

!I class methodsFor: 'operaciones' stamp: 'VP 9/17/2020 17:14:09'!
descripcionDeErrorDeNumerosNegativosNoSoportados
	^'No se puede tener números negativos'.! !

!I class methodsFor: 'operaciones' stamp: 'VP 9/14/2020 21:55:44'!
next
	^self createChildNamed: self name, 'I'.
	"^ObjectBuilder create: (self asString, 'I') asSymbol
	asChildOf: self
	collaboratorNames: ''
	in: 'NumerosDePeano'."! !


!classDefinition: #II category: #NumerosDePeano!
I subclass: #II
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'NumerosDePeano'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'II class' category: #NumerosDePeano!
II class
	instanceVariableNames: ''!

!II class methodsFor: 'operaciones' stamp: 'VP 9/14/2020 22:19:12'!
* unNumeroDePeano
	^self previous * unNumeroDePeano + unNumeroDePeano.! !

!II class methodsFor: 'operaciones' stamp: 'VP 9/14/2020 21:57:11'!
+ unNumeroDePeano 
	^unNumeroDePeano next next.! !

!II class methodsFor: 'operaciones' stamp: 'VP 9/14/2020 22:22:09'!
- unNumeroDePeano 
	^self parent.! !

!II class methodsFor: 'operaciones' stamp: 'VP 9/17/2020 17:11:44'!
/ unNumeroDePeano
	unNumeroDePeano = I ifTrue: [ ^self ].
	^self parent.! !

!II class methodsFor: 'operaciones' stamp: 'VP 9/14/2020 21:59:22'!
previous
	^self parent.! !


!classDefinition: #III category: #NumerosDePeano!
II subclass: #III
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'NumerosDePeano'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'III class' category: #NumerosDePeano!
III class
	instanceVariableNames: ''!

!III class methodsFor: 'operaciones' stamp: 'VP 9/14/2020 21:57:32'!
+ unNumeroDePeano
	^(unNumeroDePeano previous + self) next.! !

!III class methodsFor: 'operaciones' stamp: 'VP 9/14/2020 22:31:41'!
- unNumeroDePeano
	unNumeroDePeano = I ifTrue: [ ^self previous ].
	^self previous - unNumeroDePeano previous.! !

!III class methodsFor: 'operaciones' stamp: 'VP 9/17/2020 17:17:05'!
/ unNumeroDePeano
	unNumeroDePeano = I ifTrue: [ ^self ].
	^(self - unNumeroDePeano / unNumeroDePeano) next.! !


!classDefinition: #IIII category: #NumerosDePeano!
III subclass: #IIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'NumerosDePeano'!


!classDefinition: #IIIII category: #NumerosDePeano!
IIII subclass: #IIIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'NumerosDePeano'!


!classDefinition: #IIIIII category: #NumerosDePeano!
IIIII subclass: #IIIIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'NumerosDePeano'!


!classDefinition: #NumerosDePeanoTest category: #NumerosDePeano!
DenotativeObject subclass: #NumerosDePeanoTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'NumerosDePeano'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NumerosDePeanoTest class' category: #NumerosDePeano!
NumerosDePeanoTest class
	instanceVariableNames: ''!

!NumerosDePeanoTest class methodsFor: 'as yet unclassified' stamp: 'VP 9/14/2020 22:41:47'!
test01_INextEsII

	Assert that: I next isEqualTo: II.! !

!NumerosDePeanoTest class methodsFor: 'as yet unclassified' stamp: 'VP 9/14/2020 22:41:32'!
test02_SumaDeUnNumeroYIEsElSiguiente

	Assert that: I + I isEqualTo: I next.! !

!NumerosDePeanoTest class methodsFor: 'as yet unclassified' stamp: 'VP 9/14/2020 22:42:17'!
test03_IIIIIMenosIIEsIII

	Assert that: IIIII - II isEqualTo: III.! !

!NumerosDePeanoTest class methodsFor: 'as yet unclassified' stamp: 'VP 9/14/2020 22:40:49'!
test04_MultiplicacionDeIIIYIIDaIIIIII

	Assert that: III * II isEqualTo: IIIIII.! !

!NumerosDePeanoTest class methodsFor: 'as yet unclassified' stamp: 'VP 9/14/2020 22:40:12'!
test05_DivisionDeIIIIIIYIIDaIII

	Assert that: IIIIII / II isEqualTo: III.! !

!NumerosDePeanoTest class methodsFor: 'as yet unclassified' stamp: 'VP 9/14/2020 22:45:04'!
test06_PreviousDeIIIEsII

	Assert that: III previous isEqualTo: II.! !
