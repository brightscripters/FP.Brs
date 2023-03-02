sub main()

    ' Curried adder()
    adder = function ( a )
        eval( "fnRet = function ( b ) : return b + " + a.toStr() + " : end function" )
        return fnRet 
    end function

    ' Example: Create an increment() function
    ' Returns incremented integer
    increment = adder(1)

    print "Increment 11 = "; increment(11)

    print "Adding 1 + 9 = "; adder(1)(9)

    print "or"

    add1 = adder(1)

    print "add1(9) = "; add1(9)


end sub

