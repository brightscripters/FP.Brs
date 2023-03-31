
function newIterable( someList = [] as object ) as object

        ' if not isIn( type$, ["roList", "roArray", "roByteArray", "roAssociativeArray"] ) then return invalid

    newThing = { list: someList }
    newThing.map    = itrMap
    newThing.filter = itrFilter
    newThing.reduce = itrReduce

    return newThing

end function


' Applied to iterable as m
' Takes a function which takes an item and returns a boolean
' Returns a filtered iterable, shorter than the original
function itrFilter( fnFilter as object ) as object
    filtered = newIterable( getEmptyLike(m.list) )

        for each item in m.list
            if fnFilter(item) then
                filtered.list.push( item ) ' Add support for aa
            end if
        end for

    return filtered
end function


' Takes an iterable as m
' Retruns an iterable with modified items
function itrMap( fnMapper as object ) as object
    
    mapped = newIterable( getEmptyLike(m.list) )

        for each item in m.list
            mapped.list.push( fnMapper(item) ) ' Add support for aa
        end for

    return mapped

end function


' Takes an iterable as m
' Retruns single reduced value.
function itrReduce( fnReducer as object ) as dynamic
    
    ' fnReducer should be able to return a unity value.
    ' 0 for addition, 1 for multiplication, etc...
    accumulator = fnReducer() 

        for each item in m.list
            accumulator = fnReducer(item, accumulator) ' Add support for aa
        end for

    return accumulator

end function


function getEmptyLike( iterable ) as object
        if type(iterable) = "roArray" then return [] 
    return createObject( type( iterable) )
end function


function sumItems( item = 0, accumulator = 0 ) as dynamic
    return accumulator + item
end function


function multItems( item = 1, accumulator = 1 ) as dynamic
    return accumulator * item
end function


' Always return true
function alwaysTrue( item ) as boolean
    return true
end function


function pass(in)
    return in
end function


function double( x )
    return x * 2
end function


function isIn( something as dynamic, list as object ) as boolean

        for each item in list
            if item = something then return true
        end for
    
    return false

end function