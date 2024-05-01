# frozen_string_literal: true

require_relative "velha_engine/version"
require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

module VelhaEngine
  class Error < StandardError; end
end
