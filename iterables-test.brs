library "iterables.brs"
library "FP.brs"

sub main()

    collection = newIterable( [1,2,3,4,5] )

    result = collection.filter(isEven).map(add_1).map(double)
    
    ' Should return [6,10]
    print result.list

end sub