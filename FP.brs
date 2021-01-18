' Functional Programming with BrightScript
' By Bright Scripters

' Examples for Map, Filter, and composition
function FpUnitTest()
    
    SomeInputArray = [0,1,2,3]
    print "Input List: " : print : print SomeInputArray

    MappedArray = FpListMap( "FpAdd1" )( SomeInputArray )
    print "Mapped List with FpAdd1(): " : print : print MappedArray
    
    ExpectedOutputArray = [1,2,3,4]

        if not FpIsIdenticalList( MappedArray, ExpectedOutputArray ) then
            print "ERROR in FpListMap()"
            return false
        end if


    FilteredArray = FpListFilter( "FpIs4" )( MappedArray )
    print "Filtered List: " : print : print FilteredArray

        if not FpIsIdenticalList( FilteredArray, [4] ) then
            print "ERROR in FpListFilter()"
            return false
        end if

    MappedAndFiltered = FpMappedAndFiltered( SomeInputArray )
        
        if not FpIsIdenticalList( MappedAndFiltered, [2,4] ) then
            print "ERROR in FpMappedAndFiltered()"
            return false
        end if
    
    print "Mapped and Filtered through composition: " : print : print MappedAndFiltered

    return true
end function
' =====================================================
'# Function composition with BrightScript

'# Map()    - Add 1 to all array elements
'# Filter() - Remove all odd numbers

function FpMappedAndFiltered( a as object ) as object
    
    map    = FpListMap( "FpAdd1" )      '// Add 1 to all array elements with Map()
    filter = FpListFilter( "FpIsEven" ) '// Remove all array itmes with odd values with Filter()

    return filter( map( a ) )           '// Composed Map() then Filter()

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
function FpAdd1( a )
    return a+1
end function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''
function FpIsEven( a% as integer ) as boolean
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

    ' return function ( a )
    '     return a = TargetValue
    ' end function
    
    EvalStr$ = "TheFunction = function ( a ) : return a = " + TargetValue.ToStr() + " : end function"
    Eval(EvalStr$)

    return TheFunction

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





