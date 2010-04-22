require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "FetchIn" do
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
end
