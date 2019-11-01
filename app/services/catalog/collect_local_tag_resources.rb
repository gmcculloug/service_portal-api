module Catalog
  class CollectLocalTagResources
    attr_reader :tag_resources
    attr_reader :order

    def initialize(params)
      @params = params
      @tag_resources = []
    end

    def process
      @order = Order.find_by!(:id => @params[:order_id])
      @tag_resources = collect_tag_resources
      self
    end

    private

    def collect_tag_resources
      @order.order_items.each_with_object([]) do |item, result|
        result << tag_resource(item.portfolio_item)
        result << tag_resource(item.portfolio_item.portfolio)
      end.compact
    end

    def tag_resource(obj)
      tags = obj.tags
      if tags.any?
        { :app_name => 'catalog', :object_type => "#{obj.class}", :tags => minimal_tags(tags) }
      end
    end

    def minimal_tags(tags)
      tags.collect { |t| { :name => t.name, :namespace => t.namespace, :value => t.value } }
    end
  end
end
