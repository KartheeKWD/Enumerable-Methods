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
      my_each { |item| return false unless item != arg }
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
