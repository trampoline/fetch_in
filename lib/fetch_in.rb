module FetchIn
  def fetch_in(*keys)
    keys.reduce(self) do |result,key|
      return nil if !result
      result[key]
    end
  end

  # store_in stores a value in a nested associative structure
  # new levels in the structure are created as required, by the supplied Proc.
  # if no Proc is supplied, new levels are created with the same class as
  # the previous level
  def store_in(*keys_and_value, &proc)
    proc ||= lambda{|rx_key_stack| rx_key_stack[-1][0].class.new}
    keys = keys_and_value[0..-2]
    value = keys_and_value[-1]

    # find or create the last associative receiver in the chain to the value
    last_rx = keys[0..-2].reduce([self,[]]) do |(rx,rx_key_stack),key|
      rx_key_stack = rx_key_stack << [rx,key]
      rx[key] = proc.call(rx_key_stack) if !rx[key]
      [rx[key], rx_key_stack]
    end[0]

    # set the value
    last_rx[keys[-1]]=value
  end
end

class Hash
  include FetchIn
end
class Array
  include FetchIn
end
