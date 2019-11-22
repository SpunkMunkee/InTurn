require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'open-uri'

ActiveStorage::Attachment.destroy_all
ActiveStorage::Blob.destroy_all
CategoryProduct.destroy_all
Category.destroy_all
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
  category_ref = Category.find_or_create_by(name: category_name)
  sub_category_html_doc = Nokogiri::HTML(open(asham_main_url + link_href).read)
  # product_selector = 'div.feature-products div.product-accessories div.products-accessories-details'
  product_selector = 'div.feature-products div.product-accessories'
  product_details = sub_category_html_doc.css(product_selector)
  product_details.each do |product_detail|
    product_name = product_detail.at_css('div.left').at_css('h3').at_css('a').content
     product_description = product_detail.at_css('div.left').at_css('div.summary').content
     product_price = product_detail.at_css('div.right').at_css('p').at_css('span').content
     price = product_price.gsub('$','')
     stock = rand(0..100)
     percentDiscount = rand(0..0.25).round(2)
     product_ref = Product.find_or_create_by(item: product_name, description: product_description, price: price.to_f, stock: stock, percentDiscount: percentDiscount)

     product_image_url = product_detail.at_css('div.img-container').at_css('a').at_css('img').attribute('src').content
     downloaded_image = open( asham_main_url + product_image_url)
     product_image_name = product_image_url.split('/')[-1]
     puts "INAME: #{product_image_name}"
     product_ref.image.attach(io: downloaded_image, filename: product_image_name)
         #

    #  product.image.attach(io: downloaded_image, filename: filename_to_use_locally)
    #
     CategoryProduct.create(Category_id: category_ref['id'], Product_id: product_ref['id'])
  end

  sub_category_selector = 'div.content ul.tree-grid > li'
  sub_category_categories = sub_category_html_doc.css(sub_category_selector)


  sub_category_categories.each do |sub_category|
    sub_category_name = sub_category.at_css('h3').content
    sub_category_link_href = sub_category.at_css('a').attribute('href').content
    category_ref_two = Category.find_or_create_by(name: sub_category_name)
    sub_sub_category_html_doc = Nokogiri::HTML(open(asham_main_url + sub_category_link_href).read)

    product_selector = 'div.feature-products div.product-accessories'
    product_details = sub_sub_category_html_doc.css(product_selector)

    product_details.each do |product_detail|
      product_name = product_detail.at_css('div.left').at_css('h3').at_css('a').content
      product_description = product_detail.at_css('div.left').at_css('div.summary').content
      product_price = product_detail.at_css('div.right').at_css('p').at_css('span').content
      price = product_price.gsub('$','')
      stock = rand(0..100)
      percentDiscount = rand(0..0.25).round(2)
      product_ref_two = Product.find_or_create_by(item: product_name, description: product_description, price: price.to_f, stock: stock, percentDiscount: percentDiscount)

      product_image_url = product_detail.at_css('div.img-container').at_css('a').at_css('img').attribute('src').content
      downloaded_image = open( asham_main_url + product_image_url)
      product_image_name = product_image_url.split('/')[-1]
      puts "INAME: #{product_image_name}"
      product_ref_two.image.attach(io: downloaded_image, filename: product_image_name)

      CategoryProduct.create(Category_id: category_ref['id'], Product_id: product_ref_two['id'])
      CategoryProduct.create(Category_id: category_ref_two['id'], Product_id: product_ref_two['id'])
    end
end
end


AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

puts "done"
