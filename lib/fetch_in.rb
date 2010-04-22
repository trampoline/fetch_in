module FetchIn
  def fetch_in(*keys)
    keys.reduce(self) do |result,key|
      return nil if !result
      result[key]
    end
  end
end

class Hash
  include FetchIn
end
class Array
  include FetchIn
end
