class ContentDocumentValidator
  EDITABLE_TYPES = %w[string text number boolean url hosted_file external_file].freeze
  STRING_TYPES = %w[string text url hosted_file external_file].freeze

  def self.errors_for(document)
    errors = []
    validate_node(document, "$", errors)
    errors
  end

  def self.validate_node(node, path, errors)
    case node
    when Hash
      validate_hash(node, path, errors)
    when Array
      node.each_with_index { |child, index| validate_node(child, "#{path}[#{index}]", errors) }
    else
      errors << "contains a value outside an editable field at #{path}"
    end
  end

  def self.validate_hash(node, path, errors)
    has_value = node.key?("value")
    has_type = node.key?("type")

    if has_value != has_type
      errors << "editable fields must contain both value and type at #{path}"
      return
    end

    if has_value
      type = node["type"]

      unless EDITABLE_TYPES.include?(type)
        errors << "contains an unsupported editable field type at #{path}"
      end

      unless value_matches_type?(node["value"], type)
        errors << "editable field value does not match its type at #{path}"
      end
      return
    end

    node.each { |key, child| validate_node(child, "#{path}.#{key}", errors) }
  end

  def self.value_matches_type?(value, type)
    case type
    when *STRING_TYPES
      value.is_a?(String)
    when "number"
      value.is_a?(Numeric)
    when "boolean"
      value == true || value == false
    else
      false
    end
  end

  private_class_method :validate_node, :validate_hash, :value_matches_type?
end
