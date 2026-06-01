(in-package :de.h-da.lop.lang.lop-test)



(<--- (person ?id ?first-name ?surname ?gender)
"
Fact with parameters:
?id : atom - unique identifier of a person
?first-name : atom - first name of the person
?surname : atom - surname of the person
?gender : atom - one of male, female
"
      )

(<- (person Anke-Humm Anke Humm female))
(<- (person Bernhard-Humm Bernhard Humm male))

(<- (person Justin-Humm Justin Humm male))
(<- (person Leonard-Humm Leonard Humm male))
(<- (person Josiane-Humm Josiane Humm female))


(<- (person Hildegard-Humm Hildegard Humm female))
(<- (person Werner-Humm Werner Humm male))

(<- (person Wolfgang-Geisler Wolfgang Geißler male))
(<- (person Maggie-Geisler Maggie Geißler female))

(<- (person Roland-Humm Roland Humm male))
(<- (person Ursula-Humm Ursula Humm female))

(<- (person Annebelle-Humm Annabelle Humm female))
(<- (person Julia-Humm Julia Humm female))
(<- (person Dominique-Humm Dominique Humm male))
(<- (person Sandra-Humm Sandra Humm female))
(<- (person Alica-Humm Alica Humm female))

(<- (person Jürgen-König Jürgen König male))
(<- (person Nadine-König Nadine König female))

(<- (person Lennox-König Lennox König male))
(<- (person Lilou-König Lilou König female))




(<--- (parent ?parent ?child)
"
Fact with parameters:
?parent  : atom - id of person
?child : atom - id of person
"
      )

(<- (parent Werner-Humm Bernhard-Humm))
(<- (parent Werner-Humm Roland-Humm))

(<- (parent Hildegard-Humm Bernhard-Humm))
(<- (parent Hildegard-Humm Roland-Humm))

(<- (parent Wolfgang-Geisler Anke-Humm))
(<- (parent Wolfgang-Geisler Jürgen-König))

(<- (parent Maggie-Geisler Anke-Humm))
(<- (parent Maggie-Geisler Jürgen-König))

(<- (parent Bernhard-Humm Justin-Humm))
(<- (parent Bernhard-Humm Leonard-Humm))
(<- (parent Bernhard-Humm Josiane-Humm))

(<- (parent Anke-Humm Justin-Humm))
(<- (parent Anke-Humm Leonard-Humm))
(<- (parent Anke-Humm Josiane-Humm))

(<- (parent Roland-Humm Annabelle-Humm))
(<- (parent Roland-Humm Julia-Humm))
(<- (parent Roland-Humm Dominique-Humm))
(<- (parent Roland-Humm Sandra-Humm))
(<- (parent Roland-Humm Alica-Humm))

(<- (parent Ursula-Humm Annabelle-Humm))
(<- (parent Ursula-Humm Julia-Humm))
(<- (parent Ursula-Humm Dominique-Humm))
(<- (parent Ursula-Humm Sandra-Humm))
(<- (parent Ursula-Humm Alica-Humm))

(<- (parent Jürgen-König Lilou-König))
(<- (parent Jürgen-König Lennox-König))

(<- (parent Nadine-König Lilou-König))
(<- (parent Nadine-König Lennox-König))



(<--- (married ?husband ?wife)
"
Fact with parameters:
?husband : atom - id of person
?wife : atom - id of person
"
      )


(<- (married Werner-Humm Hildegard-Humm))
(<- (married Wolfgang-Geisler Maggie-Geisler))
(<- (married Bernhard-Humm Anke-Humm))
(<- (married Ursula-Humm Roland-Humm))
(<- (married Jürgen-König Nadine-König))




(<--- (father ?father ?child)
"
Rule with parameters:
?father : atom - id of person
?child : atom - id of person

is satisfied if ?father is a male parent of ?child
"
)


(<- (father ?father ?child)
    (person ?father ? ? male)
    (parent ?father ?child)
    )



(<--- (mother ?mother ?child)
"
Rule with parameters:
?mother : atom - id of person
?child : atom - id of person

is satisfied if ?mother is a female parent of ?child
"
)


(<- (mother ?mother ?child)
    (person ?mother ? ? female)
    (parent ?mother ?child)
    )



(<--- (child ?child ?parent)
"
Rule with parameters:
?child  : atom - id of person
?parent : atom - id of person

is satisfied if ?parent is a parent of ?child
"
)

(<- (child ?child ?parent)
    (parent ?parent ?child)
    )




(<--- (son ?son ?parent)
"
Rule with parameters:
?son  : atom - id of person
?parent : atom - id of person

is satisfied if ?son is a male child of ?parent
"
)

(<- (son ?son ?parent) 
    (person ?son ? ? male)
    (parent ?parent ?son)
    )



(<--- (daughter ?daughter ?parent)
"
Rule with parameters:
?daughter  : atom - id of person
?parent : atom - id of person

is satisfied if ?daughter is a female child of ?parent
"
)

(<- (daughter ?daughter ?parent) 
    (person ?daughter ? ? female)
    (parent ?parent ?daughter)
    )


(<--- (sibling ?sibling-1 ?sibling-2)
"
Rule with parameters:
?sibling-1  : atom - id of person
?sibling-2 : atom - id of person

is satisfied if ?sibling-1 and ?sibling-2 have the same parents but are different
"
)

(<- (sibling ?sibling-1 ?sibling-2)
     
    (parent ?parent ?sibling-1)
    (parent ?parent ?sibling-2)
    (not (= ?sibling-1 ?sibling-2))
     )

