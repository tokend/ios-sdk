require 'yaml'
require 'json-schema'
require 'getoptlong'

opts = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--namespace', '-n', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--folder-name', '-f', GetoptLong::REQUIRED_ARGUMENT ]
)

def putsHelp
    puts <<-EOF
generate_api_data.rb OPTION

-h, --help:
 show help

--namespace name, -n name:
 namespace name generate API data to

--folder-name name, -f name:
 specs folder name generate API data from

    EOF
end

$namespace = nil
$specs_folder_name = nil

puts opts.error_message

opts.each do |opt, arg|
  case opt
    when '--help'
      putsHelp
      exit
    when '--namespace'
      $namespace = arg
    when '--folder-name'
      $specs_folder_name = arg
  end
end

if $namespace.nil? || $specs_folder_name.nil?
    putsHelp
    exit
end

$output_root_path = '../Sources/JSONAPI/v3/ApiModels/Generated/' + $namespace
root_path = '../../Regources/v2/yaml/'
configs_root_path = root_path + $specs_folder_name

$output_resources_directory = $output_root_path + '/Resources'
$output_inner_directory = $output_root_path + '/Inner'
$output_extensions_directory = $output_root_path + '/Extensions'

resource_folder_path = configs_root_path + '/resources'
inner_folder_path = configs_root_path + '/inner'

resource_schema_path = root_path + '/schema/resource.yaml'
inner_schema_path = root_path + '/schema/inner.yaml'

## Parse schemas

resource_schema = nil
inner_schema = nil

begin
  resource_schema = YAML.safe_load File.read resource_schema_path
rescue Exception => e
  puts "Failed to load '#{resource_schema_path}'. Error: #{e.message}\n"
  exit
end

begin
  inner_schema = YAML.safe_load File.read inner_schema_path
rescue Exception => e
  puts "Failed to load '#{inner_schema_path}'. Error: #{e.message}\n"
  exit
end

## Parse configs

inner_files = Dir[inner_folder_path + '/*.yaml']
resource_files = Dir[resource_folder_path + '/*.yaml']

$has_invalid_configs = false

def parse_configs(config_files, key, schema)
  configs = {}
  config_files.each do |config|
    contens = File.read config

    begin
      yaml = YAML.safe_load contens
    rescue Exception => e
      puts "Failed to load '#{config}'. Error: #{e.message}\n\n"
      $has_invalid_configs = true
      next
    end

    key_value = yaml[key]

    if key_value.nil?
      puts "Resource config '#{config}' has no value for key '#{key}'. Abort!\n\n"
      $has_invalid_configs = true
      next
    end

    begin
      JSON::Validator.validate!(schema, yaml)
    rescue Exception => e
      puts "Failed to validate '#{key_value}'. Error: #{e.message}\n\n"
      $has_invalid_configs = true
      next
    end

    configs[key_value.to_s] = yaml
  end
  configs
end

$resource_configs = parse_configs resource_files, 'key', resource_schema
$inner_configs = parse_configs inner_files, 'name', inner_schema

## Check configs valid

if $has_invalid_configs
  puts 'Fix invalid configs!'
  exit
end

## Clean previous

previous_files = Dir[$output_root_path + '/**/*.swift']
previous_files.each do |prev|
  File.delete prev
end

## Utils

def get_resource(key)
  resource_config = $resource_configs[key]
  if resource_config.nil?
    #puts "Resource for key \"#{key}\" not found. Abort!"
    puts "Resource for key \"#{key}\" not found. Return Resource!"
    resource_config = { "name" => "" }
  end
  resource_config
end

def get_inner(name)
  $inner_configs[name]
end

$indention = '    '

def repeat_string(string, count: Int)
  result = ''
  (1..count).each do |_|
    result += string
  end
  result
end

def get_indention(level)
  result = repeat_string $indention, count: level
  result
end

$output_string = ''

def add_line(line)
  value = "#{line}\n"
  $output_string += value
  value
end

def break_line
  value = add_line ''
  value
end

def indent(level)
  value = get_indention level
  $output_string += value
  value
end

