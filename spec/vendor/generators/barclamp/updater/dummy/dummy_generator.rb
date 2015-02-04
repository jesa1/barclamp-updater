#
# Copyright 2011-2013, Dell
# Copyright 2013-2015, SUSE Linux GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require "rails/generators"
require "rails/generators/rails/app/app_generator"

module Barclamp
  module Updater
    class DummyGenerator < Rails::Generators::Base
      desc "Creates dummy application and installs Barclamp::Updater"

      def self.source_paths
        superclass.source_paths.tap do |paths|
          paths.push File.expand_path("../templates", __FILE__)
        end.flatten
      end

      PASSTHROUGH_OPTIONS = [
        :database,
        :javascript,
        :quiet,
        :pretend,
        :force,
        :skip,
        :skip_active_record,
        :skip_javascript
      ]

      def generate_test_dummy
        opts = (options || {}).slice(*PASSTHROUGH_OPTIONS)

        opts[:force] = true
        opts[:skip_bundle] = true
        opts[:old_style_hash] = false
        opts[:skip_keeps] = true

        full_dummy_path = File.expand_path(dummy_path.to_s, destination_root)
        FileUtils.rm_rf full_dummy_path if Dir.exist? full_dummy_path

        invoke Rails::Generators::AppGenerator, [full_dummy_path], opts
      end

      def test_dummy_clean
        inside dummy_path do
          %w(
            app
            doc
            lib
            test
            vendor
            db
            log
            tmp
          ).each do |name|
            remove_dir name
          end

          %w(
            .gitignore
            Gemfile
            README.rdoc
          ).each do |name|
            remove_file name
          end
        end
      end

      def test_dummy_config
        directory "app",
          dummy_path.join("app"),
          force: true

        %w(
          config/boot.rb
          config/application.rb
          config/routes.rb
          config/environment.rb
          Rakefile
          config.ru
        ).each do |name|
          template name,
            dummy_path.join(name),
            force: true
        end

        copy_file "config/database.yml",
          dummy_path.join("config", "database.yml"),
          force: true

        copy_file "config/secrets.yml",
          dummy_path.join("config", "secrets.yml"),
          force: true
      end

      protected

      def dummy_path
        @dummy_path ||= Pathname.new("spec/dummy")
      end

      def module_name
        "Dummy"
      end

      def application_definition
        @application_definition ||= begin
          dummy_application_path = File.expand_path(
            "#{dummy_path}/config/application.rb", destination_root)

          unless options[:pretend] || !File.exist?(dummy_application_path)
            contents = File.read(dummy_application_path)
            contents[(contents.index("module #{module_name}"))..-1]
          end
        end
      end

      alias_method :store_application_definition!, :application_definition

      def gemfile_path
        "../../../../Gemfile"
      end
    end
  end
end
