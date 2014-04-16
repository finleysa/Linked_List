class LinkedList
  attr_reader :size

  def initialize(*items)
    @size = 0
    if items
      items.each {|item| add_item(item)}
    else
      items = nil
    end
  end

  def sorted?
    item = @first_item
    return true if item == nil or @size == 1
    until item.last?
      next_item = item.next_list_item
      if (item.payload.class == String or Symbol) and next_item.class == Fixnum
        return false
      end
      if item.payload.class == Symbol and next_item.payload.class == String
        return false
      end
      if item.payload.class == next_item.payload.class
        return false if item.payload > next_item.payload
      end
      item = next_item
    end
    true
  end

  def add_item(payload)
    lli = LinkedListItem.new(payload)
    if @first_item.nil?
      @first_item = lli
    else
      item = @first_item
      until item.last?
        item = item.next_list_item
      end
      item.next_list_item = lli
    end
    @size += 1
  end

  def get(i)
    get_item(i).payload
  end

  alias [] get

  def last
    if size == 0
      nil
    else
      get(size - 1)
    end
  end

  def sort
    return to_s if @size == 0
    item = @first_item
    swapped = true
    count = 0
    if @size > 1
      sorted = true
      while sorted
        sorted = false
        other = item.next_list_item
        if other.payload != nil
          if item > other
            item.payload, other.payload = other.payload, item.payload
            sorted = true
          end
          other = other.next_list_item
          item = item.next_list_item
        end
      end
    end
    to_s
  end

  def swap_with_next index
    item = @first_item
    index.times do
      item = item.next_list_item
    end
    item.payload, item.next_list_item.payload = item.next_list_item.payload, item.payload
  end

  def to_s
    return "| |" if @size == 0
    result = "|"
    item = @first_item
    until item.nil?
      if item == Symbol
        result << " :" + item.payload.to_s
      else
        result << " " + item.payload.to_s
      end
      result << "," unless item.last?
      item = item.next_list_item
    end
    result + " |"
  end

  def indexOf (payload)
    item = @first_item
    count = 0
    until item.nil?
      return count if item.payload == payload
      item = item.next_list_item
      count += 1
    end
  end

  def []=(index, payload)
    item = @first_item
    index.times do
      item = item.next_list_item
    end
    item.payload = payload
  end

  def remove (index)
    item = @first_item
    if index == 0
      @first_item = @first_item.next_list_item
    else
      previous = get_item( index-1 )
      next_list_item = previous.next_list_item.next_list_item
      previous.next_list_item = next_list_item
    end
    @size -= 1

  end

  def size
    @size
  end

  private

  def get_item(i)
    raise IndexError if i < 0 or i >= size
    item = @first_item
    i.times do
      item = item.next_list_item
    end
    item
  end
end
