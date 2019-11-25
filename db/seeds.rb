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

#online store page
doc = Nokogiri::HTML(open(asham_main_url + online_store_url).read)
selector = "div.product-root ul.tree-grid > li > a"
top_level_cats = doc.css(selector)

# Retrieve top level categories listed on online store page,
# some of the contained links go to sub categories, other links head straight to products
top_level_cats.each do |cat|
  cat_name = cat.at_css('h3').content
  cat_url  = cat.attribute('href').content

  # Create or find top level category
  cat_ref_one = Category.find_or_create_by(name: cat_name)

  puts "#{cat_name} | #{cat_url}"

  # Drop down into each category url, this will result in either products or more categories
  doc = Nokogiri::HTML(open(asham_main_url + cat_url).read)

  ######## AT THIS POINT AT PRODS OR SUB CATS
  # If products on this page, using this selector will take us to the individual product page. Otherwise use selector(2)
  #selector 1
  #-------------------------------------------------
  #can write the other selector underneath bc either or will be hit but not both
  selector = "a.more-details"
  products = doc.css(selector)

  products.each do |product|
    product_url = product.attribute('href').content
    puts "P-URL: #{product_url}"

    doc = Nokogiri::HTML(open(asham_main_url + product_url).read)

    selector = "div.inner-wrapper"

    product_container = doc.css(selector)

    product_container.each do |prod_details|

      begin
        prod_price = prod_details.at_css('h2.price').at_css('span.list').content
      rescue
        prod_price = prod_details.at_css('h2.price').at_css('span.list-price').content
      end

      chance = rand(0..6)
      prod_per_dis = 0.00
      if chance == 4
        prod_per_dis = 0.10
      elsif chance == 5
        prod_per_dis = 0.25
      end


      prod_item    = prod_details.at_css('h1').content
      prod_desc    = prod_details.at_css('div.tabs').at_css('[id="features"]').content
      prod_img_url = prod_details.at_css('div.gallery-btn').at_css('img').attribute('src').content
      prod_stock = rand(0..100)

      prod_ref = Product.find_or_create_by(item: prod_item, description: prod_desc, price: prod_price.gsub('$','').to_f, stock: prod_stock, percentDiscount: prod_per_dis)

      # downloaded_image = open( asham_main_url + prod_img_url)
      # prod_img_name = product_image_url.split('/')[-1]
      # prod_ref.image.attach(io: downloaded_image, filename: prod_img_name)

      CategoryProduct.create(Category_id: cat_ref_one['id'], Product_id: prod_ref['id'])

      puts "\n\nPROD_DISCOUNT: #{prod_per_dis}\nITEM:#{prod_item.strip}\nDESC:#{prod_desc.strip}\nPRICE:#{prod_price.gsub('$','').to_f}\n#{prod_img_url}"
    end
  end

  #selector 2
  selector = 'div.content ul.tree-grid > li'
  sub_cats = doc.css(selector)

  sub_cats.each do |sub_cat|
    sub_cat_name = sub_cat.at_css('h3').content
    sub_cat_link_href = sub_cat.at_css('a').attribute('href').content
    cat_ref_two = Category.find_or_create_by(name: sub_cat_name)

    doc = Nokogiri::HTML(open(asham_main_url + sub_cat_link_href).read)

    selector = "a.more-details"
    products = doc.css(selector)

    products.each do |product|
      product_url = product.attribute('href').content
      puts "P-URL: #{product_url}"

      doc = Nokogiri::HTML(open(asham_main_url + product_url).read)

      selector = "div.inner-wrapper"

      product_container = doc.css(selector)

      product_container.each do |prod_details|

        begin
          prod_price = prod_details.at_css('h2.price').at_css('span.list').content
        rescue
          prod_price = prod_details.at_css('h2.price').at_css('span.list-price').content
        end

        chance = rand(0..6)
        prod_per_dis = 0.00
        if chance == 4
          prod_per_dis = 0.10
        elsif chance == 5
          prod_per_dis = 0.25
        end


        prod_item    = prod_details.at_css('h1').content
        prod_desc    = prod_details.at_css('div.tabs').at_css('[id="features"]').content
        prod_img_url = prod_details.at_css('div.gallery-btn').at_css('img').attribute('src').content
        prod_stock = rand(0..100)

        prod_ref = Product.find_or_create_by(item: prod_item, description: prod_desc, price: prod_price.gsub('$','').to_f, stock: prod_stock, percentDiscount: prod_per_dis)

        # downloaded_image = open( asham_main_url + prod_img_url)
        # prod_img_name = product_image_url.split('/')[-1]
        # prod_ref.image.attach(io: downloaded_image, filename: prod_img_name)

        CategoryProduct.create(Category_id: cat_ref_one['id'], Product_id: prod_ref['id'])
        CategoryProduct.create(Category_id: cat_ref_two['id'], Product_id: prod_ref['id'])
        puts "\n\nPROD_DISCOUNT: #{prod_per_dis}\nITEM:#{prod_item.strip}\nDESC:#{prod_desc.strip}\nPRICE:#{prod_price.gsub('$','').to_f}\n#{prod_img_url}"
      end
    end
  end

  #-------------------------------------------------
  # sub_category_categories.each do |sub_category|
  #       sub_category_name = sub_category.at_css('h3').content
  #       sub_category_link_href = sub_category.at_css('a').attribute('href').content
  #       category_ref_two = Category.find_or_create_by(name: sub_category_name)
  #       sub_sub_category_html_doc = Nokogiri::HTML(open(asham_main_url + sub_category_link_href).read)

  #       product_selector = 'div.feature-products div.product-accessories'
  #       product_details = sub_sub_category_html_doc.css(product_selector)

  #       product_details.each do |product_detail|
  #         product_name = product_detail.at_css('div.left').at_css('h3').at_css('a').content
  #         product_description = product_detail.at_css('div.left').at_css('div.summary').content
  #         product_price = product_detail.at_css('div.right').at_css('p').at_css('span').content
  #         price = product_price.gsub('$','')
  #         stock = rand(0..100)
  #         percentDiscount = rand(0..0.25).round(2)
  #         product_ref_two = Product.find_or_create_by(item: product_name, description: product_description, price: price.to_f, stock: stock, percentDiscount: percentDiscount)

  #         product_image_url = product_detail.at_css('div.img-container').at_css('a').at_css('img').attribute('src').content
  #         downloaded_image = open( asham_main_url + product_image_url)
  #         product_image_name = product_image_url.split('/')[-1]
  #         puts "INAME: #{product_image_name}"
  #         product_ref_two.image.attach(io: downloaded_image, filename: product_image_name)

  #         CategoryProduct.create(Category_id: category_ref['id'], Product_id: product_ref_two['id'])
  #         CategoryProduct.create(Category_id: category_ref_two['id'], Product_id: product_ref_two['id'])
  #       end
  #-------------------------------------------------

