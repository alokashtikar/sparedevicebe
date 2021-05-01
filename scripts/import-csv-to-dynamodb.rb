require 'aws-sdk'
require 'json'
require 'yaml'
require 'csv'
require 'securerandom'

class IMPORT_UTILS
  def initialize

    # @work_dir = ENV["WORK_DIR"]
    @import_data_file = ENV["IMPORT_DATA_FILE"]
    @import_table = ENV["IMPORT_TABLE"]
    @work_dir = "/opt/project"


    @region = ENV["AWS_REGION"]
    @aws_access_key_id = ENV["AWS_ACCESS_KEY_ID"]
    @aws_secret_access_key = ENV["AWS_SECRET_ACCESS_KEY"]

    @dynamodb = Aws::DynamoDB::Client.new(
        access_key_id: @aws_access_key_id,
        secret_access_key: @aws_secret_access_key,
        region: @region,
        simple_attributes: false
    )

    @TYPES_MAP = {
        "S"=>"s",
        "N"=>"n",
        "M"=>"m",
        "L"=>"l",
        "BOOL"=>"bool",
    }

  end

  def sanitize_content(content)
    content.gsub! '"S"', '"s"'
    content.gsub! '"N"', '"n"'
    content.gsub! '"M"', '"m"'
    content.gsub! '"L"', '"l"'
    content.gsub! '"BOOL"', '"bool"'
  end

  def import_data

    columns_titles=[]
    columns_types=[]

    csv_data = CSV.read(@import_data_file)
    first_line=csv_data.take(1)[0]
    first_line.each {|title|
      left_index = title.index('(')
      right_index = title.index(')')
      columns_titles.push(title[0..(left_index-2)])
      columns_types.push(@TYPES_MAP[title[(left_index+1)..(right_index-1)]])
    }
    # puts "first_line: #{first_line}"
    # puts "columns_titles: #{columns_titles}"
    # puts "columns_types: #{columns_types}"

    csv_data.drop(1).each { |line|
      item = {}
      columns_titles.each_index {|index|
        content = line[index]
        type = columns_types[index]
        if type.nil?
          puts "No Type found!!!!"
        end

        if type == "m"
          sanitize_content content
          content = JSON.parse content
        end


        item[columns_titles[index]]={type => content}
      }
      # puts item
      @dynamodb.put_item({
                             item: item,
                             table_name: @import_table,
                         })
    }

  end

end

import_utils = IMPORT_UTILS.new

import_utils.import_data
