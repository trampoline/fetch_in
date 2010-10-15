require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "FetchIn" do
  describe "fetch_in" do
    it "should fetch from a single level array" do
      [1].fetch_in(0).should == 1
    end

    it "should fetch nil if out of bounds of array" do
      [1].fetch_in(1).should == nil
    end

    it "should fetch from a single level hash" do
      {:foo=>:bar}.fetch_in(:foo).should == :bar
    end

    it "should fetch nil if no matching key in hash" do
      {:foo=>:bar}.fetch_in(:bar).should == nil
    end

    it "should fetch from a two level hash" do
      {:foo=>{:bar=>:baz}}.fetch_in(:foo, :bar).should == :baz
    end

    it "should fetch nil if no matching key in two level hash" do
      {:foo=>{:bar=>:baz}}.fetch_in(:foo, :baz).should == nil
    end

    it "should fetch from a two level array" do
      [[5]].fetch_in(0,0).should == 5
    end

    it "should fetch nil if no matching index in two level array" do
      [[5]].fetch_in(0,1).should == nil
    end
    
    it "should fetch from mixed array and hash nestings" do
      {:foo=>[nil,[nil,{:bar=>5}]]}.fetch_in(:foo,1,1,:bar).should == 5
    end

    it "should permit direct class-method invocation" do
      FetchIn.fetch_in({:foo=>[nil,[nil,{:bar=>5}]]},
                       :foo,1,1,:bar).should == 5
    end
  end

  describe "store_in" do
    it "should store in a single level array" do
      a=[]
      a.store_in(2,5)
      a.should==[nil,nil,5]
    end

    it "should store in a two level array" do
      a=[nil,[nil,3]]
      a.store_in(1,2,4)
      a.should == [nil,[nil,3,4]]
    end
    
    it "should create new nested arrays" do
      a = [nil]
      a.store_in(1,2,3)
      a.should == [nil,[nil,nil,3]]
    end

    it "should store in a single level hash" do
      h={}
      h.store_in(:foo,5)
      h.should == {:foo=>5}
    end

    it "should store in a two level hash" do
      h={:foo=>{:bar=>10}}
      h.store_in(:foo, :baz, 5)
      h.should == {:foo=>{:bar=>10, :baz=>5}}
    end

    it "should create new nested hashes" do
      h={:foo=>{:bar=>10}}
      h.store_in(:foo, :baz, :goo, 5)
      h.should == {:foo=>{:bar=>10, :baz=>{:goo=>5}}}
    end
    
    it "should store in mixed array hash structure" do
      s=[nil,{:foo=>[1,2]}]
      s.store_in(1,:foo,2,3)
      s.should == [nil,{:foo=>[1,2,3]}]
    end

    it "should create new array levels after the type of the last level" do
      s=[nil,{:foo=>[1,2]}]
      s.store_in(1,:foo,2,2,3)
      s.should == [nil,{:foo=>[1,2,[nil,nil,3]]}]
    end

    it "should create new hash levels after the type of the last level" do
      s=[nil,{:foo=>[1,2,{:bar=>5}]}]
      s.store_in(1,:foo,2,:baz,:goo,7)
      s.should == [nil,{:foo=>[1,2,{:bar=>5,:baz=>{:goo=>7}}]}]
    end

    it "should allow a block to create new levels" do
      s=[]
      s.store_in(1,2,3){|rx_key_stack| {}}
      s.should == [nil,{2=>3}]
    end

    it "should permit direct class-method invocation" do
      s=[]
      FetchIn.store_in(s,1,2,3){|rx_key_stack| {}}
      s.should == [nil,{2=>3}]
    end
  end
end
