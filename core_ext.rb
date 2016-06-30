require_relative "lib/mll"

class Array
  def most
    MLL::most[self]
  end
  def rest
    MLL::rest[self]
  end
end
