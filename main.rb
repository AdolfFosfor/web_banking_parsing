require "watir"
require "nokogiri"
require "json"
require "time"
require_relative "Transaction.rb"
require_relative "Wbank_Parsing.rb"

bank = Wbank.new
puts bank.bank_parse
