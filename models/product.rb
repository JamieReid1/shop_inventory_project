
require_relative('../db/sql_runner.rb')

class Product

  attr_reader :id
  attr_accessor :name, :category, :description, :buy_cost, :sell_cost

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @category = options['category']
    @description = options['description']
    @buy_cost = options['buy_cost'].to_i
    @sell_cost = options['sell_cost'].to_i
  end


  def save()
    sql = "INSERT INTO products ( name,
                                  category,
                                  description,
                                  buy_cost,
                                  sell_cost
                                ) VALUES ( $1, $2, $3, $4, $5 )
           RETURNING id"
    values = [@name, @category, @description, @buy_cost, @sell_cost]
    results = SqlRunner.run(sql, values)
    @id = results.first['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM products"
    products = SqlRunner.run(sql)
    product = products.map{ |product| Product.new(product) }
    return product
  end

  def self.find(id)
    sql = "SELECT * FROM products WHERE id = $1"
    values = [id]
    product = SqlRunner.run(sql, values)
    return Product.new(product.first)
  end

  def update()
    sql = "UPDATE products SET ( name,
                                 category,
                                 description,
                                 buy_cost,
                                 sell_cost
                                ) = ( $1, $2, $3, $4, $5 )
                                WHERE id = $6"
    values = [@name, @category, @description, @buy_cost, @sell_cost, @id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM products"
    SqlRunner.run(sql)
  end

  def self.delete(id)
    sql = "DELETE FROM products WHERE id = $1"
    values = [id]
    SqlRunner.run(sql, values)
  end


end