end

puts "TOTAL PRODS: #{Product.count}"
puts "TOTAL CATPRODS: #{CategoryProduct.count}"

AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?
# product_name = product_detail.at_css('div.left').at_css('h3').at_css('a').content
# product_description = product_detail.at_css('div.left').at_css('div.summary').content
# product_price = product_detail.at_css('div.right').at_css('p').at_css('span').content
# price = product_price.gsub('$','')
# stock = rand(0..100)
# percentDiscount = rand(0..0.25).round(2)
# product_ref = Product.find_or_create_by(item: product_name, description: product_description, price: price.to_f, stock: stock, percentDiscount: percentDiscount)

# product_image_url = product_detail.at_css('div.img-container').at_css('a').at_css('img').attribute('src').content
# downloaded_image = open( asham_main_url + product_image_url)
# product_image_name = product_image_url.split('/')[-1]
# puts "INAME: #{product_image_name}"
# product_ref.image.attach(io: downloaded_image, filename: product_image_name)


# online_store_category_selector = 'div.product-root ul.tree-grid > li > a'

# online_store_categories = online_store_html_doc.css(online_store_category_selector)

# online_store_categories.each do |category|
#   category_name = category.at_css('h3').content
#   link_href = category.attribute('href').content
#   category_ref = Category.find_or_create_by(name: category_name)
#   sub_category_html_doc = Nokogiri::HTML(open(asham_main_url + link_href).read)
#   # product_selector = 'div.feature-products div.product-accessories div.products-accessories-details'
#   product_selector = 'div.feature-products div.product-accessories'
#   product_details = sub_category_html_doc.css(product_selector)
#   product_details.each do |product_detail|
#     product_name = product_detail.at_css('div.left').at_css('h3').at_css('a').content
#      product_description = product_detail.at_css('div.left').at_css('div.summary').content
#      product_price = product_detail.at_css('div.right').at_css('p').at_css('span').content
#      price = product_price.gsub('$','')
#      stock = rand(0..100)
#      percentDiscount = rand(0..0.25).round(2)
#      product_ref = Product.find_or_create_by(item: product_name, description: product_description, price: price.to_f, stock: stock, percentDiscount: percentDiscount)

