require 'json'
require 'set'
require 'mysql_binlog'

module CDC
  module Producer
    # CDC::Producer::Worker
    class Worker
      HANDLE_EVENTS = Set.new(%i[write_rows_event_v2 update_rows_event_v2 delete_rows_event_v2])

      # @param position_file [String]
      # @return [void]
      def initialize(root_dir)
        @root_dir = root_dir
        @position_file = "#{root_dir}/positions/position.json"
        position = JSON.parse(File.read(@position_file))
        @init_binlog = position['file']
        @init_pos = position['position']
        @binlog_stream = MysqlBinlog::Binlog.new(file_reader)
        @binlog_stream.checksum = :crc32
        @binlog_stream.ignore_rotate = false
      end

      # @return [void]
      def run
        binlog_stream.each_event do |event|
          next if event[:filename] == init_binlog && event[:position] < init_pos
          next unless HANDLE_EVENTS.include?(event[:type])

          Consumer::Worker.perform_async(event)
        end
      end

      private

      # @!attribute [r] root_dir
      # @return [String]
      attr_reader :root_dir
      # @!attribute [r] position_file
      # @return [String]
      attr_reader :position_file
      # @!attribute [r] init_binlog
      # @return [String]
      attr_reader :init_binlog
      # @!attribute [r] init_pos
      # @return [Integer]
      attr_reader :init_pos
      # @!attribute [r] binlog
      # @return [MysqlBinlog::Binlog]
      attr_reader :binlog_stream


      # @return [String]
      def binlog_fullpath
        "#{root_dir}/binlogs/#{init_binlog}"
      end

      # @return [MysqlBinlog::BinlogFileReader]
      def file_reader
        reader = MysqlBinlog::BinlogFileReader.new(binlog_fullpath)
        reader.tail = true
        reader
      end
    end
  end
end