def add_indented_line(level, line: String)
  value = indent level
  value += add_line line
  value
end

def indent_break(level)
  value = indent level
  value += break_line
  value
end

def close_block(level)
  value = indent level
  value += add_line '}'
  value
end

def get_output_attribute_type(type)
  if type == 'Amount'
    'Decimal'
  elsif type == 'Object'
    '[String: Any]'
  elsif type == 'String'
    type
  elsif type == 'Date'
    type
  elsif type == 'Int'
    type
  elsif type == 'Int32'
    type
  elsif type == 'Int64'
    type
  elsif type == 'UInt32'
    type
  elsif type == 'UInt64'
    type
  elsif type == 'Bool'
    type
  end
end

def get_output_attribute_type_default_value(type)
  if type == 'Amount'
    '0.0'
  elsif type == 'Object'
    '[:]'
  elsif type == 'String'
    '""'
  elsif type == 'Date'
    'Date()'
  elsif type == 'Int'
    '0'
  elsif type == 'Int32'
    '0'
  elsif type == 'Int64'
    '0'
  elsif type == 'UInt32'
    '0'
  elsif type == 'UInt64'
    '0'
  elsif type == 'Bool'
    'false'
  end
end

def get_uncapitalized(string) # lowercases only first letter
  if string.nil?
    puts 'zero for lowercase'
    return ''
  end

  if string.empty?
    puts 'zero for lowercase'
    return ''
  end

  value = string[0, 1].downcase + string[1..-1]
  value
end

def get_camel_name(string)
  if string.nil?
    puts 'zero for camel'
    return ''
  end

  if string.empty?
    puts 'zero for camel'
    return ''
  end

  words = string.split('_')
  if words.count > 1
    words.map!(&:capitalize)
    words[0] = get_uncapitalized words[0]
    return words.join
  else
    return string
  end
end

def get_resource_type(config)
  resource_type = config['key']
  resource_type
end

def get_resource_base(config)
  base = config['base']
  base
end

def get_resource_name(config)
  resource_name = config['name']
  resource_name
end

def get_resource_output_name(config)
  resource_name = get_resource_name config
  output_resource_name = "#{resource_name}Resource"
end

def sort_by_name(configs, name_key: String)
  unless configs.nil?
    configs.sort! do |attr1, attr2|
      name1 = get_camel_name attr1[name_key.to_s]
      name2 = get_camel_name attr2[name_key.to_s]

      name1 <=> name2
    end
  end
end

def get_resource_relations(config)
  relations = config['relations']
  if relations.nil?
    []
  else
    relations
  end
end

def get_resource_by_name(name)
  resource_config = $resource_configs.find { |r| r[1]['name'] == name }
  if resource_config.nil?
    puts "Resource for name \"#{name}\" not found. Abort!"
    exit
  end
  resource_config[1]
end

## Render

$all_resource_names = []
$subclasses_by_key = {} # { base_class_type: [ subclass_type_1, subclass_type_2, ... ] }
$related_subclasses_by_key = {} # { relation_type_key: { base_class_type: [ subclass_type_1, subclass_type_2, ... ] } }

def check_res_config_for_base(config)
  base = get_resource_base config
  key = get_resource_type config

  unless base.nil?
    existing_subclasses = $subclasses_by_key[base.to_s]
    if existing_subclasses.nil?
      $subclasses_by_key[base.to_s] = [key]
    else
      existing_subclasses.push key
      $subclasses_by_key[base.to_s] = existing_subclasses
    end
  end
end

def check_res_config_for_relations(config)
  resource_type = get_resource_type config
  relations = get_resource_relations config
  base = get_resource_base config

  return if base.nil?

  relations.each do |rel|
    relation_resource_key = rel['resource']

    existing_relations_by_base = $related_subclasses_by_key[relation_resource_key.to_s]
    existing_relations_by_base = {} if existing_relations_by_base.nil?

    existing_relations = existing_relations_by_base[base.to_s]
    if existing_relations.nil?
      existing_relations = [resource_type]
    else
      unless existing_relations.include? resource_type.to_s
        existing_relations.push resource_type
      end
    end

    existing_relations_by_base[base.to_s] = existing_relations

    $related_subclasses_by_key[relation_resource_key.to_s] = existing_relations_by_base
  end
