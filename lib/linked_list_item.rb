class LinkedListItem
  include Comparable
  attr_accessor :payload, :next_list_item

  def initialize(payload)
    @payload = payload
  end

  def next_list_item= next_list_item
    next_list_item === self ? (raise ArgumentError.new("Nope")) : (@next_list_item = next_list_item)
  end

  def last?
    self.next_list_item == nil ? true : false
  end

  def ===(other)
    self.object_id === other.object_id ? true : false
  end

  def <=> (other_item)
    payload1 = self.payload
    payload2 = other_item.payload

    precedence = [Fixnum, String, Symbol]
    index1 = precedence.index(payload1.class)
    index2 = precedence.index(payload2.class)
    class_equality = (index1 <=> index2)

    if class_equality == 0
      payload1 <=> payload2
    else
      class_equality
    end
  end
end

