class CustomSearch < Spree::Core::Search::Base

    protected
    def add_search_scopes(base_scope)
      statement = nil
      search.each do |property_name, property_values|
        property = Spree::Property.find_by_name(property_name.gsub("_any", ""))
        next unless property
  
        substatement = product_property[:property_id].eq(property.id).and(product_property[:value].eq(property_values.first))
        property_values[1..-1].each do |pv|
          substatement = substatement.or product_property[:value].eq(pv)
        end
        tail = product[:id].in(Spree::ProductProperty.select(:product_id).where(substatement).map(&:product_id))
        statement = statement.nil? ? tail : statement.and(tail)
      end if search
      statement ? base_scope.where(statement) : base_scope
    end
  
    def prepare(params)
      super
      @properties[:product] = Spree::Product.arel_table
      @properties[:product_property] = Spree::ProductProperty.arel_table
    end
end