end

## Resources

$resource_configs.each do |key, info|
  # puts "#{key}: #{info}"

  #------------------ Generator code ------------------#

  check_res_config_for_base info
  check_res_config_for_relations info

  $output_string = "// Auto-generated code. Do not edit.\n\n"
  $output_string += "import Foundation\n"
  resource_name = get_resource_name info
  output_resource_name = get_resource_output_name info
  add_line 'import DLJSONAPI'
  break_line

  puts "Render: #{resource_name}"

  ## Resource definition

  add_line "// MARK: - #{output_resource_name}"
  break_line

  super_class = 'Resource'
  base = info['base']
  unless base.nil?
    base_resource = get_resource base
    super_class = get_resource_output_name base_resource
  end

  add_line "extension " + $namespace + " {"
  add_line "open class #{output_resource_name}: #{super_class} {"
  indent_break 1
  add_indented_line 1, line: 'open override class var resourceType: String {'
  add_indented_line 2, line: "return \"#{key}\""
  close_block 1
  indent_break 1

  # Check attributes & relations

  attributes = info['attributes']
  relations = get_resource_relations info

  sort_by_name attributes, name_key: 'name'
  sort_by_name relations, name_key: 'name'

  attributes_count = 0
  relations_count = 0

  attributes_count = attributes.count unless attributes.nil?
  relations_count = relations.count unless relations.nil?

  if attributes_count > 0 || relations_count > 0

    ## Coding keys

    add_indented_line 1, line: 'public enum CodingKeys: String, CodingKey {'

    if attributes_count > 0
      add_indented_line 2, line: '// attributes'

      attributes.each do |attr|
        name = get_camel_name attr['name']
        add_indented_line 2, line: "case #{name}"
      end
    end

    if relations_count > 0
      indent_break 2 unless attributes.nil?

      add_indented_line 2, line: '// relations'

      relations.each do |rel|
        name = get_camel_name rel['name']
        add_indented_line 2, line: "case #{name}"
      end
    end

    close_block 1
    indent_break 1

    if attributes_count > 0

      ## Render attributes

      add_indented_line 1, line: '// MARK: Attributes'
      indent_break 1

      attributes.each do |attr|
        name = get_camel_name attr['name']
        type = get_camel_name attr['type']
        optional = attr['optional']
        is_collection = attr['is_collection']
        is_string_map = attr['is_string_map']

        output_type = get_output_attribute_type type
        cap_output_type = ''
        inner = nil

        if output_type.nil?
          inner = get_inner type
          if inner.nil?

            resource = get_resource_by_name type

            if resource.nil?
              puts "Unknown attribute type: '#{type}'"
              next
            else
              resource_name = get_resource_output_name resource
              if resource_name == 'Resource'
                output_type = resource_name
              else
                output_type = $namespace + '.' + resource_name
              end
              cap_output_type = 'Codable'
            end
          else
            inner_name = inner['name']

            output_type =  $namespace + '.' + inner_name
            cap_output_type = 'Codable'
          end
        else
          cap_output_type = if type == 'Object'
                              'Dictionary'
                            else
                              output_type
                            end
        end

        next if output_type.nil?
        
        if is_collection
            output_type = "[#{output_type}]"
            cap_output_type = "Codable"
        end
        if is_string_map
            output_type = "[String: #{output_type}]"
            cap_output_type = "Codable"
        end

        low_output_type = cap_output_type.downcase
        getter_string = "return self.#{low_output_type}OptionalValue(key: CodingKeys.#{name})"

        if optional || cap_output_type == 'Codable'
          output_type = "#{output_type}?"
        else
          output_type_default_value = get_output_attribute_type_default_value type
          getter_string += " ?? #{output_type_default_value}"
        end

        checked_name = name
        if checked_name == 'type'
          checked_name = 'attributesType'
        end

        add_indented_line 1, line: "open var #{checked_name}: #{output_type} {"
        add_indented_line 2, line: getter_string
        close_block 1
        indent_break 1
      end
    end

    if relations_count > 0

      ## Render relations

      add_indented_line 1, line: '// MARK: Relations'
      indent_break 1

      relations.each do |rel|
        name = get_camel_name rel['name']
        is_collection = rel['is_collection']
        resource_key = rel['resource']
        resource = get_resource resource_key

        output_type = nil
        relation_accessor = nil
        output_relation_resource_name = nil

        if resource.nil?
          puts "Unable to get resource: #{resource_key}"
          next
        else
          resource_name = get_resource_output_name resource
          if resource_name == 'Resource'
            output_relation_resource_name = resource_name
          else
            output_relation_resource_name = $namespace + '.' + resource_name
          end
        end

        if is_collection
          output_type = "[#{output_relation_resource_name}]"
          relation_accessor = 'Collection'
        else
          output_type = output_relation_resource_name
          relation_accessor = 'Single'
        end

        next if output_type.nil?

        add_indented_line 1, line: "open var #{name}: #{output_type}? {"
        add_indented_line 2, line: "return self.relation#{relation_accessor}OptionalValue(key: CodingKeys.#{name})"
        close_block 1
        indent_break 1
      end
    end
  end

  close_block 0
  close_block 0

  output_file_path = $output_resources_directory + '/' + $namespace + output_resource_name + '.swift'
  FileUtils.makedirs($output_resources_directory)
  output_file = File.open(output_file_path, 'w+')
  output_file.write($output_string)
  output_file.close

  $all_resource_names.push output_resource_name