#      product_image_url = product_detail.at_css('div.img-container').at_css('a').at_css('img').attribute('src').content
#      downloaded_image = open( asham_main_url + product_image_url)
#      product_image_name = product_image_url.split('/')[-1]
#      puts "INAME: #{product_image_name}"
#      product_ref.image.attach(io: downloaded_image, filename: product_image_name)
#          #

#     #  product.image.attach(io: downloaded_image, filename: filename_to_use_locally)
#     #
#      CategoryProduct.create(Category_id: category_ref['id'], Product_id: product_ref['id'])
#   end

#   sub_category_selector = 'div.content ul.tree-grid > li'
#   sub_category_categories = sub_category_html_doc.css(sub_category_selector)


#   sub_category_categories.each do |sub_category|
#     sub_category_name = sub_category.at_css('h3').content
#     sub_category_link_href = sub_category.at_css('a').attribute('href').content
#     category_ref_two = Category.find_or_create_by(name: sub_category_name)
#     sub_sub_category_html_doc = Nokogiri::HTML(open(asham_main_url + sub_category_link_href).read)

#     product_selector = 'div.feature-products div.product-accessories'
#     product_details = sub_sub_category_html_doc.css(product_selector)

#     product_details.each do |product_detail|
#       product_name = product_detail.at_css('div.left').at_css('h3').at_css('a').content
#       product_description = product_detail.at_css('div.left').at_css('div.summary').content
#       product_price = product_detail.at_css('div.right').at_css('p').at_css('span').content
#       price = product_price.gsub('$','')
#       stock = rand(0..100)
#       percentDiscount = rand(0..0.25).round(2)
#       product_ref_two = Product.find_or_create_by(item: product_name, description: product_description, price: price.to_f, stock: stock, percentDiscount: percentDiscount)

#       product_image_url = product_detail.at_css('div.img-container').at_css('a').at_css('img').attribute('src').content
#       downloaded_image = open( asham_main_url + product_image_url)
#       product_image_name = product_image_url.split('/')[-1]
#       puts "INAME: #{product_image_name}"
#       product_ref_two.image.attach(io: downloaded_image, filename: product_image_name)

#       CategoryProduct.create(Category_id: category_ref['id'], Product_id: product_ref_two['id'])
#       CategoryProduct.create(Category_id: category_ref_two['id'], Product_id: product_ref_two['id'])
#     end
# end
# end


# AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

# puts "done"


####### OLD  ########

# ActiveStorage::Attachment.destroy_all
# ActiveStorage::Blob.destroy_all
# CategoryProduct.destroy_all
# Category.destroy_all
# Product.destroy_all
# AdminUser.destroy_all

