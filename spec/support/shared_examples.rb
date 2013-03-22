
shared_examples_for 'a successful JSON response' do
  it 'should retrieve a content-type of json' do
    response.header['Content-Type'].should include 'application/json'
  end

  it 'should retrieve status code of 200' do
    response.response_code.should == 200
  end
end