;;;(<- (sibling ?sibling-1 ?sibling-2)
;;;     
;;;     (or (mother ?parent ?sibling-1) (father ?parent ?sibling-1))
;;;     (parent ?parent ?sibling-2)
;;;     
;;;     (not (= ?sibling-1 ?sibling-2))
;;;     )



(<--- (brother ?brother ?sibling)
"
Rule with parameters:
?brother  : atom - id of person
?sibling : atom - id of person

is satisfied if ?brother is a male sibling of ?sibling
"
 )

(<- (brother ?brother ?sibling)
    (person ?brother ? ? male)
    (parent ?parent ?brother)
    (parent ?parent ?sibling)
    )



(<--- (sister ?sister ?sibling)
"
Rule with parameters:
?sister  : atom - id of person
?sibling : atom - id of person

is satisfied if ?sister is a female sibling of ?sibling
"
)

(<- (sister ?sister ?sibling)
    (person ?sister ? ? female)
    (parent ?parent ?sister)
    (parent ?parent ?sibling)
    )



(<--- (grandparent ?g-parent ?g-child)
"
Rule with parameters:
?g-parent : atom - id of person
?g-child : atom - id of person

is satisfied if ?g-parent is grandparent of ?g-child
"
)
 
(<- (grandparent ?g-parent ?g-child)
    (parent ?g-parent ?child)
    (parent ?child ?g-child)
    )



(<--- (grandfather ?g-father ?g-child)
"
Rule with parameters:
?g-father : atom - id of person
?g-child : atom - id of person

is satisfied if ?g-father is the grandfather of ?g-child
"
)

(<- (grandfather ?g-father ?g-child)
    (father ?g-father ?child)
    (parent ?child ?g-child)
    )



(<--- (grandmother ?g-mother ?g-child)
"
Rule with parameters:
?g-mother : atom - id of person
?g-child : atom - id of person

is satisfied if ?g-mother is the grandmother of ?g-child
"
)

(<- (grandmother ?g-mother ?g-child)
    (mother ?g-mother ?child)
    (parent ?child ?g-child)
    )


(<--- (uncle ?uncle ?nephew-niece)
"
Rule with parameters:
?uncle : atom - id of person
?nephew-niece : atom - id of person

is satisfied if ?uncle is the uncle of ?nephew-niece
"
)

(<- (uncle ?uncle ?nephew-niece)
    (person ?uncle ? ? male)
    (brother ?uncle ?parent)
    (parent ?parent ?nephew-niece)
    )

(<- (uncle ?uncle ?nephew-niece)
    (person ?uncle ? ? male)
    (married ?uncle ?aunt)
    (sister ?aunt ?parent)
    (parent ?parent ?nephew-niece)
    )


(<--- (aunt ?aunt ?nephew-niece)
"
Rule with parameters:
?aunt : atom - id of person
?nephew-niece : atom - id of person

is satisfied if ?aunt is the aunt of ?nephew-niece
"
)

(<- (aunt ?aunt ?nephew-niece)
    (person ?aunt ? ? female)
    (sister ?aunt ?parent)
    (parent ?parent ?nephew-niece)
    )

(<- (aunt ?aunt ?nephew-niece)
    (person ?aunt ? ? female)
    (married ?uncle ?aunt)
    (brother ?uncle ?parent)
    (parent ?parent ?nephew-niece)
    )


(<--- (nephew ?nephew ?aunt-uncle)
"
Rule with parameters:
?nephew : atom - id of person
?aunt-uncle : atom - id of person

is satisfied if ?nephew is a nephew of ?aunt-uncle
"
)

(<- (nephew ?nephew ?aunt-uncle)
    (person ?nephew ? ? male)
    (uncle ?aunt-uncle ?nephew)
    )

(<- (nephew ?nephew ?aunt-uncle)
    (person ?nephew ? ? male)
    (aunt ?aunt-uncle ?nephew)
    )

(<--- (niece ?niece ?aunt-uncle)
"
Rule with parameters:
?niece : atom - id of person
?aunt-uncle : atom - id of person

is satisfied if ?niece is a niece of ?aunt-uncle
"
)

(<- (niece ?niece ?aunt-uncle)
    (person ?niece ? ? female)
    (uncle ?aunt-uncle ?niece)
    )

(<- (niece ?niece ?aunt-uncle)
    (person ?niece ? ? female)
    (aunt ?aunt-uncle ?niece)
    )


(<--- (cousin ?cousin-1 ?cousin-2)
"
Rule with parameters:
?cousin-1 : atom - id of person
?cousin-2 : atom - id of person

is satisfied if ?cousin-1 and ?cousin-2 are cousins
"
)
 
(<- (cousin ?cousin-1 ?cousin-2)
    (grandparent ?g-parent ?cousin-1)
    (grandparent ?g-parent ?cousin-2)  
    )


(<--- (ancestor ?ancestor ?descendant)
"
Rule with parameters:
?ancestor : atom - id of person
?descendant : atom - id of person

is satisfied if ?ancestor is an ancestor of ?descendant
"
)
 
(<- (ancestor ?ancestor ?descendant)
    (parent ?ancestor ?descendant)
    )

(<- (ancestor ?ancestor ?descendant)
    (parent ?ancestor ?child)
    (ancestor ?child ?descendant)
    )





(def-test sibling-test
    (assert-equal '(Roland-Humm) (query-distinct ?s (sibling ?s Bernhard-Humm)))
    (assert-equal '(Roland-Humm) (query-distinct ?s (sibling Bernhard-Humm ?s)))
    (assert-equal '((Roland-Humm)) (query-distinct (?s) (sibling Bernhard-Humm ?s)))
  )



