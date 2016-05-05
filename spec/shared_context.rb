# General context for unit testing:
RSpec.shared_context 'shared context', a: :b do
  before :each do
    options = { host: 'https://ilo1.example.com', user: 'Administrator', password: 'secret123' }
    @client = ILO_SDK::Client.new(options)
  end
end