# asham_main_url = 'https://www.asham.com'
# online_store_url = '/online-store'
# online_store_html = open(asham_main_url + online_store_url).read
# online_store_html_doc = Nokogiri::HTML(online_store_html)
# online_store_category_selector = 'div.product-root ul.tree-grid > li > a'

# online_store_categories = online_store_html_doc.css(online_store_category_selector)

# online_store_categories.each do |category|
#   category_name = category.at_css('h3').content
#   link_href = category.attribute('href').content
#   category_ref = Category.find_or_create_by(name: category_name)
#   sub_category_html_doc = Nokogiri::HTML(open(asham_main_url + link_href).read)
#   # product_selector = 'div.feature-products div.product-accessories div.products-accessories-details'
#   product_selector = 'div.feature-products div.product-accessories'
#   product_details = sub_category_html_doc.css(product_selector)
#   product_details.each do |product_detail|
#     product_name = product_detail.at_css('div.left').at_css('h3').at_css('a').content
#      product_description = product_detail.at_css('div.left').at_css('div.summary').content
#      product_price = product_detail.at_css('div.right').at_css('p').at_css('span').content
#      price = product_price.gsub('$','')
#      stock = rand(0..100)
#      percentDiscount = rand(0..0.25).round(2)
#      product_ref = Product.find_or_create_by(item: product_name, description: product_description, price: price.to_f, stock: stock, percentDiscount: percentDiscount)

#      product_image_url = product_detail.at_css('div.img-container').at_css('a').at_css('img').attribute('src').content
#      downloaded_image = open( asham_main_url + product_image_url)
#      product_image_name = product_image_url.split('/')[-1]
#      puts "INAME: #{product_image_name}"
#      product_ref.image.attach(io: downloaded_image, filename: product_image_name)
#          #

#     #  product.image.attach(io: downloaded_image, filename: filename_to_use_locally)
#     #
#      CategoryProduct.create(Category_id: category_ref['id'], Product_id: product_ref['id'])
#   end

#   sub_category_selector = 'div.content ul.tree-grid > li'
#   sub_category_categories = sub_category_html_doc.css(sub_category_selector)


#   sub_category_categories.each do |sub_category|
#     sub_category_name = sub_category.at_css('h3').content
#     sub_category_link_href = sub_category.at_css('a').attribute('href').content
#     category_ref_two = Category.find_or_create_by(name: sub_category_name)
#     sub_sub_category_html_doc = Nokogiri::HTML(open(asham_main_url + sub_category_link_href).read)

#     product_selector = 'div.feature-products div.product-accessories'
#     product_details = sub_sub_category_html_doc.css(product_selector)

#     product_details.each do |product_detail|
#       product_name = product_detail.at_css('div.left').at_css('h3').at_css('a').content
#       product_description = product_detail.at_css('div.left').at_css('div.summary').content
#       product_price = product_detail.at_css('div.right').at_css('p').at_css('span').content
#       price = product_price.gsub('$','')
#       stock = rand(0..100)
#       percentDiscount = rand(0..0.25).round(2)
#       product_ref_two = Product.find_or_create_by(item: product_name, description: product_description, price: price.to_f, stock: stock, percentDiscount: percentDiscount)

#       product_image_url = product_detail.at_css('div.img-container').at_css('a').at_css('img').attribute('src').content
#       downloaded_image = open( asham_main_url + product_image_url)
#       product_image_name = product_image_url.split('/')[-1]
#       puts "INAME: #{product_image_name}"
#       product_ref_two.image.attach(io: downloaded_image, filename: product_image_name)

#       CategoryProduct.create(Category_id: category_ref['id'], Product_id: product_ref_two['id'])
#       CategoryProduct.create(Category_id: category_ref_two['id'], Product_id: product_ref_two['id'])
#     end
# end
# end


# AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

# puts "done"

