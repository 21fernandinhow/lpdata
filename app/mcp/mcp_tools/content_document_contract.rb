module McpTools
  # The Content Document contract, written into the tool descriptions so an
  # agent never has to open documentation written for a human.
  #
  # Source of truth: ContentDocumentValidator and docs/adr/0006. When the two
  # disagree, the validator wins: the server does not validate anything itself,
  # it just forwards what the model refused.
  module ContentDocumentContract
    VALID_EXAMPLE = <<~JSON.freeze
      {
        "hero": {
          "title": { "value": "Welcome", "type": "string" },
          "cta_url": { "value": "https://example.com", "type": "url" }
        },
        "features": [
          { "name": { "value": "Fast", "type": "string" } }
        ]
      }
    JSON

    FULL = <<~CONTRACT.freeze
      CONTENT DOCUMENT CONTRACT

      Every landing page holds one Content Document in `current_data`. The
      document is the whole unit of update: writing `current_data` replaces it
      entirely. Its structure is yours to design; LPData only enforces the rules
      below.

      - `current_data` is a non-null JSON value. Objects and arrays nest freely
        and may be empty.
      - A primitive value may never sit loose inside an object or an array.
        Every leaf must be an Editable Field.
      - An Editable Field is an object carrying BOTH `value` and `type`. An
        object carrying only one of the two is invalid.
      - `type` says which editor the dashboard offers for the value, and it must
        match the value:
          `string`, `text`, `url`, `hosted_file`, `external_file` take a JSON string;
          `number` takes a JSON number;
          `boolean` takes `true` or `false`.
      - `hosted_file` and `external_file` hold the URL itself in `value`. Use
        `hosted_file` for a file hosted by LPData (see get_asset_upload_command)
        and `external_file` for a file hosted anywhere else.
      - Keys beyond `value` and `type` are accepted on an Editable Field; this is
        how `dashboard_config` travels.

      Valid document:

      #{VALID_EXAMPLE}
      Invalid document: `{ "features": ["Fast"] }` is refused with

        Current data contains a value outside an editable field at $.features[0]

      because "Fast" is a bare string inside an array instead of an Editable Field.
    CONTRACT

    # Enough to write a document correctly, next to the argument that takes one.
    ARGUMENT = <<~CONTRACT.freeze
      The Content Document, replaced whole. Every leaf must be an Editable Field:
      an object carrying both `value` and `type`. See check_connection for the
      full contract. Example:

      #{VALID_EXAMPLE}
    CONTRACT

    # For the tools that only hand a document back.
    POINTER = "The Content Document follows the contract in the check_connection description.".freeze
  end
end
