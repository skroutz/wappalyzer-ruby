require 'spec_helper'

describe WappalyzerRb::Detector do
  let(:mock_response) do
    mock(:response, body: "nobody", :[] => nil)
  end

  it "should initialize" do
    WappalyzerRb::Detector.any_instance.stub(:response).and_return(mock_response)
    WappalyzerRb::Detector.new('http://someurl.com')
  end
end
