require 'money/bank/currencylayer_bank'


MoneyRails.configure do |config|

  # set the default currency
  config.default_currency = :dkk

  mclb = Money::Bank::CurrencylayerBank.new
  mclb.access_key = '391dca5d5c5682ed936c41e3e37d1cad'

  # Set the seconds after than the current rates are automatically expired
  # by default, they never expire, in this example 1 day.
  mclb.ttl_in_seconds = 86400
  
  # Update rates (get new rates from remote if expired or access rates from cache)
  mclb.update_rates
  
  # Set default bank object
  config.default_bank = mclb

  # Define cache (string or pathname)
  #mclb.cache = 'path/to/file/cache'

end

