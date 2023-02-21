sub main()

    newAdder = function ( a )
        eval( "fnRet = function ( b ) : return b + " + a.toStr() + " : end function" )
        return fnRet 
    end function

    increment = newAdder(1)

    print "Increment 11 = "; increment(11)

    print "Adding 1 + 9 = "; newAdder(1)(9)

end sub

