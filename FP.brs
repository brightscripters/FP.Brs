' Functional Programming with BrightScript
' By Bright Scripters

' Examples for Map, Filter, Reduce and composition
function FpUnitTest()

    MyList = FpNew([0,1,2,3,4,5])
    
    print "My List: " : print : print MyList.items

    MappedArray = MyList.Map(Add_1)
    print "Mapped List with Add_1(): " : print : print MappedArray.items
    
    ExpectedOutputArray = [1,2,3,4,5,6]

        if not FpIsIdenticalList( MappedArray.items, ExpectedOutputArray ) then
            print "ERROR in FpListMap()"
            stop
            return false
        end if


    FilteredArray = MappedArray.Filter(IsEven)
    print "Filtered List: " : print : print FilteredArray.items

        if not FpIsIdenticalList( FilteredArray.items, [2,4,6] ) then
            print "ERROR in FpListFilter()"
            stop
            return false
        end if

    ReducedFromArray = FilteredArray.Reduce(FpAdd)
    print "Reduced value from array: " : print : print ReducedFromArray

        if not ReducedFromArray = 12 then
            print "ERROR in Reduce()"
            stop
            return false
        end if


    MappedThenFiltered = MapThenFilter( MyList, Add_1, IsEven )
        
        if not FpIsIdenticalList( MappedThenFiltered.items, [2,4,6] ) then
            print "ERROR in MapThenFilter()"
            stop
            return false
        end if

    print "Mapped and Filtered through composition: " : print : print MappedThenFiltered.items

    
    MappedThenFiltered = MapThenFilter2( MyList.items )
        
        if not FpIsIdenticalList( MappedThenFiltered, [2,4,6] ) then
            print "ERROR in MapThenFilter2()"
            stop
            return false
        end if

    print "Mapped and Filtered through composition 2: " : print : print MappedThenFiltered

    return true
end function

' =====================================================
'# Function composition with BrightScript

function MapThenFilter( list, fnMap, fnFilter )
   return list.Map( fnMap ).Filter( fnFilter )
end function

' Example: 
' ResultList = MapThenFilter( SomeList, Add_1, IsEven )


' Same as above with Currying
function MapThenFilter2( a as object ) as object
    
    Increment = FpListMap( "Add_1" )       '// Add 1 to all list elements with Map()
    EvenOnly  = FpListFilter( "IsEven" )  '// Remove all array itmes with odd values with Filter()

    return EvenOnly( Increment( a ) )       '// Composed Map() then Filter()

end function


'''''''''''''''''''''''''''''''''''''''''''''''''''''''
function FpIsIdenticalList( a, b ) as boolean

    Result = true

        for i = 0 to a.count()-1
            if a[i] <> b[i] then
                Result = false
                exit for
            end if
        end for

    return Result
end function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''
function FpListMap( fn$ ) as object ' Returns a function
    
    Eval$ = "TheFunction = function ( InList ) : OutList = [] : for each item in InList : OutList.Push( " + fn$ + "( item ) ) : end for : return OutList : end function"
    
    Eval(Eval$)
    return TheFunction

end Function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''
function FpListFilter( fnBoolean$ ) as object
    Eval$ = "TheFunction = function (InList) : OutList = [] : for each item in InList " +chr(10)+ " if " + fnBoolean$ + "( item ) then : OutList.Push(item) : end if : next: return OutList : end function"
    Result = Eval(Eval$)
    return TheFunction
end function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''
function FpZero( Ignored )
    return 0
end function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''
function FpAdd(a,b)
        if a = invalid and b = invalid then return 0 ' Identity value for this operation
    return a+b
end function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''
function Add_1( a )
    return a+1
end function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''
function IsEven( a% as integer ) as boolean
    return a% MOD 2 = 0
end function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''
function FpIs3( a ) as boolean
    return a = 3
end function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''
function FpIs4( a ) as boolean
    return FpIsEqualTo( 4 )( a )
end function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''
function FpIsEqualTo( TargetValue ) as object ' Returns a function

    EvalStr$ = "TheFunction = function ( a ) : return a = " + TargetValue.ToStr() + " : end function"
    Eval(EvalStr$)

    return TheFunction

end function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''
function FpNew(items as object)
    FpList = {}
    FpList.Items = items
    FpList.Map = FpMap
    FpList.Filter = FpFilter
    FpList.Reduce = FpReduce
    return FpList
end function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''
function FpMap(mapper)
    Mapped = FpNew( [] )

        for each item in m.items
            Mapped.items.Push( mapper(item) )
        end for

    return Mapped
end function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''
function FpFilter(fnBoolean)
    Filtered = FpNew( [] )

        for each item in m.items
            if fnBoolean(item)
                Filtered.items.Push( item )
            end if
        end for

    return Filtered
end function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''
function FpReduce(fn2)
    Reduced = fn2(invalid,invalid) ' Returns the identity value for fn2

        for each item in m.items
           Reduced = fn2(Reduced,item)
        end for

    return Reduced
end function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''
function FpClone(src as object) as object
    
    Clone = Box(Type(src))
        
        if type(clone) = "roArray" or type(clone) = "roList" then
            Clone = CloneArray(src)
        else if type(clone) = "roAssociativeArray"
            Clone = CloneAssArray(src)
        else
            Clone = src
        end if

    Return Clone
end function

function FpCloneArray(src)
    clone = []
        for each item in src
            clone.push(item)
        end for
    return clone
end function

function FpCloneAssArray(src)
    clone = {}
        for each item in src
            clone[item] = item
        end for
    return clone
end function

' =====================================================
' Intended for startup Unit Test only
' In BA send plugin message "UnitTest" to the fp plugin

Function fp_Initialize(msgPort As Object, userVariables As Object, bsp as Object)
    fp = newfp(msgPort, userVariables, bsp)
    return fp
End Function

Function newfp(msgPort As Object, userVariables As Object, bsp as Object)
	s = {}
	s.version = 0.1
	s.msgPort = msgPort
	s.userVariables = userVariables
	s.bsp = bsp
	s.ProcessEvent = fp_ProcessEvent
	s.objectName = "fp_object"


    print "<<<<<<<<<<<<<< HELLO FROM FP >>>>>>>>>>>>>>>>>"
	
	return s

End Function

Function fp_ProcessEvent( event As Object ) as boolean
    retval = false  
        
        if type(event) = "roAssociativeArray" then
            
            if type(event["EventType"]) = "roString" then
                
                if (event["EventType"] = "SEND_PLUGIN_MESSAGE") then

                    if event["PluginName"] = "fp" then
                        pluginMessage$ = event["PluginMessage"]
                        print pluginMessage$
                            if pluginMessage$ = "UnitTest" then

                                if FpUnitTest() then
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
	
End Function





