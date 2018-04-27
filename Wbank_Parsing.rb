class Wbank

  attr_reader :browser, :doc
  def initialize
    @browser = Watir::Browser.new :chrome
  end

  def bank_parse
  	log_in
  	parse_cards_data
  end

  def log_in
    browser.goto ("https://wb.micb.md")
    browser.text_field(class: "username").set("lolgol")
    browser.text_field(id: "password").set("Lolgol229")
    sleep(1)
    browser.button(class: "wb-button").click
    sleep(1)
  end

  def parse_cards_data
  	cards = browser.divs(class: "contract-cards")
    accounts = browser.divs(class: "contract status-active")
    accounts_info = accounts.map do |div|
      Watir::Wait.until { div.div(class: "contract-cards").a.present? }
      div.div(class: "contract-cards").a.click
      @doc = Nokogiri::HTML.parse(browser.div(id: "contract-information").html)
      sleep(1)
      sort_transactions
      data = {
          name: parse_name,
          balance: parse_ballance,
          currency: parse_currency,
          description: parse_nature,
          transaction: parse_transaction
      }
      browser.li(class: ["new_cards_accounts-menu-item active"]).a.click
      data
  	end
    JSON.pretty_generate(accounts: accounts_info) 
  end

  def parse_name
  	doc.css("tr td.value")[6].text
  end

  def parse_ballance
  	doc.css("tr td.value span.amount")[0].text
  end

  def parse_currency
    doc.css("tr td.value span.amount")[1].text
  end

  def parse_nature
  	doc.css("tr td.value")[3].text.gsub(" De baza - ","")
  end

  def sort_transactions
    browser.li(class: "ui-corner-top", index: 2).click
    Watir::Wait.until { browser.input(class: ["filter-date from maxDateToday hasDatepicker"]).present? }
    browser.input(class: ["filter-date from maxDateToday hasDatepicker"]).click
    Watir::Wait.until { browser.div(id: "ui-datepicker-div").a.present? }
    browser.div(id: "ui-datepicker-div").a.click
    sleep(1)
    Watir::Wait.until { browser.a(class: "ui-state-default").present? }
    browser.a(class: "ui-state-default").click
    sleep(2)
  end

  def parse_transaction
    arr = browser.div(class: "operations").lis
    sleep(2)
    arr.map do |li|
      Watir::Wait.until { li.a.present? }
      li.a.click
      operation_info = Nokogiri::HTML.parse(browser.div(class: "operation-details-body").html)
      description_info = Nokogiri::HTML.parse(browser.div(class: "operation-details-header").html)
      browser.send_keys :escape
      Transaction.new(
          parse_transaction_date(operation_info),
          parse_transaction_description(description_info),
          parse_transaction_amount(operation_info)
      ).to_hash
    end
  end

  def parse_transaction_date(operation_info)
    operation_info.css("div.details-section[1] div.details[1] div.value").text
  end

  def parse_transaction_description(description_info)
    description_info.css("div.operation-details-header").text
  end

  def parse_transaction_amount(operation_info)
    operation_info.css("div.details-section.amounts div.details[1] div.value").text
  end
end