end

## Generate AllResources

$output_string = "// Auto-generated code. Do not edit.\n"
break_line
add_line 'import Foundation'
add_line 'import DLJSONAPI'
break_line
add_line "extension " + $namespace + " {"
add_line 'enum AllResources {'
indent_break 1

add_indented_line 1, line: '// swiftlint:disable function_body_length'
add_indented_line 1, line: 'public static func registerAllResources() {'
add_indented_line 2, line: 'let allResources: [Resource.Type] = ['

array_indention = 3
indent array_indention
$output_string += $all_resource_names.map { |res| "#{res}.self" }.join(",\n#{get_indention array_indention}") + "\n"
add_indented_line 2, line: ']'
add_indented_line 2, line: ''
add_indented_line 2, line: 'for res in allResources {'
add_indented_line 3, line: 'Context.registerClass(res)'
add_indented_line 2, line: '}'
add_indented_line 2, line: ''
add_indented_line 2, line: 'for res in ManualResources.resources {'
add_indented_line 3, line: 'Context.registerClass(res)'
add_indented_line 2, line: '}'
add_indented_line 1, line: '}'
add_indented_line 1, line: '// swiftlint:enable function_body_length'
close_block 0
close_block 0

output_file_path = $output_root_path + '/' + $namespace + 'AllResources.swift'
FileUtils.makedirs($output_root_path)
output_file = File.open(output_file_path, 'w+')
output_file.write($output_string)
output_file.close

## Generate Namespace enum

$output_string = "// Auto-generated code. Do not edit.\n"
break_line
add_line 'public enum ' + $namespace + ' { }'

output_file_path = $output_root_path + '/' + $namespace + '.swift'
FileUtils.makedirs($output_root_path)
output_file = File.open(output_file_path, 'w+')
output_file.write($output_string)
output_file.close

## Generate resource extensions

