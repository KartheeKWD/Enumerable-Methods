# rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/ModuleLength
module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    arr = is_a?(Array) ? self : to_a
    i = 0
    # puts arr
    while i < arr.length
      yield arr[i]
      i += 1
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    arr = is_a?(Array) ? self : to_a
    i = 0
    # puts arr
    while i < arr.length
      yield arr[i], i
      i += 1
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    arr = to_a
    new_array = []
    arr.my_each do |item|
      new_array.push(item) if yield item
    end
    new_array
  end

  def my_all?(arg = nil)
    if block_given?
      my_each { |item| return false if yield(item) == false }
      return true
    elsif arg.nil?
      my_each { |n| return false if n.nil? || n == false }
    elsif !arg.nil? && (arg.is_a? Class)
      my_each { |n| return true if n.is_a? arg || n.instance_of?(arg) }
    elsif !arg.nil? && arg.class == Regexp
      my_each { |n| return false unless arg.match(n) }
    else
      my_each { |n| return false if n != arg }
    end
    true
  end

  def my_any?(arg = nil)
    if block_given?
      my_each { |item| return true if yield(item) }
    elsif arg.nil?
      my_each { |n| return true if n.nil? || n == true }
    elsif arg.is_a? Class
      my_each { |n| return true if n.is_a? arg || n.instance_of?(arg) }
    elsif !arg.nil? && arg.class == Regexp
      my_each { |n| return true if arg.match(n) }
    else
      my_each { |n| return true if n == arg }
    end
    false
  end

  def my_none?(arg = nil)
    if block_given?
      my_each { |item| return false unless yield(item) == false }
      return true
    elsif arg.nil?
      my_each { |item| return false unless item.nil? || item == false }
    elsif !arg.nil? && (arg.is_a? Class)
      my_each { |item| return false if item.instance_of?(arg) }
    elsif !arg.nil? && (arg.is_a? Regexp)
      my_each { |item| return false if arg.match(item) }
    else
      my_each { |item| return false unless item != data }
    end
    true
  end

  def my_count(num = nil)
    a = self.class == Array ? self : to_a
    return a.length unless block_given? || num

    return a.select { |item| item == num }.length if num

    a.select { |item| yield(item) }.length
  end

  def my_map(proc = nil)
    return to_enum unless block_given? || proc

    new_arr = []
    if proc
      each { |item| new_arr << proc.call(item) }
    else
      each { |item| new_arr << yield(item) }
    end
    new_arr
  end

  # // If no block is given and an arithmetic symbol or string is given without an initial value
  # // If no block is given and an arithmetic symbol or string is given without an initial value
  def my_inject(*args)
    initial_value, symbol = args if args.length == 2
    symbol = args[0] if args.length == 1 && !block_given?
    initial_value = args[0] if args.length == 1 && block_given?

    return raise LocalJumpError, 'no block provided' if !block_given? && symbol.nil?

    if block_given?
      each do |i|
        if initial_value.nil?
          initial_value = i
          next
        end
        initial_value = yield(initial_value, i)
      end
    elsif (symbol && symbol.class == Symbol) || (symbol && symbol.class == String && %r{[-+*/]}.match(symbol))
      each do |i|
        if initial_value.nil?
          initial_value = i
          next
        end
        initial_value = initial_value.send(symbol, i)
      end

    end
    initial_value
  end
end
# rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/ModuleLength

def multiply_els(args)
  args.my_inject { |result, element| result * element }
end

# a = [1, 2, 3, 4]
# b = [2,2,2,3,3]
# b = [2, 4, 5]
# p a.my_each { |i| puts i }
# p a.my_each_with_index { |item, index| p "#{index} : #{item}" }
# p a.my_select { |item| item == 2 }
# p a.my_all? { |item| item <= 2 }
# p a.my_any? { |item| item <= 2 }
# p a.my_none? { |item| item == 4 }
# p a.my_count(2)
# test_proc = proc { |item| item * 2 }
# p a.my_map(&test_proc)
# p a.my_inject (10) { |a, b| a + b }
# p multiply_els([2, 4, 5])

# p %w{ant bear cat}.my_none? { |word| word.length == 5 } #=> true
# p %w{ant bear cat}.my_none? { |word| word.length >= 4 } #=> false
# p %w{ant bear cat}.my_none?(/d/)                        #=> true
# p [1, 3.14, 42].my_none?(Float)                         #=> false
# p [].my_none?                                           #=> true
# p  [nil].my_none?                                        #=> true
# p [nil, false].my_none?                                 #=> true
# p [nil, false, true].my_none?                           #=> false

# p %w[ant bear cat].my_all? { |word| word.length >= 3 } #=> true
# p %w[ant bear cat].my_all? { |word| word.length >= 4 } #=> false
# p %w[ant bear cat].my_all?(/t/)                        #=> false
# p [1, 2i, 3.14].my_all?(Numeric)                       #=> true
# p [nil, true, 99].my_all?                              #=> false
# p [].my_all?                                           #=> true

# p %w[ant bear cat].my_any? { |word| word.length >= 3 } #=> true
# p %w[ant bear cat].my_any? { |word| word.length >= 4 } #=> true
# p %w[ant bear cat].my_any?(/d/)                        #=> false
# p [nil, true, 99].my_any?(Integer)                     #=> true
# p [nil, true, 99].my_any?                              #=> true
# p [].my_any?                                           #=> false

# p [3, 5, 7, 11].my_all?(&:odd?) # => true
# p [-8, -9, -6].my_all? { |n| n < 0 } # => true
# p [3, 5, 8, 11].my_all?(&:odd?) # => false
# p [-8, -9, -6, 0].my_all? { |n| n < 0 } # => false
# # test cases required by tse reviewer
# p [1, 2, 3, 4, 5].my_all? # => true
# p [1, 2, 3].my_all?(Integer) # => true
# p %w[dog door rod blade].my_all?(/d/) # => true
# p [1, 1, 1].my_all?(1) # => true

# p [7, 10, 4, 5].my_any?(&:even?) # => true
# p %w[q r s i].my_any? { |char| 'aeiou'.include?(char) } # => true
# p [7, 11, 3, 5].my_any?(&:even?) # => false
# p %w[q r s t].my_any? { |char| 'aeiou'.include?(char) } # => false
# # test cases required by tse reviewer
# p [3, 5, 4, 11].my_any? # => true
# p "yo? #{[nil, false, nil, false].my_any?}" # => false
# p [1, nil, false].my_any?(1) # => true
# p [1, nil, false].my_any?(Integer) # => true
# p %w[dog door rod blade].my_any?(/z/) # => false
# p [1, 2, 3].my_any?(1) # => true

# p [3, 5, 7, 11].my_none?(&:even?) # => true
# p [1, 2, 3, 4].my_none?{|num| num > 4} #=> true
# p [nil, false, nil, false].my_none? # => true
# p %w[sushi pizza burrito].my_none? { |word| word[0] == 'a' } # => true
# p [3, 5, 4, 7, 11].my_none?(&:even?) # => false
# p %w[asparagus sushi pizza apple burrito].my_none? { |word| word[0] == 'a' } # => false
# # test cases required by tse reviewer
# p [1, 2, 3].my_none? # => false
# p [1, 2, 3].my_none?(String) # => true
# p [1, 2, 3, 4, 5].my_none?(2) # => false
# p [1, 2, 3].my_none?(4) # => true
