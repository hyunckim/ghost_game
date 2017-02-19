require 'byebug'

class Array
  def my_each(&prc)
    i = 0
    while i < self.length
      prc.call(self[i])
      i+=1
    end
    self
  end

  def my_select(&prc)
    new_array = []
    my_each do |element|
      new_array << element if prc.call(element) == true
    end
    new_array
  end

  def my_reject(&prc)
    new_array = []
    my_each do |element|
      new_array << element if prc.call(element) == false
    end
    new_array
  end

  def my_any?(&prc)
    my_each do |element|
      return true if prc.call(element) == true
    end
    false
  end

  def my_all?(&prc)
    my_each do |element|
      return false if prc.call(element) == false
    end
    true
  end

  def my_flatten
    new_array = []
    my_each do |element|
      if element.is_a? Array
        element.my_flatten.my_each do |subelement|
          new_array << subelement
        end
      else
        new_array << element
      end
    end
    new_array
  end

  def my_zip(*arrays)
    new_array = []
    idx = 0
    while idx < self.length
      subarray = [self[idx]]
      arrays.my_each do |array|
        if array[idx]
          subarray << array[idx]
        else
          subarray << nil
        end
      end
      new_array << subarray
      idx += 1
    end
    new_array
  end

  def my_rotate(n =1)
    new_array = self.dup
    n.abs.times do
      if n < 0
        new_array.unshift(new_array.pop)
      else
        new_array.push(new_array.shift)
      end
    end
    new_array
  end

  def my_join(sep ="")
    string = ""
    index = 0
    self.my_each do |char|
      string << char
      if index < self.length-1
        string << sep
      end
      index += 1
    end
    string
  end

  def my_reverse
    new_array = []
    self.my_each do |element|
      new_array.unshift(element)
    end
    new_array
  end
end

# ### Factors
#
# Write a method `factors(num)` that returns an array containing all the
# factors of a given number.

def factors(num)
  (1..num).select do |n|
    num % n == 0
  end
end

# ### Bubble Sort
#
# http://en.wikipedia.org/wiki/bubble_sort
#
# Implement Bubble sort in a method, `Array#bubble_sort!`. Your method should
# modify the array so that it is in sorted order.
#
# After writing `bubble_sort!`, write a `bubble_sort` that does the same
# but doesn't modify the original. Do this in two lines using `dup`.
#
# Finally, modify your `Array#bubble_sort!` method so that, instead of
# using `>` and `<` to compare elements, it takes a block to perform the
# comparison:
#
# ```ruby
# [1, 3, 5].bubble_sort! { |num1, num2| num1 <=> num2 } #sort ascending
# [1, 3, 5].bubble_sort! { |num1, num2| num2 <=> num1 } #sort descending
# ```


class Array
  def bubble_sort!(&prc)
    prc ||= Proc.new {|num1, num2| num1 <=> num2 }
    sorted = false
    until sorted
      idx = 0
      sorted = true
      while idx < self.length - 1
        if prc.call(self[idx],self[idx + 1]) == 1
          self[idx], self[idx + 1] = self[idx + 1], self[idx]
          sorted = false
        end
        idx += 1
      end
    end
    self
  end

  def bubble_sort(&prc)
    new_array = self.dup
    if prc
      new_array.bubble_sort!(&prc)
    else
      new_array.bubble_sort!
    end
  end
end

# ### Substrings and Subwords
#
# Write a method, `substrings`, that will take a `String` and return an
# array containing each of its substrings. Don't repeat substrings.
# Example output: `substrings("cat") => ["c", "ca", "cat", "a", "at",
# "t"]`.
#
# Your `substrings` method returns many strings that are not true English
# words. Let's write a new method, `subwords`, which will call
# `substrings`, filtering it to return only valid words. To do this,
# `subwords` will accept both a string and a dictionary (an array of
# words).

def substrings(string)
  new_array = []
  (0...string.length).each do |idx|
    (idx...string.length).each do |j|
      new_array << string[idx..j]
    end
  end
  new_array.uniq
end

def subwords(word, dictionary)
  substrings(word).select {|substring| dictionary.include?(substring)}
end

# ### Doubler
# Write a `doubler` method that takes an array of integers and returns an
# array with the original elements multiplied by two.

def doubler(array)
  array.map{ |n| n * 2 }
end

# ### My Enumerable Methods
# * Implement new `Array` methods `my_map` and `my_select`. Do
#   it by monkey-patching the `Array` class. Don't use any of the
#   original versions when writing these. Use your `my_each` method to
#   define the others. Remember that `each`/`map`/`select` do not modify
#   the original array.
# * Implement a `my_inject` method. Your version shouldn't take an
#   optional starting argument; just use the first element. Ruby's
#   `inject` is fancy (you can write `[1, 2, 3].inject(:+)` to shorten
#   up `[1, 2, 3].inject { |sum, num| sum + num }`), but do the block
#   (and not the symbol) version. Again, use your `my_each` to define
#   `my_inject`. Again, do not modify the original array.

class Array
  def my_map(&prc)
    new_array = []
    self.my_each do |element|
      new_array << prc.call(element)
    end
    new_array
  end

  def my_inject(&prc)
    result = self[0]
    self[1..-1].my_each do |element|
      result = prc.call(result, element)
    end
    result
  end
end

# ### Concatenate
# Create a method that takes in an `Array` of `String`s and uses `inject`
# to return the concatenation of the strings.
#
# ```ruby
# concatenate(["Yay ", "for ", "strings!"])
# # => "Yay for strings!"
# ```

def concatenate(strings)
  strings.inject(""){ |result, current| result << current }
end
