require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'open-uri'
Product.destroy_all
AdminUser.destroy_all
asham_main_url = 'https://www.asham.com'
online_store_url = '/online-store'
online_store_html = open(asham_main_url + online_store_url).read
online_store_html_doc = Nokogiri::HTML(online_store_html)
online_store_category_selector = 'div.product-root ul.tree-grid > li > a'

online_store_categories = online_store_html_doc.css(online_store_category_selector)

online_store_categories.each do |category|
  category_name = category.at_css('h3').content
  link_href = category.attribute('href').content

  puts "\n"
  puts category_name
  puts link_href

 # sub_category_html = open(asham_main_url + link_href).read
  # sub_category_html_doc = Nokogiri::HTML(sub_category_html)
  sub_category_html_doc = Nokogiri::HTML(open(asham_main_url + link_href).read)

  product_selector = 'div.feature-products div.product-accessories div.products-accessories-details'
  product_details = sub_category_html_doc.css(product_selector)

  product_details.each do |product_detail|
    product_name = product_detail.at_css('div.left').at_css('h3').at_css('a').content

     product_description = product_detail.at_css('div.left').at_css('div.summary').content
     product_price = product_detail.at_css('div.right').at_css('p').at_css('span').content
     price = product_price.gsub('$','')
     stock = rand(0..100)
     percentDiscount = rand(0..0.25).round(2)
    #   product_price = individual_product_detail.at_css('right').at_css('p')
     Product.create(item: product_name, description: product_description, price: price.to_f, stock: stock, percentDiscount: percentDiscount)
      # Pokemon.create(name: pokemon['name'], sprite: pokemon['sprites']['front_default'] , order: pokemon['order'], weight: pokemon['weight'], height: pokemon['height']
      puts "PRODUCT NAME: #{product_name} "
      puts "PRODUCT DESCRIPTION: #{product_description}"
      puts "PRODUCT Price: #{price}"
      puts "PRODUCT PD: #{percentDiscount}"

  end

  # product_details.each do |product_detail|
  #   product_href = product_detail.attribute('href').content
  #   puts "PRODUCTURL: #{product_href}"
  #   product_html = open(asham_main_url + product_href).read
  #   product_html_doc = Nokogiri::HTML(product_html)

  #   individual_product_selector = 'div.inner-wrapper'
  #   individual_product_details = product_html_doc.css(individual_product_selector)

  #   individual_product_details.each do |individual_product_detail|
  #     product_name = individual_product_detail.at_css('h1').content
  #     product_description = individual_product_detail.at_css('content').at_css('')
  #     product_price = individual_product_detail.at_css
  #     Product.create(item: product_name, description: product_description, price: product_price, stock: 100, percentDiscount: 0.1)
  #     # Pokemon.create(name: pokemon['name'], sprite: pokemon['sprites']['front_default'] , order: pokemon['order'], weight: pokemon['weight'], height: pokemon['height']
  #     puts "PRODUCT NAME: #{product_name}"
  #   end
  # end

  sub_category_selector = 'div.content ul.tree-grid > li'
  sub_category_categories = sub_category_html_doc.css(sub_category_selector)


  sub_category_categories.each do |sub_category|
    sub_category_name = sub_category.at_css('h3').content
    sub_category_link_href = sub_category.at_css('a').attribute('href').content

    puts " #{sub_category_name}"
    puts " #{sub_category_link_href}"

    sub_sub_category_html_doc = Nokogiri::HTML(open(asham_main_url + sub_category_link_href).read)

    product_selector = 'div.feature-products div.product-accessories div.products-accessories-details'
    product_details = sub_sub_category_html_doc.css(product_selector)

    product_details.each do |product_detail|

      product_name = product_detail.at_css('div.left').at_css('h3').at_css('a').content

     product_description = product_detail.at_css('div.left').at_css('div.summary').content
     product_price = product_detail.at_css('div.right').at_css('p').at_css('span').content
     price = product_price.gsub('$','')
     stock = rand(0..100)
     percentDiscount = rand(0..0.25).round(2)
    #   product_price = individual_product_detail.at_css('right').at_css('p')
     Product.create(item: product_name, description: product_description, price: price.to_f, stock: stock, percentDiscount: percentDiscount)
      # Pokemon.create(name: pokemon['name'], sprite: pokemon['sprites']['front_default'] , order: pokemon['order'], weight: pokemon['weight'], height: pokemon['height']
      puts "PRODUCT NAME: #{product_name} "
      puts "PRODUCT DESCRIPTION: #{product_description}"
      puts "PRODUCT Price: #{price}"
      puts "PRODUCT PD: #{percentDiscount}"
    end
end
end
# puts categories
puts "PRODUCT COUNT: #{Product.count}"

AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

