# frozen_string_literal: true

# Ruby internal
require 'digest'

# TLS map module
module TLSmap
  # TLS mapping
  class CLI < App
    INTEGRITY = '9a45b44ce6b3347a7de4a34a54d4d4732b7e72a131c02bc6aa2ac2559cea6650' # sha2-256

    # Load and parse data from marshalized hash (+data/mapping.marshal+).
    # It must match the integrity check for security purpose.
    # @param force [Boolean] Force parsing even if intigrity check failed (DANGEROUS,
    #   may result in command execution vulnerability)
    def initialize(force = false) # rubocop:disable Lint/MissingSuper
      @storage_location = 'data/'
      @database_name = 'mapping.marshal'
      @database_path = absolute_db_path
      database_exists?
      @tls_map = []
      parse(force)
    end

    # Find the absolute path of the DB from its relative location
    # @return [String] absolute filename of the DB
    def absolute_db_path
      pn = Pathname.new(__FILE__)
      install_dir = pn.dirname.parent.parent.to_s + Pathname::SEPARATOR_LIST
      install_dir + @storage_location + @database_name
    end

    # Check if the password database exists
    # @return [Boolean] +true+ if the file exists
    def database_exists?
      exists = File.file?(@database_path)
      raise "Database does not exist: #{@database_path}" unless exists

      exists
    end

    def parse(force = false)
      if Digest::SHA256.file(@database_path).hexdigest == INTEGRITY || force # rubocop:disable Style/GuardClause
        @tls_map = Marshal.load(File.read(@database_path)) # rubocop:disable Security/MarshalLoad
      else
        raise 'Integry check failed, maybe be due to unavalidated database after update'
      end
    end

    def update
      tm = TLSmap::App.new
      tm.export(@database_path, :marshal)
    end

    protected :database_exists?, :absolute_db_path, :parse
  end
end
