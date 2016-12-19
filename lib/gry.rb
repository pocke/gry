require 'fileutils'
require 'tempfile'
require 'yaml'
require 'json'
require 'optparse'
require 'open3'

require 'rubocop'
require 'parallel'

require "gry/version"
require 'gry/rubocop_runner'
require 'gry/analyzer'
require "gry/option"
require 'gry/cli'
require 'gry/rubocop_adapter'
require 'gry/strategy'
require 'gry/formatter'

module Gry
  @debug = false
  def self.debug?
    @debug
  end

  def self.debug_mode!
    @debug = true
  end

  def self.debug_log(msg)
    $stderr.puts msg if debug?
  end
end
