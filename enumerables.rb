# rubocop:disable Style/CaseEquality
module Enumerable

    def my_each
        return to_enum(:my_each) unless  block_given?
        arr = arr.to_a
        i = 0
        while i < arr.length
            yield arr[i]  
        end
        self 
    end 
end

 a = [1, 2,3,4]
 puts a.my_each {|i| puts i}




  