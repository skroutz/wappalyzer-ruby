require 'spec_helper'

describe WappalyzerRb::Some do
  let(:mock_response) do
    mock(:response, body: "nobody", :[] => nil)
  end

  it "should initialize" do
    WappalyzerRb::Some.any_instance.stub(:response).and_return(mock_response)
    WappalyzerRb::Some.new('http://someurl.com')
  end
end