def generate_extension(data, extension_name, extend_base: Bool, default_case: String)
  data.each do |base_type, resources|
    next if resources.count <= 1

    base_resource = get_resource base_type

    base_resource_name = get_resource_name base_resource
    output_base_resource_name = get_resource_output_name base_resource
    output_base_resource_enum_name = "#{base_resource_name}#{extension_name}"
    output_base_resource_enum_property_name = get_uncapitalized output_base_resource_enum_name

    puts "Render extension: #{output_base_resource_enum_name}"

    $enum_output_part = "public enum #{output_base_resource_enum_name} {\n"
    $enum_output_part += indent_break 1

    $extension_output_part = ''
    $extension_output_part = if extend_base
                               "extension Resource {\n"
                             else
                               "extension #{$namespace}.#{output_base_resource_name} {\n"
                             end
    $extension_output_part += indent_break 1
    $extension_output_part += add_indented_line 1, line: "public var #{output_base_resource_enum_property_name}: #{output_base_resource_enum_name} {"
    $extension_output_part += get_indention 2

    $snippet_output_part = "/*\n"
    $snippet_output_part += add_indented_line 1, line: 'switch type {'

    resources.sort! do |res1, res2|
      resource1 = get_resource res1
      resource2 = get_resource res2

      resource_name1 = get_resource_name resource1
      resource_name2 = get_resource_name resource2

      resource_name1 <=> resource_name2
    end

    resources.each do |resources_type|
      resource = get_resource resources_type

      resource_name = get_resource_name resource
      output_resource_name = get_resource_output_name resource

      output_resource_case_name = get_uncapitalized resource_name

      if output_resource_name == 'Resource'
        $enum_output_part += add_indented_line 1, line: "case #{output_resource_case_name}(_ resource: #{output_resource_name})"
      else
        $enum_output_part += add_indented_line 1, line: "case #{output_resource_case_name}(_ resource: #{$namespace}.#{output_resource_name})"
      end

      if output_resource_name == 'Resource'
        $extension_output_part += add_line "if let resource = self as? #{output_resource_name} {"
      else
        $extension_output_part += add_line "if let resource = self as? #{$namespace}.#{output_resource_name} {"
      end
      $extension_output_part += add_indented_line 3, line: "return .#{output_resource_case_name}(resource)"
      $extension_output_part += "#{get_indention 2}} else "

      $snippet_output_part += indent_break 2
      $snippet_output_part += add_indented_line 1, line: "case .#{output_resource_case_name}(let resource):"
      $snippet_output_part += indent_break 2
    end

    $enum_output_part += add_indented_line 1, line: "case #{default_case}(_ resource: #{$namespace}.#{output_base_resource_name})"
    $enum_output_part += close_block 0

    $extension_output_part += add_line '{'
    $extension_output_part += add_indented_line 3, line: "return .#{default_case}(self)"
    $extension_output_part += close_block 2
    $extension_output_part += close_block 1
    $extension_output_part += close_block 0

    $snippet_output_part += indent_break 2
    $snippet_output_part += add_indented_line 1, line: "case .#{default_case}(let resource):"
    $snippet_output_part += indent_break 2
    $snippet_output_part += close_block 1
    $snippet_output_part += add_line '*/'

    final_output = "// Auto-generated code. Do not edit.\n"
    final_output += break_line
    final_output += add_line 'import Foundation'
    final_output += break_line
    final_output += $enum_output_part
    final_output += break_line
    final_output += $extension_output_part
    final_output += break_line
    final_output += $snippet_output_part

    output_file_path = $output_extensions_directory + '/' + $namespace + output_base_resource_name + '+' + extension_name + '.swift'
    FileUtils.makedirs($output_extensions_directory)
    output_file = File.open(output_file_path, 'w+')
    output_file.write(final_output)
    output_file.close
  end
end

# By subclasses

generate_extension $subclasses_by_key, 'Type', extend_base: false, default_case: '`self`'

# By relations

$related_subclasses_by_key.each do |relation_type, related_by_subclasses|
  relation = get_resource relation_type
  relation_output_name = get_resource_name relation

  generate_extension related_by_subclasses, "RelatedTo#{relation_output_name}", extend_base: false, default_case: '`self`'
end

# generate_extension $relations_by_key, 'Related', extend_base: true, default_case: 'unrelated'

## Inner

