require_relative '../email_search'
require 'tty-table'
require 'io/console'
module EmailSearch
  class MboxFile
    include ::EmailSearch::Output

    attr_reader :mbox_file,
                :mbox_path,
                :current_file,
                :progress_bar,
                :line_counter,
                :file_counter,
                :emails_path

    def initialize(file, index = 1)
      @line_counter = 0
      @index        = index
      @file_counter = 0
      @mbox_file    = file
      @mbox_path    = File.dirname(@mbox_file) if @mbox_file
      @emails_path  = "#{File.dirname(@mbox_path)}/elmx"

      FileUtils.mkdir_p(@emails_path)

      unless File.exist?(mbox_file)
        error "file #{mbox_file} does not exist!"
        return
      end

      mbox_lines = `cat "#{mbox_file}" | wc -l`.to_i
      header(mbox_lines)

      @progress_bar = ::ProgressBar.create(title:         pb_title,
                                           progress_mark: '■'.bold.red,
                                           total:         mbox_lines,
                                           format:        '%t: %P% |%B| %E  ',
                                           throttle_rate: 1)
      @line_queue   = Queue.new
    end

    MBOX_REGEX = /^From\s/.freeze

    def process!
      return unless progress_bar

      open
      @line_counter = 0
      @progress_bar.start

      @thread = writer_thread

      File.open(@mbox_file, 'r').each do |line|
        @line_queue << line
      end

      sleep 0.1 until @line_queue.empty?

      @progress_bar.finish
      close
      @current_file = nil
      @thread.join
      puts
    end

    private

    def header(lines)

      table = TTY::Table.new [
                                 'Mbox File Path'.bold,
                                 'Extracting To',
                                 'MBox File Size',
                                 '# of Lines',
                             ],
                             [[sprintf('%-28.28s', @mbox_file).bold.yellow,
                               sprintf('%-15.15s', @emails_path).bold.yellow,
                               sprintf('%6.2f Mb', File.size(@mbox_file).to_f / 1024.0 / 1024.0).bold.blue,
                               sprintf('%20d', lines).bold.blue
                              ]]

      puts TTY::Table::Renderer::Unicode.new(table,
                                        padding:    [0, 1, 0, 1],
                                        width:      IO.console.winsize[1],
                                        alignments: [:left, :left, :right, :right]).render

    end

    def reopen
      close
      @file_counter      += 1
      progress_bar.title = pb_title
      open
    end

    def open
      @current_file.close rescue nil unless @current_file&.closed?
      @current_file_name = "#{@emails_path}/#{sprintf '%s-%02d-%05d', File.basename(@mbox_file), @index, @file_counter}.elmx"
      @current_file      = ::File.open(@current_file_name, 'w')
    end

    def close
      @current_file&.close
    end

    def writer_thread
      Thread.new do
        @previous_line = "\n"
        while @current_file
          process_line(@line_queue.pop) unless @line_queue.empty?
        end
      end
    end

    def process_line(line)
      @line_counter += 1
      @progress_bar.increment
      if @previous_line == "\n" && MBOX_REGEX.match?(line.chomp)
        reopen
      end
      @current_file.write(line)
      @previous_line = line
    end

    def pb_title
      "#{sprintf '|  extracted: %7d ', @file_counter}".bold.yellow
    end
  end
end
