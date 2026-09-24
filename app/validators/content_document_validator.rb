class ContentDocumentValidator
  EDITABLE_TYPES = %w[string text number boolean url hosted_file external_file].freeze

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
      unless EDITABLE_TYPES.include?(node["type"])
        errors << "contains an unsupported editable field type at #{path}"
      end
      return
    end

    node.each { |key, child| validate_node(child, "#{path}.#{key}", errors) }
  end

  private_class_method :validate_node, :validate_hash
end
