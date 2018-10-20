

MoneyRails.configure do |config|

  # set the default currency
  config.default_currency = :dkk
  eu_bank = EuCentralBank.new
  # Set default bank object
  config.default_bank = eu_bank

  #eu_bank_cache = "/some/file/location/exchange_rates.xml"
end