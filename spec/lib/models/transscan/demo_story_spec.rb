require 'spec_helper'

describe Transscan::DemoStory do
  it "says hello" do
    expect( Transscan::DemoStory.new.find_all).to eq({res => "Hello, world!"})
  end
end