$inner_configs.each do |name, info|
  # puts "inner #{name}: #{info}"

  #------------------ Generator code ------------------#

  inner_name = info['name']
  output_inner_name = inner_name
  puts "Render: #{inner_name}"

  $inner_declaration_output = ''
  $inner_declaration_output += add_line '// Auto-generated code. Do not edit.'
  $inner_declaration_output += break_line
  $inner_declaration_output += add_line 'import Foundation'

  $inner_declaration_output += break_line

  ## Inner definition

  $inner_declaration_output += add_line "// MARK: - #{output_inner_name}"
  $inner_declaration_output += break_line
  $inner_declaration_output += add_line "extension " + $namespace + " {"
  $inner_declaration_output += add_line "public struct #{output_inner_name}: Decodable {"
  $inner_declaration_output += indent_break 1

  attributes = info['attributes']

  sort_by_name attributes, name_key: 'name'

  attributes_count = 0
  attributes_count = attributes.count unless attributes.nil?

  if attributes_count > 0

    ## Coding keys

    $inner_declaration_output += add_indented_line 1, line: 'public enum CodingKeys: String, CodingKey {'

    if attributes_count > 0
      $inner_declaration_output += add_indented_line 2, line: '// attributes'

      attributes.each do |attr|
        name = get_camel_name attr['name']
        $inner_declaration_output += add_indented_line 2, line: "case #{name}"
      end
    end

    $inner_declaration_output += close_block 1
    $inner_declaration_output += indent_break 1

    if attributes_count > 0

      ## Render attributes and init

      $attributes_properties_output = ''
      $init_output = ''

      $attributes_properties_output += add_indented_line 1, line: '// MARK: Attributes'
      $attributes_properties_output += indent_break 1

      $init_output += add_indented_line 1, line: '// MARK: -'
      $init_output += indent_break 1
      $init_output += add_indented_line 1, line: 'public init(from decoder: Decoder) throws {'
      $init_output += add_indented_line 2, line: 'let container = try decoder.container(keyedBy: CodingKeys.self)'
      $init_output += indent_break 2

      attributes.each do |attr|
        name = get_camel_name attr['name']
        type = get_camel_name attr['type']
        optional = attr['optional']
        is_collection = attr['is_collection']
        is_string_map = attr['is_string_map']

        output_type = get_output_attribute_type type
        output_init = ''

        output_init = if optional
                        'try? '
                      else
                        'try '
                      end

        if output_type.nil?
          inner = get_inner type
          if inner.nil?

            resource = get_resource_by_name type

            if resource.nil?
              puts "Unknown attribute type: '#{type}'"
              next
            else
              resource_name = get_resource_output_name resource
              if resource == 'Resource'
                output_type = resource_name
              else
                output_type = $namespace + '.' + resource_name
              end
            end
          else
            output_type = inner['name']
            decode_output_type = output_type

            decode_output_type = "[#{output_type}]" if is_collection
            decode_output_type = "[String: #{output_type}]" if is_string_map

            output_init += "container.decode(#{decode_output_type}.self, forKey: .#{name})"
          end
        else
          decode_func = ''
          if output_type == 'Decimal'
            decode_func = 'decodeDecimalString'
            decode_func += 's' if is_collection
            decode_func += '(key'
          elsif output_type == '[String: Any]'
            decode_func = "decodeDictionary(#{output_type}.self, forKey"
          else
            decode_output_type = output_type
            decode_output_type = "[#{output_type}]" if is_collection
            decode_output_type = "[String: #{output_type}]" if is_string_map

            decode_func = "decode(#{decode_output_type}.self, forKey"
          end

          output_init += "container.#{decode_func}: .#{name})"
        end

        output_type = "[#{output_type}]" if is_collection
        output_type = "[String: #{output_type}]" if is_string_map

        output_type = "#{output_type}?" if optional

        $attributes_properties_output += add_indented_line 1, line: "public let #{name}: #{output_type}"

        $init_output += add_indented_line 2, line: "self.#{name} = #{output_init}"
      end
    end
  end

  $init_output += close_block 1

  $output_string = $inner_declaration_output
  add_line $attributes_properties_output
  add_line $init_output
  close_block 0
  close_block 0

  output_file_path = $output_inner_directory + '/' + $namespace + output_inner_name + '.swift'
  FileUtils.makedirs($output_inner_directory)
  output_file = File.open(output_file_path, 'w+')
  output_file.write($output_string)
  output_file.close
end
