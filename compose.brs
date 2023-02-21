sub main()

compose = function (f$,g$)
    evalThis$ = "fnRet = function (x) : return " + g$ + "(" + f$ + "(x)) : end function"
    eval( evalthis$ )
    return fnRet
end function

doubleThenString = compose( "times2", "toString" )

doubledAsString$ = doubleThenString(3)
print "3 doubled then string: "; doubledAsString$, type(doubledAsString$)

end sub


function times2(a) 
    return a * 2
end function


function toString(x) as string
    return x.toStr()
end function