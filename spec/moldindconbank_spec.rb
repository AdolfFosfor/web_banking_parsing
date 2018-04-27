require_relative './spec_helper'
require_relative '../main'

RSpec.describe Moldindconbank do
let(:file) { File.open("./operations.html","r") { |f| f.read } }
let(:page) { Nokogiri::HTML.fragment(file).css("#contract-information") }

let(:fileNew) { File.open("./transactions.html","r") { |f| f.read } }
let(:body) { Nokogiri::HTML.fragment(fileNew).css(".operation-details-body") }
let(:header) { Nokogiri::HTML.fragment(fileNew).css(".operation-details-header") }

	before do
	expect(Watir::Browser).to receive(:new).and_return("Good")	
	end

	context "Account information parsing" do
		it "parse_name" do
			expect(subject.send(:parse_name, page)).to eq("Alexei Grushko")
		end

		it "parse_nature" do
			expect(subject.send(:parse_nature, page)).to eq("MasterCard Standard Contactless")
		end

		it "parse_currency" do
			expect(subject.send(:parse_currency, page)).to eq("USD")
		end

		it "parse_balance" do
			expect(subject.send(:parse_balance, page)).to eq("2,25")
		end
	end

	context "Transactions information parsing" do
		it "parse_data" do
			expect(subject.send(:parse_data, body)).to eq("8 aprilie 2018 10:23")
		end

		it "parse_description" do
			expect(subject.send(:parse_description, header)).to eq("Transfer to another Moldindconbank's card 5578********0602")
		end

		it "parse_amount" do
			expect(subject.send(:parse_amount, body)).to eq("100,00 USD")
		end
	end

end