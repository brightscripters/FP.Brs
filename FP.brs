' Functional Programming with BrightScript
' By Bright Scripters

' Examples for Map, Filter, Reduce and composition
function fpUnitTest()

    MyList = fpNew([0, 1, 2, 3, 4, 5])

    print "My List: " : print : print MyList.items

    MappedArray = MyList.Map(Add_1)
    print "Mapped List with Add_1(): " : print : print MappedArray.items

    ExpectedOutputArray = [1, 2, 3, 4, 5, 6]

    if not fpIsIdenticalList(MappedArray.items, ExpectedOutputArray) then
        print "ERROR in fpListMap()"
        stop
        return false
    end if


    FilteredArray = MappedArray.Filter(IsEven)
    print "Filtered List: " : print : print FilteredArray.items

    if not fpIsIdenticalList(FilteredArray.items, [2, 4, 6]) then
        print "ERROR in fpListFilter()"
        stop
        return false
    end if

    ReducedFromArray = FilteredArray.Reduce(fpAdd)
    print "Reduced value from array: " : print : print ReducedFromArray

    if not ReducedFromArray = 12 then
        print "ERROR in Reduce()"
        stop
        return false
    end if


    MappedThenFiltered = MapThenFilter(MyList, Add_1, IsEven)

    if not fpIsIdenticalList(MappedThenFiltered.items, [2, 4, 6]) then
        print "ERROR in MapThenFilter()"
        stop
        return false
    end if

    print "Mapped and Filtered through composition: " : print : print MappedThenFiltered.items


    MappedThenFiltered = MapThenFilter2(MyList.items)

    if not fpIsIdenticalList(MappedThenFiltered, [2, 4, 6]) then
        print "ERROR in MapThenFilter2()"
        stop
        return false
    end if

    print "Mapped and Filtered through composition 2: " : print : print MappedThenFiltered


    ListComprehensionResult = ListComprehension(Add_1, MyList, IsEven) ' In effect filter then map

    if not fpIsIdenticalList(ListComprehensionResult.items, [1, 3, 5]) then
        print "ERROR in ListComprehension()"
        stop
        return false
    end if

    print "List Comprehension: " : print : print ListComprehensionResult.items

    return true
end function

' =====================================================
'# List Comprehension with BrightScript
'# Usage: NewList = ListComprehension( fnMap, InputList, fnFilter )

function ListComprehension(fnMap, list, fnFilter)
    return FilterThenMap(list, fnFilter, fnMap)
end function

' =====================================================
'# Function composition with BrightScript

function MapThenFilter(list, fnMap, fnFilter)
    return list.Map(fnMap).Filter(fnFilter)
end function

' Example:
' ResultList = MapThenFilter( SomeList, Add_1, IsEven )

function FilterThenMap(list, fnFilter, fnMap)
    return list.Filter(fnFilter).Map(fnMap)
end function


' Same as above with Currying
function MapThenFilter2(a as object) as object

    Increment = fpListMap("Add_1") '// Add 1 to all list elements with Map()
    EvenOnly = fpListFilter("IsEven") '// Remove all array itmes with odd values with Filter()

    return EvenOnly(Increment(a)) '// Composed Map() then Filter()

end function



function fpIsIdenticalList(a, b) as boolean

    Result = true

    for i = 0 to a.count() - 1
        if a[i] <> b[i] then
            Result = false
            exit for
        end if
    end for

    return Result
end function


function fpListMap(fn$) as object ' Returns a function

    Eval$ = "TheFunction = function ( InList ) : OutList = [] : for each item in InList : OutList.Push( " + fn$ + "( item ) ) : end for : return OutList : end function"

    Eval(Eval$)
    return TheFunction

end function


function fpListFilter(fnBoolean$) as object
    Eval$ = "TheFunction = function (InList) : OutList = [] : for each item in InList " + chr(10) + " if " + fnBoolean$ + "( item ) then : OutList.Push(item) : end if : next: return OutList : end function"
    Result = Eval(Eval$)
    return TheFunction
end function


function fpZero(Ignored)
    return 0
end function


function fpAdd(a, b)
    if a = invalid and b = invalid then return 0 ' Identity value for this operation
    return a + b
end function


function Add_1(a)
    return a + 1
end function


function IsEven(a% as integer) as boolean
    return a% mod 2 = 0
end function


function fpIs3(a) as boolean
    return a = 3
end function


function fpIs4(a) as boolean
    return fpIsEqualTo(4)(a)
end function


function fpIsEqualTo(TargetValue) as object ' Returns a function

    EvalStr$ = "TheFunction = function ( a ) : return a = " + TargetValue.ToStr() + " : end function"
    Eval(EvalStr$)

    return TheFunction

end function


function fpNew(items as object)
    fpList = {}
    fpList.Items = items
    fpList.Map = fpMap
    fpList.Filter = fpFilter
    fpList.Reduce = fpReduce
    return fpList
end function


function fpMap(mapper)
    Mapped = fpNew([])

    for each item in m.items
        Mapped.items.Push(mapper(item))
    end for

    return Mapped
end function


function fpFilter(fnBoolean)
    Filtered = fpNew([])

    for each item in m.items
        if fnBoolean(item)
            Filtered.items.Push(item)
        end if
    end for

    return Filtered
end function


function fpReduce(fn2)
    Reduced = fn2(invalid, invalid) ' Returns the identity value for fn2

    for each item in m.items
        Reduced = fn2(Reduced, item)
    end for

    return Reduced
end function


function fpClone(src as object) as object

    Clone = Box(Type(src))

    if type(clone) = "roArray" or type(clone) = "roList" then
        Clone = CloneArray(src)
    else if type(clone) = "roAssociativeArray"
        Clone = CloneAssArray(src)
    else
        Clone = src
    end if

    return Clone
end function


function fpCloneArray(src)
    clone = []
    for each item in src
        clone.push(item)
    end for
    return clone
end function


function fpCloneAssArray(src)
    clone = {}
    for each item in src
        clone[item] = item
    end for
    return clone
end function

' =====================================================
' Intended for startup Unit Test only
' In BA send plugin message "UnitTest" to the fp plugin

function fp_Initialize(msgPort as object, userVariables as object, bsp as object)
    fp = newfp(msgPort, userVariables, bsp)
    return fp
end function


function newfp(msgPort as object, userVariables as object, bsp as object)
    s = {}
    s.version = 0.1
    s.msgPort = msgPort
    s.userVariables = userVariables
    s.bsp = bsp
    s.ProcessEvent = fp_ProcessEvent
    s.objectName = "fp_object"


    print "<<<<<<<<<<<<<< HELLO FROM FP >>>>>>>>>>>>>>>>>"

    return s

end function


function fp_ProcessEvent(event as object) as boolean
    retval = false

    if type(event) = "roAssociativeArray" then

        if type(event["EventType"]) = "roString" then

            if (event["EventType"] = "SEND_PLUGIN_MESSAGE") then

                if event["PluginName"] = "fp" then
                    pluginMessage$ = event["PluginMessage"]
                    print pluginMessage$
                    if pluginMessage$ = "UnitTest" then

                        if fpUnitTest() then
                            print "FP PASSED Unit Test"
                        else
                            print "FP FAILED Unit Test "
                            ' stop
                        end if

                    end if
                    retval = true
                end if

            end if
        end if

    end if

    return retval

end function





