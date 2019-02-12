=begin
Insights Service Catalog API

This is a API to fetch and order catalog items from different cloud sources

OpenAPI spec version: 1.0.0
Contact: you@your-company.com
Generated by: https://github.com/swagger-api/swagger-codegen.git

=end


class Portfolio < ApplicationRecord
  acts_as_tenant(:tenant)

  validates :name, presence: true, :uniqueness => { :scope => :tenant_id }
  validates :image_url, :format => { :with => URI::DEFAULT_PARSER.make_regexp }, :allow_blank => true
  validates :enabled_before_type_cast, :format => { :with => /\A(true|false)\z/i }, :allow_blank => true

  has_many :portfolio_items, :dependent => :destroy

  def add_portfolio_item(portfolio_item_id)
    portfolio_item = PortfolioItem.find_by(id: portfolio_item_id)
    portfolio_items << portfolio_item
  end
end
