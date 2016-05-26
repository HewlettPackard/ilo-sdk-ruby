module ILO_SDK
  # Contains helper methods for Service Root Actions
  module Service_Root_Helper
    # Get the schema information with given prefix
    # @param [String, Symbol] schema_prefix
    # @raise [RuntimeError] if the request failed
    # @return [String] schema
    def get_schema(schema_prefix)
      response = rest_get('/redfish/v1/Schemas/')
      schemas = response_handler(response)['Items']
      schema = schemas.select { |s| s['Schema'].start_with?(schema_prefix) }
      raise "NO schema found with this schema prefix : #{schema_prefix}" if schema.empty?
      info = []
      schema.each do |sc|
        response = rest_get(sc['Location'][0]['Uri']['extref'])
        schema_store = response_handler(response)
        info.push(schema_store)
      end
      info
    end

    # Get the Registry with given registry_prefix
    # @param [String, Symbol] registry_prefix
    # @raise [RuntimeError] if the request failed
    # @return [String] registry
    def get_registry(registry_prefix)
      response = rest_get('/redfish/v1/Registries/')
      registries = response_handler(response)['Items']
      registry = registries.select { |reg| reg['Schema'].start_with?(registry_prefix) }
      info = []
      registry.each do |reg|
        response = rest_get(reg['Location'][0]['Uri']['extref'])
        registry_store = response_handler(response)
        info.push(registry_store)
      end
      info
    end
  end
end
