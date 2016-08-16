# General context for unit testing:
RSpec.shared_context 'shared context', a: :b do
  before :each do
    options = { host: 'ilo1.example.com', user: 'Administrator', password: 'secret123' }
    @client = ILO_SDK::Client.new(options)
  end
end

# Context for CLI testing:
RSpec.shared_context 'cli context', a: :b do
  before :each do
    ENV['ILO_HOST'] = 'https://ilo.example.com'
    ENV['ILO_USER'] = 'Admin'
    ENV['ILO_PASSWORD'] = 'secret123'
  end
end
