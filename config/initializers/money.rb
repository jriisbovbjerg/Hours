

MoneyRails.configure do |config|

  # set the default currency
  config.default_currency = :dkk

  # Set default bank object
  config.default_bank = EuCentralBank.new

end