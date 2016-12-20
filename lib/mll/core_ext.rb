require_relative "../mll"

class Object
  def nest_while_list f, test
    MLL::nest_while_list[self, f, test]
  end
end

class Array
  def most
    MLL::most[self]
  end
  def rest
    MLL::rest[self]
  end
end
