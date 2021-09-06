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
        @position_file = position_file
        @binlog = MysqlBinlog::Binlog.new(file_reader(@position_file))
        @binlog.checksum = :crc32
        @binlog.ignore_rotate = false
      end

      # @return [void]
      def run
        binlog.each_event do |event|
          next unless HANDLE_EVENTS.include?(event[:type])

          puts event
        end
      end

      private

      # @return [String]
      attr_reader :root_dir
      # @return [MysqlBinlog::Binlog]
      attr_reader :binlog

      # @return [String]
      def position_file
        "#{root_dir}/positions/position.json"
      end

      # @param position_file [String]
      # @return [MysqlBinlog::BinlogFileReader]
      def file_reader(position_file)
        hash = JSON.parse(File.read(position_file))
        binlogfile = "/binlogs/#{hash['file']}"
        p binlogfile
        position = hash['position']
        reader = MysqlBinlog::BinlogFileReader.new(binlogfile)
        reader.tail = true
        reader.rotate(binlogfile, position)
        reader
      end
    end
  end
end
