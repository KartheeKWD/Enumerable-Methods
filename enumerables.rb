# # rubocop:disable Style/CaseEquality
module Enumerable
    def my_each
        return to_enum(:my_each) unless  block_given?
        arr = self.is_a?(Array) ? self : self.to_a
        i = 0
        # puts arr
        while i < arr.length do
            yield arr[i]
            i += 1
        end
        self
    end

    def my_each_with_index
        return to_enum(:my_each_with_index) unless  block_given?
        arr = self.is_a?(Array) ? self : self.to_a
        i = 0
        # puts arr
        while i < arr.length do
            yield  arr[i], i
            i += 1
        end
        self
    end

    def my_select
        return to_enum(:my_select) unless  block_given?
        i = 0
        arr = self.to_a
        new_array = []
        arr.each do |i|
            new_array.push(i) if yield i
        end 
       return new_array
    end 

    # def my_all?
    #     return to_enum(:my_all?) unless  block_given?
    #     arr = self.to_a
    #     arr.each do |i|
          
    #     end 
    # end

    def my_all?
        my_each{ |item| return false if yield(item) == false}
        true
      end

      def my_any?
        my_each{ |item| return true if yield(item) == true}
        false
      end

      def my_none?
        my_each{ |item| return false if yield(item) !=false}
        true
      end

      def my_count

end

a = [1, 2,3,4]
p a.my_each{ |i| puts i}
p a.my_each_with_index { |item ,index| p "#{index} : #{item}" }
p a.my_select {|item|  item == 2 }
p a.my_all? {|item|  item == 2 }
p a.all? {|item|  item == 6 }
p a.any? {|item|  item <=2 }
p a.my_any? {|item|  item <= 2 }
p a.my_none? {|item|  item ==4 }
p a.none? {|item|  item ==4 }

 
